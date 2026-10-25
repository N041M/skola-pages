# Testy hypotéz: studijní průvodce k midtermu

Zdroje: přednášky 1 až 3 H. Skalské (APSTA, UHK FIM), dvě rozhodovací schémata (B1 jeden výběr, B2 dva výběry, studentský list A5), „Testy hypotéz - příklady s řešením“, „Souhrnný přehled Rozhodování o hypotéze a funkce MsExcelu“ a Groebnerovy příklady s mobilními telefony. Písemka je v češtině. Věty, které lze na písemce napsat, jsou označené ▶.

## 0. Co písemka požaduje

Poznámky k předmětu uvádějí pět věcí, které je potřeba zvládnout u každé slovní úlohy:

1. Pojmenovat testovaný parametr (střední hodnota μ, rozptyl σ², podíl π), určit, zda jde o jeden výběr nebo dva, a u dvou výběrů, zda jsou závislé nebo nezávislé.
2. Zapsat H0 a H1 slovy i symboly.
3. Navrhnout test, pojmenovat jeho variantu a předpoklady.
4. Vypočítat testové kritérium (TK) u jednovýběrových testů, F-testu a t-testu se sdruženým rozptylem.
5. Přečíst kvantil, například t₀.₉₇₅;₆ = 2,45, a říct, zda stačí k rozhodnutí úlohy.

Zbytek průvodce slouží těmto pěti bodům.

## 1. Značení

| Parametr základního souboru | Výběrový odhad | Název |
|---|---|---|
| μ | x̄ (aritmetický průměr) | střední hodnota |
| σ, σ² | s, s² | směrodatná odchylka, rozptyl |
| π | p = m/n (relativní četnost, m = počet výskytů) | pravděpodobnost výskytu jevu, podíl |
| Δ | d̄ | střední hodnota rozdílů (párový test) |
| ρ | r | korelační koeficient |
| β | b | regresní koeficient |

Pozor na dvojice. V tomto předmětu je p výběrový podíl a π je podíl v základním souboru. P-hodnota se jmenuje „hodnota p“ nebo „přesná hladina významnosti“ a s podílem p nemá nic společného.

Další symboly: n = rozsah výběru, df = stupně volnosti, Wα = kritický obor (oblast zamítání), V = doplňkový obor, KH = kritická hodnota, CLV = centrální limitní věta.

## 2. Logika testu (přednáška 1)

Hypotéza je tvrzení o neznámém parametru základního souboru. Test má nulovou hypotézu H0 a alternativní hypotézu H1. Testové kritérium je funkce výběru, jejíž rozdělení se odvodí za předpokladu, že platí H0. Pokud pozorovaná hodnota padne tam, kde by za platnosti H0 byla nepravděpodobná, H0 se zamítne.

### Zápis H0 a H1

- H0 vždy obsahuje „=“. Říká, že není rozdíl, změna ani závislost. Příklady: H0: μ = 5, H0: μ₁ = μ₂, H0: π = 0,32, H0: σ₁² = σ₂².
- H1 je doplněk. Má tři tvary: μ ≠ μ₀ (oboustranná alternativa), μ < μ₀ (levostranná), μ > μ₀ (pravostranná).
- U jednostranné H1 logicky pokrývá H0 i druhou nerovnost. Přednáška píše H0: π = 0,32 proti H1: π > 0,32 a poznamenává, že H0 pak zahrnuje i π < 0,32.
- H1 je obvykle nové tvrzení, které někdo chce prokázat („kampaň zvýšila podíl“, „školení zkrátilo hovory“). V zadání je třeba hledat slova „větší“, „menší“, „zvýšil“, „snížil“, „liší se“, „stejný“. „Liší se“ nebo „změnil se“ znamená oboustrannou alternativu. Slovo udávající směr znamená jednostrannou.
- ▶ „H0 zamítáme, přijímáme H1.“ / ▶ „H0 nezamítáme.“ Nikdy se nepíše „H0 přijímáme“. Přednáška to říká výslovně.

### Chyby při testování

| | H0 platí | H0 neplatí |
|---|---|---|
| H0 nezamítáme (TK ∈ V) | správně, P ≥ 1 − α | chyba II. druhu, P = β |
| H0 zamítáme (TK ∈ Wα) | chyba I. druhu, P ≤ α | správně, P = 1 − β = síla testu |

