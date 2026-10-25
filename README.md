# Škola

Tento repozitář je web na GitHub Pages se studijními materiály ke škole. Má interaktivní testy v HTML, taháky a PDF ke stažení a studijní průvodce. Je to čisté HTML, CSS a JavaScript bez sestavování, takže funguje bez Claude a bez jakéhokoli nástroje.

Každý předmět má vlastní složku. Zatím je tu jedna:

- [`apsta/`](apsta/) má tahák k testům hypotéz (PDF a zdroj v Typstu) a studijní průvodce k midtermu. Průvodce je psaný anglicky s českými pojmy.

## Spuštění na počítači

Repozitář se spouští z kořene:

```sh
python3 -m http.server
```

Pak se otevře http://localhost:8000/. Studijní průvodce načítá soubor Markdown, takže se nedá otevřít přímo ze souboru.

## Přidání materiálu

- Nový předmět je nová složka s vlastním `index.html` podle `apsta/index.html` a karta v kořenovém `index.html`.
- Interaktivní test je jeden samostatný soubor HTML bez externích závislostí, aby šel otevřít i stažený.
- Nový PDF soubor stačí dát do složky předmětu a přidat na něj kartu.
- Studijní průvodce je soubor Markdown. Stránka `apsta/pruvodce.html` ho zobrazí a umí nadpisy, odstavce, seznamy, tabulky, tučné písmo a kód.

Kopie souborů z `~/Desktop/APSTA` jsou v `apsta/` z 25. 10. 2026. Pozdější změny v původní složce je nutné zkopírovat znovu.

## Nasazení

Workflow `.github/workflows/deploy-pages.yml` publikuje celý repozitář při každém pushi do `main`. V nastavení repozitáře musí být v Settings, Pages, Source zvoleno GitHub Actions.

## Licence a zdroje

Obsah vychází z přednášek a materiálů předmětu APSTA (UHK FIM, H. Skalská). Písmo IBM Plex Mono od IBM je pod licencí SIL Open Font License 1.1, text licence je v `fonts/LICENSE-IBMPlexMono.txt`.
