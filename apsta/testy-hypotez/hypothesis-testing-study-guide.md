# Testy hypotéz: study guide for the midterm

Sources: lectures 1 to 3 by H. Skalská (APSTA, UHK FIM), the two decision schemas (B1 one sample, B2 two samples, the student A5 sheet), "Testy hypotéz - příklady s řešením", "Souhrnný přehled Rozhodování o hypotéze a funkce MsExcelu", and the Groebner cell phone examples. The exam is on paper and in Czech, so the Czech term is given next to each English one. Phrases you can write on the exam are marked with ▶.

## 0. What the exam asks for

The course notes list five things you must be able to do with any word problem:

1. Name the parameter being tested (střední hodnota μ, rozptyl σ², podíl π), say whether it is one sample or two, and whether two samples are dependent or independent.
2. Write H0 and H1 in words and in symbols.
3. Propose the test, name its variant and its assumptions (předpoklady).
4. Compute the test statistic (testové kritérium, TK) for the one-sample tests, the F-test and the pooled t-test.
5. Read a quantile such as t₀.₉₇₅;₆ = 2,45 and say whether it lets you decide the problem.

Everything below serves those five points.

## 1. Notation (značení)

| Population parameter | Sample estimate | Czech name |
|---|---|---|
| μ | x̄ (aritmetický průměr) | střední hodnota |
| σ, σ² | s, s² | směrodatná odchylka, rozptyl |
| π | p = m/n (relativní četnost, m = počet výskytů) | pravděpodobnost výskytu jevu, podíl |
| Δ | d̄ | střední hodnota rozdílů (párový test) |
| ρ | r | korelační koeficient |
| β | b | regresní koeficient |

Watch the pairs. In this course p is the sample proportion and π is the population proportion. The p-value is called "hodnota p" or "přesná hladina významnosti" and is a different thing from the proportion p.

Other symbols: n = rozsah výběru, df = stupně volnosti, Wα = kritický obor (oblast zamítání), V = doplňkový obor, KH = kritická hodnota, CLV = centrální limitní věta.

## 2. The logic of a test (lecture 1)

A hypothesis is a claim about an unknown population parameter. The test has a null hypothesis H0 and an alternative H1. The test statistic is a function of the sample whose probability distribution is derived under the assumption that H0 is true. If the observed value falls where it would be unlikely under H0, H0 is rejected.

### Writing H0 and H1

- H0 always contains "=". It says there is no difference, no change, no dependence. Examples: H0: μ = 5, H0: μ₁ = μ₂, H0: π = 0,32, H0: σ₁² = σ₂².
- H1 is the complement. Three forms: μ ≠ μ₀ (oboustranná alternativa), μ < μ₀ (levostranná), μ > μ₀ (pravostranná).
- With a one-sided H1, H0 logically also covers the other inequality. The lecture writes H0: π = 0,32 against H1: π > 0,32 and notes that H0 then includes π < 0,32 as well.
- H1 is usually the new claim someone wants to prove ("the campaign raised the share", "the training shortened calls"). Read the story for words like "větší", "menší", "zvýšil", "snížil", "liší se", "stejný". "Liší se" or "změnil se" means two-sided. A direction word means one-sided.
- ▶ "H0 zamítáme, přijímáme H1." / ▶ "H0 nezamítáme." Never write "H0 přijímáme". The lecture is explicit about this.

### Errors (chyby při testování)

| | H0 is true | H0 is false |
|---|---|---|
| Do not reject H0 (TK ∈ V) | correct, P ≥ 1 − α | chyba II. druhu, P = β |
| Reject H0 (TK ∈ Wα) | chyba I. druhu, P ≤ α | correct, P = 1 − β = síla testu |

- α (hladina významnosti) is the probability of wrongly rejecting a true H0. You choose it, usually 0,05 or 0,01. The test is built so that this probability never exceeds α.
- β is the probability of wrongly keeping a false H0. You do not choose it. It can only be computed for one specific alternative value, so it is often unknown. That is why the result is phrased "H0 nezamítáme" and not "H0 přijímáme".
- Power (síla testu) = 1 − β = probability of rejecting H0 when it is false.

How β behaves (lecture 1, slide 16, and the simulations in lecture 3):