- α (hladina významnosti) je pravděpodobnost, že se platná H0 chybně zamítne. Volí se, obvykle 0,05 nebo 0,01. Test je sestaven tak, aby tato pravděpodobnost nepřesáhla α.
- β je pravděpodobnost, že se neplatná H0 chybně ponechá. Nevolí se. Dá se spočítat jen pro jednu konkrétní hodnotu alternativy, takže bývá neznámá. Proto se výsledek formuluje „H0 nezamítáme“ a ne „H0 přijímáme“.
- Síla testu = 1 − β = pravděpodobnost, že se neplatná H0 zamítne.

Chování β (přednáška 1, snímek 16, a simulace v přednášce 3):

- Menší α při stejném n dává větší β. Proto se α nevolí příliš malé.
- Větší n při stejném α dává menší β. V simulaci se skutečným rozdílem 3 a n = 30 se H0 nezamítla v 47 % běhů. Při n = 100 to bylo jen 3 %.
- Menší variabilita proměnné dává menší β. Variabilita je vlastnost dat a nedá se zvolit.

Statistická a věcná významnost: u velmi velkého n se statisticky významným stane i nepatrný a prakticky bezvýznamný rozdíl. U každé úlohy je proto nutné říct, co rozdíl znamená ve skutečném problému.

### Kritický obor a kritická hodnota

- Wα je množina hodnot TK, pro které se H0 zamítá. Jeho doplněk je V.
- Kritická hodnota (KH) je kvantil rozdělení TK, který odděluje Wα od V.
- Wα závisí na testu (tvar rozdělení TK za platnosti H0), na zvoleném α a na tvaru H1 (oboustranná rozdělí α do dvou chvostů po α/2, jednostranná dá celé α do jednoho chvostu).

Pro testové kritérium, které je za platnosti H0 symetrické kolem 0 (U s rozdělením N(0,1), T s t-rozdělením):

| H1 | Wα | KH | p-hodnota |
|---|---|---|---|
| ≠ | \|TK\| > x₁₋α/₂ | ± x₁₋α/₂ (pro α = 0,05: ±1,96 u U) | 2·[1 − F(\|TK\|)] |
| < | TK < xα = −x₁₋α | −1,645 u U, α = 0,05 | F(TK) |
| > | TK > x₁₋α | +1,645 u U, α = 0,05 | 1 − F(TK) |

F je distribuční funkce (Φ pro N(0,1), distribuční funkce t-rozdělení pro T).

U rozdělení F a χ², která nejsou symetrická, je oboustranný kritický obor TK < xα/₂ nebo TK > x₁₋α/₂, levostranný je TK < xα a pravostranný je TK > x₁₋α.

### Dvě rozhodovací pravidla

- Pravidlo I: vypočítat TK, najít KH a zamítnout H0, když TK ∈ Wα.
- Pravidlo II: vypočítat p-hodnotu a zamítnout H0, když p ≤ α.

P-hodnota je pravděpodobnost, že za platnosti H0 vyjde TK alespoň tak extrémní, jako bylo pozorováno. Software (SPSS „Sig.“) vypisuje p. Obě pravidla vždy vedou ke stejnému rozhodnutí.

### Kvantily a čtení t₀.₉₇₅;₆ = 2,45

Kvantil x_p je hodnota, pro kterou platí P(X < x_p) = p. Hodnoty pod ním mají pravděpodobnost p a hodnoty nad ním pravděpodobnost 1 − p. Percentil je totéž v procentech.

t₀,₉₇₅;₆ = 2,45 znamená: u t-rozdělení se 6 stupni volnosti mají hodnoty pod 2,45 pravděpodobnost 0,975 a hodnoty nad 2,45 pravděpodobnost 0,025. Tato hodnota je:

- kritická hodnota oboustranného testu při α = 0,05 a df = 6 (obor je |t| > 2,45),
- kritická hodnota pravostranného testu při α = 0,025 a df = 6,
- ze symetrie je −2,45 = t₀,₀₂₅;₆ levostranná kritická hodnota při α = 0,025.

Není to kritická hodnota jednostranného testu při α = 0,05 a df = 6 (ta je t₀,₉₅;₆ = 1,943) ani pro df = 7. Když písemka zadá kvantil, je třeba zkontrolovat tři věci: rozdělení, df a index pravděpodobnosti oproti α a H1.

