SET DEFINE OFF;

CREATE TABLE en_user
(
    id                 VARCHAR2(36)  NOT NULL,
    external_id        VARCHAR2(64)  NOT NULL,
    legal_entity_id    VARCHAR2(36)  NOT NULL,
    full_name          VARCHAR2(255) NOT NULL,
    preferred_language VARCHAR2(8) DEFAULT NULL,
    external_id_up     VARCHAR2(64) AS (UPPER(external_id)),
    full_name_up       VARCHAR2(255) AS (UPPER(full_name)),
    additions          NCLOB         NULL,
    CONSTRAINT pk_en_user PRIMARY KEY (id)
);

CREATE UNIQUE INDEX uq_en_user_01 on en_user (lower(external_id));

CREATE INDEX ix_en_user_leid on en_user (legal_entity_id);

CREATE UNIQUE INDEX uq_external_id_up ON en_user (external_id_up);

CREATE INDEX ix_full_name_up ON en_user (full_name_up);

CREATE TABLE realm
(
    id         VARCHAR2(36)  NOT NULL,
    realm_name VARCHAR2(255) NOT NULL,
    CONSTRAINT pk_realm PRIMARY KEY (id)
);

CREATE UNIQUE INDEX uq_rlm_realm_name ON realm (realm_name);

CREATE TABLE legal_entity_assigned_realm
(
    legal_entity_id VARCHAR2(36) NOT NULL,
    realm_id        VARCHAR2(36) NOT NULL,
    CONSTRAINT pk_le_assign_realm PRIMARY KEY (legal_entity_id),
    CONSTRAINT fk_lear2realm FOREIGN KEY (realm_id) REFERENCES realm (id) ON DELETE CASCADE
);

INSERT INTO realm (id, realm_name)
VALUES ('0006f11c-366d-43cc-83ce-9277cda55092', 'backbase');

COMMIT;

CREATE TABLE approval_user
(
    approval_id   VARCHAR2(36)   NOT NULL,
    user_id       VARCHAR2(36)   NOT NULL,
    status        VARCHAR2(36)   NOT NULL,
    approval_type VARCHAR2(36)   NOT NULL,
    patch         VARCHAR2(2000) NOT NULL,
    created_at    TIMESTAMP      NOT NULL,
    CONSTRAINT pk_approval_user PRIMARY KEY (approval_id)
);

COMMIT;