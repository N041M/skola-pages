// Tahák: chyby a soustavy rovnic (NUMA, zápočet). Kompilace: typst compile tahak-chyby-a-soustavy-rovnic.typ
// Jedna strana. Vzorce a příklady jsou převzaté ze studijni-pruvodce.md ve stejné složce.
#set page(paper: "a4", margin: 6mm)
#set text(font: ("Helvetica Neue", "Arial"), size: 7.9pt, lang: "cs")
#set par(leading: 0.5em, spacing: 0.5em, justify: false)
#set list(spacing: 0.42em, indent: 0pt, body-indent: 4pt)
#set enum(spacing: 0.42em, indent: 0pt, body-indent: 4pt)
#show math.equation: set text(size: 8.1pt)
#show raw: set text(font: ("Menlo", "Courier New"), size: 7.3pt)

#let navy = rgb("#1f3f6f")
#let purple = rgb("#5a3d8f")
#let green = rgb("#1f6b47")
#let teal = rgb("#0f6e73")
#let slate = rgb("#4d4d4d")
#let red = rgb("#b3261e")
#set table(stroke: 0.35pt + luma(120), inset: (x: 2pt, y: 1.6pt), align: horizon)
#show table: set par(leading: 0.62em)

#let sec(title, color) = block(width: 100%, fill: color, inset: (x: 3pt, y: 2pt), above: 6pt, below: 3pt, sticky: true,
  text(fill: white, weight: "bold", size: 8.8pt, title))
#let f(body) = block(width: 100%, inset: (x: 2pt, y: 1.5pt), above: 3pt, below: 3pt, align(center, body))
#let tbox(color, fill, title, body) = block(width: 100%, fill: fill, stroke: (left: 1.6pt + color), inset: (x: 3pt, y: 2.5pt),
  above: 3.5pt, below: 3.5pt, breakable: false, { text(fill: color, weight: "bold", title); linebreak(); body })
#let pisemka(body) = tbox(green, rgb("#e3f1e6"), [Na písemku], body)
#let pozor(body) = tbox(red, rgb("#fbe7e5"), [Pozor], body)
#let head = (x, y) => if y == 0 { luma(225) }

#block(width: 100%, fill: navy, inset: (x: 5pt, y: 3.5pt), below: 2pt,
  grid(columns: (auto, 1fr), align: horizon, gutter: 10pt,
    text(fill: white, weight: "bold", size: 11pt)[Chyby a soustavy rovnic],
    text(fill: white, size: 7.9pt)[NUMA, zápočet. Matice jsou psané po řádcích, (1 2; 3 4). E je jednotková matice a $e_i$ její sloupce.],
  ))

#columns(3, gutter: 9pt)[

#sec([Co patří na papír], green)
+ Zadání: matice A a pravá strana b.
+ Úprava matice a její důvod: multiplikátory, prohození řádků, kontrola podmínky konvergence.
+ Název metody a vzorce rozepsané pro danou matici.
+ Příkazy nebo funkce z Matlabu, které spočítaly výsledek.
+ Výsledek. U iterací také $x^((0))$, tolerance a počet iterací.

#sec([GEM a zpětná substituce], navy)
Krok $k$ nuluje prvky pod diagonálou v $k$-tém sloupci. Pivot je $a_(k k)$.
#f[$ m_(i k) = a_(i k) / a_(k k), quad "řádek" i - m_(i k) dot "řádek" k $]
Stejně se upraví pravá strana b. Výsledek je horní trojúhelníková U. Zpětná substituce pro $i = n, ..., 1$:
#f[$ x_i = (b_i - sum_(j=i+1)^n u_(i j) x_j) / u_(i i) $]
*Částečná pivotace:* za pivot se vezme prvek sloupce (na diagonále a pod ní) s největší absolutní hodnotou a prohodí se řádky A i b. Malý pivot dá velký multiplikátor a velkou zaokrouhlovací chybu.

