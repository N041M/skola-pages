// Tahák: testy hypotéz (APSTA, přednášky 1 až 3). Kompilace: typst compile tahak-testy-hypotez.typ
// Strana 1: přehled testů. Strana 2: rozhodovací schémata a výpočet na kalkulačce.
#set page(paper: "a4", margin: 5mm)
#set text(font: ("Helvetica Neue", "Arial"), size: 7pt, lang: "cs")
#set par(leading: 0.48em, spacing: 0.48em, justify: false)
#show math.equation: set text(size: 7.2pt)

// Barvy. Odstín rámečku říká, o jakém parametru test je.
#let navy = rgb("#1f3f6f")
#let green = rgb("#1f6b47")
#let purple = rgb("#5a3d8f")
#let slate = rgb("#4d4d4d")
#let tailc = rgb("#2d6fc0")
#let zebra = rgb("#eef2f8")
#let tints = (
  mu: (rgb("#e2ecf8"), rgb("#7fa3d4")),
  var: (rgb("#e3f1e6"), rgb("#7fbb92")),
  pi: (rgb("#fff1c9"), rgb("#d9b652")),
  other: (luma(240), luma(130)),
)
#set table(stroke: 0.35pt + luma(120), inset: (x: 1.6pt, y: 1.1pt), align: horizon)

#let sec(title, color) = block(width: 100%, fill: color, inset: (x: 3pt, y: 1.8pt), above: 4.5pt, below: 2.5pt,
  text(fill: white, weight: "bold", size: 8pt, title))
#let sub(title) = block(above: 3pt, below: 1.2pt, text(weight: "bold", size: 7.4pt, title))
#let tbox(kind, title, body) = {
  let (fill, border) = tints.at(kind)
  block(width: 100%, fill: fill, stroke: 0.5pt + border, inset: (x: 3pt, y: 2.5pt), breakable: false, above: 3pt, below: 3pt,
    { text(weight: "bold", size: 7.5pt, title); linebreak(); body })
}
#let f(body) = block(width: 100%, fill: white, inset: (x: 2pt, y: 1pt), above: 2pt, below: 2pt, align(center, body))
#let sw(c) = box(width: 6pt, height: 6pt, fill: c.at(0), stroke: 0.5pt + c.at(1), baseline: 1pt)

// Ikony hustot. Vybarvená plocha je oblast zamítání.
#let bell(mode, w: 40pt, h: 13pt) = {
  let n = 60
  let xs = range(0, n + 1).map(i => -3.0 + i * 6.0 / n)
  let P(x) = ((x + 3.0) / 6.0 * w, h - 0.5pt - calc.exp(-x * x / 2) * (h - 2pt))
  let B(x) = ((x + 3.0) / 6.0 * w, h - 0.5pt)
  let k = if mode == "two" { 1.96 } else { 1.645 }
  box(width: w, height: h, {
    if mode == "two" or mode == "left" {
      place(polygon(fill: tailc, stroke: none, B(-3.0), ..xs.filter(x => x <= -k).map(P), P(-k), B(-k)))
    }
    if mode == "two" or mode == "right" {
      place(polygon(fill: tailc, stroke: none, B(k), P(k), ..xs.filter(x => x >= k).map(P), B(3.0)))
    }
    place(curve(stroke: 0.45pt + black, curve.move(P(xs.at(0))), ..xs.slice(1).map(x => curve.line(P(x)))))
    place(line(start: B(-3.0), end: B(3.0), stroke: 0.35pt + black))
    place(line(start: B(0.0), end: ((3.0 / 6.0) * w, 1pt), stroke: 0.3pt + luma(140)))
  })
}
#let fcurve(mode, w: 40pt, h: 13pt) = {
  let n = 60
  let xs = range(0, n + 1).map(i => i * 5.0 / n)
  let g(x) = x * calc.exp(-x) / 0.3679
  let P(x) = (x / 5.0 * w, h - 0.5pt - g(x) * (h - 2pt))
  let B(x) = (x / 5.0 * w, h - 0.5pt)
  let k = if mode == "two" { 3.0 } else { 2.6 }
  box(width: w, height: h, {
    if mode == "two" {
      place(polygon(fill: tailc, stroke: none, B(0.0), ..xs.filter(x => x <= 0.3).map(P), P(0.3), B(0.3)))
    }
    place(polygon(fill: tailc, stroke: none, B(k), P(k), ..xs.filter(x => x >= k).map(P), B(5.0)))
    place(curve(stroke: 0.45pt + black, curve.move(P(xs.at(0))), ..xs.slice(1).map(x => curve.line(P(x)))))
    place(line(start: B(0.0), end: B(5.0), stroke: 0.35pt + black))
  })
}

// Hlavička přes celou šířku.
#block(width: 100%, fill: navy, inset: (x: 5pt, y: 3pt), below: 4pt,
  grid(columns: (auto, 1fr, auto), align: horizon, gutter: 8pt,
    text(fill: white, weight: "bold", size: 10pt)[Testy hypotéz],
    text(fill: white, size: 7.2pt)[APSTA, přednášky 1 až 3. Barva rámečku = testovaný parametr. Vybarvená plocha pod křivkou = oblast zamítání $W_alpha$. $H_0$ vždy obsahuje „=“. Druhá strana: rozhodovací schémata a výpočet na kalkulačce.],
    block(fill: white, inset: (x: 4pt, y: 2pt), text(size: 7.2pt)[#sw(tints.mu) $mu$ střední hodnota #h(5pt) #sw(tints.var) $sigma^2$ rozptyl #h(5pt) #sw(tints.pi) $pi$ podíl])
  ))

#columns(3, gutter: 8pt)[

#sec([Značení], navy)
#table(columns: (auto, auto, 1fr), fill: (x, y) => if y == 0 { luma(225) },
  [*Populace*], [*Odhad*], [*Název*],
  [$mu$], [$overline(x)$], [střední hodnota, odhad průměrem],
  [$sigma$, $sigma^2$], [$s$, $s^2$], [směrodatná odchylka, rozptyl],
  [$pi$], [$p = m\/n$], [pravděpodobnost (podíl) jevu, $m$ = počet výskytů ve výběru],
  [$Delta$], [$overline(d)$], [střední hodnota rozdílů (párový test)],
  [$rho$, $beta$], [$r$, $b$], [korelační a regresní koeficient],
)
$n$ rozsah výběru, df stupně volnosti, TK testové kritérium, KH kritická hodnota, $W_alpha$ kritický obor, $V$ jeho doplněk, CLV centrální limitní věta. Hypotézy se píší o populačním (řeckém) parametru.

