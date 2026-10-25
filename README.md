# Škola

Tento repozitář je web na GitHub Pages. Je to kolekce rozkliknutelných interaktivních testů, studijních materiálů a PDF, které vytvářejí relace Claude. Je to čisté HTML, CSS a JavaScript bez sestavování, takže funguje bez Claude a bez jakéhokoli nástroje.

Web je na https://n041m.github.io/skola-pages/.

## Struktura

Soubory jsou ve složkách `předmět/téma/`, například `apsta/testy-hypotez/`. Úvodní stránka má stejné složky jako rozbalovací skupiny a v nich karty s položkami.

## Přidání materiálu

- Soubory patří do složky tématu. Nové téma je nová složka a nový předmět je nová složka v kořeni.
- Na úvodní stránce má každá položka kartu ve skupině svého tématu. Karta je kopie existující karty s novým odkazem, typem, názvem a popisem. Nové téma je kopie bloku `folder-topic` a nový předmět je kopie bloku `folder-subject`.
- Interaktivní test je jeden samostatný soubor HTML bez externích závislostí, aby šel otevřít i stažený.
- Studijní průvodce je soubor Markdown. Stránka `apsta/testy-hypotez/pruvodce.html` ho zobrazí a umí nadpisy, odstavce, seznamy, tabulky, tučné písmo a kód.
- Text webu je neutrální a neoslovuje čtenáře.

Kopie souborů z `~/Desktop/APSTA` jsou v `apsta/testy-hypotez/` z 25. 10. 2026. Pozdější změny v původní složce je nutné zkopírovat znovu.

## Spuštění na počítači

Repozitář se spouští z kořene:

```sh
python3 -m http.server
```

Pak se otevře http://localhost:8000/. Studijní průvodce načítá soubor Markdown, takže se nedá otevřít přímo ze souboru.

## Nasazení

Workflow `.github/workflows/deploy-pages.yml` publikuje celý repozitář při každém pushi do `main`.

## Zdroje

Obsah vychází z přednášek a materiálů předmětu APSTA (UHK FIM, H. Skalská).