Symetrie: tα;df = −t₁₋α;df a uα = −u₁₋α. Pro F: Fα;df₁;df₂ = 1 / F₁₋α;df₂;df₁.

Čtení v Excelu: funkce INV vedou od pravděpodobnosti ke kvantilu (T.INV(0,975; 6) = 2,45) a funkce DIST od hodnoty k pravděpodobnosti (T.DIST(2,45; 6; 1) = 0,975). RT znamená pravý chvost a 2T oba chvosty.

### Postup testování (přednáška 1, snímek 20)

1. Zapsat H0 a H1.
2. Zvolit α.
3. Získat výběrová data.
4. Zvolit test (typ proměnné, parametr, hypotéza, rozsah výběru, předpoklady).
5. Vypočítat TK z výběru.
6. Určit Wα pro zvolené α.
7. Rozhodnout: TK je ve Wα nebo není (nebo p ≤ α nebo ne).
8. Interpretovat slovy úlohy.

## 3. Jednovýběrové testy (přednáška 2, schéma B1)

Rozhodovací cesta ve schématu B1: je proměnná přibližně normální, nebo lze předpokládat CLV? Ano → test střední hodnoty nebo rozptylu. Ne → je to binomická proměnná (ano/ne)? Ano → test o π. Ne → jiné rozdělení nebo neparametrický test.

### Střední hodnota, σ známé (u-test)

H0: μ = μ₀. U = (x̄ − μ₀) / (σ/√n), za platnosti H0 U ~ N(0,1). Předpoklady: normální základní soubor nebo velké n, prostý náhodný výběr, σ známé.

### Střední hodnota, σ neznámé (jednovýběrový t-test)

H0: μ = μ₀. T = (x̄ − μ₀) / (s/√n) = (x̄ − μ₀) / s_x̄, kde s_x̄ = s/√n je směrodatná chyba průměru. Za platnosti H0 T ~ t(n − 1). Předpoklady: proměnná má přibližně rozdělení N(μ, σ²), σ² je neznámé a odhaduje se pomocí s², prostý náhodný výběr. Pro n > 100 je t-rozdělení prakticky N(0,1).

Příklad z přednášky (koření): deklarováno 16 g, n = 50, x̄ = 14,9, s = 3,9, zákazníci tvrdí, že je to méně. H0: μ = 16, H1: μ < 16, α = 0,05.
t = (14,9 − 16)/(3,9/√50) = −1,994. KH = t₀,₀₅;₄₉ = −1,6765. −1,994 < −1,6765, tedy H0 se zamítá. p = F_t(−1,994) = 0,026 < 0,05. ▶ „Deklarovaná hmotnost je vyšší než skutečná, stížnost je oprávněná.“

### Rozptyl (χ² test)

H0: σ² = σ₀². χ² = (n − 1)s² / σ₀², za platnosti H0 χ² ~ χ²(n − 1). Test je citlivý na odchylky od normality. Oboustranný obor: χ² < χ²α/₂;n₋₁ nebo χ² > χ²₁₋α/₂;n₋₁.

### Podíl (parametr binomického rozdělení), limitní test

Dvouhodnotová proměnná (má znak / nemá). m = počet úspěchů v n nezávislých pokusech má binomické rozdělení. p = m/n odhaduje π.

H0: π = π₀. U = (p − π₀) / √(π₀(1 − π₀)/n), za platnosti H0 přibližně U ~ N(0,1).

Předpoklad (CLV): n·π₀ ≥ 5 a n·(1 − π₀) ≥ 5 a π₀ není blízko 0 ani 1. Kontrola používá π₀ z H0, ne p. Když kontrola neprojde, použije se exaktní binomický test (není součástí písemky).

Korekce na nespojitost: přednáška odečítá 1/(2n) od |p − π₀| v čitateli. Příklad A: π₀ = 0,56, n = 500, m = 298, p = 0,596. Bez korekce u = 0,036/0,0222 = 1,62. S korekcí u = (0,036 − 0,001)/0,0222 = 1,5766. Obě hodnoty jsou pod 1,96, takže H0 se nezamítá. Oboustranné p = 2·[1 − Φ(1,5766)] = 0,1148.

Příklad B má stejná data a H1: π > 0,56. KH = u₀,₉₅ = 1,645. u = 1,58 < 1,645, nezamítá se. Jednostranné p = 1 − Φ(1,5766) = 0,0574 > 0,05. Porovnání: stejná data dávají p = 0,115 oboustranně a p = 0,057 jednostranně. Jednostranné p je polovina oboustranného, když výběr ukazuje ve směru H1.

