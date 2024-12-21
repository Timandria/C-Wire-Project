# C-Wire-Project

# Projet C-Wire

Ce projet a été développé pour analyser et synthétiser les données d'un système de distribution d'électricité. Il utilise un fichier CSV massif contenant des informations sur la production et la consommation d'énergie, filtrées et traitées grâce à un script Shell et un programme en langage C.

## Fonctionnalités principales

1. **Filtrage des données** :
   - Utilisation d'un script Shell (`c-wire.sh`) pour extraire les données pertinentes en fonction des paramètres d'entrée.

2. **Calculs et traitements** :
   - Implémentation d'un arbre AVL dans un programme en C (`cwire.c` et `avl_tree.c`) pour stocker et analyser les données efficacement.

3. **Exportation des résultats** :
   - Les résultats sont enregistrés dans des fichiers CSV triés par capacité croissante.
   - Génération de graphiques pour les postes LV lorsque l'option `lv all` est utilisée.

## Organisation du dépôt

```plaintext
C-Wire-Project/
├── README.md            # Documentation du projet
├── input/               # Fichier de données d'entrée
│   └── data.csv
├── codeC/               # Code source en C
│   ├── cwire.c          # Programme principal
│   ├── avl_tree.c       # Gestion des arbres AVL
│   ├── avl_tree.h       # Header pour les fonctions AVL
│   └── Makefile         # Fichier pour la compilation
├── graphs/              # Graphiques générés
├── tmp/                 # Fichiers temporaires
├── tests/               # Fichiers de résultats de tests
│   ├── lv_indiv.csv     # Résultats pour les particuliers
│   ├── lv_all.csv       # Résultats pour tous les consommateurs
│   ├── lv_comp.csv      # Résultats pour les entreprises
│   └── lv_all_minmax.png # Graphique des postes les plus/moins chargés
└── c-wire.sh            # Script Shell principal
```

## Prérequis

- **Système d'exploitation** : Linux ou tout environnement compatible Bash.
- **Logiciels nécessaires** :
  - Bash
  - `gcc` pour compiler le programme C.
  - `gnuplot` pour générer des graphiques (optionnel).

## Instructions d'utilisation

### 1. Compilation
Accédez au dossier `codeC` et exécutez la commande suivante pour compiler le programme :
```bash
make
```
Cela génère un exécutable nommé `cwire`.

### 2. Exécution
Le script principal `c-wire.sh` permet de lancer le traitement des données. Voici quelques exemples :

- **Analyser les stations HV-B pour les entreprises** :
  ```bash
  ./c-wire.sh input/data.csv hvb comp
  ```

- **Analyser les postes LV pour tous les consommateurs** :
  ```bash
  ./c-wire.sh input/data.csv lv all
  ```

- **Inclure un filtre par identifiant de centrale** :
  ```bash
  ./c-wire.sh input/data.csv hva comp 2
  ```

### 3. Nettoyage
Pour supprimer les fichiers compilés, exécutez :
```bash
make clean
```

## Détails de développement

Le projet a été développé progressivement pour garantir une bonne qualité de code :

### Étape 1 : Initialisation du dépôt
- Mise en place de la structure initiale (répertoires `codeC`, `tests`, `tmp`).
- Écriture d'un premier prototype de `c-wire.sh` pour la gestion des paramètres.

### Étape 2 : Implémentation de l'arbre AVL
- Création des fichiers `avl_tree.c` et `avl_tree.h` pour gérer les structures AVL.
- Tests initiaux sur des ensembles de données réduits.

### Étape 3 : Intégration et filtrage des données
- Amélioration du script Shell pour filtrer les données en fonction des paramètres utilisateur.
- Liaison avec le programme C pour effectuer les calculs sur les données filtrées.

### Étape 4 : Génération des graphiques
- Utilisation de `gnuplot` pour créer un graphique des 10 postes LV les plus et les moins chargés.

### Étape 5 : Tests finaux et optimisation
- Test du projet avec le fichier complet `data.csv`.
- Résolution des problèmes de performance et gestion de la mémoire.

## Résultats et exemples
Les résultats sont générés dans le dossier `tests/` sous forme de fichiers CSV et de graphiques.

- Exemple de fichier CSV : `lv_all.csv` contient les postes LV analysés pour tous les consommateurs.
- Exemple de graphique :

![Graphique](graphs/lv_all_minmax.png)

## Limitations
- Le fichier de données d'entrée doit être bien formé et respecter le format attendu.
- La génération des graphiques est uniquement disponible pour l'option `lv all`.

## Auteur
Développé par [Votre Nom].

---
Ce dépôt a été régulièrement mis à jour pour refléter l'avancement du projet et garantir sa complétion avant la date limite.
