# Projet n° 6 — Structure du marché du whisky écossais

**Data Science sous R — ESME, 2026–2027 — Groupe 1**
Moé Al-Asbahi · Aymeric Bonnans · Victor Premat · Mélissa Treso

## Question

Un distributeur de spiritueux veut savoir quelles marques de whisky écossais référencer,
placer ensemble en rayon et associer en promotion :

1. Quelle est la pénétration de chaque marque ?
2. Quelles marques sont consommées ensemble ?
3. Peut-on représenter les marques sur une carte du marché ?
4. Existe-t-il des groupes de consommateurs aux répertoires de marques distincts ?

## Données

`Scotch` du package `bayesm` : 2 218 consommateurs réels (enquête Simmons), 21 marques,
codées 1 si la marque a été achetée dans l'année, 0 sinon.

## Reproduire l'analyse

1. Ouvrir `projet-6.Rproj` dans RStudio (le répertoire de travail est alors le dossier du projet).
2. Installer les packages :
   ```r
   install.packages(c("tidyverse", "knitr", "rmarkdown", "bayesm",
                      "FactoMineR", "factoextra", "cluster"))
   ```
3. Ouvrir `rapport.qmd` puis cliquer sur **Render**. Le rapport HTML autonome est produit
   dans le dossier du projet. Les chemins sont relatifs et la graine aléatoire est fixée
   (`set.seed(2026)`).
4. Les graphiques du résumé exécutif sont exportés automatiquement dans `figures/` pendant le rendu.
5. Pour le résumé exécutif, ouvrir `resume-executif.tex` et le compiler avec pdfLaTeX
   (bouton **Compile PDF**, ou Overleaf).

## Méthodes

- **Exploration** : pénétration, fidélité (taux d'exclusivité), corrélations et lift entre marques
- **Carte du marché** : ACP normée (`FactoMineR::PCA`), nombre de marques achetées en variable illustrative
- **Familles de marques** : CAH de Ward sur les marques
- **Segmentation des consommateurs** : HCPC (CAH de Ward consolidée par les k-moyennes),
  choix du nombre de segments par silhouette et méthode du coude
- **Évaluation** : échantillon test (70 % / 30 %) comparé à une règle simple,
  stabilité selon la graine, la méthode et le nombre de segments (indice de Rand ajusté, Jaccard)

## Principaux résultats

- Marché concentré : Chivas Regal touche 36 % des consommateurs ; 12 marques sur 21 sont sous les 6 %.
- 47 % des consommateurs n'achètent qu'une seule marque.
- Quatre familles de marques : blends leaders, blends standard, single malts, blends économiques.
- Six segments de consommateurs ; seul celui des gros acheteurs multi-marques (7 %) est très stable.

## Contenu

| Fichier | Rôle |
|:--------|:-----|
| `rapport.qmd` | rapport technique (code, exploration, modélisation, évaluation) |
| `R/fonctions.R` | chargement des données et fonctions (matrice d'achats, lift, ARI, segmentation, stabilité, format français) |
| `resume-executif.tex` / `.pdf` | résumé exécutif de 2 pages pour la direction marketing |
| `references.bib` | références citées |
| `figures/` | graphiques du résumé exécutif (`figure-cle.pdf` : carte du marché ; `segments.pdf` : profils des segments) |
| `presentation.pdf` | support de la présentation orale |