- Smaller α at the same n gives larger β. So do not pick α too small.
- Larger n at the same α gives smaller β. In the simulation with a true difference of 3 and n = 30, H0 was not rejected in 47 % of runs. With n = 100 it was only 3 %.
- Smaller variability of the variable gives smaller β. Variability is a property of the data, not of your choice.

Statistical versus practical significance (statistická vs. věcná významnost): with a very large n, even a tiny and practically irrelevant difference becomes statistically significant. Always say what the difference means in the real problem.

### Critical region and critical value

- Wα is the set of TK values for which H0 is rejected. Its complement is V.
- The critical value (KH) is the quantile of the TK distribution that separates Wα from V.
- Wα depends on: the test (shape of the TK distribution under H0), the chosen α, and the form of H1 (two-sided splits α into two tails of α/2, one-sided puts all of α into one tail).

For a test statistic that is symmetric around 0 under H0 (U with N(0,1), T with the t distribution):

| H1 | Wα | KH | p-value |
|---|---|---|---|
| ≠ | \|TK\| > x₁₋α/₂ | ± x₁₋α/₂ (for α = 0,05: ±1,96 for U) | 2·[1 − F(\|TK\|)] |
| < | TK < xα = −x₁₋α | −1,645 for U, α = 0,05 | F(TK) |
| > | TK > x₁₋α | +1,645 for U, α = 0,05 | 1 − F(TK) |

F is the distribution function (Φ for N(0,1), the t distribution function for T).

For the F and χ² distributions, which are not symmetric, the two-sided region is TK < xα/₂ or TK > x₁₋α/₂, the left-sided region is TK < xα, and the right-sided region is TK > x₁₋α.

### The two decision rules (rozhodovací pravidla)

- Rule I: compute TK, find KH, reject H0 when TK ∈ Wα.
- Rule II: compute the p-value, reject H0 when p ≤ α.

The p-value is the probability, under H0, of getting a TK at least as extreme as the one observed. Software (SPSS "Sig.") prints p. Both rules always give the same decision.

### Quantiles and how to read t₀.₉₇₅;₆ = 2,45

A quantile x_p is the value for which P(X < x_p) = p. Values below it have probability p, values above it have probability 1 − p. The percentile is the same thing in percent.

t₀,₉₇₅;₆ = 2,45 means: for the t distribution with 6 degrees of freedom, values below 2,45 have probability 0,975 and values above 2,45 have probability 0,025. This value is:

- the critical value of a two-sided test at α = 0,05 with df = 6 (the region is |t| > 2,45),
- the critical value of a right-sided test at α = 0,025 with df = 6,
- by symmetry, −2,45 = t₀,₀₂₅;₆ is the left-sided critical value at α = 0,025.

It is not the critical value for a one-sided test at α = 0,05 with df = 6 (that would be t₀,₉₅;₆ = 1,943), nor for df = 7. If the exam gives you a quantile, check all three things: distribution, df, and probability index versus your α and H1.

Symmetry: tα;df = −t₁₋α;df and uα = −u₁₋α. For F: Fα;df₁;df₂ = 1 / F₁₋α;df₂;df₁.

Excel reading: INV functions go from probability to quantile (T.INV(0,975; 6) = 2,45), DIST functions go from value to probability (T.DIST(2,45; 6; 1) = 0,975). RT means the right tail, 2T means both tails.

### The procedure (postup testování), lecture 1 slide 20

1. Write H0 and H1.
2. Choose α.
3. Get the sample data.
4. Choose the test (type of variable, parameter, hypothesis, sample size, assumptions).
5. Compute TK from the sample.
6. Determine Wα for the chosen α.
7. Decide: TK in Wα or not (or p ≤ α or not).
8. Interpret in the words of the problem.

## 3. One-sample tests (lecture 2, schema B1)

Decision path in the B1 schema: Is the variable approximately normal, or can the CLV be assumed? Yes → mean or variance test. No → is it a binomial (yes/no) variable? Yes → test for π. No → other distribution or a nonparametric test.

### Mean, σ known (u-test)

H0: μ = μ₀. U = (x̄ − μ₀) / (σ/√n), U ~ N(0,1) under H0. Assumptions: normal population or large n, simple random sample, σ known.

### Mean, σ unknown (one-sample t-test)

