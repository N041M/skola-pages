# Postupy a chytáky: GEM, LU rozklad, iterační metody a šíření chyb

Dokument ukazuje krok za krokem, jak na papíře vyřešit úlohy na Gaussovu eliminační metodu, LU rozklad, Jacobiho, Gauss-Seidelovu a Ritzovu (prostou) iterační metodu a šíření chyb. Každá kapitola má postup, úplně spočítaný příklad, chytáky s ukázkou chybného a správného výpočtu a cvičení s výsledky. Příklady jsou ze souborů cviceni_03.m a cviceni_04.m, z listu cvITER_SLAR.pdf, z přednášky numa_01.pdf, z listu MOJE_CHYBA.pdf a z kapitoly IV.pdf. Ostatní příklady jsou nové. Všechna čísla jsou přepočítaná v Pythonu, u přímých metod přesně ve zlomcích. Příkazy pro Matlab nebyly spuštěné. V materiálech ke cvičení nejsou přímé vzorce pro prvky L a U, sloupcová diagonální dominance a odhad chyby iterační metody. Dokument je přebírá ze standardní učebnicové látky a u každého to uvádí.

## 0. Návyky pro každý výpočet

- Soustava se zapisuje jako rozšířená matice (A | b). Každá úprava řádku se tak provede i s pravou stranou.
- Počítá se ve zlomcích a desetinná čísla se zaokrouhlují až ve výsledku. U iteračních metod se drží aspoň 4 až 6 desetinných míst.
- Každá úprava se zapíše vedle řádku, například ř₃ − 2·ř₂.
- Výsledek přímé metody se ověří dosazením do původní soustavy.
- Iterace se zapisují do tabulky se sloupci k, x₁, x₂, x₃ a ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖∞.

Značení: řᵢ je i-tý řádek, mᵢₖ multiplikátor, E jednotková matice a x⁽ᵏ⁾ vektor po k krocích iterace. Matice jsou v textu zapsané po řádcích se středníkem mezi řádky, například (1 2; 3 4). Pivot je v ručních výpočtech v rámečku a změněná čísla jsou žlutá.

## 1. Gaussova eliminační metoda (GEM)

GEM převede rozšířenou matici (A | b) řádkovými úpravami na horní trojúhelníkový tvar (U | y). Soustava Ux = y se pak vyřeší zpětnou substitucí odspodu nahoru.

### Postup

> Na písemku
> 1. Zapsat rozšířenou matici (A | b).
> 2. V kroku k = 1, …, n − 1 vzít za pivot prvek aₖₖ aktuální matice. Když je nulový, prohodit řádek k s některým řádkem pod ním.
> 3. Pro každý řádek i pod pivotem spočítat mᵢₖ = aᵢₖ / aₖₖ z aktuální matice.
> 4. Nový řádek i = řádek i − mᵢₖ · řádek k, včetně posledního sloupce b.
> 5. Po posledním kroku spočítat zpětnou substitucí xₙ, pak xₙ₋₁ až x₁.
> 6. Dosadit x do původní soustavy.

Zpětná substituce pro i = n, n − 1, …, 1:

**xᵢ = (yᵢ − Σ uᵢⱼ·xⱼ) / uᵢᵢ**, kde součet jde přes j = i + 1, …, n.

### Vyřešený příklad

Soustava z cviceni_03.m: 2x₁ + x₂ + x₃ = 1, 4x₁ + x₂ = −2, −2x₁ + 2x₂ + x₃ = 7. Poslední sloupec matice je pravá strana b.

```matice
(A | b) = [*2 1 1 1; 4 1 0 −2; −2 2 1 7]
| ; ř₂ − 2·ř₁; ř₃ − (−1)·ř₁
→ krok 1
[2 1 1 1; !0 !*−1 !−2 !−4; !0 !3 !2 !8]
| ; ; ř₃ − (−3)·ř₂
→ krok 2
[2 1 1 1; 0 −1 −2 −4; 0 !0 !−4 !−4] = (U | y)
- Krok 1, pivot 2: m₂₁ = 4/2 = 2 a m₃₁ = −2/2 = −1. Úprava ř₃ − (−1)·ř₁ je ř₃ + ř₁.
- Krok 2, pivot −1: m₃₂ = 3/(−1) = −3. Úprava ř₃ − (−3)·ř₂ je ř₃ + 3·ř₂.
```

Zpětná substituce:

```
x₃ = −4 / (−4) = 1
x₂ = (−4 − (−2)·x₃) / (−1) = (−4 + 2) / (−1) = 2
x₁ = (1 − 1·x₂ − 1·x₃) / 2 = (1 − 2 − 1) / 2 = −1
```

Zkouška v původní soustavě: 2·(−1) + 2 + 1 = 1, 4·(−1) + 2 = −2 a −2·(−1) + 2·2 + 1 = 7. Řešení je x = (−1; 2; 1).

### Částečná pivotace

S částečnou pivotací se v kroku k za pivot vezme prvek s největší absolutní hodnotou ve sloupci k na diagonále a pod ní. Jeho řádek se prohodí s řádkem k celý, včetně b. Takto počítá funkce `NaseEliminaceCastecna` ze cvičení a stejně pivotuje `A\b` v Matlabu.

Příklad: x₁ − x₂ + 2x₃ = −3, 2x₁ + x₂ + x₃ = 3, −4x₁ + 2x₂ + x₃ = −1.

```matice
(A | b) = [1 −1 2 −3; 2 1 1 3; *−4 2 1 −1]
→ ř₁ ↔ ř₃
[!*−4 !2 !1 !−1; 2 1 1 3; !1 !−1 !2 !−3]
| ; ř₂ − (−1/2)·ř₁; ř₃ − (−1/4)·ř₁
→ krok 1
[−4 2 1 −1; !0 !*2 !3/2 !5/2; !0 !−1/2 !9/4 !−13/4]
| ; ; ř₃ − (−1/4)·ř₂
→ krok 2
[−4 2 1 −1; 0 2 3/2 5/2; 0 !0 !21/8 !−21/8]
- Krok 1: ve sloupci 1 jsou čísla 1, 2 a −4. Největší absolutní hodnotu má −4, proto se prohodí ř₁ a ř₃. Pak m₂₁ = 2/(−4) = −1/2 a m₃₁ = 1/(−4) = −1/4.
- Krok 2: ve sloupci 2 na diagonále a pod ní jsou 2 a −1/2. Pivot 2 už je na diagonále, takže se nic neprohazuje. m₃₂ = (−1/2)/2 = −1/4.
- Zpětná substituce: x₃ = (−21/8)/(21/8) = −1, x₂ = (5/2 − 3/2·(−1))/2 = 2 a x₁ = (−1 − 2·2 − 1·(−1))/(−4) = 1.
```

### Chytáky

#### Znaménko multiplikátoru

Multiplikátor je mᵢₖ = aᵢₖ / aₖₖ a od řádku i se vždy odečítá mᵢₖ·řₖ. Při záporném multiplikátoru se tedy řádek přičítá. V příkladu je m₃₁ = −1 a úprava je ř₃ + ř₁. Zápis „ř₃ − ř₁“ dá místo (0 3 2 8) řádek (−4 1 0 6) a pod pivotem nula nevznikne.

Pivot je ve jmenovateli. Obrácený podíl m₂₁ = 2/4 = 1/2 dá řádek (3 1/2 −1/2 −5/2) a nulu také nevyrobí. Když v prvním sloupci nevyjde nula, je chyba v multiplikátoru.

#### Multiplikátor z aktuální matice

V kroku 2 se multiplikátor počítá z matice po kroku 1. V příkladu je m₃₂ = 3/(−1) = −3. Čísla z původní matice A by dala a₃₂/a₂₂ = 2/1 = 2, a to je špatně. Odečítá se také upravený řádek ř₂ = (0 −1 −2 −4), ne původní (4 1 0 −2).

#### Pravá strana

Každá úprava řádku a každé prohození se provede i s bᵢ. Kdo upravuje b zvlášť až na konci, snadno vynechá jeden krok. V rozšířené matici (A | b) se to nestane.

#### Nulový pivot

Když na diagonále vyjde nula, multiplikátor nejde spočítat. Řádek se prohodí s některým řádkem pod ním, který má v tomto sloupci nenulové číslo. Řádek nad pivotem se nepoužije, protože by se porušily nuly, které už vznikly.

