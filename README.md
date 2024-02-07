# Projet Projet_oracle_banque

## Description
Le projet "Projet_oracle_banque" est une application Python conçue pour effectuer des analyses sur des données financières stockées dans une base de données Oracle. L'application utilise l'interface graphique Tkinter pour fournir une interface utilisateur conviviale pour exécuter des requêtes SQL prédéfinies et afficher les résultats sous forme de tableaux et de graphiques.

- **dwh_py_menu.py** crée une interface utilisateur graphique simple à l'aide de Tkinter, qui permet à l'utilisateur d'exécuter des requêtes SQL sur une base de données Oracle et d'afficher les résultats dans la même interface graphique.
- **DWH-BANQUE.sql** est un script SQL utilisé pour créer un schéma de base de données, peupler les tables avec des données de référence et principales, et effectuer quelques requêtes d'analyse sur les données bancaires.
- **queries.py** contient des requêtes SQL prédéfinies pour récupérer des informations spécifiques à partir de la base de données, telles que la plus grosse catégorie de dépenses, la plus grosse sous-catégorie de revenus et l'évolution du solde client. Ces requêtes sont utilisées dans le programme principal pour interagir avec la base de données et afficher les résultats dans l'interface utilisateur.
- **balance-2020.csv** contient les valeurs à insérer dans la bdd.

## Fonctionnalités
- Affichage de la plus grosse catégorie de dépense.
- Affichage de la plus grosse sous-catégorie de revenu.
- Affichage de l'évolution du solde client à travers le temps.

## Prérequis
- Python 3.x
- Oracle Database
- Bibliothèques Python :
    - tkinter
    - oracledb
    - matplotlib

## Installation
1. Clonez ce dépôt sur votre machine locale.
2. Assurez-vous d'avoir Python 3.x installé sur votre système.
3. Installez les bibliothèques Python requises avec pip.

## Utilisation
1. Exécutez le fichier `dwh_py_menu.py` pour lancer l'application.
2. Utilisez l'interface graphique pour sélectionner l'analyse financière souhaitée.
3. Visualisez les résultats dans les tableaux et les graphiques affichés.