H0: μ = μ₀. T = (x̄ − μ₀) / (s/√n) = (x̄ − μ₀) / s_x̄, where s_x̄ = s/√n is the standard error of the mean. T ~ t(n − 1) under H0. Assumptions: the variable is approximately N(μ, σ²), σ² is unknown and estimated by s², simple random sample. For n > 100 the t distribution is practically N(0,1).

Lecture example (koření): declared 16 g, n = 50, x̄ = 14,9, s = 3,9, customers say it is less. H0: μ = 16, H1: μ < 16, α = 0,05.
t = (14,9 − 16)/(3,9/√50) = −1,994. KH = t₀,₀₅;₄₉ = −1,6765. −1,994 < −1,6765, so H0 is rejected. p = F_t(−1,994) = 0,026 < 0,05. ▶ "Deklarovaná hmotnost je vyšší než skutečná, stížnost je oprávněná."

### Variance (χ² test)

H0: σ² = σ₀². χ² = (n − 1)s² / σ₀², χ² ~ χ²(n − 1) under H0. Sensitive to departures from normality. Two-sided region: χ² < χ²α/₂;n₋₁ or χ² > χ²₁₋α/₂;n₋₁.

### Proportion (parametr binomického rozdělení), limit test

Binary variable (has the feature / does not). m = number of successes in n independent trials has a binomial distribution. p = m/n estimates π.

H0: π = π₀. U = (p − π₀) / √(π₀(1 − π₀)/n), U ~ N(0,1) approximately under H0.

Assumption (CLV): n·π₀ ≥ 5 and n·(1 − π₀) ≥ 5, and π₀ not close to 0 or 1. Note that the check uses π₀ from H0, not p. If the check fails, use the exact binomial test (not part of the exam).

Continuity correction (korekce na nespojitost): the lecture subtracts 1/(2n) from |p − π₀| in the numerator. Example A: π₀ = 0,56, n = 500, m = 298, p = 0,596. Without correction u = 0,036/0,0222 = 1,62. With correction u = (0,036 − 0,001)/0,0222 = 1,5766. Both are below 1,96, so H0 is not rejected. Two-sided p = 2·[1 − Φ(1,5766)] = 0,1148.

Example B is the same data with H1: π > 0,56. KH = u₀,₉₅ = 1,645. u = 1,58 < 1,645, not rejected. One-sided p = 1 − Φ(1,5766) = 0,0574 > 0,05. Compare: the same data give p = 0,115 two-sided and p = 0,057 one-sided. One-sided p is half the two-sided p when the sample points in the direction of H1.

▶ "Nepodařilo se prokázat statisticky významnou změnu podílu na trhu (na hladině významnosti 0,05). Pozorovanou odchylku lze vysvětlit náhodnou chybou výběru."

## 4. Two-sample tests (lecture 3, schema B2)

### Dependent or independent samples?

Dependent (závislé, párové): the same units measured twice (before and after, first and second reading), or units matched in pairs (the same shopping basket priced in store A and store B). Each value in sample 1 has a partner in sample 2, and n₁ = n₂.

Independent (nezávislé): two different groups of units (men and women, store A customers and store B customers, Basic plan and Business plan). The sizes can differ.

### Paired t-test (párový t-test)

Form the differences dᵢ for each pair. The lecture defines dᵢ = xᵢ⁽²⁾ − xᵢ⁽¹⁾ on the theory slide, while the worked blood pressure example uses D = X₁ − X₂. Either is fine, but the direction of H1 must match your definition of d. State it.

H0: Δ = Δ₀ (usually 0). d̄ = (1/n) Σ dᵢ, s_d² = (1/(n − 1)) Σ (dᵢ − d̄)².
T = (d̄ − Δ₀) / (s_d/√n), T ~ t(n − 1). Assumption: the differences are approximately N(Δ, σ_d²). This is the one-sample t-test applied to the differences.

Lecture example (hypermarkets A and B, 100 matched baskets): d̄ = 3,57, s_d = 2,99, H1: Δ > 0, α = 0,01. t = 3,57/(2,99/√100) = 11,94 > t₀,₉₉;₉₉ = 2,364. SPSS printed Sig. = 0,000 (really 7·10⁻²¹). ▶ "Na 1% hladině významnosti je prokázána statisticky významně vyšší průměrná úroveň cen v hypermarketu A."

