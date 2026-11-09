# XPLab - synthèse du cahier des charges

Cette synthèse présente les exigences du projet scolaire et le travail de conception. Elle ne décrit pas une application déjà livrée. Le document collectif de référence compte 127 pages, incluant notamment spécifications, schémas, maquettes et planification.

## Besoin initial

Organiser une expérimentation implique de relier plusieurs informations : étude, critères de participation, candidatures, consentement, créneaux, ressources matérielles, présences et éventuelles rétributions. Le projet vise à centraliser ces informations et à rendre les actions accessibles selon le rôle de l'utilisateur.

## Six profils dans le périmètre fonctionnel

| Profil | Besoins décrits |
| --- | --- |
| Enseignant-chercheur | Paramétrer une étude, définir les restrictions de participation, examiner les candidatures, suivre les présences et rétributions |
| Gestionnaire / ingénieur de laboratoire | Organiser les salles et équipements, examiner les disponibilités et gérer les créneaux |
| Participant | Renseigner son profil, consulter les études compatibles, consentir, s'inscrire, réserver et consulter son historique |
| Responsable d'équipe de recherche | Suivre les études et l'activité de son équipe |
| Directeur de laboratoire | Consulter une vision consolidée des expérimentations du laboratoire |
| Administrateur | Gérer les comptes, rôles, paramètres, journaux et interfaces avec les services externes |

La phase d'exploitation SQL publiée couvre les trois premiers rôles. Les autres restent dans le périmètre décrit par le cahier des charges.

## Un parcours qui traverse plusieurs rôles

1. Le chercheur prépare l'étude et ses conditions de participation.
2. Le gestionnaire organise les créneaux et les ressources nécessaires.
3. Le participant consulte les études compatibles avec son profil et réserve après consentement.
4. Le chercheur accepte ou refuse la candidature lorsque la validation est requise.
5. Après la séance, le chercheur enregistre la présence et, selon les conditions prévues, la rétribution.

Ce parcours oblige à distinguer l'état de la candidature de celui de chaque réservation. Il implique également de vérifier les disponibilités et de conserver un historique des annulations.

## Ma contribution à la spécification

J'ai pris en charge l'essentiel de l'analyse et de la rédaction :

- Contexte, objectifs et critères d'acceptation.
- Scénarios par profil et description des actions attendues.
- Fiches fonctionnelles précisant acteur, préconditions, entrées, traitements, sorties et erreurs.
- Architecture fonctionnelle, répartition en modules et parcours de navigation.
- Mise en relation des exigences avec les règles métier et la conception des données.

La planification et les maquettes Figma ont été réalisées par les autres membres de l'équipe. Le projet est collectif ; cette présentation distingue ma contribution des livrables auxquels je n'ai pas contribué de manière principale.

## Exigences à intégrer dans l'application

Le cahier des charges décrit notamment l'authentification universitaire, la séparation des droits, le consentement, la traçabilité des activités et une interface adaptée aux différents publics. Ces éléments sont des exigences de conception, pas des garanties de conformité ou des fonctions déjà démontrées dans une application.

Les critères d'acceptation doivent être confrontés aux parcours réels lors du développement et de la validation. La base de données seule ne démontre ni la qualité d'une interface, ni l'authentification complète, ni la résistance aux accès concurrents.

## Passage à la base de données

La phase suivante traduit les règles métier en dictionnaire, dépendances fonctionnelles, modèle conceptuel et modèle logique. Le livrable SQL retient un périmètre opérationnel centré sur le chercheur, le gestionnaire et le participant.

Lire la [conception détaillée de la base](base-de-donnees.md) ou revenir au [README](../README.md).