```matice
[*1 2 1 4; 2 4 3 9; 3 7 2 12]
| ; ř₂ − 2·ř₁; ř₃ − 3·ř₁
→ krok 1
[1 2 1 4; !0 !*0 !1 !1; !0 !1 !−1 !0]
| ; ř₂ ↔ ř₃; ř₃ ↔ ř₂
→ prohození
[1 2 1 4; !0 !*1 !−1 !0; !0 !0 !1 !1]
- Po kroku 1 je na pozici (2, 2) nula a m₃₂ = 1/0 neexistuje. Řádky 2 a 3 se prohodí.
- Po prohození je pod pivotem nula, takže krok 2 nic nemění. Zpětná substituce dá x₃ = 1, x₂ = 0 + x₃ = 1 a x₁ = 4 − 2 − 1 = 1.
```

Nulový pivot neznamená singulární matici. Tato matice má det A = −1. Matice je singulární, když v některém kroku jsou ve sloupci na diagonále a pod ní samé nuly.

#### Malý pivot

Malý pivot výpočet nezastaví, ale dá velký multiplikátor. Při počítání s omezeným počtem číslic pak velká čísla přehluší ostatní řádky. Soustava 0,0001·x₁ + x₂ = 1, x₁ + x₂ = 2 má přesné řešení x₁ ≈ 1,0001 a x₂ ≈ 0,9999. Výpočet na 3 platné číslice:

```
bez pivotace:  m₂₁ = 1 / 0,0001 = 10000
               u₂₂ = 1 − 10000 = −9999 ≈ −10000
               y₂  = 2 − 10000 = −9998 ≈ −10000
               x₂  = −10000 / (−10000) = 1
               x₁  = (1 − x₂) / 0,0001 = 0         špatně

s pivotací:    ř₁ ↔ ř₂, m₂₁ = 0,0001 / 1 = 0,0001
               u₂₂ = 1 − 0,0001 = 0,9999 ≈ 1,00
               y₂  = 1 − 0,0002 = 0,9998 ≈ 1,00
               x₂  = 1,00 / 1,00 = 1
               x₁  = (2 − x₂) / 1 = 1             správně na 3 číslice
```

Ve zlomcích se na papíře počítá přesně a pivotace tam kvůli přesnosti potřeba není. Když ale zadání chce částečnou pivotaci, provede se v každém kroku, i když je pivot nenulový.

#### Částečná pivotace podle absolutní hodnoty

Pivot je číslo s největší absolutní hodnotou. Ve sloupci (1; 2; −4) je to −4, ne 2. Porovnávají se jen prvky aktuálního sloupce na diagonále a pod ní. Řádky, které už pivot měly, se neprohazují.

#### Singulární matice

Když po eliminaci vyjde v U řádek samých nul, matice je singulární a zpětná substituce by dělila nulou. O soustavě rozhodne číslo v posledním sloupci téhož řádku. Když je nenulové, soustava nemá řešení. Když je nulové, soustava má nekonečně mnoho řešení.

```matice
[*1 2 3; 2 4 6]
| ; ř₂ − 2·ř₁
→
[1 2 3; !0 !0 !0]
- Druhý řádek dává 0 = 0, takže soustava má nekonečně mnoho řešení x₁ = 3 − 2x₂ pro libovolné x₂.
- S pravou stranou (3; 7) by vyšel řádek 0 = 1 a soustava by neměla řešení.
```

#### Zpětná substituce

Počítá se odspodu. Do řádku i se dosazují už spočítané xᵢ₊₁ až xₙ a výsledek se dělí diagonálním prvkem uᵢᵢ i se znaménkem. V příkladu je x₂ = (−4 + 2)/(−1) = 2. Bez dělení −1 by vyšlo x₂ = −2.

#### Zkouška v původní soustavě

Řešení se dosazuje do původní soustavy. Chybu z eliminace má i upravená soustava (U | y), a zkouška v ní ji proto neodhalí.

### Kontrola v Matlabu

```
A = [2 1 1; 4 1 0; -2 2 1];
b = [1; -2; 7];
[U, y] = NaseEliminace(A, b)
x = NaseZpet(U, y)
[U, y] = NaseEliminaceCastecna(A, b)
A\b
```

- `NaseEliminace` počítá bez pivotace stejně jako ruční výpočet a vrátí U a upravené b.
- `NaseEliminaceCastecna` pivotuje. U této matice prohazuje řádky v obou krocích a vrátí U = (4 1 0; 0 5/2 1; 0 0 4/5) a y = (−2; 6; 4/5). Řešení x vyjde stejné.
- `A\b` pivotuje sám a vrátí x = (−1; 2; 1).

### Cvičení

1. Matice (2 4 −6; 1 5 3; 1 3 2) z cviceni_03.m a b = (4; 14; 9). Na kontrolu: m₂₁ = 1/2, m₃₁ = 1/2, m₃₂ = 1/3, U = (2 4 −6; 0 3 6; 0 0 3), y = (4; 12; 3) a x = (1; 2; 1).
2. Soustavu z chytáku Nulový pivot, (1 2 1; 2 4 3; 3 7 2) a b = (4; 9; 12), spočítat s částečnou pivotací. Na kontrolu: v kroku 1 se prohodí ř₁ a ř₃, m₂₁ = 2/3, m₃₁ = 1/3, v kroku 2 se nic neprohazuje, protože |−2/3| > |−1/3|, m₃₂ = 1/2, U = (3 7 2; 0 −2/3 5/3; 0 0 −1/2), y = (12; 1; −1/2) a x = (1; 1; 1).
3. Matice (2 1 1; 4 3 3; 8 7 9) a b = (4; 10; 24). Na kontrolu: m₂₁ = 2, m₃₁ = 4, m₃₂ = 3, U = (2 1 1; 0 1 1; 0 0 2), y = (4; 2; 2) a x = (1; 1; 1).

## 2. LU rozklad

LU rozklad zapíše matici jako A = L·U. U je výsledek GEM. L má na diagonále jedničky a pod diagonálou multiplikátory mᵢₖ na pozici (i, k). List cvLU_rozklad.pdf to nazývá maticovým zápisem GEM. Soustava Ax = b se pak řeší ve dvou krocích: Ly = b dopřednou substitucí a Ux = y zpětnou substitucí.

### Postup

> Na písemku
> 1. Napsat, že se použije LU rozklad A = L·U.
> 2. Provést GEM na matici A bez prohazování řádků a zapsat multiplikátory.
> 3. Zapsat U jako výsledek GEM a L s jedničkami na diagonále a mᵢₖ na pozici (i, k).
> 4. Zkontrolovat L·U = A aspoň v jednom řádku.
> 5. Soustava: vyřešit Ly = b shora dolů, pak Ux = y zdola nahoru.
> 6. Inverze: zopakovat krok 5 pro b = e₁, e₂, …, eₙ. Výsledky jsou sloupce A⁻¹.
> 7. Determinant: det A = u₁₁·u₂₂·…·uₙₙ.

Dopředná substituce pro i = 1, …, n:

**yᵢ = bᵢ − Σ lᵢⱼ·yⱼ**, kde součet jde přes j = 1, …, i − 1. Dělit se nemusí, protože lᵢᵢ = 1.

### Vyřešený příklad

Matice z cviceni_03.m je stejná jako v kapitole 1. GEM dala m₂₁ = 2, m₃₁ = −1 a m₃₂ = −3.

```matice
A = [2 1 1; 4 1 0; −2 2 1] = L·U
→ multiplikátory
L = [1 0 0; !2 1 0; !−1 !−3 1],
U = [2 1 1; 0 −1 −2; 0 0 −4]
- Kontrola 3. řádku: −1·(2 1 1) − 3·(0 −1 −2) + 1·(0 0 −4) = (−2 −1 −1) + (0 3 6) + (0 0 −4) = (−2 2 1). Vyšel 3. řádek A.
```

Soustava s b = (1; −2; 7):

```
Ly = b:  y₁ = 1
         y₂ = −2 − 2·y₁ = −4
         y₃ = 7 − (−1)·y₁ − (−3)·y₂ = 7 + 1 − 12 = −4

Ux = y:  x₃ = −4 / (−4) = 1
         x₂ = (−4 − (−2)·x₃) / (−1) = 2
         x₁ = (1 − x₂ − x₃) / 2 = −1
```

Vektor y = (1; −4; −4) je stejný jako upravená pravá strana z GEM v kapitole 1. Podle toho se výpočet y dá zkontrolovat. Determinant je det A = 2·(−1)·(−4) = 8.

Inverze se počítá po sloupcích. Pro e₁ = (1; 0; 0):

```
Ly = e₁:  y₁ = 1,  y₂ = 0 − 2·1 = −2,  y₃ = 0 + 1·1 + 3·(−2) = −5
Ux = y:   x₃ = −5 / (−4) = 5/4
          x₂ = (−2 + 2·5/4) / (−1) = −1/2
          x₁ = (1 + 1/2 − 5/4) / 2 = 1/8
```

