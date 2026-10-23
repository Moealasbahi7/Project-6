# Fonctions du projet 6 : structure du marché du whisky écossais
#
# Chargées au début de rapport.qmd avec source("R/fonctions.R").

# Charge le jeu de données principal du projet n° `projet` (1 à 7).
charger_donnees <- function(projet) {
  verifier_package <- function(package) {
    if (!requireNamespace(package, quietly = TRUE)) {
      stop("Installer d'abord le package ", package, " : install.packages(\"",
           package, "\")", call. = FALSE)
    }
  }
  charger <- function(nom, package) {
    verifier_package(package)
    environnement <- new.env()
    utils::data(list = nom, package = package, envir = environnement)
    environnement[[nom]]
  }

  switch(as.character(projet),
    "1" = charger("marketing", "datarium"),
    "2" = charger("customerSat", "bayesm"),
    "3" = charger("Caravan", "ISLR"),
    "4" = charger("Carseats", "ISLR"),
    "5" = lire_boutique_commandes(),
    "6" = charger("Scotch", "bayesm"),            # positionnement des marques
    "7" = charger("OJ", "ISLR"),
    stop("Numéro de projet inconnu : ", projet, " (attendu : 1 à 7)", call. = FALSE)
  )
}

# Projet 5 : fichiers CSV de la boutique (non utilisés dans le projet 6).
lire_boutique <- function(table) {
  chemin <- file.path("donnees", paste0("boutique_", table, ".csv"))
  if (!file.exists(chemin)) {
    stop("Fichier introuvable : ", chemin, " (voir donnees/README.md)", call. = FALSE)
  }
  utils::read.csv(chemin, fileEncoding = "UTF-8")
}

lire_boutique_commandes <- function() {
  commandes <- lire_boutique("commandes")
  clients <- lire_boutique("clients")
  commandes$date <- as.Date(commandes$date)
  clients$date_inscription <- as.Date(clients$date_inscription)
  merge(commandes, clients, by = "client_id", all.x = TRUE)
}

# Racine de l'erreur quadratique moyenne (projets de prédiction).
rmse <- function(observe, predit) {
  sqrt(mean((observe - predit)^2, na.rm = TRUE))
}

# Met les données en matrice numérique consommateurs x marques (0/1).
matrice_achats <- function(donnees) {
  X <- as.matrix(sapply(as.data.frame(donnees), as.numeric))
  colnames(X) <- names(donnees)
  if (any(!(X %in% c(0, 1)))) {
    stop("Les données doivent ne contenir que des 0 et des 1 (ou des valeurs manquantes à traiter)", call. = FALSE)
  }
  X
}

# Indice de lift : P(A et B) / (P(A) x P(B)). Au-dessus de 1, co-achat plus fréquent que par hasard.
indice_lift <- function(X) {
  p <- colMeans(X)
  lift <- (crossprod(X) / nrow(X)) / outer(p, p)
  diag(lift) <- NA
  lift
}

# Indice de Rand ajusté (ARI) : concordance entre deux partitions, 1 = identiques, 0 = hasard.
ari <- function(a, b) {
  tab <- table(a, b)
  n <- sum(tab)
  paires <- function(x) sum(choose(x, 2))
  somme_lignes <- paires(rowSums(tab))
  somme_colonnes <- paires(colSums(tab))
  total <- paires(tab)
  attendu <- somme_lignes * somme_colonnes / choose(n, 2)
  maximum <- (somme_lignes + somme_colonnes) / 2
  (total - attendu) / (maximum - attendu)
}

# Format français des nombres : 2 218, 45,3
fr <- function(x, digits = 1) {
  format(round(x, digits), nsmall = digits, decimal.mark = ",", big.mark = " ", trim = TRUE)
}