#sec([Postup testu], navy)
#grid(columns: (1fr, 1fr), gutter: 2pt,
  [1. Zápis $H_0$ a $H_1$.], [5. Výpočet TK z dat výběru.],
  [2. Volba $alpha$ (0,05 nebo 0,01).], [6. Vymezení $W_alpha$: KH = kvantil rozdělení TK.],
  [3. Data výběru, ověření předpokladů.], [7. Rozhodnutí: TK $in W_alpha$ → $H_0$ zamítáme.],
  [4. Volba testu (znak, parametr, $n$).], [8. Interpretace slovy úlohy.],
)

#sec([Klíčová slova v zadání], navy)
#table(columns: (1fr, auto),
  [průměr, průměrná hodnota, střední hodnota], [#sw(tints.mu) $mu$],
  [procento, podíl, pravděpodobnost, ano/ne, má/nemá, vadný], [#sw(tints.pi) $pi$, $p = m\/n$],
  [rozptyl, variabilita, stabilita, přesnost, kolísání], [#sw(tints.var) $sigma^2$],
  [stejné osoby nebo kusy měřené dvakrát, před a po, dvojice, „ke každému přiřazen“], [závislé výběry, párový test],
  [dvě různé skupiny (muži a ženy, dva bazary, dva plány)], [nezávislé výběry],
  [liší se, změnil se, odpovídá, je stejný], [oboustranná $H_1$],
  [zvýšil, snížil, větší, menší, kratší, delší, lepší], [jednostranná $H_1$],
  [deklaruje, tvrdí, norma, dosud, dříve], [hodnota do $H_0$ ($mu_0$, $pi_0$)],
)

#sec([Hypotézy a oblast zamítání], navy)
$H_0$ vždy obsahuje „=“ (není rozdíl, není změna). $H_1$ je doplněk. Při jednostranné $H_1$ zahrnuje $H_0$ i opačnou nerovnost. $H_1$ bývá nová domněnka („zvýšil se“, „je menší“). Závěr: „$H_0$ zamítáme, přijímáme $H_1$“ nebo „$H_0$ nezamítáme“. Nikdy „$H_0$ přijímáme“.
#sub([TK symetrické kolem 0 ($U$, $T$)])
#table(columns: (auto, auto, 1.5fr, 1fr), fill: (x, y) => if y == 0 { luma(225) },
  [$H_1$], [], [$W_alpha$ (zamítáme) a KH], [hodnota $p$],
  [$mu != mu_0$ \ oboustranná], [#bell("two", w: 30pt)], [$abs("TK") > x_(1-alpha\/2)$ \ KH $= plus.minus x_(1-alpha\/2)$], [$2[1 - F(abs("TK"))]$],
  [$mu < mu_0$ \ levostranná], [#bell("left", w: 30pt)], [$"TK" < x_alpha$ \ KH $= x_alpha = -x_(1-alpha)$], [$F("TK")$],
  [$mu > mu_0$ \ pravostranná], [#bell("right", w: 30pt)], [$"TK" > x_(1-alpha)$ \ KH $= x_(1-alpha)$], [$1 - F("TK")$],
)
$F$ je distribuční funkce rozdělení TK ($Phi$ pro N(0,1), $F_t$ pro t). Nesymetrická rozdělení ($F$, $chi^2$): $!=$: TK $< x_(alpha\/2)$ nebo TK $> x_(1-alpha\/2)$; $<$: TK $< x_alpha$; $>$: TK $> x_(1-alpha)$.
#sub([Rozhodovací pravidla])
*I:* TK $in W_alpha$ → $H_0$ zamítáme na hladině $alpha$. *II:* $p <= alpha$ → $H_0$ zamítáme. Hodnota $p$ (přesná hladina významnosti) = pravděpodobnost, že při platnosti $H_0$ vyjde TK aspoň tak extrémní jako pozorované (SPSS: Sig.). Obě pravidla dávají stejný závěr. Jednostranné $p$ je jeden ocas, nezdvojuje se.
#sub([Kvantil])
$x_p$: $P(X < x_p) = p = F(x_p)$, $P(X > x_p) = 1 - p$. Index = percentil. Příklad $t_("0,975"; 6) = "2,45"$: hodnoty $< "2,45"$ mají pravděpodobnost 0,975, hodnoty $> "2,45"$ pravděpodobnost 0,025. Je to KH oboustranného testu při $alpha$ = 0,05 a df = 6, nebo pravostranného při $alpha$ = 0,025. Pro jednostranný test při $alpha$ = 0,05 je potřeba $t_("0,95"; 6) = "1,943"$ (schéma 3 na druhé straně). Symetrie: $t_(alpha; "df") = -t_(1-alpha; "df")$, $u_alpha = -u_(1-alpha)$. $F_(alpha; d_1; d_2) = 1 \/ F_(1-alpha; d_2; d_1)$.

#sec([Chyby testu], navy)
#table(columns: (auto, 1fr, 1fr), fill: (x, y) => if y == 0 or x == 0 { luma(225) },
  [], [*$H_0$ platí*], [*$H_0$ neplatí*],
  [nezamítáme \ (TK $in V$)], [správně, $P >= 1 - alpha$], [*chyba II. druhu*, $P = beta$],
  [zamítáme \ (TK $in W_alpha$)], [*chyba I. druhu*, $P <= alpha$], [správně, $P = 1 - beta$ = síla testu],
)
- $alpha$ = hladina významnosti = P(nesprávného zamítnutí $H_0$). Volíme ji.
- $beta$ nevolíme, závisí na skutečné hodnotě parametru. Lze spočítat jen pro konkrétní alternativu, často neznámá, proto „nezamítáme“.
- Při stejném $n$: menší $alpha$ → větší $beta$. Proto $alpha$ ne příliš malé.
- Větší $n$ → menší $beta$, větší síla. Menší variabilita znaku → menší $beta$. Simulace: rozdíl 3, $n$ = 30: $H_0$ nezamítnuta ve 47 % výběrů; $n$ = 100: ve 3 %.
- Statistická vs. věcná významnost: při velkém $n$ je i malý, věcně nepodstatný rozdíl statisticky významný. Vždy uvést velikost rozdílu.

#sec([Jeden výběr (B1)], green)
#tbox("mu", [Střední hodnota, $sigma$ známé (u-test)])[
  $H_0: mu = mu_0$
  #f[$ U = (overline(x) - mu_0) / (sigma \/ sqrt(n)) tilde.op N(0,1) $]
  Předpoklady: normalita nebo velké $n$ (CLV), prostý náhodný výběr.
]
#tbox("mu", [Střední hodnota, $sigma$ neznámé (t-test)])[
  $H_0: mu = mu_0$
  #f[$ T = (overline(x) - mu_0) / (s \/ sqrt(n)) = (overline(x) - mu_0) / s_(overline(x)) tilde.op t(n-1), quad s_(overline(x)) = s / sqrt(n) $]
  Pro $n > 100$ přibližně N(0,1). Předpoklady: znak přibližně $N(mu, sigma^2)$, $sigma$ odhadnuto $s$, prostý náhodný výběr.
]
#tbox("var", [Rozptyl])[
  $H_0: sigma^2 = sigma_0^2$
  #f[$ chi^2 = ((n-1) s^2) / sigma_0^2 tilde.op chi^2 (n-1) $]
  Citlivý na odchylky od normality. $!=$: $chi^2 < chi^2_(alpha\/2; n-1)$ nebo $chi^2 > chi^2_(1-alpha\/2; n-1)$.
]
#tbox("pi", [Podíl (parametr binomického rozdělení), limitní test])[
  $H_0: pi = pi_0$, $p = m\/n$
  #f[$ U = (p - pi_0) / sqrt(pi_0 (1 - pi_0) \/ n) tilde.op N(0,1) $]
  Předpoklad CLV: $n pi_0 >= 5$ a $n(1-pi_0) >= 5$ (počítá se s $pi_0$ z $H_0$), $pi_0$ ne blízko 0 nebo 1. Jinak přesný binomický test. Korekce na nespojitost: v čitateli $abs(p - pi_0) - 1\/(2n)$ se znaménkem rozdílu.
]

