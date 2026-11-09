USE master;
GO
DROP DATABASE IF EXISTS XPLab_SAE3;
GO
CREATE DATABASE XPLab_SAE3;
GO
USE XPLab_SAE3;
GO

-- laboratoire auquel sont rattachés personnels et ressources
CREATE TABLE Laboratoire (
    id_laboratoire INT IDENTITY(1,1) NOT NULL,
    nom NVARCHAR(120) NOT NULL,
    CONSTRAINT PK_Laboratoire PRIMARY KEY (id_laboratoire),
    CONSTRAINT UQ_Laboratoire_Nom UNIQUE (nom)
);

-- identité commune sans création de compte SQL
CREATE TABLE Utilisateur (
    id_utilisateur INT IDENTITY(1,1) NOT NULL,
    nom NVARCHAR(80) NOT NULL,
    prenom NVARCHAR(80) NOT NULL,
    email NVARCHAR(180) NOT NULL,
    actif BIT NOT NULL DEFAULT (1),
    CONSTRAINT PK_Utilisateur PRIMARY KEY (id_utilisateur),
    CONSTRAINT UQ_Utilisateur_Email UNIQUE (email),
    CONSTRAINT CK_Utilisateur_EmailFormat CHECK (email LIKE '%_@_%._%')
);

-- enseignant responsable des études
CREATE TABLE Chercheur (
    id_utilisateur INT NOT NULL,
    id_laboratoire INT NOT NULL,
    CONSTRAINT PK_Chercheur PRIMARY KEY (id_utilisateur),
    CONSTRAINT FK_Chercheur_Utilisateur FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur (id_utilisateur),
    CONSTRAINT FK_Chercheur_Laboratoire FOREIGN KEY (id_laboratoire) REFERENCES Laboratoire (id_laboratoire)
);

-- personnel chargé des ressources
CREATE TABLE Gestionnaire (
    id_utilisateur INT NOT NULL,
    id_laboratoire INT NOT NULL,
    CONSTRAINT PK_Gestionnaire PRIMARY KEY (id_utilisateur),
    CONSTRAINT FK_Gestionnaire_Utilisateur FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur (id_utilisateur),
    CONSTRAINT FK_Gestionnaire_Laboratoire FOREIGN KEY (id_laboratoire) REFERENCES Laboratoire (id_laboratoire)
);

-- petit référentiel fermé des langues du jeu de données
CREATE TABLE Langue (
    code_langue CHAR(2) NOT NULL,
    libelle NVARCHAR(40) NOT NULL,
    CONSTRAINT PK_Langue PRIMARY KEY (code_langue),
    CONSTRAINT UQ_Langue_Libelle UNIQUE (libelle)
);

-- profil utilisé pour vérifier les critères de recrutement
CREATE TABLE Participant (
    id_utilisateur INT NOT NULL,
    date_naissance DATE NOT NULL,
    genre NVARCHAR(12) NOT NULL,
    porte_lunettes BIT NOT NULL,
    modifie_le DATETIME2(0) NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_Participant PRIMARY KEY (id_utilisateur),
    CONSTRAINT FK_Participant_Utilisateur FOREIGN KEY (id_utilisateur) REFERENCES Utilisateur (id_utilisateur),
    CONSTRAINT CK_Participant_Genre CHECK (genre IN ('FEMME','HOMME','AUTRE','NON_PRECISE')),
    CONSTRAINT CK_Participant_Naissance CHECK (date_naissance >= '1900-01-01')
);

-- langues maîtrisées par chaque participant
CREATE TABLE ParticipantLangue (
    id_participant INT NOT NULL,
    code_langue CHAR(2) NOT NULL,
    CONSTRAINT PK_ParticipantLangue PRIMARY KEY (id_participant, code_langue),
    CONSTRAINT FK_ParticipantLangue_Participant FOREIGN KEY (id_participant) REFERENCES Participant (id_utilisateur),
    CONSTRAINT FK_ParticipantLangue_Langue FOREIGN KEY (code_langue) REFERENCES Langue (code_langue)
);