▶ „Nepodařilo se prokázat statisticky významnou změnu podílu na trhu (na hladině významnosti 0,05). Pozorovanou odchylku lze vysvětlit náhodnou chybou výběru.“

## 4. Dvouvýběrové testy (přednáška 3, schéma B2)

### Závislé, nebo nezávislé výběry?

Závislé (párové): stejné jednotky změřené dvakrát (před a po, první a druhé čtení) nebo jednotky spárované (stejný nákupní košík oceněný v obchodě A a v obchodě B). Každá hodnota v prvním výběru má partnera v druhém a n₁ = n₂.

Nezávislé: dvě různé skupiny jednotek (muži a ženy, zákazníci obchodu A a obchodu B, tarif Basic a tarif Business). Rozsahy se mohou lišit.

### Párový t-test

Pro každý pár se vytvoří rozdíl dᵢ. Přednáška definuje dᵢ = xᵢ⁽²⁾ − xᵢ⁽¹⁾ na teoretickém snímku, zatímco řešený příklad s krevním tlakem používá D = X₁ − X₂. Obojí je v pořádku, ale směr H1 musí odpovídat definici d. Je nutné ji uvést.

H0: Δ = Δ₀ (obvykle 0). d̄ = (1/n) Σ dᵢ, s_d² = (1/(n − 1)) Σ (dᵢ − d̄)².
T = (d̄ − Δ₀) / (s_d/√n), T ~ t(n − 1). Předpoklad: rozdíly mají přibližně rozdělení N(Δ, σ_d²). Je to jednovýběrový t-test použitý na rozdíly.

Příklad z přednášky (hypermarkety A a B, 100 spárovaných košíků): d̄ = 3,57, s_d = 2,99, H1: Δ > 0, α = 0,01. t = 3,57/(2,99/√100) = 11,94 > t₀,₉₉;₉₉ = 2,364. SPSS vypsal Sig. = 0,000 (ve skutečnosti 7·10⁻²¹). ▶ „Na 1% hladině významnosti je prokázána statisticky významně vyšší průměrná úroveň cen v hypermarketu A.“

### F-test shody rozptylů

H0: σ₁² = σ₂². F = s₁²/s₂², přičemž označení se zvolí tak, aby s₁² ≥ s₂² (větší rozptyl v čitateli). Za platnosti H0 F ~ F(n₁ − 1, n₂ − 1) (nejdřív stupně volnosti čitatele, potom jmenovatele). Předpoklad: nezávislé výběry z normálních souborů.

S větším rozptylem nahoře záleží jen na pravém chvostu: oboustranná H1 zamítá, když F > F₁₋α/₂;n₁₋₁;n₂₋₁, pravostranná H1 zamítá, když F > F₁₋α;n₁₋₁;n₂₋₁. Když větší rozptyl nahoře není, je oboustranný obor F < Fα/₂ nebo F > F₁₋α/₂.

Poznámka: snímek 11 přednášky 3 píše stupně volnosti jako (n₁ − 1, n₂ − 2). Snímek 12 a příklady používají (n₁ − 1, n₂ − 1), což je správně.

Příklad z přednášky (ohřívače): s₁² = 8,354 (n₁ = 13), s₂² = 2,367 (n₂ = 15), H1: σ₁² > σ₂², α = 0,05. F = 3,53 > F₀,₉₅;₁₂;₁₄ = 2,53. Zamítá se. ▶ „Model 2 má statisticky významně nižší rozptyl teplot.“

F-test se v tomto předmětu používá hlavně k výběru jedné ze dvou verzí nepárového t-testu.

V SPSS výstup místo poměru F ukazuje Levenův test. Jeho Sig. hraje stejnou roli (Sig. > α → rozptyly se berou jako shodné → čte se řádek „Equal variances assumed“; Sig. ≤ α → čte se „Equal variances not assumed“). Levenovo F není poměr s₁²/s₂², takže když písemka žádá kritérium F, poměr je nutné spočítat ručně.

### Nepárový t-test při shodných rozptylech

