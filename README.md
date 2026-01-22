# passGen

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)

[![License GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Bash](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)](https://www.gnu.org/software/bash/)

Générateur de mots de passe aléatoires sécurisés en ligne de commande avec interface interactive.

## Table des matières

- [Fonctionnalités](#-fonctionnalités)
- [Prérequis](#-prérequis)
- [Installation](#-installation)
- [Utilisation](#-utilisation)
  - [Mode interactif](#mode-interactif)
  - [Ligne de commande](#ligne-de-commande)
- [Types de caractères](#-types-de-caractères)
- [Exemples](#-exemples)
- [Captures d'écran](#-captures-décran)
- [Sécurité](#-sécurité)
- [Contribution](#-contribution)
- [Licence](#-licence)

## Fonctionnalités

- **Interface interactive** avec navigation au clavier
- **Génération rapide** en ligne de commande
- **Source aléatoire sécurisée** (`/dev/urandom`)
- **Personnalisation complète** du type de caractères
- **Longueur configurable** (4 à 128 caractères)
- **Interface utilisateur claire** avec menus déroulants
- **Documentation intégrée** avec l'option `-h`

## Prérequis

- Bash 4.0 ou supérieur
- Système Unix/Linux ou macOS
- Commandes système : `tr`, `head`, `tput`

## Installation

### Installation rapide

```bash
# Cloner le dépôt
git clone https://github.com/DavidLM-ux/passGen.git

# Se déplacer dans le répertoire
cd passGen

# Rendre le script exécutable
chmod +x passGen

# (Optionnel) Copier dans un répertoire du PATH
sudo cp passGen /usr/local/bin/
```

### Installation manuelle

1. Télécharger le script `passGen`
2. Le rendre exécutable : `chmod +x passGen`
3. Le placer dans un répertoire de votre `PATH` (ex: `/usr/local/bin/`)

## Utilisation

### Mode interactif

Lancez simplement le script sans arguments pour accéder au menu interactif :

```bash
./passGen
```

Le menu vous permettra de :

1. Définir le nombre de caractères souhaité
2. Choisir le type de caractères
3. Générer le mot de passe
4. Quitter l'application

### Ligne de commande

Générez directement un mot de passe avec des options :

```bash
passGen [OPTIONS]
```

#### Options disponibles

| Option | Description | Valeur par défaut |
| --- | --- | --- |
| `-n NUMBER` | Nombre de caractères (4-128) | 12  |
| `-t TYPE` | Type de caractères | all |
| `-h` | Afficher l'aide | -   |

## Types de caractères

| Type | Description | Exemple |
| --- | --- | --- |
| `all` | Tous les caractères imprimables | `aZ3!@#$` |
| `alnum` ou `alphanum` | Lettres et chiffres | `aZ3bY7` |
| `alpha` | Lettres uniquement (majuscules et minuscules) | `aZbYcX` |
| `digit` | Chiffres uniquement | `123456` |
| `lower` | Lettres minuscules uniquement | `abcdef` |
| `upper` | Lettres majuscules uniquement | `ABCDEF` |
| `punct` | Symboles de ponctuation | `!@#$%^` |

## Exemples

### Génération basique

```bash
# Mot de passe par défaut (12 caractères, tous types)
passGen
```

### Mot de passe alphanumérique

```bash
# 16 caractères alphanumériques
passGen -n 16 -t alnum
```

### Code PIN

```bash
# Code PIN de 6 chiffres
passGen -n 6 -t digit
```

### Mot de passe complexe

```bash
# 24 caractères avec tous les types
passGen -n 24 -t all
```

### Mot de passe pour systèmes anciens

```bash
# 12 caractères sans symboles spéciaux
passGen -n 12 -t alnum
```

### Génération de plusieurs mots de passe

```bash
# Générer 5 mots de passe de 16 caractères
for i in {1..5}; do passGen -n 16 -t alnum; done
```

## Captures d'écran

```
======================================
    GÉNÉRATEUR DE MOT DE PASSE
======================================

Configuration actuelle:
  - Longueur: 12 caractères
  - Type: all

Sélectionnez une option:
- Change option: [up/down], Select: [ENTER] 
 Définir le nombre de caractères 
 Choisir le type de caractères 
 Générer le mot de passe 
 Quitter
```

## Sécurité

### Source d'aléa

passGen utilise `/dev/urandom` comme source d'entropie, ce qui garantit une génération cryptographiquement sécurisée des mots de passe.

### Bonnes pratiques

- Utilisez au minimum 12 caractères pour un usage général
- Utilisez au minimum 16 caractères pour des données sensibles
- Privilégiez le type `all` pour une sécurité maximale
- Ne réutilisez jamais le même mot de passe
- Utilisez un gestionnaire de mots de passe

### Recommandations par type d'utilisation

| Usage | Longueur recommandée | Type recommandé |
| --- | --- | --- |
| Compte web standard | 16-20 caractères | `alnum` ou `all` |
| Compte bancaire | 20-24 caractères | `all` |
| Compte email principal | 20-24 caractères | `all` |
| Wi-Fi | 20-24 caractères | `all` |
| Base de données | 24-32 caractères | `all` |
| Code PIN | 6-8 caractères | `digit` |

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

1. Fork le projet
2. Créer une branche pour votre fonctionnalité (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Idées de contributions

- [ ] Ajouter plus de types de caractères personnalisés
- [ ] Implémenter la génération de phrases de passe (passphrases)
- [ ] Ajouter une option pour exclure certains caractères ambigus (0, O, l, 1)
- [ ] Créer une option pour copier automatiquement dans le presse-papiers
- [ ] Ajouter une évaluation de la force du mot de passe
- [ ] Support de la configuration via fichier `.passGenrc`

## Licence

Ce projet est sous licence GNU General Public License v3.0. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

```
passGen - Générateur de mots de passe aléatoires
Copyright (C) 2026

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```

## Auteur

**DavidLM-ux**

- GitHub: [@DavidLM-ux](https://github.com/DavidLM-ux)

## Support

Pour toute question ou problème :

- Ouvrir une [issue](https://github.com/DavidLM-ux/PassGen/issues)
- Contact : [lemeur.david@proton.me](mailto:lemeur.david@proton.me)

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :

- Signaler des bugs
- Proposer des améliorations
- Ajouter de nouvelles fonctionnalités
