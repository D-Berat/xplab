# Exécuter les scripts XPLab

## Choisir une version

Utiliser SQL Server avec SSMS ou un outil compatible pour `sql/sqlserver`, ou MySQL avec un client acceptant la directive `DELIMITER` pour `sql/mysql`. Les contraintes et fonctions utilisées supposent une version récente du moteur ; MySQL doit notamment appliquer les contraintes `CHECK`.

Les deux dossiers implémentent le même modèle. Il n'est pas nécessaire d'exécuter les deux pour explorer le projet, et leurs syntaxes ne sont pas interchangeables.

## Ordre d'exécution

1. `01-creation.sql` crée les tables, clés et contraintes.
2. `02-donnees.sql` insère le jeu de démonstration.
3. `03-exploitation.sql` définit les vues et procédures et présente les consultations et exemples d'appels.

**Le premier script contient `DROP DATABASE IF EXISTS XPLab_SAE3`. Il supprime la base de ce nom avant de la recréer.** Exécuter uniquement dans une instance de développement dédiée, sans données à conserver sous ce nom.

Pour SQL Server, exécuter les fichiers dans cet ordre dans l'éditeur, en conservant les séparateurs `GO`. Pour MySQL, se connecter avec son propre compte de développement, puis utiliser les chemins absolus adaptés à sa copie :

```sql
SOURCE /chemin/vers/xplab/sql/mysql/01-creation.sql;
SOURCE /chemin/vers/xplab/sql/mysql/02-donnees.sql;
SOURCE /chemin/vers/xplab/sql/mysql/03-exploitation.sql;
```

Aucun identifiant de connexion au serveur n'est fourni dans le dépôt. Les comptes de la table `Utilisateur` sont des données métier fictives, pas des comptes SQL.

## Explorer les résultats

Le script d'exploitation regroupe les actions du chercheur, du gestionnaire et du participant. La variable d'acteur sélectionne un identifiant fictif du jeu de données. Les exemples d'appels aux procédures sont commentés : les examiner puis les exécuter individuellement pour observer leur effet.

Les dates du jeu de démonstration sont fixes, en 2026. Les consultations de créneaux futurs et certaines procédures dépendent de l'heure courante en UTC. Une consultation peut donc retourner moins de lignes, ou aucun résultat, si le jeu est exécuté plus tard. Ce comportement n'est pas une preuve d'échec d'installation. Pour un nouvel essai, préparer des dates adaptées dans une copie locale tout en conservant la cohérence des études et des créneaux.

## Ce qui est vérifié pour cette publication

Les six fichiers SQL de ce dépôt ont été comparés octet par octet aux livrables du Drive. La préparation du dépôt a harmonisé leurs noms, sans réécrire les commandes. La présence des 16 tables, 9 procédures et 3 vues par version a été contrôlée.

La création du dépôt ne constitue pas une nouvelle campagne d'exécution des bases ni un test de l'application, qui reste à développer. Les limites sur la concurrence et les écritures directes sont détaillées dans la [documentation de conception](base-de-donnees.md).