H0: μ₁ = μ₂. Sdružený rozptyl s² = [(n₁ − 1)s₁² + (n₂ − 1)s₂²] / (n₁ + n₂ − 2).
T = (x̄₁ − x̄₂) / (s·√(1/n₁ + 1/n₂)), za platnosti H0 T ~ t(n₁ + n₂ − 2).
Předpoklady: oba soubory jsou přibližně normální, nezávislé prosté náhodné výběry, σ₁² = σ₂² neznámé (F-test nezamítl).

Příklad z přednášky (autobazary A a B): n₁ = 36, x̄₁ = 169,417, s₁² = 1442,99; n₂ = 34, x̄₂ = 162,068, s₂² = 1022,6; α = 0,05.
F-test: F = 1,411 < F₀,₉₇₅;₃₅;₃₃ = 1,9886, rozptyly se berou jako shodné.
s² = (35·1442,99 + 33·1022,6)/68 = 1238,98, s = 35,20.
t = 7,349 / (35,20·√(1/36 + 1/34)) = 0,873 < t₀,₉₇₅;₆₈ = 1,995. Nezamítá se. p = 2·T.DIST.RT(0,873; 68) = 0,386. ▶ „Rozdíl mezi průměrnými cenami nebyl prokázán (p = 0,386).“

### Nepárový t-test při různých rozptylech (Welch)

H0: μ₁ = μ₂. T = (x̄₁ − x̄₂) / √(s₁²/n₁ + s₂²/n₂).
df = (s₁²/n₁ + s₂²/n₂)² / [ (s₁²/n₁)²/(n₁ − 1) + (s₂²/n₂)²/(n₂ − 1) ], zaokrouhleno dolů na celé číslo.

Příklad z přednášky (autobazary A a C): s₁² = 1442,99, s₃² = 636,004, obě n = 36. F = 2,269 > F₀,₉₇₅;₃₅;₃₅ = 1,961, rozptyly se tedy liší a použije se Welch. H1: μ₁ > μ₃. t = 20,823/7,599 = 2,740, df = 60,83 → 60, KH = t₀,₉₅;₆₀ = 1,671. Zamítá se, p = 0,004.

### Dvouvýběrový Z-test (σ₁, σ₂ známé)

Jen ve studentském schématu A5, v přednáškách není. Z = (x̄₁ − x̄₂ − Δ₀) / √(σ₁²/n₁ + σ₂²/n₂), Z ~ N(0,1). Používá se, když zadání uvádí směrodatné odchylky základních souborů.

### Dva podíly (test shody podílů, shoda dvou parametrů binomického rozdělení)

Dva nezávislé výběry, p₁ = m₁/n₁, p₂ = m₂/n₂. Sdružený odhad za platnosti H0: p̄ = (m₁ + m₂)/(n₁ + n₂).
H0: π₁ = π₂. U = (p₁ − p₂) / √( p̄(1 − p̄)·(1/n₁ + 1/n₂) ), což přednáška zapisuje také jako (p₁ − p₂)/√(p̄(1 − p̄)) · √(n₁n₂/(n₁ + n₂)). Přibližně U ~ N(0,1).
Předpoklad (CLV): nᵢpᵢ ≥ 5 a nᵢ(1 − pᵢ) ≥ 5 u obou výběrů. Jinak exaktní Fisherův test. Pro párová dvouhodnotová data McNemarův test. Limitní test je ekvivalentní χ² testu tabulky 2×2.

Příklad z přednášky: 54 z 231 mladých a 49 ze 173 starších lidí uvádí zhoršení. p₁ = 0,234, p₂ = 0,283, p̄ = 103/404 = 0,255. u = −0,049 / √(0,255·0,745·(1/231 + 1/173)) = −1,13 (snímek ukazuje 1,07, protože zaokrouhlil p₂ na 0,281). |u| < 1,96, nezamítá se, p = 0,26. ▶ „Mezi věkovými skupinami nebyl prokázán statisticky významný rozdíl v podílech.“

### Výběr testu (schéma B2 slovy)

Kvantitativní proměnná, střední hodnoty:
- jeden výběr: σ známé → u-test; σ neznámé → t-test (df = n − 1)
- dva závislé výběry → párový t-test (df = n − 1)
- dva nezávislé výběry: σ₁, σ₂ známé → Z-test; neznámé → nejdřív F-test, potom t-test se sdruženým rozptylem (df = n₁ + n₂ − 2), pokud F nezamítne, a Welch, pokud zamítne
- více než dva nezávislé výběry → ANOVA (další kapitola)