### F-test of equal variances (test shody rozptylů)

H0: σ₁² = σ₂². F = s₁²/s₂², with the labels chosen so that s₁² ≥ s₂² (larger variance in the numerator). F ~ F(n₁ − 1, n₂ − 1) under H0 (numerator df first, denominator df second). Assumption: independent samples from normal populations.

With the larger variance on top, only the right tail matters: two-sided H1 rejects when F > F₁₋α/₂;n₁₋₁;n₂₋₁, right-sided H1 rejects when F > F₁₋α;n₁₋₁;n₂₋₁. If you did not put the larger variance on top, the two-sided region is F < Fα/₂ or F > F₁₋α/₂.

Note: slide 11 of lecture 3 writes the degrees of freedom as (n₁ − 1, n₂ − 2). Slide 12 and the examples use (n₁ − 1, n₂ − 1), which is correct.

Lecture example (ohřívače): s₁² = 8,354 (n₁ = 13), s₂² = 2,367 (n₂ = 15), H1: σ₁² > σ₂², α = 0,05. F = 3,53 > F₀,₉₅;₁₂;₁₄ = 2,53. Rejected. ▶ "Model 2 má statisticky významně nižší rozptyl teplot."

The F-test's main use in this course is to choose between the two versions of the unpaired t-test.

In SPSS the output shows Levene's test instead of the F ratio. Its Sig. plays the same role (Sig. > α → variances taken as equal → read the row "Equal variances assumed"; Sig. ≤ α → read "Equal variances not assumed"). The Levene F is not the ratio s₁²/s₂², so when the exam asks for the F criterion, compute the ratio yourself.

### Unpaired t-test, equal variances (nepárový t-test při shodných rozptylech)

H0: μ₁ = μ₂. Pooled variance s² = [(n₁ − 1)s₁² + (n₂ − 1)s₂²] / (n₁ + n₂ − 2).
T = (x̄₁ − x̄₂) / (s·√(1/n₁ + 1/n₂)), T ~ t(n₁ + n₂ − 2) under H0.
Assumptions: both populations approximately normal, independent simple random samples, σ₁² = σ₂² unknown (the F-test did not reject).

Lecture example (autobazary A and B): n₁ = 36, x̄₁ = 169,417, s₁² = 1442,99; n₂ = 34, x̄₂ = 162,068, s₂² = 1022,6; α = 0,05.
F-test: F = 1,411 < F₀,₉₇₅;₃₅;₃₃ = 1,9886, variances taken as equal.
s² = (35·1442,99 + 33·1022,6)/68 = 1238,98, s = 35,20.
t = 7,349 / (35,20·√(1/36 + 1/34)) = 0,873 < t₀,₉₇₅;₆₈ = 1,995. Not rejected. p = 2·T.DIST.RT(0,873; 68) = 0,386. ▶ "Rozdíl mezi průměrnými cenami nebyl prokázán (p = 0,386)."

### Unpaired t-test, unequal variances (Welch)

H0: μ₁ = μ₂. T = (x̄₁ − x̄₂) / √(s₁²/n₁ + s₂²/n₂).
df = (s₁²/n₁ + s₂²/n₂)² / [ (s₁²/n₁)²/(n₁ − 1) + (s₂²/n₂)²/(n₂ − 1) ], rounded down to an integer.

Lecture example (autobazary A and C): s₁² = 1442,99, s₃² = 636,004, n = 36 each. F = 2,269 > F₀,₉₇₅;₃₅;₃₅ = 1,961, so variances differ and Welch is used. H1: μ₁ > μ₃. t = 20,823/7,599 = 2,740, df = 60,83 → 60, KH = t₀,₉₅;₆₀ = 1,671. Rejected, p = 0,004.

### Two-sample Z-test (σ₁, σ₂ known)

Only in the student A5 schema, not in the lectures. Z = (x̄₁ − x̄₂ − Δ₀) / √(σ₁²/n₁ + σ₂²/n₂), Z ~ N(0,1). Use it when the problem gives population standard deviations.

### Two proportions (test shody podílů, shoda dvou parametrů binomického rozdělení)