#sec([LU rozklad], navy)
$A = L dot U$. U je výsledek GEM bez prohazování řádků. L má na diagonále jedničky a pod ní multiplikátory $m_(i k)$.
- $A x = b$: nejdřív $L y = b$ dopřednou substitucí (shora dolů), pak $U x = y$ zpětnou (zdola nahoru).
- Více pravých stran: L a U se nemění, opakují se jen substituce.
- $A^(-1)$: vyřešit $A x_i = e_i$ pro $i = 1, ..., n$. Vektory $x_i$ jsou sloupce $A^(-1)$.
- $det A = u_(11) dot u_(22) dot ... dot u_(n n)$, protože $det L = 1$.
#table(columns: (auto, 1fr), fill: (x, y) => if x == 0 { luma(235) },
  [A], [(1 −2 3; 6 −13 18; 4 −10 14)],
  [L], [(1 0 0; 6 1 0; 4 2 1)],
  [U], [(1 −2 3; 0 −1 0; 0 0 2)],
  [det A], [1 · (−1) · 2 = −2],
)
#pozor[`[L, U, P] = lu(A)` prohazuje řádky a platí $P dot A = L dot U$. Ruční L a U se ověří přes `L*U - A`.]

#sec([Choleského rozklad], navy)
$A = L dot L^T$, L je dolní trojúhelníková s kladnou diagonálou. Jde jen pro symetrickou ($A = A^T$) a pozitivně definitní A.
*Sylvestrovo kritérium:* všechny hlavní minory, tedy determinanty levých horních podmatic 1×1 až n×n, jsou kladné.
Po sloupcích, nejdřív diagonála, součty přes $k = 1, ..., j - 1$:
#f[$ l_(j j) = sqrt(a_(j j) - sum_k l_(j k)^2), quad l_(i j) = (a_(i j) - sum_k l_(i k) l_(j k)) / l_(j j) $]
Soustava: $L y = b$ dopředu, $L^T x = y$ zpětně. `chol(A)` vrací $R = L^T$, `chol(A, 'lower')` vrací L. Symetrii `chol` nekontroluje.

#colbreak()

#sec([Normy], purple)
#table(columns: (auto, 1fr, auto), fill: head,
  [*Norma*], [*Výpočet*], [*Matlab*],
  [$norm(A)_1$ \ sloupcová], [největší součet $abs(a_(i j))$ ve sloupci], [`norm(A,1)`],
  [$norm(A)_infinity$ \ řádková], [největší součet $abs(a_(i j))$ v řádku], [`norm(A,Inf)`],
  [$norm(A)_F$ \ Frobeniova], [$sqrt(sum a_(i j)^2)$ přes všechny prvky], [`norm(A,'fro')`],
  [$norm(A)_2$ \ spektrální], [největší singulární číslo $sigma_1$], [`norm(A)`],
)
U vektoru je $norm(v)_infinity = max abs(v_i)$, v Matlabu `norm(v,Inf)`. `norm(A)` bez druhého argumentu je spektrální norma.

#sec([Vlastní a singulární čísla], purple)
Vlastní číslo: $B v = lambda v$ pro nenulové v. Čísla $lambda$ jsou kořeny $det(B - lambda E) = 0$. Pro B = (a b; c d):
#f[$ (a - lambda)(d - lambda) - b c = 0 $]
Spektrální poloměr $rho(B) = max abs(lambda_i)$. Pro každou normu z tabulky platí $rho(B) <= norm(B)$.
Singulární čísla $sigma_i$ jsou odmocniny vlastních čísel $A^T A$, $sigma_1 >= ... >= sigma_n >= 0$. U symetrické A je $sigma_i = abs(lambda_i)$.