Kvantitativní proměnná, rozptyly: jeden výběr → χ²(n − 1); dva nezávislé výběry → F(n₁ − 1, n₂ − 1).

Dvouhodnotová proměnná, podíly:
- jeden výběr: nπ₀ ≥ 5 a n(1 − π₀) ≥ 5 → limitní u-test; jinak binomický test
- dva nezávislé výběry: CLV platí → limitní U test; jinak Fisherův exaktní test
- dva závislé výběry → McNemarův test
- závislost v tabulce r × c → χ² test (další kapitola)

Proměnná není normální a n je malé → neparametrický test (není na písemce).

## 5. Jak zapsat řešení písemkové úlohy

Tato kostra platí pro každou slovní úlohu a pokrývá vše, co se v předmětu hodnotí.

1. ▶ Parametr: „Testuje se střední hodnota μ (jeden výběr, σ neznámé).“ nebo „Testují se podíly π₁ a π₂ ve dvou nezávislých výběrech.“
2. ▶ Hypotézy: „H0: μ = 540 (školení délku hovorů nezměnilo), H1: μ < 540 (školení hovory zkrátilo), levostranná alternativa.“ Vždy se uvede, o jaký parametr jde, a směr se vyjádří slovy.
3. ▶ Hladina významnosti: „α = 0,05.“
4. ▶ Test a předpoklady: „Jednovýběrový t-test. Předpoklady: přibližně normální rozdělení délky hovorů, prostý náhodný výběr, σ odhadnuto výběrovou směrodatnou odchylkou s.“
5. ▶ Testové kritérium: napsat vzorec, dosadit a uvést číslo.
6. ▶ Kritický obor: „T má při platnosti H0 t-rozdělení s df = n − 1 = 15. W₀,₀₅ = {t: t < t₀,₀₅;₁₅ = −1,753}.“ Uvede se, který kvantil je potřeba a proč má tento index.
7. ▶ Rozhodnutí: „t = −2,67 ∈ W, H0 zamítáme na hladině významnosti 0,05 (p = 0,009 < 0,05).“
8. ▶ Interpretace: „Školení statisticky významně zkrátilo průměrnou délku hovoru.“ nebo při nezamítnutí: „Statisticky významný rozdíl nebyl prokázán, pozorovaný rozdíl lze vysvětlit výběrovou chybou.“

Když písemka zadá kvantil a ptá se, zda stačí k rozhodnutí, je třeba pojmenovat rozdělení, df a index pravděpodobnosti, které test potřebuje, a porovnat je se zadaným. Když souhlasí, rozhodne se. Když ne, uvede se, co chybí (například „potřebuji t₀,₉₅;₁₅, zadáno je t₀,₉₇₅;₁₅, to je kritická hodnota pro oboustrannou alternativu“).

## 6. Pasti, na které materiály předmětu upozorňují

- π a p, σ a s, μ a x̄. Hypotézy se vždy týkají řeckého symbolu (základní soubor).
- H0 musí obsahovat „=“. „H0: μ > 540“ je špatně.
- Slovo udávající směr v zadání znamená jednostrannou H1 a jednostrannou kritickou hodnotu (u₀,₉₅ = 1,645, ne 1,96). Oboustranná H1 používá α/2 v každém chvostu.
- Levostranný test: kritická hodnota je záporná a TK musí být pod ní.
- Jednostranná p-hodnota je jeden chvost. Nezdvojnásobuje se.
- F-test: větší rozptyl nahoře, potom porovnání s F₁₋α/₂ (oboustranně) nebo F₁₋α (jednostranně). Nejdřív stupně volnosti čitatele.
- F-test předchází nepárový t-test a rozhoduje, která verze se použije.
- Welchovo df se zaokrouhluje dolů.
- Párová data (n₁ = n₂ a přirozené párování) se nesmí analyzovat jako dva nezávislé výběry.
- Kontrola CLV u jednoho podílu používá π₀, u dvou podílů výběrové podíly.
- „H0 nezamítáme“ neznamená „H0 platí“. Nezamítnutí znamená, že data H0 neodporují.
- Menší α znamená větší β. Větší n zmenšuje β.
- Statistická významnost není věcná důležitost.

## 7. Příklady k procvičení

