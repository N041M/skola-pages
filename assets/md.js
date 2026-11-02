// Renders the Markdown subset the study guides use: headings, paragraphs, bullet and
// numbered lists, tables, images, boxes, code blocks between ``` lines, **bold**,
// ==highlight==, `code` and [links](https://…).
// A box is a run of lines starting with ">". Its first line is the title, and the titles
// in BOXES get their own colour.
// A code block opened with ```matice is a hand calculation drawn as a chain of matrices.
// Each line is a unit of text and matrices such as "A = [*1 2; !0 3]", where *x marks
// the pivot and !x a changed entry. "| a; b" puts row operations beside the rows of the
// unit's last matrix, "→ text" is an arrow with a label and "- text" a note under the chain.
const BOXES = { "Shrnutí": "box-sum", "Pozor": "box-warn", "Na písemku": "box-exam", "Do zprávy": "box-exam" };

function renderMarkdown(source) {
  const esc = (s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
  const inline = (s) => esc(s)
    .replace(/`([^`]+)`/g, "<code>$1</code>")
    .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>")
    .replace(/==([^=]+)==/g, "<mark>$1</mark>")
    .replace(/\[([^\]]+)\]\((https:\/\/[^\s)]+)\)/g, '<a href="$2">$1</a>');
  const cells = (line) => line.trim().replace(/^\||\|$/g, "").split(/(?<!\\)\|/).map((c) => c.trim().replace(/\\\|/g, "|"));
  const isBlockStart = (l) => /^(#{1,4} |\||>|!\[|```)/.test(l) || /^(\d+\.|[-*]) /.test(l);
  const matrix = (src) => {
    const rows = src.split(";").map((r) => r.trim().split(/\s+/));
    const cell = (c) => {
      const [, marks, value] = c.match(/^([!*]*)(.*)$/);
      const cls = [marks.includes("*") && "pv", marks.includes("!") && "new", value === "0" && "z"].filter(Boolean).join(" ");
      return `<span${cls ? ` class="${cls}"` : ""}>${esc(value)}</span>`;
    };
    return `<span class="mat" style="--n:${rows[0].length}">${rows.flat().map(cell).join("")}</span>`;
  };
  const calc = (src) => {
    const chain = [], notes = [];
    for (let k = 0; k < src.length; k++) {
      const l = src[k].trim();
      if (!l) continue;
      if (l.startsWith("- ")) notes.push(`<li>${inline(l.slice(2))}</li>`);
      else if (l.startsWith("→")) chain.push(`<span class="arrow">${inline(l.slice(1).trim())}<b>→</b></span>`);
      else {
        const ops = (src[k + 1] || "").trim().startsWith("|") ? src[++k].trim().slice(1).split(";").map((o) => o.trim()) : null;
        const parts = l.split(/(\[[^\]]*\])/).filter((p) => p.trim());
        const last = parts.map((p) => p.startsWith("[")).lastIndexOf(true);
        const html = parts.map((p, n) => {
          if (!p.startsWith("[")) return `<span>${inline(p.trim())}</span>`;
          const side = n === last && ops ? `<span class="ops">${ops.map((o) => `<span>${inline(o) || "&nbsp;"}</span>`).join("")}</span>` : "";
          return `<span class="mg">${matrix(p.slice(1, -1))}${side}</span>`;
        });
        chain.push(`<span class="unit">${html.join("")}</span>`);
      }
    }
    return `<div class="calc"><div class="chain">${chain.join("")}</div>${notes.length ? `<ul class="steps">${notes.join("")}</ul>` : ""}</div>`;
  };

  const lines = source.replace(/\r\n?/g, "\n").split("\n");
  const out = [];
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (!line.trim()) { i++; continue; }

    const heading = line.match(/^(#{1,4}) (.*)/);
    const image = line.match(/^!\[(.*)\]\((.*)\)$/);
    if (heading) {
      const level = heading[1].length;
      out.push(`<h${level}>${inline(heading[2])}</h${level}>`);
      i++;
    } else if (image) {
      out.push(`<figure><img src="${esc(image[2])}" alt="${esc(image[1])}"><figcaption>${inline(image[1])}</figcaption></figure>`);
      i++;
    } else if (line.startsWith("```")) {
      const code = [];
      i++;
      while (i < lines.length && !lines[i].startsWith("```")) code.push(lines[i++]);
      i++;
      out.push(line.slice(3).trim() === "matice" ? calc(code) : `<pre><code>${esc(code.join("\n"))}</code></pre>`);
    } else if (line.startsWith(">")) {
      const body = [];
      while (i < lines.length && lines[i].startsWith(">")) body.push(lines[i++].replace(/^> ?/, ""));
      const title = body.shift();
      out.push(`<aside class="box ${BOXES[title] || ""}"><p class="box-title">${inline(title)}</p>${renderMarkdown(body.join("\n"))}</aside>`);
    } else if (line.startsWith("|")) {
      const head = cells(line);
      i += 2;
      const rows = [];
      while (i < lines.length && lines[i].startsWith("|")) rows.push(cells(lines[i++]));
      const row = (tag, r) => `<tr>${r.map((c) => `<${tag}>${inline(c)}</${tag}>`).join("")}</tr>`;
      out.push(`<div class="scroll"><table><thead>${row("th", head)}</thead><tbody>${rows.map((r) => row("td", r)).join("")}</tbody></table></div>`);
    } else if (/^(\d+\.|[-*]) /.test(line)) {
      const tag = /^\d/.test(line) ? "ol" : "ul";
      const items = [];
      while (i < lines.length && /^(\d+\.|[-*]) /.test(lines[i])) {
        items.push(`<li>${inline(lines[i].replace(/^(\d+\.|[-*]) /, ""))}</li>`);
        i++;
      }
      out.push(`<${tag}>${items.join("")}</${tag}>`);
    } else {
      const para = [];
      while (i < lines.length && lines[i].trim() && !isBlockStart(lines[i])) para.push(lines[i++]);
      out.push(`<p>${inline(para.join(" "))}</p>`);
    }
  }
  return out.join("\n");
}
