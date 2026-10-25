// Renders the Markdown subset the study guides use: headings, paragraphs, bullet and
// numbered lists, tables, **bold** and `code`.
function renderMarkdown(source) {
  const esc = (s) => s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  const inline = (s) => esc(s)
    .replace(/`([^`]+)`/g, "<code>$1</code>")
    .replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  const cells = (line) => line.trim().replace(/^\||\|$/g, "").split("|").map((c) => c.trim());
  const isBlockStart = (l) => /^(#{1,4} |\|)/.test(l) || /^(\d+\.|[-*]) /.test(l);

  const lines = source.replace(/\r\n?/g, "\n").split("\n");
  const out = [];
  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (!line.trim()) { i++; continue; }

    const heading = line.match(/^(#{1,4}) (.*)/);
    if (heading) {
      const level = heading[1].length;
      out.push(`<h${level}>${inline(heading[2])}</h${level}>`);
      i++;
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
