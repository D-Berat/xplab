# Exécuter les scripts XPLab

## Environnements

| Version du dépôt | Environnement utilisé pour les essais du projet | Outil de lancement |
| --- | --- | --- |
| `sql/sqlserver` | SQL Server Express 2022 | SQL Server Management Studio (SSMS) |
| `sql/mysql` | MariaDB 10.4.32 portable | Client en ligne de commande acceptant `DELIMITER` |

Le dossier `mysql` contient l'adaptation demandée pour MySQL / XAMPP. Les essais retrouvés ont été effectués sur **MariaDB 10.4.32**, pas sur un serveur Oracle MySQL. Pour MySQL, prévoir au minimum **8.0.16**, version à partir de laquelle les contraintes `CHECK` sont appliquées : [documentation MySQL](https://dev.mysql.com/doc/refman/8.0/en/create-table-check-constraints.html). Ce minimum ne constitue pas une validation sur toutes les versions suivantes.

Les deux dossiers proposent le même modèle métier. Choisir une seule version : leurs syntaxes ne sont pas interchangeables.

## Préparer la base

**Le premier script supprime la base `XPLab_SAE3` si elle existe, puis la recrée.** Utiliser une instance de développement sans données à conserver sous ce nom.

Le compte de connexion doit pouvoir créer une base, des tables, des vues et des procédures. Les lignes de la table `Utilisateur` sont des personnes fictives du jeu de démonstration, pas des comptes de connexion au serveur.

Exécuter les fichiers dans cet ordre :

1. `01-creation.sql` : base, tables, clés et contraintes.
2. `02-donnees.sql` : données de démonstration.
3. `03-exploitation.sql` : vues, procédures, consultations et exemples d'appels.

### SQL Server

Se connecter à l'instance dans SSMS. Ouvrir et exécuter successivement les trois fichiers de `sql/sqlserver`, en conservant les séparateurs `GO`.

Pour identifier la version du serveur :

```sql
SELECT @@VERSION;
```

### MySQL / MariaDB

Ouvrir le client `mysql` avec son propre compte de développement, puis utiliser les chemins absolus adaptés à sa copie. Les commandes `SOURCE` ci-dessous sont destinées à ce client :

```sql
SELECT VERSION();
SOURCE C:/chemin/vers/xplab/sql/mysql/01-creation.sql;
SOURCE C:/chemin/vers/xplab/sql/mysql/02-donnees.sql;
SOURCE C:/chemin/vers/xplab/sql/mysql/03-exploitation.sql;
```

Conserver les directives `DELIMITER` du troisième fichier. Sur un autre système, remplacer les chemins par ceux de la copie locale.

## Premières consultations

Après le chargement, ces consultations fonctionnent dans les deux versions :

```sql
USE XPLab_SAE3;

SELECT * FROM vue_etudes_candidatures;
SELECT * FROM vue_bilan_experimentations;
SELECT * FROM vue_planning_salles;
```

Pour vérifier le nombre de tables, utiliser la requête adaptée au moteur :

**SQL Server :**

```sql
SELECT COUNT(*) AS nombre_tables
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_CATALOG = 'XPLab_SAE3'
  AND TABLE_TYPE = 'BASE TABLE';
```

**MySQL / MariaDB :**

```sql
SELECT COUNT(*) AS nombre_tables
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'XPLab_SAE3'
  AND TABLE_TYPE = 'BASE TABLE';
```

Le nombre attendu est **16**. Les trois vues proposent respectivement un suivi des candidatures, un bilan des présences et rétributions, et le planning des salles.

Le script d'exploitation regroupe ensuite les actions du chercheur, du gestionnaire et du participant. La variable d'acteur sélectionne un identifiant fictif. Les exemples de procédures sont commentés : les examiner puis les exécuter individuellement pour observer leur effet.

## Dates et résultats

Le jeu de démonstration utilise des **dates fixes en 2026**. Les consultations de créneaux futurs et certaines procédures dépendent de l'heure courante en UTC. Une consultation peut donc retourner moins de lignes, ou aucun résultat, lors d'un essai ultérieur.

Pour tester de nouvelles réservations, préparer des dates adaptées dans une copie locale, en conservant la cohérence entre la période de l'étude et ses créneaux. Il n'est pas nécessaire de modifier les scripts pour consulter le modèle, les données chargées et les vues de bilan.

## Vérifications et limites

Les six scripts publiés correspondent aux livrables du Drive. Leur contenu a été conservé ; les noms de fichiers ont été harmonisés. Chaque version comporte 16 tables, 9 procédures stockées et 3 vues.

Les environnements indiqués plus haut proviennent des traces d'exécution du projet. La mise à jour de la documentation n'est pas une nouvelle campagne d'essais des bases.

Les procédures vérifient les règles métier et annulent une opération qui échoue. La gestion des demandes simultanées reste hors du périmètre traité ; les écritures directes peuvent contourner les contrôles portés uniquement par les procédures. Voir les [choix de conception](base-de-donnees.md).