Two independent samples, p₁ = m₁/n₁, p₂ = m₂/n₂. Pooled estimate under H0: p̄ = (m₁ + m₂)/(n₁ + n₂).
H0: π₁ = π₂. U = (p₁ − p₂) / √( p̄(1 − p̄)·(1/n₁ + 1/n₂) ), which the lecture also writes as (p₁ − p₂)/√(p̄(1 − p̄)) · √(n₁n₂/(n₁ + n₂)). U ~ N(0,1) approximately.
Assumption (CLV): nᵢpᵢ ≥ 5 and nᵢ(1 − pᵢ) ≥ 5 for both samples. Otherwise the exact Fisher test. For paired binary data the McNemar test. The limit test is equivalent to the χ² test of a 2×2 table.

Lecture example: 54 of 231 young people and 49 of 173 older people report worsening. p₁ = 0,234, p₂ = 0,283, p̄ = 103/404 = 0,255. u = −0,049 / √(0,255·0,745·(1/231 + 1/173)) = −1,13 (the slide shows 1,07 because it rounded p₂ to 0,281). |u| < 1,96, not rejected, p = 0,26. ▶ "Mezi věkovými skupinami nebyl prokázán statisticky významný rozdíl v podílech."

### Choosing the test (B2 schema in words)

Quantitative variable, means:
- one sample: σ known → u-test; σ unknown → t-test (df = n − 1)
- two dependent samples → paired t-test (df = n − 1)
- two independent samples: σ₁, σ₂ known → Z-test; unknown → F-test first, then pooled t-test (df = n₁ + n₂ − 2) if F does not reject, Welch if it does
- more than two independent samples → ANOVA (next chapter)

Quantitative variable, variances: one sample → χ²(n − 1); two independent samples → F(n₁ − 1, n₂ − 1).

Binary variable, proportions:
- one sample: nπ₀ ≥ 5 and n(1 − π₀) ≥ 5 → limit u-test; otherwise binomial test
- two independent samples: CLV holds → limit U test; otherwise Fisher exact test
- two dependent samples → McNemar test
- dependence in an r × c table → χ² test (next chapter)

Variable not normal and n small → nonparametric test (not in the exam).

## 5. How to write up an exam problem

Use this skeleton for every word problem. It covers everything the course grades.

1. ▶ Parametr: "Testuje se střední hodnota μ (jeden výběr, σ neznámé)." or "Testují se podíly π₁ a π₂ ve dvou nezávislých výběrech."
2. ▶ Hypotézy: "H0: μ = 540 (školení délku hovorů nezměnilo), H1: μ < 540 (školení hovory zkrátilo), levostranná alternativa." Always say which parameter and give the direction in words.
3. ▶ Hladina významnosti: "α = 0,05."
4. ▶ Test a předpoklady: "Jednovýběrový t-test. Předpoklady: přibližně normální rozdělení délky hovorů, prostý náhodný výběr, σ odhadnuto výběrovou směrodatnou odchylkou s."
5. ▶ Testové kritérium: write the formula, substitute, give the number.
6. ▶ Kritický obor: "T má při platnosti H0 t-rozdělení s df = n − 1 = 15. W₀,₀₅ = {t: t < t₀,₀₅;₁₅ = −1,753}." Say which quantile you need and why that index.
7. ▶ Rozhodnutí: "t = −2,67 ∈ W, H0 zamítáme na hladině významnosti 0,05 (p = 0,009 < 0,05)."
8. ▶ Interpretace: "Školení statisticky významně zkrátilo průměrnou délku hovoru." or, when not rejected: "Statisticky významný rozdíl nebyl prokázán, pozorovaný rozdíl lze vysvětlit výběrovou chybou."

When the exam gives you a quantile and asks whether it is enough to decide: name the distribution, the df and the probability index that your test needs, and compare with what was given. If it matches, decide. If not, say what is missing (for example "potřebuji t₀,₉₅;₁₅, zadáno je t₀,₉₇₅;₁₅, to je kritická hodnota pro oboustrannou alternativu").

## 6. Traps the course materials warn about