#sec([Dva výběry (B2)], purple)
*Závislé (párové):* stejné jednotky měřené dvakrát (před/po) nebo spárované dvojice, $n_1 = n_2$. *Nezávislé:* dvě různé skupiny jednotek.
#tbox("mu", [Párový t-test (závislé výběry)])[
  Rozdíly $d_i = x_i^((1)) - x_i^((2))$, směr $H_1$ podle definice $d$. $H_0: Delta = Delta_0$ (obvykle 0)
  #f[$ T = (overline(d) - Delta_0) / (s_d \/ sqrt(n)) tilde.op t(n-1) $]
  $overline(d) = 1/n sum d_i$, $s_d^2 = 1/(n-1) sum (d_i - overline(d))^2$. Předpoklad: rozdíly přibližně $N(Delta, sigma_d^2)$. Je to jednovýběrový t-test rozdílů.
]
#tbox("var", [F-test shody rozptylů (nezávislé výběry)])[
  $H_0: sigma_1^2 = sigma_2^2$, značení tak, že $s_1^2 >= s_2^2$ (větší nahoře)
  #f[$ F = s_1^2 / s_2^2 tilde.op F(n_1 - 1, n_2 - 1) $]
  df čitatele, df jmenovatele. \
  #fcurve("two") $H_1: sigma_1^2 != sigma_2^2$: $W$: $F > F_(1-alpha\/2; n_1-1; n_2-1)$ \
  #fcurve("right") $H_1: sigma_1^2 > sigma_2^2$: $W$: $F > F_(1-alpha; n_1-1; n_2-1)$ \
  Bez většího nahoře: $F < F_(alpha\/2)$ nebo $F > F_(1-alpha\/2)$. Předpoklady: nezávislé výběry z normálních rozdělení. Rozhoduje o variantě t-testu. SPSS: Levene Sig. $> alpha$ → řádek „Equal variances assumed“, jinak „not assumed“. Levene F není $s_1^2\/s_2^2$.
]
#tbox("mu", [Nepárový t-test, shodné rozptyly])[
  $H_0: mu_1 = mu_2$
  #f[$ T = (overline(x)_1 - overline(x)_2) / (s sqrt(1/n_1 + 1/n_2)) tilde.op t(n_1 + n_2 - 2) $
  $ s^2 = ((n_1 - 1) s_1^2 + (n_2 - 1) s_2^2) / (n_1 + n_2 - 2) $]
  Předpoklady: normalita, nezávislé prosté náhodné výběry, $sigma_1^2 = sigma_2^2$ neznámé (F-test nezamítl).
]
#tbox("mu", [Nepárový t-test, neshodné rozptyly (Welch)])[
  $H_0: mu_1 = mu_2$
  #f[$ T = (overline(x)_1 - overline(x)_2) / sqrt(s_1^2 / n_1 + s_2^2 / n_2), quad "df" = (s_1^2 / n_1 + s_2^2 / n_2)^2 / ((s_1^2 \/ n_1)^2 / (n_1 - 1) + (s_2^2 \/ n_2)^2 / (n_2 - 1)) $]
  df zaokrouhlit dolů na celé číslo.
]
#tbox("mu", [Dvouvýběrový Z-test, $sigma_1$ a $sigma_2$ známé])[
  $H_0: mu_1 = mu_2$
  #f[$ Z = (overline(x)_1 - overline(x)_2 - Delta_0) / sqrt(sigma_1^2 / n_1 + sigma_2^2 / n_2) tilde.op N(0,1) $]
]
#tbox("pi", [Shoda podílů (dva parametry binomického rozdělení)])[
  $H_0: pi_1 = pi_2$, $p_1 = m_1\/n_1$, $p_2 = m_2\/n_2$, $overline(p) = (m_1 + m_2)/(n_1 + n_2)$
  #f[$ U = (p_1 - p_2) / sqrt(overline(p)(1 - overline(p)) (1/n_1 + 1/n_2)) tilde.op N(0,1) $
  $ = (p_1 - p_2) / sqrt(overline(p)(1 - overline(p))) sqrt((n_1 n_2) / (n_1 + n_2)) $]
  Předpoklad CLV: $n_i p_i >= 5$, $n_i (1 - p_i) >= 5$ pro oba výběry. Jinak přesný Fisherův test. Párová binární data: McNemarův test. Ekvivalent: $chi^2$ test tabulky 2×2.
]
Volba testu: schéma 1 na druhé straně. Více než 2 průměry: ANOVA. Nenormální znak a malé $n$: neparametrický test.

