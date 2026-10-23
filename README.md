# Projet n° 6 — Structure du marché du whisky écossais

Données : `Scotch` du package `bayesm` (2 218 consommateurs, 21 marques, achats sur un an).

## Reproduire l'analyse

1. Ouvrir `projet-6.Rproj` dans RStudio (le répertoire de travail est alors le dossier du projet).
2. Installer les packages :
   ```r
   install.packages(c("tidyverse", "knitr", "rmarkdown", "bayesm",
                      "FactoMineR", "factoextra", "cluster"))
   ```
3. Ouvrir `rapport.qmd` puis cliquer sur **Render**. Le rapport HTML autonome est produit dans le dossier du projet. Les chemins sont relatifs et la graine aléatoire est fixée (`set.seed(2026)`).
4. Le graphique principal est exporté automatiquement vers `figures/figure-cle.pdf` pendant le rendu.
5. Pour le résumé exécutif, ouvrir `resume-executif.tex` et le compiler avec pdfLaTeX (bouton **Compile PDF**, ou Overleaf).

## Contenu

| Fichier | Rôle |
|:--------|:-----|
| `rapport.qmd` | rapport technique (code, exploration, modélisation, évaluation) |
| `R/fonctions.R` | chargement des données et fonctions (matrice d'achats, lift, ARI, format français) |
| `resume-executif.tex` | résumé exécutif de 2 pages pour la direction marketing |
| `references.bib` | références citées |
| `figures/` | graphique principal du résumé exécutif |
