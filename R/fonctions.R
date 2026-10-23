
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
    "6" = charger("Scotch", "bayesm"),            
    "7" = charger("OJ", "ISLR"),
    stop("Numéro de projet inconnu : ", projet, " (attendu : 1 à 7)", call. = FALSE)
  )
}

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

rmse <- function(observe, predit) {
  sqrt(mean((observe - predit)^2, na.rm = TRUE))
}

matrice_achats <- function(donnees) {
  X <- as.matrix(sapply(as.data.frame(donnees), as.numeric))
  colnames(X) <- names(donnees)
  if (any(!(X %in% c(0, 1)))) {
    stop("Les données doivent ne contenir que des 0 et des 1 (ou des valeurs manquantes à traiter)", call. = FALSE)
  }
  X
}

indice_lift <- function(X) {
  p <- colMeans(X)
  lift <- (crossprod(X) / nrow(X)) / outer(p, p)
  diag(lift) <- NA
  lift
}

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

fr <- function(x, digits = 1) {
  format(round(x, digits), nsmall = digits, decimal.mark = ",", big.mark = " ", trim = TRUE)
}