#sec([Excel], slate)
INV: z pravděpodobnosti kvantil. DIST: z hodnoty $P(X <= x)$. RT = pravý ocas ($1 - F$), 2T = oba ocasy.
#table(columns: (auto, 1fr), fill: (x, y) => if x == 0 { luma(225) },
  [N(0,1)], [NORM.S.INV(q); NORM.S.DIST(x;1). Starší: NORMSINV, NORMSDIST],
  [t], [T.INV(q;df); T.INV.2T($alpha$;df) = $t_(1-alpha\/2)$; T.DIST(x;df;1); T.DIST.RT(x;df); T.DIST.2T(|x|;df)],
  [F], [F.INV(q;df1;df2); F.INV.RT($alpha$;df1;df2) = $F_(1-alpha)$; F.DIST.RT(F;df1;df2)],
  [$chi^2$], [CHISQ.INV(q;df); CHISQ.INV.RT($alpha$;df); CHISQ.DIST.RT(x;df)],
)
*Hodnota $p$:* U: $!=$ 2·(1 − NORM.S.DIST(|u|;1)); $<$ NORM.S.DIST(u;1); $>$ 1 − NORM.S.DIST(u;1). T: $!=$ T.DIST.2T(|t|;df); $<$ T.DIST(t;df;1); $>$ T.DIST.RT(t;df). F (větší nahoře): $!=$ 2·F.DIST.RT(F;df1;df2); $>$ F.DIST.RT(F;df1;df2).

