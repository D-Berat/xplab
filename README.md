# XPLab - de l'analyse des besoins à la base de données

Projet de deuxième année de BUT Informatique : concevoir une application de gestion des expérimentations d'un laboratoire. **120 heures sont prévues par étudiant**, dans une équipe de trois. Le cahier des charges et la phase base de données sont réalisés ; l'application reste à développer. Fin du projet prévue début janvier 2027.

**[Étude de cas sur mon portfolio](https://dastan.fr/fr/projets/xplab/)** · [Cahier des charges : synthèse](docs/cahier-des-charges.md) · [Conception de la base](docs/base-de-donnees.md) · [Exécuter les scripts](docs/execution.md)

## Mon rôle

J'ai pris en charge l'essentiel du cahier des charges et de la base de données : analyse des besoins, rédaction des spécifications, architecture fonctionnelle, parcours de navigation, règles de gestion, modélisation et scripts SQL. Les autres membres de l'équipe ont réalisé la planification du projet et les maquettes Figma.

Ce dépôt est une présentation personnelle d'un travail collectif. Il conserve le contexte de l'équipe sans nommer ses membres. La documentation de présentation a été préparée avec l'aide de Codex à partir des livrables scolaires ; les six scripts SQL sont conservés à l'identique, avec des noms de fichiers harmonisés.

## Ce que le système doit permettre

- Au chercheur : créer des études, examiner les candidatures, valider les présences et les rétributions.
- Au gestionnaire : organiser les créneaux et affecter les salles et les équipements.
- Au participant : trouver des études compatibles avec son profil, consentir, réserver ou annuler un créneau.

Le cahier des charges prévoit aussi les rôles de responsable d'équipe, directeur de laboratoire et administrateur. Le livrable SQL se concentre sur les trois premiers rôles ; il ne constitue pas encore l'application complète.

## Livrables disponibles

| Élément | Contenu |
| --- | --- |
| [Synthèse des exigences](docs/cahier-des-charges.md) | Besoin, acteurs, parcours, exigences et périmètre |
| [Conception de la base](docs/base-de-donnees.md) | Règles, choix de clés, transactions et limites |
| [Modèle conceptuel](docs/images/xplab-mcd.webp) | 11 entités et leurs associations |
| [Modèle logique](docs/images/xplab-mld.webp) | 16 tables et leurs relations |
| [Version SQL Server](sql/sqlserver/) | Création, données de démonstration, exploitation |
| [Version MySQL](sql/mysql/) | Même modèle métier, avec la syntaxe adaptée |

Chaque version SQL comporte **9 consultations, 9 procédures stockées et 3 vues**. Les vues font partie des consultations. Il s'agit de deux implémentations du même livrable, pas de fonctionnalités à additionner.

<a href="docs/images/xplab-mcd.webp"><img src="docs/images/xplab-mcd.webp" alt="Modèle conceptuel XPLab" width="800"></a>

## Explorer le code

```text
sql/
  mysql/
    01-creation.sql
    02-donnees.sql
    03-exploitation.sql
  sqlserver/
    01-creation.sql
    02-donnees.sql
    03-exploitation.sql
docs/
  cahier-des-charges.md
  base-de-donnees.md
  execution.md
  images/
```

Les scripts s'exécutent dans cet ordre : `01`, `02`, puis `03`, dans **une seule des deux versions**. Le script de création supprime puis recrée la base `XPLab_SAE3` : utiliser une instance de développement dédiée. Les instructions et les particularités des dates sont dans le [guide d'exécution](docs/execution.md).

## Un problème concret : les conflits de réservation

Une réservation de 10 h à 11 h entre en conflit avec un créneau de 9 h 30 à 11 h 30, même si leurs heures de début sont différentes. La consultation PA01 compare donc les deux bornes :

```sql
c_reserve.debut < c.fin
AND c.debut < c_reserve.fin
```

Les comparaisons strictes laissent en revanche se suivre deux créneaux dont l'un finit exactement quand l'autre commence. Le [détail des choix et des contrôles](docs/base-de-donnees.md) explique aussi la séparation entre candidature et réservation et les clés étrangères composées.

## État et limites

- Réalisé : exigences, conception des données et scripts SQL Server / MySQL.
- À venir : application, interfaces, intégration et validation des parcours complets.
- Les transactions annulent une opération qui échoue. La gestion des demandes simultanées reste hors du périmètre traité.
- Les règles sont conçues pour être appliquées via les procédures ; le passage direct par des écritures arbitraires dans les tables n'est pas un parcours applicatif validé.
- Les personnes, adresses en `.example` et valeurs du jeu de démonstration sont fictives.
- L'IA a aidé à relire les modèles et les scripts, à préparer des exemples et à discuter la logique de certaines requêtes d'exploitation. Le dossier scolaire comporte une déclaration de cet usage.

Les maquettes Figma et la planification ne sont pas présentées ici comme des réalisations personnelles. Les synthèses de ce dépôt ne remplacent pas l'intégralité du cahier des charges collectif.

Berat DASTAN