#sec([Podmíněnost matice], purple)
#f[$ op("cond")(A) = norm(A) dot norm(A^(-1)) >= 1, quad op("cond")_2 (A) = sigma_1 / sigma_n $]
#f[$ norm(Delta x) / norm(x) <= op("cond")(A) dot norm(Delta b) / norm(b) $]
Postup: spočítat $A^(-1)$ (například přes LU), normu A a normu $A^(-1)$ ve stejné normě a vynásobit je. Při $op("cond")(A) approx 10^k$ se ve výsledku ztratí asi $k$ platných číslic.
Příklad: A = (1 1; 1 1,0001), $A^(-1)$ = (10001 −10000; −10000 10000), $op("cond")_infinity (A)$ = 2,0001 · 20001 ≈ 40004.

#sec([Iterační metody], green)
$x^((k+1)) = B x^((k)) + c$ od zvoleného $x^((0))$. Rozdělení $A = L + D + U$: L pod diagonálou, D diagonála, U nad diagonálou. Nejsou to L a U z LU rozkladu.
#table(columns: (auto, auto, 1fr), fill: head,
  [*Metoda*], [*B a c*], [*Konverguje, když*],
  [Ritzova], [$B = E - A$ \ $c = b$], [$norm(E - A) < 1$],
  [Jacobiho], [$B = -D^(-1)(L + U)$ \ $c = D^(-1) b$], [A je ryze řádkově diagonálně dominantní],
  [Gauss- \ Seidelova], [$B = -(D + L)^(-1) U$ \ $c = (D + L)^(-1) b$], [totéž, nebo A je symetrická pozitivně definitní],
)
Podmínky v tabulce jsou postačující. Vždy stačí $norm(B) < 1$ v jedné normě. Nutná a postačující podmínka je $rho(B) < 1$. Čím menší $rho(B)$, tím méně iterací.
*Jacobi* bere všechny složky z minulého kroku:
#f[$ x_i^((k+1)) = 1 / a_(i i) (b_i - sum_(j != i) a_(i j) x_j^((k))) $]
*Gauss-Seidel* použije nové složky hned:
#f[$ x_i^((k+1)) = 1 / a_(i i) (b_i - sum_(j < i) a_(i j) x_j^((k+1)) - sum_(j > i) a_(i j) x_j^((k))) $]
*Dominance:* v každém řádku $abs(a_(i i)) > sum_(j != i) abs(a_(i j))$. Když neplatí, přeházet rovnice i s pravou stranou.
*Zastavení:* $norm(x^((k+1)) - x^((k)))_infinity <$ tolerance, jako ve funkcích `NaseJacobi` a `NaseGaussSeidel`.
#pisemka[Nerovnosti dominance, předpisy pro $x_1^((k+1))$ až $x_n^((k+1))$, $x^((0))$, tolerance, ručně spočítané $x^((1))$, výsledek z Matlabu a počet iterací.]

#colbreak()

#sec([Chyby], teal)
$x = tilde(x) plus.minus delta(tilde(x))$. $delta$ je odhad absolutní chyby, $rho(tilde(x)) = delta(tilde(x)) \/ abs(tilde(x))$ odhad relativní chyby, často v %.
#table(columns: (auto, 1fr, auto), fill: head,
  [*Operace*], [*Absolutní δ*], [*Relativní ρ*],
  [$tilde(x) plus.minus tilde(y)$], [$delta(tilde(x)) + delta(tilde(y))$], [$delta \/ abs(tilde(x) plus.minus tilde(y))$],
  [$tilde(x) dot tilde(y)$], [$abs(tilde(x)) delta(tilde(y)) + abs(tilde(y)) delta(tilde(x))$], [$rho(tilde(x)) + rho(tilde(y))$],
  [$tilde(x) \/ tilde(y)$], [$(abs(tilde(y)) delta(tilde(x)) + abs(tilde(x)) delta(tilde(y))) \/ tilde(y)^2$], [$rho(tilde(x)) + rho(tilde(y))$],
  [$tilde(x)^n$], [$abs(n) abs(tilde(x))^(n-1) delta(tilde(x))$], [$abs(n) rho(tilde(x))$],
)
#f[$ delta(f(tilde(x))) approx sum_(i=1)^n abs((partial f) / (partial x_i)(tilde(x))) dot delta(tilde(x)_i), quad rho(f) = delta(f) / abs(f) $]
#pisemka[Hodnoty ve tvaru $tilde(x) plus.minus delta$ s jednotkami, $f(tilde(x))$, parciální derivace v $tilde(x)$, $delta(f)$, $rho$ v %. Chyba se zaokrouhlí na jednu platnou číslici, nebo na dvě, když začíná 1 nebo 2. Hodnota se zaokrouhlí na stejný řád, například V = (0,500 ± 0,023) m³.]
Odečítání blízkých čísel zvětší relativní chybu. $rho(tilde(x))$ u čísla není spektrální poloměr $rho(B)$.