Pro e₂ vyjde y = (0; 1; 3) a x = (1/8; 1/2; −3/4). Pro e₃ vyjde y = (0; 0; 1) a x = (−1/8; 1/2; −1/4).

```matice
A⁻¹ = [1/8 1/8 −1/8; −1/2 1/2 1/2; 5/4 −3/4 −1/4]
- Sloupce A⁻¹ jsou vektory x pro e₁, e₂ a e₃.
- Kontrola: 1. řádek A krát 1. sloupec A⁻¹ je 2·1/8 + 1·(−1/2) + 1·5/4 = 1.
```

### Elementární matice ze cviceni_03.m

cviceni_03.m zapisuje každý krok GEM jako násobení maticí. T₁ = (1 0 0; −2 1 0; 1 0 1) vynuluje první sloupec a T₂ = (1 0 0; 0 1 0; 0 3 1) druhý sloupec. Platí T₂·T₁·A = U a L = T₁⁻¹·T₂⁻¹.

- T₁ a T₂ mají pod diagonálou multiplikátory s opačným znaménkem. Inverze jedné takové matice vznikne obrácením znamének pod diagonálou.
- L má multiplikátory s jejich vlastním znaménkem: L = (1 0 0; 2 1 0; −1 −3 1).
- Součin T₂·T₁ = (1 0 0; −2 1 0; −5 3 1) má na pozici (3, 1) číslo −5, kdežto L tam má −1. L proto nevznikne obrácením znamének v součinu T₂·T₁. Skládá se přímo z multiplikátorů.

### Přímý výpočet prvků L a U

Prvky jde spočítat bez řádkových úprav z rovnosti A = L·U. Pro matici 3×3 se počítá v pořadí 1. řádek U, 1. sloupec L, 2. řádek U, 2. sloupec L a poslední prvek U:

- u₁ⱼ = a₁ⱼ
- lᵢ₁ = aᵢ₁ / u₁₁
- u₂ⱼ = a₂ⱼ − l₂₁·u₁ⱼ pro j = 2, 3
- l₃₂ = (a₃₂ − l₃₁·u₁₂) / u₂₂
- u₃₃ = a₃₃ − l₃₁·u₁₃ − l₃₂·u₂₃

Pro příklad: u₁ = (2 1 1), l₂₁ = 4/2 = 2, l₃₁ = −2/2 = −1, u₂₂ = 1 − 2·1 = −1, u₂₃ = 0 − 2·1 = −2, l₃₂ = (2 − (−1)·1)/(−1) = −3 a u₃₃ = 1 − (−1)·1 − (−3)·(−2) = −4. Vyjde totéž co z GEM. Tento postup není v materiálech ke cvičení a hodí se jako kontrola.

### Rozklad s prohozením řádků

Když GEM bez pivotace narazí na nulový pivot, rozklad A = L·U neexistuje. Řádky se prohodí a rozklad má tvar P·A = L·U. P je jednotková matice se stejně prohozenými řádky. Soustava se řeší jako Ly = Pb a Ux = y.

Matice z chytáku Nulový pivot v kapitole 1:

```matice
A = [*1 2 1; 2 4 3; 3 7 2]
| ; ř₂ − 2·ř₁; ř₃ − 3·ř₁
→ krok 1
[1 2 1; !0 !*0 !1; !0 !1 !−1]
| ; ř₂ ↔ ř₃; ř₃ ↔ ř₂
→ prohození
[1 2 1; !0 !1 !−1; !0 !0 !1] = U
- Krok 1: m₂₁ = 2 patří původnímu 2. řádku a m₃₁ = 3 původnímu 3. řádku.
- Po prohození je původní 3. řádek na 2. místě. Jeho multiplikátor jde s ním: l₂₁ = 3 a l₃₁ = 2.
- Krok 2: pod pivotem 1 už je nula, takže m₃₂ = 0.
```

```matice
P = [1 0 0; 0 0 1; 0 1 0],
L = [1 0 0; !3 1 0; !2 0 1],
U = [1 2 1; 0 1 −1; 0 0 1]
- Kontrola: L·U = (1 2 1; 3 7 2; 2 4 3) = P·A.
- Ly = Pb pro b = (4; 9; 12): Pb = (4; 12; 9), y₁ = 4, y₂ = 12 − 3·4 = 0, y₃ = 9 − 2·4 − 0·0 = 1.
- Ux = y: x₃ = 1, x₂ = 0 + x₃ = 1, x₁ = 4 − 2·1 − 1 = 1.
- det A = (−1)¹ · 1 · 1 · 1 = −1, protože se řádky prohodily jednou.
```

### Chytáky

#### Jedničky na diagonále L

L z GEM má na diagonále jedničky. Pivoty patří na diagonálu U. S pivoty na diagonále L by součin L·U nedal A.

#### Znaménko v L

Do L jde mᵢₖ = aᵢₖ / aₖₖ beze změny znaménka. Úprava ř₃ + ř₁ znamená m₃₁ = −1, a proto l₃₁ = −1. Elementární matice T z cviceni_03.m mají znaménka opačná.

#### Pozice multiplikátoru

mᵢₖ patří do řádku i, kde vznikla nula, a do sloupce k, kde je pivot. m₃₂ = −3 je proto v L na pozici (3, 2).

#### Úpravy, které LU nedovoluje

Násobení řádku číslem, dělení řádku pivotem a přičtení řádku zespodu dávají v GEM správné řešení. L složená z multiplikátorů pak ale nesplňuje L·U = A. Pro LU rozklad se používá jen úprava řᵢ − mᵢₖ·řₖ s i > k a případně prohození řádků s maticí P.

#### Prohození řádků

S řádky se prohodí i multiplikátory, které už jsou v L zapsané. Bez toho vyjde v příkladu výše L = (1 0 0; 2 1 0; 3 0 1) a L·U = (1 2 1; 2 5 1; 3 6 4). Tento součin se nerovná ani A, ani P·A. Prohodí se i pravá strana. Řešení Ly = b místo Ly = Pb dá x = (−2; 1; 4) místo (1; 1; 1). Determinant mění znaménko při každém prohození.

#### Pořadí substitucí

Ly = b se řeší shora dolů, protože L je dolní trojúhelníková. Ux = y se řeší zdola nahoru. Mezivýsledek y se rovná upravené pravé straně z GEM.

#### Inverze po sloupcích

Řešení pro e₁ je první sloupec A⁻¹. Zapsané jako první řádek dá transponovanou matici, která pro nesymetrickou A inverzí není. Kontrola je A·A⁻¹ = E aspoň pro jeden řádek A a jeden sloupec A⁻¹.

#### Determinant

det A je součin diagonály U. Diagonála L dává vždy 1. Při prohazování řádků se výsledek násobí (−1)ˢ, kde s je počet prohození.

#### L a U v iteračních metodách

V rozkladu A = L + D + U u iteračních metod jsou L a U části matice A, které se sčítají. S činiteli z LU rozkladu nemají nic společného.

#### Funkce lu v Matlabu

`[L, U, P] = lu(A)` pivotuje podle absolutní hodnoty, takže jeho L a U se obvykle liší od ručních. Pro matici z příkladu prohodí už v kroku 1, protože |4| > |2|. `[L, U] = lu(A)` se dvěma výstupy vrátí L s přeházenými řádky, která obecně není dolní trojúhelníková. Ruční rozklad se proto ověřuje příkazem `L*U - A`.

### Kontrola v Matlabu

```
A = [2 1 1; 4 1 0; -2 2 1];
[L, U] = MOJELUDNES(A)
L*U - A
b = [1; -2; 7];
y = L\b
x = U\y
X = inverzni(L, U)
D = determinant(U)
```

- `MOJELUDNES` počítá bez pivotace stejně jako ruční výpočet.
- `L*U - A` musí vyjít nulová matice.
- `inverzni` volá `solve_LU` a ta funkce `fwsub` a `backsub`. Všechny soubory musí být ve stejné složce.

### Cvičení

Matice jsou z cviceni_03.m.

1. A = (2 4 −6; 1 5 3; 1 3 2). Na kontrolu: L = (1 0 0; 1/2 1 0; 1/2 1/3 1), U = (2 4 −6; 0 3 6; 0 0 3), det A = 18 a A⁻¹ = (1/18 −13/9 7/3; 1/18 5/9 −2/3; −1/9 −1/9 1/3).
2. B = (1 1 6; −1 2 9; 1 −2 3). Na kontrolu: L = (1 0 0; −1 1 0; 1 −1 1), U = (1 1 6; 0 3 15; 0 0 12), det B = 36 a B⁻¹ = (2/3 −5/12 −1/12; 1/3 −1/12 −5/12; 0 1/12 1/12).
3. C = (4 8 4 0; 1 5 4 −3; 1 4 7 2; 1 3 0 −2). Na kontrolu: L = (1 0 0 0; 1/4 1 0 0; 1/4 2/3 1 0; 1/4 1/3 −1/2 1), U = (4 8 4 0; 0 3 3 −3; 0 0 4 4; 0 0 0 1) a det C = 48.
4. Soustava s maticí z úlohy 1 a b = (4; 14; 9). Na kontrolu: y = (4; 12; 3) a x = (1; 2; 1).