#sec([Kvantily], slate)
*N(0,1):* $u_("0,90")$ = 1,2816; $u_("0,95")$ = 1,6449; $u_("0,975")$ = 1,9600; $u_("0,99")$ = 2,3263; $u_("0,995")$ = 2,5758. Levostranné KH jsou záporné.
#let tt = (
  ("1", "6,314", "12,706", "31,821", "63,657"), ("2", "2,920", "4,303", "6,965", "9,925"), ("3", "2,353", "3,182", "4,541", "5,841"),
  ("4", "2,132", "2,776", "3,747", "4,604"), ("5", "2,015", "2,571", "3,365", "4,032"), ("6", "1,943", "2,447", "3,143", "3,707"),
  ("7", "1,895", "2,365", "2,998", "3,499"), ("8", "1,860", "2,306", "2,896", "3,355"), ("9", "1,833", "2,262", "2,821", "3,250"),
  ("10", "1,812", "2,228", "2,764", "3,169"), ("11", "1,796", "2,201", "2,718", "3,106"), ("12", "1,782", "2,179", "2,681", "3,055"),
  ("13", "1,771", "2,160", "2,650", "3,012"), ("14", "1,761", "2,145", "2,624", "2,977"), ("15", "1,753", "2,131", "2,602", "2,947"),
  ("16", "1,746", "2,120", "2,583", "2,921"), ("17", "1,740", "2,110", "2,567", "2,898"), ("18", "1,734", "2,101", "2,552", "2,878"),
  ("19", "1,729", "2,093", "2,539", "2,861"), ("20", "1,725", "2,086", "2,528", "2,845"), ("21", "1,721", "2,080", "2,518", "2,831"),
  ("22", "1,717", "2,074", "2,508", "2,819"), ("23", "1,714", "2,069", "2,500", "2,807"), ("24", "1,711", "2,064", "2,492", "2,797"),
  ("25", "1,708", "2,060", "2,485", "2,787"), ("26", "1,706", "2,056", "2,479", "2,779"), ("27", "1,703", "2,052", "2,473", "2,771"),
  ("28", "1,701", "2,048", "2,467", "2,763"), ("29", "1,699", "2,045", "2,462", "2,756"), ("30", "1,697", "2,042", "2,457", "2,750"),
  ("40", "1,684", "2,021", "2,423", "2,704"), ("60", "1,671", "2,000", "2,390", "2,660"), ("120", "1,658", "1,980", "2,358", "2,617"),
  ("∞", "1,645", "1,960", "2,326", "2,576"),
)
*t-rozdělení* $t_(q; "df")$:
#table(columns: (auto, 1fr, 1fr, 1fr, 1fr), align: (x, y) => if y <= 1 { center } else { right },
  fill: (x, y) => if y <= 1 { if x == 1 or x == 2 { tints.pi.at(0) } else { luma(225) } } else if calc.even(y) { zebra },
  [df], [0,95], [0,975], [0,99], [0,995],
  [], [jednostr. $alpha$ = 0,05], [oboustr. $alpha$ = 0,05], [jednostr. $alpha$ = 0,01], [oboustr. $alpha$ = 0,01],
  ..tt.map(r => r.map(c => [#c])).flatten()
)
#let cc = (
  ("1", "0,001", "0,004", "3,84", "5,02"), ("2", "0,05", "0,10", "5,99", "7,38"), ("3", "0,22", "0,35", "7,81", "9,35"), ("4", "0,48", "0,71", "9,49", "11,14"),
  ("5", "0,83", "1,15", "11,07", "12,83"), ("6", "1,24", "1,64", "12,59", "14,45"), ("7", "1,69", "2,17", "14,07", "16,01"), ("8", "2,18", "2,73", "15,51", "17,53"),
  ("9", "2,70", "3,33", "16,92", "19,02"), ("10", "3,25", "3,94", "18,31", "20,48"), ("15", "6,26", "7,26", "25,00", "27,49"),
  ("20", "9,59", "10,85", "31,41", "34,17"), ("30", "16,79", "18,49", "43,77", "46,98"),
)
*$chi^2$-rozdělení* $chi^2_(q; "df")$:
#table(columns: (auto, 1fr, 1fr, 1fr, 1fr), align: (x, y) => if y == 0 { center } else { right },
  fill: (x, y) => if y == 0 { luma(225) } else if calc.even(y) { zebra },
  [df], [0,025], [0,05], [0,95], [0,975],
  ..cc.map(r => r.map(c => [#c])).flatten()
)
Kvantily F: ze zadání nebo Excel.

#sec([Formulace závěru], slate)
*Zamítnutí:* „$H_0$ zamítáme na hladině významnosti $alpha$ ($p$ = …), přijímáme $H_1$. Rozdíl (změna) je statisticky významný: … (věcně).“ \
*Nezamítnutí:* „$H_0$ nezamítáme na hladině významnosti $alpha$ ($p$ = …). Statisticky významný rozdíl nebyl prokázán, pozorovaný rozdíl lze vysvětlit výběrovou (náhodnou) chybou.“ \
Vždy uvést parametr, směr, hladinu, hodnotu $p$ a kritickou hodnotu. Jednostranné $p$ ze SPSS = Sig./2, pokud rozdíl míří ve směru $H_1$.

]

// ===================== STRANA 2 =====================
#pagebreak()

// Prvky schémat: otázka (bílý rámeček), výsledek (barevný rámeček), šipky.
#let dbox(body) = block(width: 100%, fill: white, stroke: 0.6pt + navy, inset: (x: 2.5pt, y: 2.2pt), align(center + horizon, body))
#let lbox(kind, title, note: none) = {
  let (fill, border) = tints.at(kind)
  block(width: 100%, fill: fill, stroke: 0.6pt + border, inset: (x: 2.5pt, y: 2.2pt),
    align(center + horizon, { text(weight: "bold", title); if note != none { linebreak(); text(size: 6.5pt, note) } }))
}
#let harrow(label, w: 9mm) = box(width: w, height: 5mm, {
  place(dx: 0mm, dy: 3.3mm, line(length: w - 1.4mm, stroke: 0.6pt))
  place(dx: w - 1.5mm, dy: 2.5mm, polygon(fill: black, (0mm, 0mm), (1.5mm, 0.8mm), (0mm, 1.6mm)))
  place(dx: 0mm, dy: -0.2mm, box(width: w - 1.5mm, align(center, text(size: 6.3pt, label))))
})
#let varrow(label, h: 5.2mm) = box(width: 100%, height: h, {
  place(dx: 50%, dy: 0mm, line(angle: 90deg, length: h - 1.4mm, stroke: 0.6pt))
  place(dx: 50%, dy: h - 1.5mm, move(dx: -0.8mm, polygon(fill: black, (0mm, 0mm), (1.6mm, 0mm), (0.8mm, 1.5mm))))
  place(dx: 50%, dy: 0.5mm, move(dx: 1mm, text(size: 6.3pt, label)))
})
#let ladder(steps, final, aw: 9mm) = {
  let cells = ()
  for s in steps {
    cells += ([#dbox(s.q)], [#harrow(s.at("yes", default: "ano"), w: aw)], [#lbox(s.kind, s.leaf, note: s.at("note", default: none))])
    cells += ([#varrow(s.at("no", default: "ne"))], [], [])
  }
  cells += ([#lbox(final.kind, final.leaf, note: final.at("note", default: none))], [], [])
  grid(columns: (1fr, aw, 1fr), align: center + horizon, row-gutter: 0pt, column-gutter: 0pt, ..cells)
}
#let head(title, color) = block(width: 100%, fill: color, inset: (x: 3pt, y: 1.8pt), below: 3pt, text(fill: white, weight: "bold", size: 7.6pt, title))

#block(width: 100%, fill: navy, inset: (x: 5pt, y: 3pt), below: 4pt,
  grid(columns: (auto, 1fr), align: horizon, gutter: 8pt,
    text(fill: white, weight: "bold", size: 10pt)[Rozhodovací schémata a výpočet na kalkulačce],
    text(fill: white, size: 7.2pt)[Bílý rámeček = otázka, barevný rámeček = test (barva = parametr). Vzorce a kvantily jsou na první straně.]))

#sec([Schéma 1: Který test?], navy)
#grid(columns: (1fr, 1fr, 1fr), column-gutter: 5mm,
  [
    #head([Kvantitativní znak, 1 výběr], green)
    #ladder((
      (q: [Testuje se rozptyl $sigma^2$?], kind: "var", leaf: [$chi^2$ test], note: [df = $n - 1$]),
      (q: [Testuje se $mu$. Je $sigma$ známé?], kind: "mu", leaf: [u-test], note: [N(0,1)]),
    ), (kind: "mu", leaf: [t-test], note: [df = $n - 1$; pro $n > 100$ jako N(0,1)]))
    #v(2pt)
    Předpoklad: znak přibližně normální nebo velké $n$ (CLV). Jinak neparametrický test.
  ],
  [
    #head([Kvantitativní znak, 2 výběry], purple)
    #ladder((
      (q: [Testuje se shoda rozptylů?], kind: "var", leaf: [F-test], note: [větší $s^2$ nahoře, df = ($n_1 - 1$, $n_2 - 1$)]),
      (q: [Testuje se $mu$. Jsou výběry závislé (párové)?], kind: "mu", leaf: [Párový t-test], note: [rozdíly $d_i$, df = $n - 1$]),
      (q: [Jsou $sigma_1$, $sigma_2$ známé?], kind: "mu", leaf: [Z-test], note: [N(0,1)]),
      (q: [F-test: rozptyly shodné? ($F < F_(1-alpha\/2)$)], kind: "mu", leaf: [t-test pooled], note: [df = $n_1 + n_2 - 2$]),
    ), (kind: "mu", leaf: [Welch t-test], note: [df ze vzorce, dolů]))
    #v(2pt)
    Více než 2 nezávislé výběry: ANOVA.
  ],
  [
    #head([Binární znak (podíl $pi$)], rgb("#8a6d1a"))
    *1 výběr*
    #ladder((
      (q: [$n pi_0 >= 5$ a $n(1 - pi_0) >= 5$?], kind: "pi", leaf: [U-test o $pi$], note: [N(0,1), $p = m\/n$]),
    ), (kind: "other", leaf: [Binomický test], note: [přesný, mimo zkoušku]))
    #v(2pt)
    *2 výběry*
    #ladder((
      (q: [Jsou výběry závislé (párové)?], kind: "other", leaf: [McNemarův test]),
      (q: [$n_i p_i >= 5$ a $n_i (1 - p_i) >= 5$ pro oba?], kind: "pi", leaf: [U-test shody podílů], note: [N(0,1), $overline(p)$ společné]),
    ), (kind: "other", leaf: [Fisherův přesný test]))
  ],
)