- π versus p, σ versus s, μ versus x̄. Hypotheses are always about the Greek (population) symbol.
- H0 must contain "=". "H0: μ > 540" is wrong.
- A direction word in the problem means a one-sided H1 and a one-sided critical value (u₀,₉₅ = 1,645, not 1,96). A two-sided H1 uses α/2 in each tail.
- Left-sided test: the critical value is negative and TK must be below it.
- The one-sided p-value is one tail. Do not double it.
- F-test: larger variance on top, then compare with F₁₋α/₂ (two-sided) or F₁₋α (one-sided). Numerator df first.
- The F-test comes before the unpaired t-test and decides which version you use.
- Welch df is rounded down.
- Paired data (n₁ = n₂ and a natural pairing) must not be analysed as two independent samples.
- CLV check for one proportion uses π₀, for two proportions uses the sample proportions.
- "H0 nezamítáme" is not "H0 platí". Not rejecting means the data do not contradict H0.
- Smaller α means larger β. Larger n reduces β.
- Statistical significance is not practical importance.

## 7. Practice problems

Solve on paper with the cheat sheet, then check the solutions at the end. Quantiles you need: u₀,₉₅ = 1,645, u₀,₉₇₅ = 1,960, t₀,₉₅;₉ = 1,833, t₀,₉₇₅;₉ = 2,262, t₀,₉₅;₁₁ = 1,796, t₀,₉₇₅;₁₈ = 2,101, t₀,₉₉;₂₄ = 2,492, F₀,₉₅;₉;₁₁ = 2,896, F₀,₉₇₅;₉;₁₁ = 3,588, χ²₀,₀₂₅;₉ = 2,70, χ²₀,₉₇₅;₉ = 19,02.

**P1.** A coffee dispenser should dispense 5 g. In 10 random cups the mean was 5,3 g with s = 0,4 g. Does the dispenser deviate from 5 g? α = 0,05. Assume normality.

**P2.** A manufacturer claims at most 10 % of its devices fail within a year. Of 200 devices, 28 failed. Is the failure rate higher than claimed? α = 0,05.

**P3.** Two independent groups of students did the same test. Group 1: n₁ = 10, x̄₁ = 72, s₁ = 8. Group 2: n₂ = 12, x̄₂ = 65, s₂ = 6. Does group 1 score higher on average? α = 0,05. Assume normality. Start with the F-test.

**P4.** 25 patients had their cholesterol measured before and after a diet. The mean drop (before − after) was 0,30 mmol/l with s_d = 0,50. Did the diet reduce cholesterol? α = 0,01.

**P5.** In town A, 120 of 300 respondents support a project; in town B, 90 of 300. Does support differ between the towns? α = 0,05.

**P6.** A machine should have standard deviation σ = 2,0 mm. A sample of 10 parts has s = 2,9 mm. Is the variance different from 4,0 mm²? α = 0,05. Which quantiles do you need?

**P7.** You are testing H0: μ = 100 against H1: μ > 100 with n = 12 and σ unknown. The exam sheet gives t₀,₉₇₅;₁₁ = 2,201. Your t = 2,0. Can you decide at α = 0,05? What do you need?

**P8.** Conceptual. (a) What happens to β if you lower α from 0,05 to 0,01 with the same data? (b) Two ways to reduce β. (c) A test with n = 10 000 rejects H0: μ₁ = μ₂ with p = 0,001 and the observed difference is 0,2 % of the mean. What should you say about it?

**P9.** SPSS output for Total $ spent, males versus females: Levene F = 11,262, Sig. = 0,002; row "Equal variances assumed" t = 2,158, df = 48, Sig. (2-tailed) = 0,036; row "Equal variances not assumed" t = 2,450, df = 44,55, Sig. (2-tailed) = 0,018. Which row do you read and what do you conclude at α = 0,05?

### Solutions

**P1.** Parameter μ, one sample, σ unknown. H0: μ = 5, H1: μ ≠ 5. One-sample t-test, df = 9. t = (5,3 − 5)/(0,4/√10) = 0,3/0,1265 = 2,372. KH = ±t₀,₉₇₅;₉ = ±2,262. |2,372| > 2,262 → H0 zamítáme na hladině 0,05. The dispenser deviates (it overfills). Note that with a one-sided H1: μ > 5 the KH would be 1,833 and the conclusion the same.