## 3. Iterační metody: společný základ

Jacobiho, Gauss-Seidelova a Ritzova metoda přepíšou Ax = b do tvaru x = Bx + c a opakují x⁽ᵏ⁺¹⁾ = Bx⁽ᵏ⁾ + c od zvoleného x⁽⁰⁾. Liší se maticí B a vektorem c. Matice se pro ně rozdělí na A = L + D + U, kde L je část pod diagonálou, D diagonála a U část nad diagonálou.

| Metoda | B | c | Konvergenci zaručí |
|---|---|---|---|
| Ritzova (prostá) | E − A | b | ‖E − A‖ < 1 v některé normě |
| Jacobiho | −D⁻¹(L + U) | D⁻¹b | A je ryze řádkově diagonálně dominantní |
| Gauss-Seidelova | −(D + L)⁻¹U | (D + L)⁻¹b | A je ryze řádkově diagonálně dominantní, nebo symetrická a pozitivně definitní |

Podmínky v tabulce jsou postačující. Nutná a postačující podmínka je ρ(B) < 1, kde spektrální poloměr ρ(B) je největší absolutní hodnota vlastního čísla B. Každá norma matice je aspoň ρ(B), takže ‖B‖ < 1 v jakékoli normě stačí.

Normy z listu cvITER_SLAR.pdf:

- řádková norma ‖B‖_R = ‖B‖∞ je největší součet absolutních hodnot v řádku,
- sloupcová norma ‖B‖_S = ‖B‖₁ je největší součet absolutních hodnot ve sloupci.

### Zastavení a počet iterací

| Funkce ze cvičení | Počítá další krok, dokud | Chyba |
|---|---|---|
| `NaseJacobi`, `NaseGaussSeidel` | ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖∞ > presnost | absolutní |
| `Jacobi2`, `GaussSeidel2` | ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖∞ > r·‖x⁽ᵏ⁾‖∞ a počet je nejvýš max_it | relativní |
| `Ritz` | ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖∞ > 10⁻⁴ | absolutní, tolerance pevně v souboru |

Funkce vrátí poslední spočítaný vektor a počet spočítaných vektorů. Při počtu 12 je výsledek x⁽¹²⁾, tedy první vektor, u kterého rozdíl od předchozího klesl na toleranci nebo pod ni. `Jacobi2` má v podmínce ≥ místo >, na výsledku se to prakticky neprojeví.

### Chytáky společné všem iteračním metodám

#### Postačující podmínka není nutná

Když dominance nebo ‖B‖ < 1 neplatí, metoda může konvergovat i tak. Rozhodne až ρ(B), v Matlabu `max(abs(eig(B)))`. Při ρ(B) ≥ 1 metoda pro obecné x⁽⁰⁾ diverguje. Soustavy, kde jedna metoda konverguje a druhá ne, jsou v kapitole 5.

#### Rozdíl iterací není chyba

Zastavovací podmínka měří rozdíl dvou po sobě jdoucích iterací. Skutečná chyba ‖x − x⁽ᵏ⁾‖ může být větší. Pro q = ‖B‖ < 1 platí odhad ‖x − x⁽ᵏ⁾‖ ≤ q/(1 − q) · ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖ ve stejné normě. Tento odhad není v materiálech ke cvičení. V příkladu Jacobiho metody v kapitole 4 je q = 6/7 a q/(1 − q) = 6. Poslední rozdíl je 0,000667, ale skutečná chyba je 0,000693.

#### Ruční zaokrouhlování

Každá iterace se počítá z předchozí, takže zaokrouhlení v jednom kroku se přenese do všech dalších. Na papíře se drží aspoň 4 až 6 desetinných míst. Ruční x⁽¹⁾ a x⁽²⁾ se pak s Matlabem porovnávají na 4 desetinná místa.

#### x⁽¹⁾ z nulového vektoru je c

Pro x⁽⁰⁾ = 0 je x⁽¹⁾ = B·0 + c = c. První iterace z nuly tak dá vektor c a obráceně ověří c spočítané z matic.

#### Divergence ve funkcích ze cvičení

`NaseJacobi`, `NaseGaussSeidel` a `Ritz` nemají omezení počtu iterací. Při divergenci vrátí Inf nebo NaN, nebo neskončí a výpočet se musí přerušit klávesami Ctrl+C. `Jacobi2` a `GaussSeidel2` skončí po max_it iteracích.

## 4. Jacobiho metoda

Z i-té rovnice se vyjádří xᵢ a do pravé strany se dosadí všechny složky z minulého kroku:

**xᵢ⁽ᵏ⁺¹⁾ = (bᵢ − Σ aᵢⱼ·xⱼ⁽ᵏ⁾) / aᵢᵢ**, kde součet jde přes všechna j ≠ i.

### Postup

> Na písemku
> 1. Ověřit ryzí řádkovou diagonální dominanci: v každém řádku |aᵢᵢ| > Σ |aᵢⱼ| přes j ≠ i. Nerovnosti vypsat.
> 2. Když neplatí, přeházet rovnice i s bᵢ, aby platila.
> 3. Z i-té rovnice vyjádřit xᵢ a zapsat předpisy pro x₁⁽ᵏ⁺¹⁾ až xₙ⁽ᵏ⁺¹⁾. Vpravo je všude index (k).
> 4. Uvést x⁽⁰⁾, toleranci a zastavovací podmínku.
> 5. Spočítat ručně x⁽¹⁾ a x⁽²⁾ a zapsat je do tabulky.
> 6. Zapsat výsledek z Matlabu: x a počet iterací.

### Vyřešený příklad

Soustava z cviceni_04.m, tady zadaná s jiným pořadím rovnic:

```
  x₁ +  x₂ − 4x₃ = 21
 3x₁ −  x₂ +  x₃ = 26,5
  x₁ − 7x₂ + 5x₃ = −9,5
```

Krok 1, dominance. První rovnice má na diagonále 1 a platí 1 < 1 + 4, takže v tomto pořadí matice dominantní není. Pro každou neznámou se hledá rovnice, ve které má tato neznámá v absolutní hodnotě větší koeficient než ostatní dohromady:

- x₁ dominuje ve 2. rovnici: |3| > |−1| + |1| = 2.
- x₂ dominuje ve 3. rovnici: |−7| > |1| + |5| = 6.
- x₃ dominuje v 1. rovnici: |−4| > |1| + |1| = 2.

Pořadí rovnic 2, 3, 1 dává:

```matice
A = [*3 −1 1; 1 *−7 5; 1 1 *−4]
| |3| > 1 + 1; |−7| > 1 + 5; |−4| > 1 + 1
b = [26,5; −9,5; 21]
```

Krok 2, předpisy. U záporné diagonály se dělí záporným číslem:

```
x₁⁽ᵏ⁺¹⁾ = (26,5 + x₂⁽ᵏ⁾ − x₃⁽ᵏ⁾) / 3
x₂⁽ᵏ⁺¹⁾ = (−9,5 − x₁⁽ᵏ⁾ − 5x₃⁽ᵏ⁾) / (−7) = (9,5 + x₁⁽ᵏ⁾ + 5x₃⁽ᵏ⁾) / 7
x₃⁽ᵏ⁺¹⁾ = (21 − x₁⁽ᵏ⁾ − x₂⁽ᵏ⁾) / (−4)    = (−21 + x₁⁽ᵏ⁾ + x₂⁽ᵏ⁾) / 4
```

Stejné předpisy má cviceni_04.m v části „rucni vypocet jacobi“.

Krok 3, iterace z x⁽⁰⁾ = (0; 0; 0):

```
x₁⁽¹⁾ = 26,5 / 3 = 8,833333
x₂⁽¹⁾ = 9,5 / 7 = 1,357143
x₃⁽¹⁾ = −21 / 4 = −5,25

x₁⁽²⁾ = (26,5 + 1,357143 + 5,25) / 3 = 11,035714
x₂⁽²⁾ = (9,5 + 8,833333 + 5·(−5,25)) / 7 = −1,130952
x₃⁽²⁾ = (−21 + 8,833333 + 1,357143) / 4 = −2,702381
```