#sec([Schéma 2: Rozhodnutí o $H_0$ podle tvaru $H_1$], navy)
#grid(columns: (26mm, 9mm, 1fr, 9mm, 26mm, 9mm, 24mm, 9mm, 36mm), align: center + horizon,
  dbox[*1.* Zápis $H_0$: $theta = theta_0$ \ a $H_1$ (podle slov zadání)],
  harrow([]),
  grid(columns: (1fr), row-gutter: 2pt,
    lbox("other", [$H_1: theta != theta_0$ oboustranná], note: [KH = $plus.minus x_(1-alpha\/2)$ #h(3pt) $W$: $abs("TK") >$ KH #h(3pt) #bell("two", h: 11pt)]),
    lbox("other", [$H_1: theta < theta_0$ levostranná], note: [KH = $x_alpha = -x_(1-alpha)$ #h(3pt) $W$: TK $<$ KH #h(3pt) #bell("left", h: 11pt)]),
    lbox("other", [$H_1: theta > theta_0$ pravostranná], note: [KH = $x_(1-alpha)$ #h(3pt) $W$: TK $>$ KH #h(3pt) #bell("right", h: 11pt)]),
  ),
  harrow([]),
  dbox[*2.* Spočítat TK ze vzorce testu. Zapsat df a rozdělení TK.],
  harrow([]),
  dbox[*3.* Je TK v $W$? \ (nebo $p <= alpha$?)],
  grid(columns: (1fr), row-gutter: 3pt, harrow([ano]), harrow([ne])),
  grid(columns: (1fr), row-gutter: 3pt,
    lbox("other", [$H_0$ zamítáme, přijímáme $H_1$], note: [rozdíl je statisticky významný na hladině $alpha$]),
    lbox("other", [$H_0$ nezamítáme], note: [rozdíl nebyl prokázán, lze ho vysvětlit výběrovou chybou]),
  ),
)
*4.* Interpretace slovy úlohy: parametr, směr, hladina $alpha$, hodnota $p$ a KH, věcný význam velikosti rozdílu. Pro F a $chi^2$ (nesymetrická rozdělení) jsou KH kvantily $x_(alpha\/2)$ a $x_(1-alpha\/2)$ ($!=$), $x_alpha$ ($<$), $x_(1-alpha)$ ($>$).

#grid(columns: (1fr, 1fr), column-gutter: 5mm,
  [
    #sec([Schéma 3: Stačí zadaný kvantil k rozhodnutí?], navy)
    #ladder((
      (q: [Je to rozdělení mého TK? (t, N(0,1), F, $chi^2$)], kind: "other", leaf: [Nestačí], note: [napsat, které rozdělení je potřeba], yes: "ne", no: "ano"),
      (q: [Souhlasí df? ($n - 1$; $n_1 + n_2 - 2$; $(n_1 - 1, n_2 - 1)$)], kind: "other", leaf: [Nestačí], note: [napsat potřebné df], yes: "ne", no: "ano"),
      (q: [Odpovídá index tvaru $H_1$ a $alpha$? \ $!=$: $1 - alpha\/2$; $>$: $1 - alpha$; $<$: $alpha$ (= $-x_(1-alpha)$)], kind: "other", leaf: [Jen částečně], note: [viz pravidla vpravo], yes: "ne", no: "ano"),
    ), (kind: "mu", leaf: [Porovnat TK s kvantilem a rozhodnout], note: [TK $in W$ → zamítáme, jinak nezamítáme]), aw: 8mm)
  ],
  [
    #sec([Pravidla pro „skoro správný“ kvantil], navy)
    Platí $x_("0,95") < x_("0,975") < x_("0,99")$ při stejných df. Vždy napsat, který kvantil by byl správný.
    - *Mám $x_("0,975")$, potřebuji $x_("0,95")$ (jednostranný test, $alpha$ = 0,05):* když TK $> x_("0,975")$, je i TK $> x_("0,95")$ → zamítám (směr TK musí odpovídat $H_1$). Když TK $< x_("0,975")$, nelze rozhodnout.
    - *Mám $x_("0,95")$, potřebuji $x_("0,975")$ (oboustranný test, $alpha$ = 0,05):* když $abs("TK") < x_("0,95")$, je i $< x_("0,975")$ → nezamítám. Když $abs("TK") > x_("0,95")$, nelze rozhodnout.
    - *Levostranný test:* KH = $-x_(1-alpha)$. Kladný tabulkový kvantil stačí, jen se otočí znaménko.
    - *Jiné df:* větší df dává menší kvantil t. Když TK překročí kvantil pro menší df, překročí i kvantil pro větší df.
    - *Hodnota $p$ z tabulky:* najít, mezi které kvantily padne $abs("TK")$. Např. t = 2,0, df = 9: $t_("0,95")$ = 1,833 $<$ 2,0 $< t_("0,975")$ = 2,262 → jednostranné $p$ je mezi 0,025 a 0,05, oboustranné mezi 0,05 a 0,10.
  ],
)

#sec([Výpočet na kalkulačce], slate)
#let rec(body) = block(width: 100%, breakable: false, below: 3pt, body)
#columns(3, gutter: 6pt)[
#rec[
*Obecně*
- Nejdřív jmenovatel (směrodatná chyba SE), uložit do paměti (STO / M+), pak čitatel, pak dělit.
- Počítat na 4 desetinná místa, zaokrouhlit až výsledek.
- Procenta převést na podíl: 56 % = 0,56. Zadáno $s$, nebo $s^2$? Do $s^2$ ve vzorcích dosadit druhou mocninu, do $s\/sqrt(n)$ samotné $s$.
- $sqrt(n)$ spočítat zvlášť: $sqrt(50)$ = 7,0711.
- Znaménko TK: u jednostranné $H_1$ rozhoduje; u oboustranné porovnat $abs("TK")$ s KH.

]
#rec[
#sw(tints.mu) *$overline(x)$ a $s$ z dat*
1. $sum x$ a $sum x^2$ (každou hodnotu umocnit a přičíst).
2. $overline(x) = sum x \/ n$.
3. $s^2 = (sum x^2 - n overline(x)^2) \/ (n - 1)$, $s = sqrt(s^2)$.
Příklad 12, 15, 18: $sum x$ = 45, $sum x^2$ = 144 + 225 + 324 = 693, $overline(x)$ = 15, $s^2$ = (693 − 3·225)/2 = 9, $s$ = 3. \
Režim STAT: zadat data, číst $overline(x)$ a $s_x$ (dělí $n - 1$, výběrová). $sigma_x$ (dělí $n$) nepoužívat.

]
#rec[
#sw(tints.mu) *Jednovýběrový t-test (u-test stejně se $sigma$)*
1. SE = $s ÷ sqrt(n)$.
2. rozdíl = $overline(x) - mu_0$, včetně znaménka.
3. t = rozdíl ÷ SE, df = $n - 1$.
Příklad (koření, $mu_0$ = 16, n = 50, $overline(x)$ = 14,9, s = 3,9, $H_1: mu < 16$): 3,9 ÷ 7,0711 = 0,5515; 14,9 − 16 = −1,1; −1,1 ÷ 0,5515 = −1,994 $< t_("0,05"; 49)$ = −1,677 → zamítáme, p = 0,026.

]
#rec[
#sw(tints.pi) *Podíl, 1 výběr*
1. $p = m ÷ n$.
2. Ověřit $n pi_0 >= 5$ a $n(1 - pi_0) >= 5$.
3. SE = $sqrt(pi_0 (1 - pi_0) ÷ n)$: součin, ÷ n, odmocnina.
4. u = $(p - pi_0)$ ÷ SE.
Příklad ($pi_0$ = 0,56, m = 298, n = 500, $H_1: pi != "0,56"$): 298 ÷ 500 = 0,596; 0,56·0,44 = 0,2464; ÷ 500 = 0,0004928; √ = 0,0222; (0,596 − 0,56) ÷ 0,0222 = 1,62 (s korekcí 1,58) $<$ 1,96 → nezamítáme, p = 0,10. Pravostranně: KH 1,645, také nezamítáme.

]
#rec[
#sw(tints.mu) *Párový t-test*
1. $d_i = x_i^((1)) - x_i^((2))$ pro každou dvojici, se znaménkem.
2. $overline(d)$ a $s_d$ jako $overline(x)$ a $s$ z dat ($sum d$, $sum d^2$).
3. SE = $s_d ÷ sqrt(n)$; t = $(overline(d) - Delta_0)$ ÷ SE; df = $n - 1$.
Příklad (hypermarkety, $overline(d)$ = 3,57, $s_d$ = 2,99, n = 100, $H_1: Delta > 0$, $alpha$ = 0,01): 2,99 ÷ 10 = 0,299; 3,57 ÷ 0,299 = 11,94 $> t_("0,99"; 99)$ = 2,364 → zamítáme.

]
#rec[
#sw(tints.var) *F-test*
1. Zadáno $s$? Umocnit: $s^2 = s dot s$.
2. Větší rozptyl do čitatele: F = větší $s^2$ ÷ menší $s^2$ (F ≥ 1).
3. df₁ = $n$ u většího rozptylu − 1, df₂ = $n$ u menšího − 1.
4. Porovnat s $F_(1-alpha\/2)$ ($!=$) nebo $F_(1-alpha)$ ($>$).
Příklad (ohřívače, n = 13 a 15, $H_1: sigma_1^2 > sigma_2^2$): 8,354 ÷ 2,367 = 3,53; df 12 a 14; 3,53 $> F_("0,95"; 12; 14)$ = 2,53 → zamítáme.

]
#rec[
#sw(tints.var) *$chi^2$ test rozptylu*
$chi^2 = (n - 1) dot s^2 ÷ sigma_0^2$. Zadáno $sigma_0$? Umocnit.

]
#rec[
#sw(tints.mu) *Nepárový t-test, shodné rozptyly*
1. $s^2 = [(n_1 - 1) s_1^2 + (n_2 - 1) s_2^2] ÷ (n_1 + n_2 - 2)$, $s = sqrt(s^2)$.
2. k = $sqrt(1\/n_1 + 1\/n_2)$.
3. SE = $s dot k$; t = $(overline(x)_1 - overline(x)_2)$ ÷ SE; df = $n_1 + n_2 - 2$.
Příklad (autobazary A, B: n = 36 a 34, $overline(x)$ = 169,417 a 162,068, $s^2$ = 1442,99 a 1022,6; F = 1,41 $< F_("0,975"; 35; 33)$ = 1,99 → rozptyly shodné): (35·1442,99 + 33·1022,6) ÷ 68 = (50 504,7 + 33 745,8) ÷ 68 = 1238,98; s = 35,20. √(1/36 + 1/34) = √(0,02778 + 0,02941) = 0,2391. SE = 35,20·0,2391 = 8,417. t = 7,349 ÷ 8,417 = 0,873 $< t_("0,975"; 68)$ = 1,995 → nezamítáme, p = 0,386.

]
#rec[
#sw(tints.mu) *Welch*
1. a = $s_1^2 ÷ n_1$, b = $s_2^2 ÷ n_2$.
2. SE = $sqrt(a + b)$; t = $(overline(x)_1 - overline(x)_2)$ ÷ SE.
3. df = $(a + b)^2 ÷ [a^2 ÷ (n_1 - 1) + b^2 ÷ (n_2 - 1)]$, zaokrouhlit dolů.
Příklad: a = 1442,99 ÷ 36 = 40,083; b = 636,004 ÷ 36 = 17,667; SE = √57,750 = 7,599; t = 20,823 ÷ 7,599 = 2,740. df = 57,75² ÷ (40,083² ÷ 35 + 17,667² ÷ 35) = 3335,1 ÷ (45,90 + 8,92) = 60,8 → 60. (Autobazary A, C: n = 36 a 36, F = 2,27 $> F_("0,975"; 35; 35)$ = 1,96 → rozptyly neshodné; $H_1: mu_1 > mu_3$: 2,740 $> t_("0,95"; 60)$ = 1,671 → zamítáme, p = 0,004.)

]
#rec[
#sw(tints.pi) *Dva podíly*
1. $p_1 = m_1 ÷ n_1$, $p_2 = m_2 ÷ n_2$, $overline(p) = (m_1 + m_2) ÷ (n_1 + n_2)$.
2. Ověřit $n_i p_i >= 5$ a $n_i (1 - p_i) >= 5$.
3. SE = $sqrt(overline(p)(1 - overline(p)) dot (1\/n_1 + 1\/n_2))$.
4. u = $(p_1 - p_2)$ ÷ SE.
Příklad: $overline(p)$ = 103 ÷ 404 = 0,2550; 0,255·0,745 = 0,1900; 1/231 + 1/173 = 0,004329 + 0,005780 = 0,010109; 0,1900·0,010109 = 0,001921; √ = 0,04383; (0,2338 − 0,2832) ÷ 0,04383 = −1,13; $abs(u)$ $<$ 1,96 → nezamítáme, p = 0,26. (Věkové skupiny: 54 z 231 a 49 ze 173.)

]
#rec[
*Časté chyby*
- $m$ místo $p$ (počet místo podílu), $s$ místo $s^2$, procenta místo podílu.
- Zapomenutá odmocnina u $n$ nebo u SE.
- Menší rozptyl v čitateli F (F $<$ 1): pak se porovnává s levým kvantilem, nebo zlomek otočit.
- Welch df zaokrouhlený nahoru; správně dolů.
- Jednostranná $H_1$ s oboustranným kvantilem (1,96 místo 1,645).
- Párová data počítaná jako dva nezávislé výběry.
]
]
