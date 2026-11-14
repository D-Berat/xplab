# Explorer la documentation XPLab

Le projet se lit à deux niveaux : les synthèses expliquent les principaux choix, et les rapports donnent accès au détail des spécifications et de la modélisation.

## Vue d'ensemble

- [Présentation du projet et de ma contribution](../README.md)
- [Synthèse du cahier des charges](cahier-des-charges.md)
- [Choix de conception de la base](base-de-donnees.md)
- [Exécution des scripts](execution.md)

## Cahier des charges

**[Ouvrir le cahier des charges complet (PDF, 127 pages)](rapports/cahier-des-charges.pdf)**

| Pour explorer… | Pages du PDF |
| --- | --- |
| Le contexte, les objectifs et les critères d'acceptation | 5 à 17 |
| Les scénarios des six profils | 18 à 19 |
| Les interfaces et l'architecture du système | 20 à 40 |
| Les spécifications fonctionnelles détaillées | 41 à 88 |
| Les parcours de navigation | 89 à 95 |
| Le diagramme de classes métier | 96 |
| Les maquettes et le prototype Figma | 97 à 110 |
| La planification, les charges et les risques | 111 à 119 |
| Le cadrage QQOQCP, les échanges avec le client et le glossaire | 120 à 127 |

Les repères ci-dessus correspondent aux pages réelles du fichier. Les signets du PDF permettent de naviguer dans les grandes parties après ouverture dans un lecteur PDF.

Les maquettes et la planification font partie du travail collectif. Le [fichier Figma](https://www.figma.com/design/3NTrWKLUQh5znYPqcO1f5m/Maquette-Sae2.03?node-id=0-1) est également référencé dans le rapport ; ses droits d'accès dépendent du partage défini par son propriétaire. Les captures restent consultables dans le PDF.

## Conception de la base de données

**[Ouvrir le dossier BDD complet (PDF, 17 pages)](rapports/conception-bdd.pdf)**

| Pour explorer… | Pages du PDF |
| --- | --- |
| Le périmètre et les 32 règles de gestion | 3 à 5 |
| Le dictionnaire des données | 5 à 10 |
| Les dépendances fonctionnelles et leurs graphes | 10 à 13 |
| Le modèle conceptuel (MCD) | 14 |
| Le modèle logique (MLD) | 15 |
| Les commandes par rôle et les contrôles | 16 à 17 |

Les schémas sont aussi disponibles séparément pour être agrandis : [MCD](images/xplab-mcd.webp) et [MLD](images/xplab-mld.webp).

## Du modèle aux scripts

| Étape | SQL Server | MySQL / MariaDB |
| --- | --- | --- |
| Tables et contraintes | [Création](../sql/sqlserver/01-creation.sql) | [Création](../sql/mysql/01-creation.sql) |
| Données de démonstration | [Insertion](../sql/sqlserver/02-donnees.sql) | [Insertion](../sql/mysql/02-donnees.sql) |
| Consultations et opérations métier | [Exploitation](../sql/sqlserver/03-exploitation.sql) | [Exploitation](../sql/mysql/03-exploitation.sql) |

Les six scripts conservent le contenu des livrables. Les données sont fictives. Les règles portant sur le consentement, les droits et la traçabilité décrivent le comportement attendu du système ; elles ne constituent pas à elles seules une garantie de conformité de l'application future.

## Appui à la réalisation

L'IA a été utilisée pour relire les modèles et les scripts, préparer des exemples et discuter la logique de certaines requêtes d'exploitation. Cet usage est déclaré dans le dossier de travail du projet.
