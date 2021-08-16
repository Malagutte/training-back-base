--  *********************************************************************
--  Update Database Script
--  *********************************************************************
--  Change Log: src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml
--  Ran at: 04/09/20 08:18
--  Against: null@offline:mysql?version=5.7&outputLiquibaseSql=none&changeLogFile=/Users/jasonn/Documents/workspace/stash-repos/audit/audit-service/target/liquibase/mysql-changelog-full.csv
--  Liquibase version: 3.5.3
--  *********************************************************************

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_13_1.yml::audit1::richardj
CREATE TABLE audit_record (id VARCHAR(36) NOT NULL, message_set_id VARCHAR(36) NULL, event_category VARCHAR(35) NOT NULL, event_action VARCHAR(35) NOT NULL, object_type VARCHAR(35) NOT NULL, actor_username VARCHAR(64) NOT NULL, actor_user_id VARCHAR(36) NOT NULL, event_time datetime(3) NOT NULL, event_desc VARCHAR(255) NOT NULL, legal_entity_id VARCHAR(36) NULL, sa_id VARCHAR(36) NULL, CONSTRAINT pk_audit_record PRIMARY KEY (id));

CREATE TABLE ext_audit_record (id VARCHAR(36) NOT NULL, value VARCHAR(500) NULL, key_name VARCHAR(50) NOT NULL, CONSTRAINT pk_ear_id_key_name PRIMARY KEY (id, key_name));

CREATE TABLE audit_event_data (id VARCHAR(36) NOT NULL, audit_record_id VARCHAR(36) NOT NULL, key_name VARCHAR(255) NOT NULL, value VARCHAR(255) NULL, CONSTRAINT pk_audit_event_data PRIMARY KEY (id));

ALTER TABLE ext_audit_record ADD CONSTRAINT fk_ear2ar FOREIGN KEY (id) REFERENCES audit_record (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

ALTER TABLE audit_event_data ADD CONSTRAINT fk_aed2ar FOREIGN KEY (audit_record_id) REFERENCES audit_record (id) ON UPDATE NO ACTION ON DELETE NO ACTION;

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_13_1.yml::audit3::richardj
CREATE INDEX ix_ear_id ON ext_audit_record(id);

CREATE INDEX ix_aed_audit_record_id ON audit_event_data(audit_record_id);

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_14_0.yml::audit4::richardj
--  Creates a non-nullable status column with the default value set to 'Unknown'
ALTER TABLE audit_record ADD status VARCHAR(11) DEFAULT 'Unknown' NOT NULL;

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_14_1.yml::audit5::gavin
--  Creates a nullable ipAddress column
ALTER TABLE audit_record ADD ip_address VARCHAR(45) NULL;

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_16_4.yml::audit6::jasonn
--  Creates a nullable schema_version column
ALTER TABLE audit_record ADD schema_version VARCHAR(36) NULL;

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_17_0.yml::audit7::jasonn
--  Alters the width of event_desc column to 511
ALTER TABLE audit_record MODIFY event_desc VARCHAR(511);

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_17_0.yml::audit8::jasonn
--  Creates a nullable user_agent column
ALTER TABLE audit_record ADD user_agent VARCHAR(255) NULL;

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit9::patrickn
--  Add new tables with greater efficiency
CREATE TABLE audit_message (id BIGINT NOT NULL, status VARCHAR(11) DEFAULT 'Unknown' NOT NULL, event_time datetime(3) NOT NULL, actor_user_id VARCHAR(36) NOT NULL, actor_username NVARCHAR(64) NOT NULL, event_category VARCHAR(35) NOT NULL, object_type VARCHAR(35) NOT NULL, event_action VARCHAR(35) NOT NULL, event_desc NVARCHAR(511) NOT NULL, message_set_id VARCHAR(36) NULL, legal_entity_id VARCHAR(36) NULL, sa_id VARCHAR(36) NULL, ip_address VARCHAR(45) NULL, user_agent VARCHAR(255) NULL, schema_version VARCHAR(36) NULL, error VARCHAR(255) NULL, metadata MEDIUMTEXT NULL, additions MEDIUMTEXT NULL, temp_legacy_id VARCHAR(36) NULL);

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit10::jasonn
CREATE TABLE sequence_table (sequence_name VARCHAR(255) NOT NULL, next_val BIGINT NULL);

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit11::jasonn
--  Creates a nullable error column
ALTER TABLE audit_record ADD error VARCHAR(255) NULL;

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit12::jasonn
CREATE TABLE migration_progress (audit_message_id BIGINT NOT NULL, audit_record_id VARCHAR(36) NOT NULL, success CHAR(1) NULL, migrated_date datetime(3) NULL, CONSTRAINT PK_MIGRATION_PROGRESS PRIMARY KEY (audit_record_id));

CREATE INDEX ix_mp_success ON migration_progress(success);

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit13::jasonn
CREATE TABLE migration_config (id BIGINT NOT NULL, active CHAR(1) NOT NULL, max_migrations_per_minute INT NOT NULL, CONSTRAINT PK_MIGRATION_CONFIG PRIMARY KEY (id));

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit14::simonf
--  partition audit_message table on Oracle
--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit15::simonf
--  partition audit_message table on MySQL
ALTER TABLE audit_message ADD PRIMARY KEY (event_time, actor_user_id, id);

ALTER TABLE audit_message PARTITION BY RANGE COLUMNS (event_time)
SUBPARTITION BY KEY (actor_user_id)
SUBPARTITIONS 4
(
PARTITION p_dummy VALUES LESS THAN ('2020-01-01'),
PARTITION p_2020_01 VALUES LESS THAN ('2020-02-01'),
PARTITION p_2020_02 VALUES LESS THAN ('2020-03-01'),
PARTITION p_2020_03 VALUES LESS THAN ('2020-04-01'),
PARTITION p_2020_04 VALUES LESS THAN ('2020-05-01'),
PARTITION p_2020_05 VALUES LESS THAN ('2020-06-01'),
PARTITION p_2020_06 VALUES LESS THAN ('2020-07-01'),
PARTITION p_2020_07 VALUES LESS THAN ('2020-08-01'),
PARTITION p_2020_08 VALUES LESS THAN ('2020-09-01'),
PARTITION p_2020_09 VALUES LESS THAN ('2020-10-01'),
PARTITION p_2020_10 VALUES LESS THAN ('2020-11-01'),
PARTITION p_2020_11 VALUES LESS THAN ('2020-12-01'),
PARTITION p_2020_12 VALUES LESS THAN ('2021-01-01'),
PARTITION p_max_value VALUES LESS THAN (MAXVALUE));

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit16::simonf
--  partition audit_message table on MSSQL
--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit17::jasonn
--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit18::jasonn
CREATE TABLE migration_progress_estimate (id BIGINT NOT NULL, success INT NOT NULL, failed INT NOT NULL, CONSTRAINT PK_MIGRATION_PROGRESS_ESTIMATE PRIMARY KEY (id));

--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit19::jasonn
--  Changeset src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml::audit20::patrickn
--  Remove temporary migration tables
DROP TABLE migration_progress;

DROP TABLE migration_config;