-- paramètres des études et critères retenus pour ce périmètre
CREATE TABLE Experimentation (
    id_experimentation INT IDENTITY(1,1) NOT NULL,
    id_chercheur INT NOT NULL,
    titre NVARCHAR(160) NOT NULL,
    description NVARCHAR(1000) NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE NOT NULL,
    statut NVARCHAR(12) NOT NULL DEFAULT ('OUVERTE'),
    validation_requise BIT NOT NULL,
    age_min INT NOT NULL,
    age_max INT NOT NULL,
    genre_requis NVARCHAR(12) NULL,
    langue_requise CHAR(2) NULL,
    lunettes_autorisees BIT NOT NULL DEFAULT (1),
    version_consentement NVARCHAR(30) NOT NULL,
    type_retribution NVARCHAR(10) NOT NULL,
    valeur_retribution DECIMAL(8,2) NOT NULL,
    CONSTRAINT PK_Experimentation PRIMARY KEY (id_experimentation),
    CONSTRAINT FK_Experimentation_Chercheur FOREIGN KEY (id_chercheur) REFERENCES Chercheur (id_utilisateur),
    CONSTRAINT FK_Experimentation_Langue FOREIGN KEY (langue_requise) REFERENCES Langue (code_langue),
    CONSTRAINT CK_Experimentation_Dates CHECK (date_fin >= date_debut),
    CONSTRAINT CK_Experimentation_Statut CHECK (statut IN ('BROUILLON','OUVERTE','ARCHIVEE')),
    CONSTRAINT CK_Experimentation_Ages CHECK (age_min BETWEEN 0 AND 120 AND age_max BETWEEN age_min AND 120),
    CONSTRAINT CK_Experimentation_Genre CHECK (genre_requis IS NULL OR genre_requis IN ('FEMME','HOMME','AUTRE','NON_PRECISE')),
    CONSTRAINT CK_Experimentation_Retribution CHECK ((type_retribution = 'AUCUNE' AND valeur_retribution = 0) OR (type_retribution IN ('COUPON','CREDIT') AND valeur_retribution > 0))
);

-- salle physique rattachée à un laboratoire
CREATE TABLE Salle (
    id_salle INT IDENTITY(1,1) NOT NULL,
    id_laboratoire INT NOT NULL,
    nom NVARCHAR(80) NOT NULL,
    capacite INT NOT NULL,
    etat NVARCHAR(15) NOT NULL DEFAULT ('DISPONIBLE'),
    CONSTRAINT PK_Salle PRIMARY KEY (id_salle),
    CONSTRAINT FK_Salle_Laboratoire FOREIGN KEY (id_laboratoire) REFERENCES Laboratoire (id_laboratoire),
    CONSTRAINT UQ_Salle_NomLaboratoire UNIQUE (id_laboratoire,nom),
    CONSTRAINT CK_Salle_Capacite CHECK (capacite > 0),
    CONSTRAINT CK_Salle_Etat CHECK (etat IN ('DISPONIBLE','MAINTENANCE','HORS_SERVICE'))
);

-- un exemplaire physique identifié par son inventaire
CREATE TABLE Equipement (
    id_equipement INT IDENTITY(1,1) NOT NULL,
    id_laboratoire INT NOT NULL,
    reference NVARCHAR(40) NOT NULL,
    designation NVARCHAR(120) NOT NULL,
    etat NVARCHAR(15) NOT NULL DEFAULT ('DISPONIBLE'),
    CONSTRAINT PK_Equipement PRIMARY KEY (id_equipement),
    CONSTRAINT FK_Equipement_Laboratoire FOREIGN KEY (id_laboratoire) REFERENCES Laboratoire (id_laboratoire),
    CONSTRAINT UQ_Equipement_Reference UNIQUE (reference),
    CONSTRAINT CK_Equipement_Etat CHECK (etat IN ('DISPONIBLE','MAINTENANCE','HORS_SERVICE'))
);

-- créneau identifié relativement à son expérimentation
CREATE TABLE Creneau (
    id_experimentation INT NOT NULL,
    numero INT NOT NULL,
    id_salle INT NOT NULL,
    debut DATETIME2(0) NOT NULL,
    fin DATETIME2(0) NOT NULL,
    places INT NOT NULL,
    statut NVARCHAR(10) NOT NULL DEFAULT ('OUVERT'),
    CONSTRAINT PK_Creneau PRIMARY KEY (id_experimentation, numero),
    CONSTRAINT FK_Creneau_Experimentation FOREIGN KEY (id_experimentation) REFERENCES Experimentation (id_experimentation),
    CONSTRAINT FK_Creneau_Salle FOREIGN KEY (id_salle) REFERENCES Salle (id_salle),
    CONSTRAINT CK_Creneau_DatesPlacesNumero CHECK (numero > 0 AND places > 0 AND fin > debut),
    CONSTRAINT CK_Creneau_Statut CHECK (statut IN ('OUVERT','ANNULE'))
);