**P2.** Parameter π, one sample. H0: π = 0,10, H1: π > 0,10. CLV: 200·0,1 = 20 ≥ 5 and 200·0,9 = 180 ≥ 5, so the limit test applies. p = 28/200 = 0,14. u = (0,14 − 0,10)/√(0,1·0,9/200) = 0,04/0,02121 = 1,886. KH = u₀,₉₅ = 1,645. 1,886 > 1,645 → H0 zamítáme. The failure rate is significantly higher than 10 %. (With the continuity correction: (0,04 − 0,0025)/0,02121 = 1,768, still rejected.)

**P3.** F-test first. H0: σ₁² = σ₂², H1: σ₁² ≠ σ₂². F = 64/36 = 1,778 (larger on top, df 9 and 11). KH = F₀,₉₇₅;₉;₁₁ = 3,588. 1,778 < 3,588 → variances taken as equal. Pooled t-test. H0: μ₁ = μ₂, H1: μ₁ > μ₂. s² = (9·64 + 11·36)/20 = (576 + 396)/20 = 48,6, s = 6,971. t = (72 − 65)/(6,971·√(1/10 + 1/12)) = 7/(6,971·0,4282) = 7/2,985 = 2,345. df = 20. KH = t₀,₉₅;₂₀ = 1,725 (from the t table). 2,345 > 1,725 → H0 zamítáme. Group 1 scores significantly higher.

**P4.** Paired, parameter Δ = μ_before − μ_after. H0: Δ = 0, H1: Δ > 0. t = 0,30/(0,50/√25) = 0,30/0,10 = 3,0. df = 24. KH = t₀,₉₉;₂₄ = 2,492. 3,0 > 2,492 → H0 zamítáme na hladině 0,01. The diet lowered cholesterol significantly.

**P5.** Two independent proportions. H0: π₁ = π₂, H1: π₁ ≠ π₂. p₁ = 0,40, p₂ = 0,30, p̄ = 210/600 = 0,35. CLV holds (all of n·p and n·(1 − p) are far above 5). u = (0,40 − 0,30)/√(0,35·0,65·(2/300)) = 0,10/√(0,0015167) = 0,10/0,03894 = 2,568. KH = ±1,96. 2,568 > 1,96 → H0 zamítáme. Support differs (p ≈ 0,010).

**P6.** One-sample variance test. H0: σ² = 4, H1: σ² ≠ 4. χ² = (n − 1)s²/σ₀² = 9·8,41/4 = 18,92. df = 9. Two-sided region: χ² < χ²₀,₀₂₅;₉ = 2,70 or χ² > χ²₀,₉₇₅;₉ = 19,02. 18,92 is just below 19,02 → H0 nezamítáme. The deviation is not significant at α = 0,05 (it would be at α = 0,10, where the quantile is 16,92).

**P7.** You need the right-sided critical value t₀,₉₅;₁₁ = 1,796. The given t₀,₉₇₅;₁₁ = 2,201 is the two-sided value at α = 0,05 (or the one-sided value at α = 0,025). With it alone you can only say this: because 2,0 < 2,201, the one-sided p is more than 0,025. That does not settle whether p ≤ 0,05. Since t₀,₉₅;₁₁ = 1,796 < 2,0, H0 is rejected at α = 0,05. On the exam, write which quantile you need and why.

**P8.** (a) β rises. A smaller α makes the critical region smaller, so a false H0 is kept more often. (b) Increase n, or reduce the variability of the measurement (better design, more homogeneous units). Choosing a larger α also lowers β but raises the type I risk. (c) The difference is statistically significant because n is huge, but a difference of 0,2 % is practically negligible. Report both the p-value and the size of the difference, and say that the statistical significance does not imply practical importance.

**P9.** Levene Sig. = 0,002 < 0,05, so the variances differ and you read "Equal variances not assumed": t = 2,450, df = 44,55, p = 0,018 < 0,05. Reject H0 of equal mean spending. Men spend significantly more on average (mean difference 38,38 USD). If the alternative had been one-sided in the observed direction, p would be 0,009.

## 8. Next chapters (not in this midterm, but on the overview sheet)

ANOVA for one factor tests H0: μ₁ = μ₂ = … = μᵣ with F = MSTR/MSE and df (r − 1, n − r). The χ² test of independence in an r × c contingency table uses χ² = Σ (nᵢⱼ − nᵢⱼᵀ)²/nᵢⱼᵀ with df (r − 1)(c − 1) and the right-tail critical value CHISQ.INV.RT(α; df).