Iterace s tolerancí 10⁻³ podle `NaseJacobi`:

| k | x₁ | x₂ | x₃ | ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖∞ |
|---|---|---|---|---|
| 1 | 8,833333 | 1,357143 | −5,250000 | 8,833333 |
| 2 | 11,035714 | −1,130952 | −2,702381 | 2,547619 |
| 3 | 9,357143 | 1,003401 | −2,773810 | 2,134354 |
| 4 | 10,092404 | 0,712585 | −2,659864 | 0,735261 |
| … | | | | |
| 11 | 9,999633 | 0,998641 | −2,500896 | 0,001501 |
| 12 | 9,999846 | 0,999307 | −2,500432 | 0,000667 |

Přesné řešení je x = (10; 1; −2,5). `NaseJacobi` s presnost = 10⁻³ skončí po 12 iteracích. `Jacobi2` s r = 10⁻³ jako v cviceni_04.m měří relativní chybu a skončí po 9 iteracích. S tolerancí 10⁻⁶ je to 22 a 18 iterací.

### Maticový tvar

B = −D⁻¹(L + U) má na diagonále nuly a mimo ni −aᵢⱼ/aᵢᵢ. Vektor c = D⁻¹b má složky bᵢ/aᵢᵢ.

```matice
B = [0 1/3 −1/3; 1/7 0 5/7; 1/4 1/4 0]
| součet 2/3; součet 6/7; součet 1/2
c = [53/6; 19/14; −21/4]
- ‖B‖_R = max{2/3; 6/7; 1/2} = 6/7 ≈ 0,857 < 1, takže metoda konverguje.
- ‖B‖_S = max{1/7 + 1/4; 1/3 + 1/4; 1/3 + 5/7} ≈ max{0,393; 0,583; 1,048} = 1,048. Sloupcová norma je větší než 1, ale stačí, že řádková je menší.
- c je x⁽¹⁾ z nulového vektoru: 53/6 = 8,833333, 19/14 = 1,357143 a −21/4 = −5,25.
- ρ(B) ≈ 0,490.
```

Řádkové součty B jsou přesně podíly Σ |aᵢⱼ| / |aᵢᵢ| z kontroly dominance. Ryzí řádková diagonální dominance A proto znamená totéž co ‖B‖_R < 1.

### Chytáky

#### Znaménka při vyjádření xᵢ

Člen převedený na druhou stranu rovnice změní znaménko a celek se pak dělí aᵢᵢ i se znaménkem. Z x₁ − 7x₂ + 5x₃ = −9,5 vyjde x₂ = (−9,5 − x₁ − 5x₃)/(−7). Při dělení 7 místo −7 vyjde x₂⁽¹⁾ = −1,357143 místo 1,357143 a iterace řeší jinou soustavu.

Předpis se dá zkontrolovat dosazením řešení z Matlabu. Pro x = (10; 1; −2,5) dá předpis pro x₂ hodnotu (9,5 + 10 + 5·(−2,5))/7 = 1 a to je správné x₂.

#### Jen hodnoty z minulého kroku

V Jacobiho metodě je vpravo všude index (k). Kdo do x₂⁽²⁾ dosadí už nové x₁⁽²⁾, počítá Gauss-Seidelovu metodu.

#### Ryzí dominance v každém řádku

Nerovnost musí být ostrá a musí platit ve všech řádcích. Matice (4 3 0; 1 5 4; 2 1 6) má ve 2. řádku 5 = 1 + 4, takže ryze řádkově dominantní není. Porovnávají se absolutní hodnoty, a záporná diagonála proto nevadí: |−7| > 6 platí.

#### Přehazují se rovnice

Prohození dvou rovnic i s pravou stranou soustavu nemění. Prohození sloupců přejmenuje neznámé a výsledek by se musel přeskládat zpět. Ve cvičeních se přehazují jen rovnice. V Matlabu to dělá permutační matice: `P = [E(2,:); E(3,:); E(1,:)]` a `Y = P*[A, b]`.

#### Rovnice nejde přeházet

Někdy dominanci nedá žádné pořadí rovnic, například když dvě rovnice mají největší koeficient u stejné neznámé. Pak se spočítá ρ(B) v Matlabu, nebo se použije Gauss-Seidelova metoda na symetrickou pozitivně definitní matici, nebo soustava AᵀAx = Aᵀb. Obojí je v kapitole 5.

#### Sloupcová dominance

Matice (4 3 0; 1 5 4; 2 1 6) není ryze řádkově dominantní, ale je ryze sloupcově diagonálně dominantní: 4 > 1 + 2, 5 > 3 + 1 a 6 > 0 + 4. Sloupcová dominance také zaručí konvergenci Jacobiho i Gauss-Seidelovy metody. Tady je ρ(B) ≈ 0,743 u Jacobiho a 0,447 u Gauss-Seidelovy metody. Sloupcové kritérium není v materiálech ke cvičení.

#### Nula na diagonále

Z rovnice s nulou na diagonále nejde xᵢ vyjádřit a rovnice se musí přeházet. Funkce ze cvičení by dělily nulou a vrátily Inf nebo NaN.

## 5. Gauss-Seidelova metoda

Předpisy jsou stejné jako u Jacobiho metody, ale složky spočítané v tomtéž kroku se použijí hned:

**xᵢ⁽ᵏ⁺¹⁾ = (bᵢ − Σ aᵢⱼ·xⱼ⁽ᵏ⁺¹⁾ − Σ aᵢⱼ·xⱼ⁽ᵏ⁾) / aᵢᵢ**, kde první součet jde přes j < i a druhý přes j > i.

### Postup

> Na písemku
> 1. Ověřit ryzí řádkovou diagonální dominanci. Když neplatí a přeházením ji získat nejde, ověřit symetrii a Sylvestrovo kritérium.
> 2. Zapsat předpisy a vyznačit, kde už je index (k+1).
> 3. Počítat složky v pořadí x₁, x₂, …, xₙ.
> 4. Uvést x⁽⁰⁾, toleranci a zastavovací podmínku. Spočítat ručně x⁽¹⁾ a x⁽²⁾.
> 5. Zapsat výsledek z Matlabu a počet iterací.

### Vyřešený příklad

Soustava z kapitoly 4 po přeházení rovnic:

```
x₁⁽ᵏ⁺¹⁾ = (26,5 + x₂⁽ᵏ⁾   − x₃⁽ᵏ⁾)    / 3
x₂⁽ᵏ⁺¹⁾ = (9,5  + x₁⁽ᵏ⁺¹⁾ + 5x₃⁽ᵏ⁾)   / 7
x₃⁽ᵏ⁺¹⁾ = (−21  + x₁⁽ᵏ⁺¹⁾ + x₂⁽ᵏ⁺¹⁾) / 4
```

Z x⁽⁰⁾ = (0; 0; 0):

```
x₁⁽¹⁾ = 26,5 / 3 = 8,833333
x₂⁽¹⁾ = (9,5 + 8,833333 + 0) / 7 = 2,619048
x₃⁽¹⁾ = (−21 + 8,833333 + 2,619048) / 4 = −2,386905

x₁⁽²⁾ = (26,5 + 2,619048 + 2,386905) / 3 = 10,501984
x₂⁽²⁾ = (9,5 + 10,501984 + 5·(−2,386905)) / 7 = 1,152494
x₃⁽²⁾ = (−21 + 10,501984 + 1,152494) / 4 = −2,336380
```

| k | x₁ | x₂ | x₃ | ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖∞ |
|---|---|---|---|---|
| 1 | 8,833333 | 2,619048 | −2,386905 | 8,833333 |
| 2 | 10,501984 | 1,152494 | −2,336380 | 1,668651 |
| 3 | 9,996292 | 1,116341 | −2,471842 | 0,505693 |
| … | | | | |
| 7 | 10,000507 | 1,000965 | −2,499632 | 0,001806 |
| 8 | 10,000199 | 1,000291 | −2,499877 | 0,000673 |

`NaseGaussSeidel` s presnost = 10⁻³ skončí po 8 iteracích, Jacobiho metoda jich potřebovala 12. `GaussSeidel2` s r = 10⁻³ skončí po 6 iteracích. S tolerancí 10⁻⁶ je to 14 a 12 iterací.

### Matice B bez inverze

B = −(D + L)⁻¹U potřebuje inverzi, a proto se ručně počítá těžko. Jde to obejít. Krok metody z vektoru eⱼ s nulovou pravou stranou dá B·eⱼ, tedy j-tý sloupec B. Krok z nulového vektoru se zadanou pravou stranou dá c. Platí to pro každou metodu tvaru x⁽ᵏ⁺¹⁾ = Bx⁽ᵏ⁾ + c.