Úlohy se řeší na papíře s tahákem a řešení na konci slouží ke kontrole. Potřebné kvantily: u₀,₉₅ = 1,645, u₀,₉₇₅ = 1,960, t₀,₉₅;₉ = 1,833, t₀,₉₇₅;₉ = 2,262, t₀,₉₅;₁₁ = 1,796, t₀,₉₇₅;₁₈ = 2,101, t₀,₉₉;₂₄ = 2,492, F₀,₉₅;₉;₁₁ = 2,896, F₀,₉₇₅;₉;₁₁ = 3,588, χ²₀,₀₂₅;₉ = 2,70, χ²₀,₉₇₅;₉ = 19,02.

**P1.** Automat na kávu má vydávat 5 g. V 10 náhodných kelímcích byl průměr 5,3 g a s = 0,4 g. Liší se automat od 5 g? α = 0,05. Předpokládá se normalita.

**P2.** Výrobce tvrdí, že nejvýše 10 % jeho přístrojů selže do roka. Z 200 přístrojů jich selhalo 28. Je podíl poruch vyšší, než se tvrdí? α = 0,05.

**P3.** Dvě nezávislé skupiny studentů psaly stejný test. Skupina 1: n₁ = 10, x̄₁ = 72, s₁ = 8. Skupina 2: n₂ = 12, x̄₂ = 65, s₂ = 6. Dosahuje skupina 1 v průměru vyššího skóre? α = 0,05. Předpokládá se normalita. Začít F-testem.

**P4.** U 25 pacientů se měřil cholesterol před dietou a po ní. Průměrný pokles (před − po) byl 0,30 mmol/l a s_d = 0,50. Snížila dieta cholesterol? α = 0,01.

**P5.** Ve městě A podporuje projekt 120 z 300 respondentů, ve městě B 90 z 300. Liší se podpora mezi městy? α = 0,05.

**P6.** Stroj má mít směrodatnou odchylku σ = 2,0 mm. Výběr 10 dílů má s = 2,9 mm. Liší se rozptyl od 4,0 mm²? α = 0,05. Které kvantily jsou potřeba?

**P7.** Testuje se H0: μ = 100 proti H1: μ > 100 při n = 12 a neznámém σ. List k písemce uvádí t₀,₉₇₅;₁₁ = 2,201. Vyšlo t = 2,0. Lze rozhodnout při α = 0,05? Co chybí?

**P8.** Pojmová úloha. (a) Co se stane s β, když se při stejných datech sníží α z 0,05 na 0,01? (b) Dva způsoby, jak snížit β. (c) Test s n = 10 000 zamítá H0: μ₁ = μ₂ s p = 0,001 a pozorovaný rozdíl je 0,2 % průměru. Co o tom říct?

**P9.** Výstup SPSS pro Total $ spent, muži proti ženám: Levene F = 11,262, Sig. = 0,002; řádek „Equal variances assumed“ t = 2,158, df = 48, Sig. (2-tailed) = 0,036; řádek „Equal variances not assumed“ t = 2,450, df = 44,55, Sig. (2-tailed) = 0,018. Který řádek se čte a jaký je závěr při α = 0,05?

### Řešení

**P1.** Parametr μ, jeden výběr, σ neznámé. H0: μ = 5, H1: μ ≠ 5. Jednovýběrový t-test, df = 9. t = (5,3 − 5)/(0,4/√10) = 0,3/0,1265 = 2,372. KH = ±t₀,₉₇₅;₉ = ±2,262. |2,372| > 2,262 → H0 zamítáme na hladině 0,05. Automat se odchyluje (přeplňuje). U jednostranné H1: μ > 5 by KH byla 1,833 a závěr by byl stejný.

**P2.** Parametr π, jeden výběr. H0: π = 0,10, H1: π > 0,10. CLV: 200·0,1 = 20 ≥ 5 a 200·0,9 = 180 ≥ 5, limitní test lze použít. p = 28/200 = 0,14. u = (0,14 − 0,10)/√(0,1·0,9/200) = 0,04/0,02121 = 1,886. KH = u₀,₉₅ = 1,645. 1,886 > 1,645 → H0 zamítáme. Podíl poruch je významně vyšší než 10 %. (S korekcí na nespojitost: (0,04 − 0,0025)/0,02121 = 1,768, pořád se zamítá.)