-- candidature et preuve de consentement au niveau de l’étude
CREATE TABLE Inscription (
    id_participant INT NOT NULL,
    id_experimentation INT NOT NULL,
    statut NVARCHAR(10) NOT NULL,
    consenti_le DATETIME2(0) NOT NULL,
    ip_consentement NVARCHAR(45) NOT NULL,
    version_consentement NVARCHAR(30) NOT NULL,
    decision_le DATETIME2(0) NULL,
    motif_decision NVARCHAR(250) NULL,
    CONSTRAINT PK_Inscription PRIMARY KEY (id_participant, id_experimentation),
    CONSTRAINT FK_Inscription_Participant FOREIGN KEY (id_participant) REFERENCES Participant (id_utilisateur),
    CONSTRAINT FK_Inscription_Experimentation FOREIGN KEY (id_experimentation) REFERENCES Experimentation (id_experimentation),
    CONSTRAINT CK_Inscription_Statut CHECK (statut IN ('ATTENTE','VALIDEE','REFUSEE','ANNULEE'))
);

-- choix d’un créneau et présence correspondante
CREATE TABLE Reservation (
    id_participant INT NOT NULL,
    id_experimentation INT NOT NULL,
    numero INT NOT NULL,
    etat NVARCHAR(10) NOT NULL DEFAULT ('RESERVEE'),
    reserve_le DATETIME2(0) NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_Reservation PRIMARY KEY (id_participant, id_experimentation, numero),
    CONSTRAINT FK_Reservation_Inscription FOREIGN KEY (id_participant,id_experimentation) REFERENCES Inscription (id_participant,id_experimentation),
    CONSTRAINT FK_Reservation_Creneau FOREIGN KEY (id_experimentation,numero) REFERENCES Creneau (id_experimentation,numero),
    CONSTRAINT CK_Reservation_Etat CHECK (etat IN ('RESERVEE','ANNULEE','PRESENT','ABSENT'))
);

-- association d’un exemplaire matériel à un créneau
CREATE TABLE AffectationEquipement (
    id_experimentation INT NOT NULL,
    numero INT NOT NULL,
    id_equipement INT NOT NULL,
    CONSTRAINT PK_AffectationEquipement PRIMARY KEY (id_experimentation, numero, id_equipement),
    CONSTRAINT FK_AffectationEquipement_Creneau FOREIGN KEY (id_experimentation,numero) REFERENCES Creneau (id_experimentation,numero),
    CONSTRAINT FK_AffectationEquipement_Equipement FOREIGN KEY (id_equipement) REFERENCES Equipement (id_equipement)
);

-- métadonnées des fichiers sécurisés associés à une étude
CREATE TABLE Document (
    id_document INT IDENTITY(1,1) NOT NULL,
    id_experimentation INT NOT NULL,
    titre NVARCHAR(160) NOT NULL,
    type_document NVARCHAR(15) NOT NULL,
    chemin_stockage NVARCHAR(250) NOT NULL,
    depose_le DATETIME2(0) NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_Document PRIMARY KEY (id_document),
    CONSTRAINT FK_Document_Experimentation FOREIGN KEY (id_experimentation) REFERENCES Experimentation (id_experimentation),
    CONSTRAINT UQ_Document_Chemin UNIQUE (chemin_stockage),
    CONSTRAINT CK_Document_Type CHECK (type_document IN ('PROTOCOLE','CONSENTEMENT','QUESTIONNAIRE','AUTRE'))
);

-- attribution interne unique pour une présence validée
CREATE TABLE Retribution (
    id_participant INT NOT NULL,
    id_experimentation INT NOT NULL,
    numero INT NOT NULL,
    type_retribution NVARCHAR(10) NOT NULL,
    valeur DECIMAL(8,2) NOT NULL,
    attribue_le DATETIME2(0) NOT NULL DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_Retribution PRIMARY KEY (id_participant, id_experimentation, numero),
    CONSTRAINT FK_Retribution_Reservation FOREIGN KEY (id_participant,id_experimentation,numero) REFERENCES Reservation (id_participant,id_experimentation,numero),
    CONSTRAINT CK_Retribution_TypeValeur CHECK (type_retribution IN ('COUPON','CREDIT') AND valeur > 0)
);
GO
