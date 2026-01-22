#!/bin/bash

##################################################################################
# passGen                                                                        #
# Utilisation: Générateur de mot de passe aléatoire                              #
# Usage: ./passGen -n NUMBER -t TYPE  OU ./passGen (Mode interactif)             #
# Auteur: DavidLM-ux <lemeur.david@proton.me>                                    #
# Version: V1.0                                                                  #
# Licence: GPL                                                                   #
##################################################################################

# Variables globales
PASSWORD_LENGTH=12
CHAR_TYPE="all"

# Définition des types de caractères
get_char_set() {
    case $1 in
        "alpha")
            echo "[:alpha:]"
            ;;
        "alnum")
            echo "[:alnum:]"
            ;;
        "digit")
            echo "[:digit:]"
            ;;
        "lower")
            echo "[:lower:]"
            ;;
        "upper")
            echo "[:upper:]"
            ;;
        "punct")
            echo "[:punct:]"
            ;;
        "all"|"print")
            echo "[:print:]"
            ;;
        "alphanum")
            echo "[:alnum:]"
            ;;
        *)
            echo "[:print:]"
            ;;
    esac
}

# Fonction de génération du mot de passe
generate_password() {
    local length=$1
    local type=$2
    local charset=$(get_char_set "$type")
    
    local password=$(tr -dc "$charset" < /dev/urandom | head -c"$length")
    echo "$password"
}

# Menu d'aide
show_help() {
    cat << EOF
Usage: passGen [OPTIONS]

Générateur de mot de passe aléatoire

OPTIONS:
    -n NUMBER    Nombre de caractères (défaut: 12)
    -t TYPE      Type de caractères (défaut: all)
    -h           Afficher ce menu d'aide

TYPES DE CARACTÈRES:
    all          Tous les caractères imprimables (défaut)
    alpha        Lettres uniquement (a-z, A-Z)
    alnum        Lettres et chiffres
    digit        Chiffres uniquement (0-9)
    lower        Lettres minuscules uniquement
    upper        Lettres majuscules uniquement
    punct        Symboles de ponctuation
    alphanum     Alias pour alnum

EXEMPLES:
    passGen                    # Mode interactif
    passGen -n 16 -t alnum     # Génère un mot de passe de 16 caractères alphanumériques
    passGen -n 8 -t digit      # Génère un code PIN de 8 chiffres
    passGen -h                 # Affiche l'aide

EOF
}