```
z e₁ = (1; 0; 0):  x₁ = (0 + 0 − 0)/3 = 0
                   x₂ = (0 + 0 + 0)/7 = 0
                   x₃ = (0 + 0 + 0)/4 = 0

z e₂ = (0; 1; 0):  x₁ = (0 + 1 − 0)/3 = 1/3
                   x₂ = (0 + 1/3 + 0)/7 = 1/21
                   x₃ = (0 + 1/3 + 1/21)/4 = 2/21

z e₃ = (0; 0; 1):  x₁ = (0 + 0 − 1)/3 = −1/3
                   x₂ = (0 − 1/3 + 5)/7 = 2/3
                   x₃ = (0 − 1/3 + 2/3)/4 = 1/12
```

Vyšlé vektory jsou sloupce B.

```matice
B = [0 1/3 −1/3; 0 1/21 2/3; 0 2/21 1/12]
| součet 2/3; součet 5/7; součet 5/28
- ‖B‖_R = 5/7 ≈ 0,714. Jacobiho metoda má 6/7 ≈ 0,857.
- ρ(B) ≈ 0,318. Jacobiho metoda má 0,490, a proto potřebuje víc iterací.
- První sloupec B je vždy nulový, protože staré x₁⁽ᵏ⁾ Gauss-Seidelova metoda nikdy nepoužije.
```

### Chytáky

#### Nové hodnoty hned a ve správném pořadí

x₂⁽ᵏ⁺¹⁾ už používá x₁⁽ᵏ⁺¹⁾ a x₃⁽ᵏ⁺¹⁾ používá x₁⁽ᵏ⁺¹⁾ i x₂⁽ᵏ⁺¹⁾. Složky se počítají v pořadí rovnic. Při jiném pořadí rovnic dá Gauss-Seidelova metoda jiné iterace a může i divergovat.

#### Gauss-Seidel není vždy lepší

Na listu cvITER_SLAR.pdf (str. 4) a v cviceni_04.m jsou dvě soustavy, kde rozhoduje ρ(B):

| Matice A | ρ(B) Jacobi | ρ(B) Gauss-Seidel | Výsledek |
|---|---|---|---|
| (1 −2 1; −1 1 1; 0 −1 1) | 1,32 | 0 | Jacobi diverguje, Gauss-Seidel konverguje |
| (1 2 −2; 1 1 1; 2 2 1) | 0 | 2 | Jacobi konverguje, Gauss-Seidel diverguje |

Ani jedna matice není diagonálně dominantní, takže o konvergenci rozhodne až ρ(B).

#### Pozitivní definitnost zaručí jen Gauss-Seidelovu metodu

Symetrická pozitivně definitní matice zaručí konvergenci Gauss-Seidelovy metody, ale Jacobiho ne. Matice (1 1 1; 1 2 2; 1 2 3) z cviceni_04.m má hlavní minory 1, 1 a 1. Gauss-Seidelova metoda na ní konverguje s ρ(B) ≈ 0,667 a Jacobiho diverguje s ρ(B) ≈ 1,41.

#### Kladná diagonála nestačí

Matice (1 2; 2 1) je symetrická a má kladnou diagonálu, ale druhý hlavní minor je 1·1 − 2·2 = −3. Pozitivně definitní tedy není. Gauss-Seidelova metoda má B = (0 −2; 0 4) a ρ(B) = 4, takže diverguje. Sylvestrovo kritérium se proto počítá celé: determinanty levých horních podmatic 1×1, 2×2 až n×n musí být všechny kladné. V Matlabu `[det(A(1,1)), det(A(1:2,1:2)), det(A)]`.

#### Přechod na AᵀA

Když matice není dominantní ani pozitivně definitní, cviceni_04.m řeší soustavu AᵀAx = Aᵀb. Pro regulární A je AᵀA symetrická pozitivně definitní a Gauss-Seidelova metoda na ní konverguje. Skript ale novou matici pojmenuje `B = A'*A` a pravou stranu `c = A'*b`. Toto B je matice nové soustavy, ne iterační matice. Konvergence bývá pomalá. Pro A = (1 1 2; 1 2 2; 2 2 3) ze skriptu je AᵀA = (6 7 10; 7 9 12; 10 12 17), iterační matice má ρ ≈ 0,985 a `GaussSeidel2` s tolerancí 1/2·10⁻¹⁰ potřebuje přibližně 1300 iterací. Řešení je x = (1; 1; 1).

## 6. Ritzova (prostá) iterační metoda

Soustava Ax = b se přepíše bez dělení: x = x − Ax + b = (E − A)x + b. Tedy B = E − A a c = b. List cvITER_SLAR.pdf to odvozuje jako (A − E + E)x = b, odkud Ex = −(A − E)x + b. Funkce `Ritz` počítá `B=-(A-E)` a `c=b`.

Krok jde zapsat i jako x⁽ᵏ⁺¹⁾ = x⁽ᵏ⁾ + (b − Ax⁽ᵏ⁾). K minulému vektoru se přičte reziduum b − Ax⁽ᵏ⁾. Tento tvar se hodí ke kontrole ručního výpočtu.

### Postup

> Na písemku
> 1. Zapsat B = E − A: na diagonále 1 − aᵢᵢ, mimo diagonálu −aᵢⱼ. Zapsat c = b.
> 2. Spočítat ‖B‖_S a ‖B‖_R. Stačí, když je jedna z nich menší než 1.
> 3. Zapsat x⁽ᵏ⁺¹⁾ = Bx⁽ᵏ⁾ + c po složkách.
> 4. Uvést x⁽⁰⁾ a toleranci. Spočítat ručně x⁽¹⁾ a x⁽²⁾.
> 5. Zapsat výsledek z Matlabu a počet iterací.

### Vyřešený příklad

Soustava z listu cvITER_SLAR.pdf a z cviceni_04.m:

```
    x₁ + 0,2x₂ − 0,1x₃ = −0,55
  0,1x₁ +    x₂         = 2,3
  0,6x₁ − 0,7x₂ +    x₃ = −0,9
```

```matice
A = [1 0,2 −0,1; 0,1 1 0; 0,6 −0,7 1]
→ B = E − A
[0 −0,2 0,1; −0,1 0 0; −0,6 0,7 0]
| součet 0,3; součet 0,1; součet 1,3
c = [−0,55; 2,3; −0,9]
- ‖B‖_S = max{0,1 + 0,6; 0,2 + 0,7; 0,1} = 0,9 < 1, takže metoda konverguje.
- ‖B‖_R = max{0,3; 0,1; 1,3} = 1,3. Řádková norma je větší než 1, ale to nevadí, protože sloupcová je menší.
- ρ(B) ≈ 0,236.
```

Předpisy:

```
x₁⁽ᵏ⁺¹⁾ =             − 0,2x₂⁽ᵏ⁾ + 0,1x₃⁽ᵏ⁾ − 0,55
x₂⁽ᵏ⁺¹⁾ = −0,1x₁⁽ᵏ⁾                        + 2,3
x₃⁽ᵏ⁺¹⁾ = −0,6x₁⁽ᵏ⁾ + 0,7x₂⁽ᵏ⁾             − 0,9
```

Iterace z x⁽⁰⁾ = (0; 0; 0):

```
x⁽¹⁾ = c = (−0,55; 2,3; −0,9)

x₁⁽²⁾ = −0,2·2,3 + 0,1·(−0,9) − 0,55 = −1,1
x₂⁽²⁾ = −0,1·(−0,55) + 2,3 = 2,355
x₃⁽²⁾ = −0,6·(−0,55) + 0,7·2,3 − 0,9 = 1,04
```

Kontrola přes reziduum: Ax⁽¹⁾ = (0; 2,245; −2,84), b − Ax⁽¹⁾ = (−0,55; 0,055; 1,94) a x⁽¹⁾ + (b − Ax⁽¹⁾) = (−1,1; 2,355; 1,04). Vyšlo stejné x⁽²⁾.

| k | x₁ | x₂ | x₃ | ‖x⁽ᵏ⁾ − x⁽ᵏ⁻¹⁾‖∞ |
|---|---|---|---|---|
| 1 | −0,550000 | 2,300000 | −0,900000 | 2,300000 |
| 2 | −1,100000 | 2,355000 | 1,040000 | 1,940000 |
| 3 | −0,917000 | 2,410000 | 1,408500 | 0,368500 |
| 4 | −0,891150 | 2,391700 | 1,337200 | 0,071300 |
| … | | | | |
| 8 | −0,896860 | 2,389698 | 1,310972 | 0,000187 |
| 9 | −0,896842 | 2,389686 | 1,310905 | 0,000067 |

