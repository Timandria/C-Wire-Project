#!/bin/bash

# Script Shell pour le projet C-Wire

# Fonction d'aide
afficher_aide() {
    echo "Utilisation : $0 <chemin_du_fichier_csv> <type_station> <type_consommateur> [identifiant_centrale]"
    echo "\nParamètres :"
    echo "  <chemin_du_fichier_csv> : Chemin vers le fichier CSV d'entrée."
    echo "  <type_station>          : Type de station à traiter (hvb, hva, lv)."
    echo "  <type_consommateur>     : Type de consommateur (comp, indiv, all)."
    echo "  [identifiant_centrale]  : (Optionnel) Identifiant de la centrale."
    echo "\nOptions spéciales :"
    echo "  -h : Affiche cette aide."
    exit 0
}

# Vérification des paramètres
if [ "$1" == "-h" ] || [ $# -lt 3 ]; then
    afficher_aide
fi

CSV_FILE=$1
STATION_TYPE=$2
CONSUMER_TYPE=$3
CENTRAL_ID=${4:-""}

# Vérifications initiales
if [ ! -f "$CSV_FILE" ]; then
    echo "Erreur : Le fichier CSV spécifié n'existe pas."
    exit 1
fi

case "$STATION_TYPE" in
    hvb|hva|lv) ;;
    *)
        echo "Erreur : Type de station invalide (hvb, hva, lv uniquement)."
        afficher_aide
        ;;
esac

case "$CONSUMER_TYPE" in
    comp|indiv|all) ;;
    *)
        echo "Erreur : Type de consommateur invalide (comp, indiv, all uniquement)."
        afficher_aide
        ;;
esac

if [[ "$STATION_TYPE" == "hvb" && "$CONSUMER_TYPE" != "comp" ]] || \
   [[ "$STATION_TYPE" == "hva" && "$CONSUMER_TYPE" != "comp" ]]; then
    echo "Erreur : Les options hvb indiv/all et hva indiv/all sont interdites."
    afficher_aide
fi

# Vérification et compilation du programme C
EXECUTABLE="./codeC/cwire"
MAKEFILE="./codeC/Makefile"

if [ ! -f "$EXECUTABLE" ]; then
    echo "Compilation du programme C..."
    if [ ! -f "$MAKEFILE" ]; then
        echo "Erreur : Makefile non trouvé dans ./codeC."
        exit 1
    fi
    make -C ./codeC
    if [ $? -ne 0 ]; then
        echo "Erreur : La compilation a échoué."
        exit 1
    fi
fi

# Création des dossiers nécessaires
mkdir -p tmp graphs tests
rm -rf tmp/*

# Lancement du traitement
echo "Filtrage des données..."
FILTERED_FILE="tmp/filtered_data.csv"
awk -F';' -v station="$STATION_TYPE" -v consumer="$CONSUMER_TYPE" -v central="$CENTRAL_ID" '
BEGIN { OFS=":"; }
{
    if (station == "hvb" && consumer == "comp" && $1 != "" && $2 != "") print $1, $2, $7, $8;
    else if (station == "hva" && consumer == "comp" && $2 != "" && $3 != "") print $2, $3, $7, $8;
    else if (station == "lv" && consumer == "all" && $3 != "" && $4 != "") print $3, $4, $7, $8;
    else if (station == "lv" && consumer == "comp" && $3 != "" && $5 != "") print $3, $5, $7, $8;
    else if (station == "lv" && consumer == "indiv" && $3 != "" && $6 != "") print $3, $6, $7, $8;
}' "$CSV_FILE" > "$FILTERED_FILE"

if [ $? -ne 0 ]; then
    echo "Erreur lors du filtrage des données."
    exit 1
fi

echo "Exécution du programme C..."
RESULTS_FILE="tests/results_${STATION_TYPE}_${CONSUMER_TYPE}.csv"
$EXECUTABLE "$FILTERED_FILE" "$RESULTS_FILE"

if [ $? -ne 0 ]; then
    echo "Erreur : Le programme C a rencontré un problème."
    exit 1
fi

# Génération des graphiques pour lv all uniquement
if [[ "$STATION_TYPE" == "lv" && "$CONSUMER_TYPE" == "all" ]]; then
    echo "Création des graphiques avec GnuPlot..."
    GNUPLOT_SCRIPT="graphs/lv_all_minmax.gnuplot"
    cat <<EOF > "$GNUPLOT_SCRIPT"
set terminal png size 1024,768
set output 'graphs/lv_all_minmax.png'
set style data histograms
set style fill solid
set title "Postes LV avec les plus et moins de consommation"
set xlabel "Postes LV"
set ylabel "Consommation (kWh)"
plot "$RESULTS_FILE" using 2:xtic(1) title 'Consommation' linecolor rgb "blue"
EOF
    gnuplot "$GNUPLOT_SCRIPT"
    if [ $? -ne 0 ]; then
        echo "Erreur : Impossible de créer les graphiques."
        exit 1
    fi
fi

# Affichage du résultat final
echo "Traitement terminé. Les résultats sont dans : $RESULTS_FILE"