#sec([Reprezentace čísel], teal)
$x = plus.minus "0,"d_1 d_2 ... d_t dot beta^epsilon.alt$, $d_1 != 0$. $beta$ je základ, $t$ přesnost (počet číslic mantisy), $epsilon.alt$ exponent. fl(x) je nejbližší číslo této množiny. $a plus.o b = op("fl")(op("fl")(a) + op("fl")(b))$, a proto neplatí asociativní zákon.
*Double (IEEE 754):* 64 bitů, znaménko s (1 bit), exponent e (11 bitů), mantisa f (52 bitů). Pro $0 < e < 2047$:
#f[$ x = (-1)^s dot "1,"f dot 2^(e - 1023) $]
- Jednička před čárkou se neukládá, takže $t = 53$ dvojkových číslic, asi 16 desítkových.
- e = 0: nula a denormalizovaná čísla. e = 2047: Inf a NaN.
- `eps` = $2^(-52) approx$ 2,2204·10⁻¹⁶. Relativní chyba zaokrouhlení je nejvýš eps/2.
- `realmax` ≈ 1,7977·10³⁰⁸, `realmin` = $2^(-1022) approx$ 2,2251·10⁻³⁰⁸.
- Převod do dvojkové soustavy: desetinnou část násobit dvěma a zapisovat celé části. 0,1 = 0,000110011…₂ se opakuje donekonečna, a proto se neuloží přesně.
- Čísla se porovnávají s tolerancí, `abs(a - b) < tol`.

#sec([Podmíněnost úlohy], teal)
#f[$ C_p approx rho(tilde(y)) / rho(tilde(x)) $]
Pro $y = f(x)$ je $C_p approx abs(x f'(x) \/ f(x))$. $C_p approx 1$ je dobře podmíněná úloha, $C_p > 100$ špatně podmíněná. U soustavy rovnic je to $op("cond")(A)$.

#sec([Matlab], slate)
#table(columns: (auto, 1fr), fill: head,
  [*Příkaz*], [*Co dělá*],
  [`x = A\b` \ `A*x - b`], [řešení $A x = b$ s pivotací \ kontrola řešení],
  [`inv(A)`, `det(A)` \ `A'`, `eye(n)`], [inverze, determinant \ $A^T$, jednotková matice E],
  [`prod(diag(U))`], [det A jako součin diagonály U],
  [`cond(A,Inf)` \ `cond(A)`], [$op("cond")_infinity (A)$ \ $op("cond")_2 (A)$],
  [`eig(B)` \ `max(abs(eig(B)))`], [vlastní čísla \ spektrální poloměr $rho(B)$],
  [`svd(A)`], [singulární čísla od největšího],
  [`diag(diag(A))` \ `tril(A,-1)` \ `triu(A,1)`], [D \ L (pod diagonálou) \ U (nad diagonálou)],
  [`format long`], [15 desetinných míst ve výpisu],
)
Funkce ze cvičení musí ležet v Current Folder: `NaseEliminace`, `NaseEliminaceCastecna`, `NaseZpet`, `MOJELUDNES`, `solve_LU`, `inverzni`, `determinant`, `cholesky`, `Ritz`, `NaseJacobi`, `NaseGaussSeidel`.
]