`Ritz(A, b, [0; 0; 0])` s pevnou tolerancí 10⁻⁴ skončí po 9 iteracích s x ≈ (−0,8968; 2,3897; 1,3109). Stejný počet vyjde z x⁽⁰⁾ = (1; 1; 1), které používá cviceni_04.m. Přesné řešení je x = (−313/349; 834/349; 915/698) ≈ (−0,896848; 2,389685; 1,310888).

### Chytáky

#### Matice B je E − A

Odečítá se A od jednotkové matice. Na diagonále je 1 − aᵢᵢ a všechny prvky mimo diagonálu mění znaménko. Matice A − E má stejné normy jako E − A, takže záměnu kontrola konvergence neodhalí. Iterace x = (A − E)x + b ale řeší soustavu (2E − A)x = b místo Ax = b. Chybu odhalí až zkouška dosazením.

#### c = b bez dělení

U Ritzovy metody se nic nedělí. Vektor c = D⁻¹b patří k Jacobiho metodě.

#### Soustava zadaná ve tvaru x = Bx + c

Když zadání už má tvar x₁ = −0,2x₂ + 0,1x₃ − 0,55 a podobně, B a c se z něj čtou přímo. E − B se pak nepočítá, protože by se znaménka otočila podruhé.

#### Velká diagonála

Ritzova metoda potřebuje diagonálu blízko 1. Pro soustavu z kapitoly 4 je E − A = (−2 1 −1; −1 8 −5; −1 −1 5) s ρ ≈ 9,21 a metoda diverguje, přestože A je ryze řádkově diagonálně dominantní. Diagonální dominance A o Ritzově metodě nic neříká.

Pomůže vydělit každou rovnici jejím diagonálním prvkem, i s pravou stranou. Matice D⁻¹A pak má na diagonále jedničky a E − D⁻¹A = −D⁻¹(L + U) je Jacobiho matice B. Ritzova metoda na takto vydělené soustavě je Jacobiho metoda.

```matice
D⁻¹A = [1 −1/3 1/3; −1/7 1 −5/7; −1/4 −1/4 1]
→ E − D⁻¹A
[0 1/3 −1/3; 1/7 0 5/7; 1/4 1/4 0]
- Vyšla stejná matice jako B Jacobiho metody v kapitole 4.
```

#### Stačí jedna norma

Pro konvergenci stačí, aby byla menší než 1 aspoň jedna norma B. V příkladu je ‖B‖_R = 1,3 a ‖B‖_S = 0,9. Kdo spočítá jen řádkovou normu, prohlásí metodu chybně za nekonvergentní. Frobeniova norma √(Σ bᵢⱼ²) také stačí, v příkladu je √0,91 ≈ 0,954. Když jsou všechny normy aspoň 1, rozhodne až ρ(B).

#### Funkce Ritz

Tolerance je v souboru Ritz.m pevně 10⁻⁴ a x⁽⁰⁾ je povinný třetí argument. Funkce vrací i B a c, takže normy jde spočítat hned po ní:

```
A = [1 0.2 -0.1; 0.1 1 0; 0.6 -0.7 1];
b = [-0.55; 2.3; -0.9];
[x, pocet, B, c] = Ritz(A, b, [0; 0; 0])
norm(B, 1)
norm(B, Inf)
max(abs(eig(B)))
```

## 7. Šíření chyb

Přibližná hodnota x̃ s odhadem absolutní chyby δ(x̃) se zapisuje x = x̃ ± δ(x̃). Odhad relativní chyby je ρ(x̃) = δ(x̃)/|x̃| a často se uvádí v procentech. Značení je z přednášky numa_01.pdf a z listu MOJE_CHYBA.pdf. Písmeno ρ tady neznamená spektrální poloměr z kapitoly 3.

| Výpočet | δ (absolutní) | ρ (relativní) |
|---|---|---|
| x̃ ± ỹ | δ(x̃) + δ(ỹ) | δ(x̃ ± ỹ) / \|x̃ ± ỹ\| |
| x̃ · ỹ | \|x̃\|·δ(ỹ) + \|ỹ\|·δ(x̃) | ρ(x̃) + ρ(ỹ) |
| x̃ / ỹ | (\|ỹ\|·δ(x̃) + \|x̃\|·δ(ỹ)) / ỹ² | ρ(x̃) + ρ(ỹ) |
| c·x̃ pro přesné c | \|c\|·δ(x̃) | ρ(x̃) |
| x̃ⁿ | \|n\|·\|x̃\|ⁿ⁻¹·δ(x̃) | \|n\|·ρ(x̃) |
| f(x̃₁, …, x̃ₙ) | Σ \|∂f/∂xᵢ\|·δ(x̃ᵢ) | δ(f) / \|f\| |

Řádky pro součet, součin, podíl a obecnou funkci jsou z přednášky (str. 25 až 38). Řádky pro c·x̃ a x̃ⁿ vycházejí ze vzorce pro funkci a MOJE_CHYBA.pdf je používá jako ρ(π/6) = 0 a ρ(d̃³) = 3ρ(d̃).

### Postup

> Na písemku
> 1. Zapsat vstupy jako x̃ ± δ(x̃) s jednotkami. U zaokrouhleného čísla je δ polovina řádu poslední číslice.
> 2. Spočítat f(x̃) z nezaokrouhlených vstupů.
> 3. Spočítat parciální derivace a dosadit do nich x̃.
> 4. Spočítat δ(f) = Σ |∂f/∂xᵢ|·δ(x̃ᵢ). Každý člen zapsat zvlášť.
> 5. Spočítat ρ(f) = δ(f)/|f| a převést na procenta.
> 6. Zaokrouhlit δ na 1 platnou číslici, nebo na 2, když začíná číslicí 1 nebo 2. Hodnotu zaokrouhlit na stejný řád.
> 7. Zapsat výsledek ve tvaru f = (hodnota ± δ) jednotka a ρ v procentech.

### Vyřešený příklad

Tíhové zrychlení z délky a doby kmitu kyvadla: g = 4π²l/T², l = (1,000 ± 0,002) m a T = (2,006 ± 0,004) s. Čísla 4 a π jsou přesná.

```
g = 4π² · 1,000 / 2,006² = 9,8107 m/s²

∂g/∂l = 4π²/T²   =  9,8107 s⁻²
∂g/∂T = −8π²l/T³ = −9,7813 m/s³

δ(g) = |9,8107| · 0,002 + |−9,7813| · 0,004
     = 0,0196 + 0,0391 = 0,0587 m/s²
ρ(g) = 0,0587 / 9,8107 = 0,0060 = 0,60 %

g = (9,81 ± 0,06) m/s²
```

Druhý člen je dvakrát větší než první. Obě veličiny mají skoro stejnou relativní chybu, ale doba kmitu je ve vzorci ve druhé mocnině.

Stejný výsledek dají pravidla pro relativní chyby, protože g je součin a podíl:

```
ρ(g) = ρ(l) + 2·ρ(T) = 0,002/1,000 + 2 · 0,004/2,006 = 0,0020 + 0,0040 = 0,0060
δ(g) = g · ρ(g) = 9,8107 · 0,0060 ≈ 0,059 m/s²
```

### Chytáky

#### Chyby se vždy sčítají

Při odčítání se absolutní chyby také sčítají: δ(x̃ − ỹ) = δ(x̃) + δ(ỹ). Odečtení chyb by předpokládalo, že se chyby navzájem zruší, a to nikdo nezaručí.

#### Absolutní hodnota derivace

Záporná derivace se do vzorce bere v absolutní hodnotě. V příkladu je ∂g/∂T = −9,7813. Bez absolutní hodnoty by vyšlo δ(g) = 0,0196 − 0,0391 = −0,0196 a záporná chyba nemá smysl.

#### Odečítání blízkých čísel

Absolutní chyba rozdílu je malá, ale relativní může být velká. Pro a = 5,23 ± 0,01 a b = 5,11 ± 0,01 je a + b = 10,34 ± 0,02 s relativní chybou 0,19 %, ale a − b = 0,12 ± 0,02 s relativní chybou 17 %. Přednáška ukazuje totéž na x = 14,20 ± 0,08 a y = 12,40 ± 0,06, kde rozdíl má relativní chybu asi 8 %.

#### Zaokrouhlené číslo

Když zadání řekne, že číslo je zaokrouhlené, chyba je polovina řádu poslední platné číslice. Pro a = 2,5 cm je δ(a) = 0,05 cm, pro 624,2 je δ = 0,05 a pro 94,53 je δ = 0,005. Přednáška tak počítá √5 zaokrouhlené na jedno desetinné místo jako 2,2 ± 0,05.

#### Přesná čísla a konstanty