**P3.** Nejdřív F-test. H0: σ₁² = σ₂², H1: σ₁² ≠ σ₂². F = 64/36 = 1,778 (větší nahoře, df 9 a 11). KH = F₀,₉₇₅;₉;₁₁ = 3,588. 1,778 < 3,588 → rozptyly se berou jako shodné. T-test se sdruženým rozptylem. H0: μ₁ = μ₂, H1: μ₁ > μ₂. s² = (9·64 + 11·36)/20 = (576 + 396)/20 = 48,6, s = 6,971. t = (72 − 65)/(6,971·√(1/10 + 1/12)) = 7/(6,971·0,4282) = 7/2,985 = 2,345. df = 20. KH = t₀,₉₅;₂₀ = 1,725 (z tabulky t-rozdělení). 2,345 > 1,725 → H0 zamítáme. Skupina 1 dosahuje významně vyššího skóre.

**P4.** Párový test, parametr Δ = μ_před − μ_po. H0: Δ = 0, H1: Δ > 0. t = 0,30/(0,50/√25) = 0,30/0,10 = 3,0. df = 24. KH = t₀,₉₉;₂₄ = 2,492. 3,0 > 2,492 → H0 zamítáme na hladině 0,01. Dieta významně snížila cholesterol.

**P5.** Dva nezávislé podíly. H0: π₁ = π₂, H1: π₁ ≠ π₂. p₁ = 0,40, p₂ = 0,30, p̄ = 210/600 = 0,35. CLV platí (všechna n·p a n·(1 − p) jsou daleko nad 5). u = (0,40 − 0,30)/√(0,35·0,65·(2/300)) = 0,10/√(0,0015167) = 0,10/0,03894 = 2,568. KH = ±1,96. 2,568 > 1,96 → H0 zamítáme. Podpora se liší (p ≈ 0,010).

**P6.** Jednovýběrový test rozptylu. H0: σ² = 4, H1: σ² ≠ 4. χ² = (n − 1)s²/σ₀² = 9·8,41/4 = 18,92. df = 9. Oboustranný obor: χ² < χ²₀,₀₂₅;₉ = 2,70 nebo χ² > χ²₀,₉₇₅;₉ = 19,02. 18,92 je těsně pod 19,02 → H0 nezamítáme. Odchylka není významná při α = 0,05 (při α = 0,10, kde je kvantil 16,92, by významná byla).

**P7.** Potřebná je pravostranná kritická hodnota t₀,₉₅;₁₁ = 1,796. Zadané t₀,₉₇₅;₁₁ = 2,201 je oboustranná hodnota při α = 0,05 (nebo jednostranná při α = 0,025). Samotná dovoluje říct jen toto: protože 2,0 < 2,201, je jednostranné p větší než 0,025. Z toho nevyplývá, zda p ≤ 0,05. Protože t₀,₉₅;₁₁ = 1,796 < 2,0, H0 se při α = 0,05 zamítá. Na písemce se píše, který kvantil je potřeba a proč.

**P8.** (a) β roste. Menší α zmenšuje kritický obor, takže se neplatná H0 ponechává častěji. (b) Zvětšit n nebo snížit variabilitu měření (lepší plán, homogennější jednotky). Zvolit větší α také snižuje β, ale zvyšuje riziko chyby I. druhu. (c) Rozdíl je statisticky významný, protože n je obrovské, ale rozdíl 0,2 % je prakticky zanedbatelný. Uvádí se p-hodnota i velikost rozdílu a říká se, že statistická významnost neznamená věcnou důležitost.

**P9.** Levene Sig. = 0,002 < 0,05, rozptyly se tedy liší a čte se „Equal variances not assumed“: t = 2,450, df = 44,55, p = 0,018 < 0,05. H0 o shodě průměrných výdajů se zamítá. Muži v průměru utrácejí významně více (rozdíl průměrů 38,38 USD). Kdyby alternativa byla jednostranná v pozorovaném směru, bylo by p = 0,009.

## 8. Další kapitoly (nejsou v tomto midtermu, ale jsou na souhrnném přehledu)

ANOVA pro jeden faktor testuje H0: μ₁ = μ₂ = … = μᵣ pomocí F = MSTR/MSE a df (r − 1, n − r). χ² test nezávislosti v kontingenční tabulce r × c používá χ² = Σ (nᵢⱼ − nᵢⱼᵀ)²/nᵢⱼᵀ s df (r − 1)(c − 1) a pravostrannou kritickou hodnotou CHISQ.INV.RT(α; df).