inputChoice() {
    local prompt="${1}"; shift
    echo "${prompt}"
    echo "$(tput dim)""- Change option: [up/down], Select: [ENTER]" "$(tput sgr0)"
    
    local selected=0
    local options=("$@")

    ESC=$(echo -e "\033")
    cursor_blink_on()  { tput cnorm; }
    cursor_blink_off() { tput civis; }
    cursor_to()        { tput cup $(($1-1)); }
    print_option()     { echo "$(tput sgr0)" "$1" "$(tput sgr0)"; }
    print_selected()   { echo "$(tput rev)" "$1" "$(tput sgr0)"; }
    get_cursor_row()   { IFS=';' read -rsdR -p $'\E[6n' ROW COL; echo "${ROW#*[}"; }
    key_input()        { read -rs -n3 key 2>/dev/null >&2; [[ $key = ${ESC}[A ]] && echo up; [[ $key = ${ESC}[B ]] && echo down; [[ $key = "" ]] && echo enter; }

    # Afficher les lignes vides pour chaque option
    for opt in "${options[@]}"; do echo; done

    local lastrow
    lastrow=$(get_cursor_row)
    local startrow=$((lastrow - ${#options[@]}))
    trap "cursor_blink_on; echo; echo; exit" 2
    cursor_blink_off

    while true; do
        local idx=0
        for opt in "${options[@]}"; do
            cursor_to $((startrow + idx))
            if [ ${idx} -eq ${selected} ]; then
                print_selected "${opt}"
            else
                print_option "${opt}"
            fi
            ((idx++))
        done

        case $(key_input) in
            enter) break;;
            up)    ((selected--)); [ ${selected} -lt 0 ] && selected=$((${#options[@]} - 1));;
            down)  ((selected++)); [ ${selected} -ge ${#options[@]} ] && selected=0;;
        esac
    done

    cursor_to "${lastrow}"
    cursor_blink_on
    echo

    return ${selected}
}


# Menu interactif avec inputChoice
interactive_menu() {
    while true; do
        clear
        echo "======================================"
        echo "    GÉNÉRATEUR DE MOT DE PASSE"
        echo "======================================"
        echo ""
        echo "Configuration actuelle:"
        echo "  - Longueur: $PASSWORD_LENGTH caractères"
        echo "  - Type: $CHAR_TYPE"
        echo ""
        
        choices=("Définir le nombre de caractères" "Choisir le type de caractères" "Générer le mot de passe" "Quitter")
        inputChoice "Sélectionnez une option:" "${choices[@]}"
        choice=$?
        
        case $choice in
            0)  # Nombre de caractères
                echo ""
                read -p "Entrez le nombre de caractères souhaité (4-128): " num
                if [[ "$num" =~ ^[0-9]+$ ]] && [ "$num" -ge 4 ] && [ "$num" -le 128 ]; then
                    PASSWORD_LENGTH=$num
                    echo "Longueur définie à $PASSWORD_LENGTH caractères"
                else
                    echo "Valeur invalide. La longueur doit être entre 4 et 128."
                fi
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            1)  # Type de caractères
                echo ""
                type_choices=("Tous les caractères (all)" "Lettres et chiffres (alnum)" "Lettres uniquement (alpha)" "Chiffres uniquement (digit)" "Minuscules (lower)" "Majuscules (upper)" "Symboles (punct)" "Retour")
                inputChoice "Choisissez le type de caractères:" "${type_choices[@]}"
                type_choice=$?
                
                case $type_choice in
                    0) CHAR_TYPE="all" ;;
                    1) CHAR_TYPE="alnum" ;;
                    2) CHAR_TYPE="alpha" ;;
                    3) CHAR_TYPE="digit" ;;
                    4) CHAR_TYPE="lower" ;;
                    5) CHAR_TYPE="upper" ;;
                    6) CHAR_TYPE="punct" ;;
                    7) continue ;;
                esac
                echo "Type de caractères défini: $CHAR_TYPE"
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            2)  # Générer
                echo ""
                echo "Génération du mot de passe..."
                password=$(generate_password "$PASSWORD_LENGTH" "$CHAR_TYPE")
                echo ""
                echo "======================================"
                echo "Mot de passe généré:"
                echo ""
                echo "    $password"
                echo ""
                echo "======================================"
                echo ""
                read -p "Appuyez sur Entrée pour continuer..."
                ;;
            3)  # Quitter
                echo "Au revoir!"
                echo ""
                exit 0
                ;;
        esac
    done
}


# Programme principal
main() {
    # Si aucun argument, lancer le menu interactif
    if [ $# -eq 0 ]; then
        interactive_menu
        exit 0
    fi
    
    # Traitement des arguments en ligne de commande
    while getopts "n:t:h" opt; do
        case $opt in
            n)
                if [[ "$OPTARG" =~ ^[0-9]+$ ]] && [ "$OPTARG" -ge 8 ] && [ "$OPTARG" -le 128 ]; then
                    PASSWORD_LENGTH=$OPTARG
                else
                    echo "Erreur: La longueur doit être un nombre entre 8 et 128"
                    exit 1
                fi
                ;;
            t)
                CHAR_TYPE=$OPTARG
                ;;
            h)
                show_help
                exit 0
                ;;
            \?)
                echo "Option invalide: -$OPTARG" >&2
                echo "Utilisez -h pour l'aide"
                exit 1
                ;;
        esac
    done
    
    # Génération directe du mot de passe
    password=$(generate_password "$PASSWORD_LENGTH" "$CHAR_TYPE")
    echo "$password"
}

# Lancement du programme
main "$@"