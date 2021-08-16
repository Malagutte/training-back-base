SET DEFINE OFF;

CREATE TABLE user_profile
(
    id             VARCHAR2(36) NOT NULL,
    external_id    VARCHAR2(64) NOT NULL,
    user_id        VARCHAR2(36) NOT NULL,
    username       VARCHAR2(64) NOT NULL,
    representation BLOB         NOT NULL
);
COMMIT;


ALTER TABLE user_profile ADD CONSTRAINT pk_user_profile PRIMARY KEY (id) USING INDEX;
COMMIT;

ALTER TABLE user_profile ADD CONSTRAINT uq_user_profile_externalid UNIQUE(external_id);
ALTER TABLE user_profile ADD CONSTRAINT uq_user_profile_username UNIQUE(username);
ALTER TABLE user_profile ADD CONSTRAINT uq_user_profile_userid UNIQUE(user_id);
COMMIT;
