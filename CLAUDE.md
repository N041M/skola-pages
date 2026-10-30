# škola-pages

Statický web na GitHub Pages se studijními materiály. Je česky a bez sestavování. README.md je popis pro lidi. Návod níže stačí k přidání položky bez procházení repozitáře.

- Text webu je neutrální. Neoslovuje čtenáře ani tykáním, ani vykáním.
- Web je kolekce rozkliknutelných testů a materiálů, které vytvořily jiné relace Claude. Soubory jsou ve složkách `předmět/téma/` a úvodní stránka je zobrazuje jako složky s kartami. Úvodní texty a odkazy na stažení se nepřidávají.
- Design je světlý s tmavou variantou, písmo je systémové, rohy jsou hranaté a výplně jsou jednobarevné.

## Mapa repozitáře

- `index.html` je úvodní stránka psaná ručně. Předmět je `<details class="folder folder-subject" open>`, v něm je téma `<details class="folder folder-topic" open>` a v tématu je `<ul class="grid">` s kartami.
- `assets/site.css` má barevné proměnné v `:root` a tmavou variantu v `@media (prefers-color-scheme: dark)`. Třídy jsou `.folder`, `.grid`, `.card`, `.crumb` a `.doc` pro text průvodce.
- `assets/md.js` má funkci `renderMarkdown`, kterou používají stránky průvodců.
- `apsta/testy-hypotez/` je vzorové téma. Má od každého typu položky jeden soubor.
- `.github/workflows/deploy-pages.yml` publikuje celý repozitář při každém pushi do `main`.

Velké soubory se nečtou celé. Soubor `tahak-testy-hypotez.pdf` se nečte vůbec. U `kviz-testy-hypotez.html` (68 kB) stačí CSS a HTML na začátku, komentář se schématem otázek nad `const BANK` a logika od `const STORE`.

## Pojmenování

Složky a soubory jsou malými písmeny bez diakritiky a slova odděluje pomlčka, například `apsta/testy-hypotez/kviz-testy-hypotez.html`. Text na stránkách diakritiku má.

## Karta na úvodní stránce

Každý soubor, na který se kliká, má v `index.html` jednu kartu ve svém tématu:

```html
<li><a class="card" href="predmet/tema/soubor.html"><span class="type">Kvíz</span><strong>Název</strong><span class="d">Jedna věta o obsahu.</span></a></li>
```

Použité typy jsou `PDF`, `Průvodce` a `Kvíz`. Nové téma je kopie celého bloku `folder-topic` a nový předmět je kopie bloku `folder-subject`.

## Typy položek

Kvíz je jeden samostatný soubor HTML s CSS a JS uvnitř a bez externích závislostí. Nový kvíz vznikne kopií `apsta/testy-hypotez/kviz-testy-hypotez.html`, ve které se změní `<title>`, `<h1>`, `TOPICS`, `BANK` a `STORE`. `STORE` je klíč v localStorage a každý kvíz musí mít jiný, proto se rovná názvu souboru. Otázka má pole `t` (okruh z `TOPICS`), `k` (`single`, `multi` nebo `num`), `q` (text, smí obsahovat HTML), `o` (možnosti), `a` (index, pole indexů nebo číslo), `tol` (tolerance u `num`), `hint`, `e` (vysvětlení) a `fixed` (možnosti se nemíchají).

Studijní průvodce je soubor `studijni-pruvodce.md` a stránka `pruvodce.html` vedle něj. Stránka je kopie `apsta/testy-hypotez/pruvodce.html`, ve které se mění jen `<title>`. `md.js` umí nadpisy `#` až `####`, odstavce, seznamy (`-`, `*`, `1.`), tabulky, `**tučné**`, `==zvýraznění==` a `` `kód` ``. Svislítko uvnitř buňky tabulky se píše `\|`. Řádek `![popisek](obrazky/soubor.svg)` vloží obrázek s popiskem. Obrázky jsou SVG ve složce `obrazky/` tématu a tmavou variantu mají v `@media (prefers-color-scheme: dark)` uvnitř souboru. Řádky začínající `>` tvoří rámeček a první z nich je jeho nadpis. Nadpis `Shrnutí` dává modrý rámeček, `Pozor` červený a `Na písemku` zelený. Uvnitř rámečku fungují seznamy. Kurzíva, odkazy, vnořené seznamy, bloky kódu a vzorce v LaTeXu se nevykreslí. Když průvodce potřebuje další prvek, rozšíří se `md.js`, protože ho sdílejí všechny průvodce.

PDF má vedle sebe zdrojový soubor Typst se stejným názvem a příponou `.typ`. Kompiluje se příkazem `typst compile soubor.typ`. Typst nemusí být nainstalovaný a ověří se to příkazem `which typst`.

Každá stránka HTML má na začátku `<main>` odkaz zpět: `<p class="crumb"><a href="../../">Škola</a></p>`.

## Kontrola a nasazení

Web se spouští z kořene repozitáře příkazem `python3 -m http.server` a otevírá se na http://localhost:8000/. Průvodce se přímo ze souboru nenačte. Kontroluje se světlá i tmavá varianta a šířka telefonu.

Zprávy commitů jsou anglicky jako dosavadní historie. Push do `main` nasadí web na https://n041m.github.io/skola-pages/.