Celá čísla ve vzorci, například 2, 4 nebo 1/6, a konstanty dosazené s plnou přesností mají nulovou chybu. MOJE_CHYBA.pdf proto píše ρ(π/6) = 0. Když se π dosadí jako 3,14, má chybu |π − 3,14| ≈ 0,0016 a ta se musí započítat.

#### Stejná proměnná vícekrát

Pravidla pro součet, součin a podíl předpokládají nezávislé vstupy. Když je ve vzorci stejná proměnná vícekrát, výpočet po krocích chybu nadhodnotí. Pro f = x/(1 + x) a x = 2,0 ± 0,1:

```
po krocích:  ρ(f) = ρ(x) + ρ(1 + x) = 0,1/2 + 0,1/3 = 0,0833
             δ(f) = 0,6667 · 0,0833 = 0,056

derivací:    f'(x) = 1/(1 + x)² = 1/9
             δ(f) = 1/9 · 0,1 = 0,011
```

Správný je výpočet derivací. Po krocích vyšla chyba pětkrát větší.

#### Úhly ve stupních

Derivace goniometrických funkcí platí pro úhel v radiánech, takže chyba úhlu se převede na radiány. Pro f = sin α a α = (30 ± 0,5)°:

```
δ(α) = 0,5 · π/180 = 0,00873 rad
δ(f) = |cos 30°| · 0,00873 = 0,866 · 0,00873 = 0,0076
sin α = 0,500 ± 0,008
```

Bez převodu by vyšlo δ(f) = 0,866 · 0,5 = 0,43, tedy chyba skoro stejně velká jako hodnota sin 30° = 0,5.

#### Procenta

Relativní chyba v procentech se před dosazením převede na desetinné číslo. Odpor R = 100 Ω ± 5 % má δ(R) = 0,05 · 100 = 5 Ω. Sčítají se jen relativní chyby s relativními a absolutní s absolutními.

#### Mocniny a odmocniny

ρ(x̃ⁿ) = |n|·ρ(x̃) platí i pro n = 1/2, tedy pro odmocninu, a pro n = −1, tedy pro převrácenou hodnotu. Odmocnina relativní chybu půlí a převrácená hodnota ji nemění. Úloha z přednášky: pro a = 1,2 ± 0,1 je ρ(a) = 1/12 a relativní chyba 50 % vyjde pro n = 0,5 / (1/12) = 6, tedy u šesté mocniny.

#### Zaokrouhlení výsledku

Chyba se zaokrouhlí na 1 platnou číslici, nebo na 2, když začíná číslicí 1 nebo 2. Hodnota se zaokrouhlí na stejný řád jako chyba. Zaokrouhluje se až na konci a mezivýsledky se drží na víc míst.

| Spočítáno | Zápis |
|---|---|
| V = 0,5 m³, δ = 0,0225 m³ | V = (0,500 ± 0,023) m³ |
| V = 28179 mm³, δ = 40,3 mm³ | V = (28180 ± 40) mm³ |
| f = 11,43 cm, δ = 0,728 cm | f = (11,4 ± 0,8) cm |
| R = 252,7 Ω, δ = 6 Ω | R = (253 ± 6) Ω |
| C = 1,2 µF, δ = 0,05 µF | C = (1,20 ± 0,05) µF |

První dva řádky jsou z poznámek ze cvičení a z MOJE_CHYBA.pdf, ostatní z kapitoly IV.pdf.

#### Přednáška a kapitola IV počítají jinak

Kapitola IV.pdf je text o nejistotách měření z fyzikální laboratoře. Od přednášky se liší ve dvou věcech:

- Nejistotu nepřímého měření skládá kvadraticky: u(W) = √(Σ (∂W/∂xᵢ)²·u(xᵢ)²). Přednáška a MOJE_CHYBA.pdf sčítají |∂f/∂xᵢ|·δ(x̃ᵢ) bez kvadrátů. Pro kyvadlo vyjde kvadraticky √(0,0196² + 0,0391²) ≈ 0,044 m/s² a lineárně 0,059 m/s².
- Nejistotu zaokrouhluje vždy nahoru, například 0,0327 na 0,04 a 0,728 na 0,8. MOJE_CHYBA.pdf zaokrouhluje běžně, 40,3 na 40.

Úlohy na odhad chyby δ se počítají podle přednášky a MOJE_CHYBA.pdf. Kvadratický součet patří k úlohám na standardní nejistotu u. Který z postupů zápočet chce, materiály výslovně neuvádějí.

### Cvičení

Úlohy 1 až 7 jsou z přednášky numa_01.pdf (str. 27, 31 a 35).

1. x = 6,2 a y = 3,8 jsou zaokrouhlená čísla. Určit x + y a x − y s relativními chybami. Na kontrolu: δ(x) = δ(y) = 0,05, x + y = 10,0 ± 0,1 s ρ = 1 % a x − y = 2,4 ± 0,1 s ρ ≈ 4,2 %.
2. a = 148,0 ± 0,8 a b = 98,2 ± 0,4. Na kontrolu: a + b = 246,2 ± 1,2 s ρ ≈ 0,49 % a a − b = 49,8 ± 1,2 s ρ ≈ 2,4 %.
3. a = 23,5 ± 0,1 a b = 37,3 ± 0,2, součin a podíl. Na kontrolu: a·b = 876,55, δ = 23,5·0,2 + 37,3·0,1 = 8,43 a ρ ≈ 0,96 %, zápis 877 ± 8. a/b = 0,6300 s ρ ≈ 0,96 % a δ ≈ 0,0061, zápis 0,630 ± 0,006.
4. a = 14,2 ± 0,6 a b = 0,9 ± 0,1. Na kontrolu: a·b = 12,78, δ = 1,96 a ρ ≈ 15 %, zápis 12,8 ± 2,0. a/b = 15,78 s ρ ≈ 15 % a δ ≈ 2,42, zápis 15,8 ± 2,4.
5. Čtverec a krychle se stranou a = 2,5 cm, číslo je zaokrouhlené. Na kontrolu: S = 6,25 cm², δ(S) = 2·2,5·0,05 = 0,25 cm², ρ = 4 %, zápis (6,25 ± 0,25) cm². V = 15,625 cm³, δ(V) = 3·2,5²·0,05 ≈ 0,94 cm³, ρ = 6 %, zápis (15,6 ± 0,9) cm³.
6. Auto spotřebuje (8 ± 1) l na 100 km. Kolik spotřebuje na cestu z Hradce Králové do Prahy a zpět, je-li vzdálenost (100 ± 10) km? Na kontrolu: dráha je 2·(100 ± 10) = (200 ± 20) km, spotřeba 8·200/100 = 16 l, ρ = 1/8 + 20/200 = 22,5 %, δ = 3,6 l a zápis (16 ± 4) l.
7. Obdélník má stranu a = (26 ± 0,5) cm a obsah S = (760 ± 5) cm². Určit druhou stranu b = S/a. Na kontrolu: b = 29,23 cm, ρ = 5/760 + 0,5/26 ≈ 2,6 %, δ ≈ 0,75 cm a zápis (29,2 ± 0,8) cm.
8. Válec s r = (2 ± 0,05) cm a h = (10 ± 0,1) cm, V = πr²h. Na kontrolu: V ≈ 125,66 cm³, ρ(V) = 2ρ(r) + ρ(h) = 2·0,025 + 0,01 = 6 %, δ(V) ≈ 7,54 cm³ a zápis (126 ± 8) cm³.

## 8. Kontrolní seznam

| Úloha | Co zkontrolovat před odevzdáním |
|---|---|
| GEM | znaménko každého mᵢₖ, multiplikátory z aktuální matice, upravené b, zkouška v původní soustavě |
| GEM s pivotací | největší absolutní hodnota ve sloupci, prohozené celé řádky i s b |
| LU | jedničky na diagonále L, mᵢₖ na pozici (i, k), L·U = A, y rovné upravené pravé straně z GEM, det A z diagonály U |
| LU s prohozením | matice P, prohozené multiplikátory v L, Pb místo b, znaménko det A |
| Jacobi | nerovnosti dominance, znaménka po dělení aᵢᵢ, vpravo jen index (k), x⁽¹⁾ = c |
| Gauss-Seidel | nové hodnoty hned, pořadí x₁, x₂, x₃, při symetrické matici celé Sylvestrovo kritérium |
| Ritz | B = E − A, c = b, aspoň jedna norma B menší než 1 |
| Iterace obecně | x⁽⁰⁾, tolerance, absolutní nebo relativní zastavovací podmínka, počet iterací z Matlabu |
| Šíření chyb | absolutní hodnoty derivací, úhly v radiánech, δ na 1 nebo 2 platné číslice, hodnota na stejný řád |
