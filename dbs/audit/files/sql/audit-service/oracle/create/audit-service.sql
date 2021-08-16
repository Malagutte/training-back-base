-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml
-- Ran at: 04/09/20 08:18
-- Against: null@offline:oracle?version=12.1&outputLiquibaseSql=none&changeLogFile=/Users/jasonn/Documents/workspace/stash-repos/audit/audit-service/target/liquibase/oracle-changelog-full.csv
-- Liquibase version: 3.5.3
-- *********************************************************************

SET DEFINE OFF;

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_13_1.yml::audit1::richardj
CREATE TABLE audit_record (id VARCHAR2(36) NOT NULL, message_set_id VARCHAR2(36), event_category VARCHAR2(35) NOT NULL, event_action VARCHAR2(35) NOT NULL, object_type VARCHAR2(35) NOT NULL, actor_username VARCHAR2(64) NOT NULL, actor_user_id VARCHAR2(36) NOT NULL, event_time TIMESTAMP NOT NULL, event_desc VARCHAR2(255) NOT NULL, legal_entity_id VARCHAR2(36), sa_id VARCHAR2(36), CONSTRAINT pk_audit_record PRIMARY KEY (id));

CREATE TABLE ext_audit_record (id VARCHAR2(36) NOT NULL, value VARCHAR2(500), key_name VARCHAR2(50) NOT NULL, CONSTRAINT pk_ear_id_key_name PRIMARY KEY (id, key_name));

CREATE TABLE audit_event_data (id VARCHAR2(36) NOT NULL, audit_record_id VARCHAR2(36) NOT NULL, key_name VARCHAR2(255) NOT NULL, value VARCHAR2(255), CONSTRAINT pk_audit_event_data PRIMARY KEY (id));

ALTER TABLE ext_audit_record ADD CONSTRAINT fk_ear2ar FOREIGN KEY (id) REFERENCES audit_record (id);

ALTER TABLE audit_event_data ADD CONSTRAINT fk_aed2ar FOREIGN KEY (audit_record_id) REFERENCES audit_record (id);

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_13_1.yml::audit2::richardj
CREATE INDEX ix_ear_id ON ext_audit_record(id) TABLESPACE users;

CREATE INDEX ix_aed_audit_record_id ON audit_event_data(audit_record_id) TABLESPACE users;

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_14_0.yml::audit4::richardj
-- Creates a non-nullable status column with the default value set to 'Unknown'
ALTER TABLE audit_record ADD status VARCHAR2(11) DEFAULT 'Unknown' NOT NULL;

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_14_1.yml::audit5::gavin
-- Creates a nullable ipAddress column
ALTER TABLE audit_record ADD ip_address VARCHAR2(45);

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_16_4.yml::audit6::jasonn
-- Creates a nullable schema_version column
ALTER TABLE audit_record ADD schema_version VARCHAR2(36);

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_17_0.yml::audit7::jasonn
-- Alters the width of event_desc column to 511
ALTER TABLE audit_record MODIFY event_desc VARCHAR2(511);

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_17_0.yml::audit8::jasonn
-- Creates a nullable user_agent column
ALTER TABLE audit_record ADD user_agent VARCHAR2(255);

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit9::patrickn
-- Add new tables with greater efficiency
CREATE TABLE audit_message (id NUMBER(38, 0) NOT NULL, status VARCHAR2(11) DEFAULT 'Unknown' NOT NULL, event_time TIMESTAMP NOT NULL, actor_user_id VARCHAR2(36) NOT NULL, actor_username NVARCHAR2(64) NOT NULL, event_category VARCHAR2(35) NOT NULL, object_type VARCHAR2(35) NOT NULL, event_action VARCHAR2(35) NOT NULL, event_desc NVARCHAR2(511) NOT NULL, message_set_id VARCHAR2(36), legal_entity_id VARCHAR2(36), sa_id VARCHAR2(36), ip_address VARCHAR2(45), user_agent VARCHAR2(255), schema_version VARCHAR2(36), error VARCHAR2(255), metadata CLOB, additions CLOB, temp_legacy_id VARCHAR2(36));

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit10::jasonn
CREATE TABLE sequence_table (sequence_name VARCHAR2(255) NOT NULL, next_val NUMBER(38, 0));

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit11::jasonn
-- Creates a nullable error column
ALTER TABLE audit_record ADD error VARCHAR2(255);

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit12::jasonn
CREATE TABLE migration_progress (audit_message_id NUMBER(38, 0) NOT NULL, audit_record_id VARCHAR2(36) NOT NULL, success CHAR(1), migrated_date TIMESTAMP, CONSTRAINT PK_MIGRATION_PROGRESS PRIMARY KEY (audit_record_id));

CREATE INDEX ix_mp_success ON migration_progress(success);

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit13::jasonn
CREATE TABLE migration_config (id NUMBER(38, 0) NOT NULL, active CHAR(1) NOT NULL, max_migrations_per_minute INTEGER NOT NULL, CONSTRAINT PK_MIGRATION_CONFIG PRIMARY KEY (id));

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit14::simonf
-- partition audit_message table on Oracle
DECLARE
   partitioning VARCHAR2(10) := 'FALSE';
BEGIN
    select VALUE INTO partitioning from v$option where parameter = 'Partitioning';
    IF (partitioning = 'TRUE') THEN
    	EXECUTE IMMEDIATE q'[ALTER TABLE audit_message MODIFY
        PARTITION BY RANGE (event_time) INTERVAL (NUMTOYMINTERVAL(1,'MONTH'))
        SUBPARTITION BY HASH (actor_user_id) SUBPARTITIONS 8
        (PARTITION dummy VALUES LESS THAN (TO_DATE('01-JAN-2017','dd-MON-yyyy')))]';

        EXECUTE IMMEDIATE q'[CREATE UNIQUE INDEX ix_am_event_time_actor_user_id_id
		ON audit_message (event_time, actor_user_id, id) LOCAL]';

        EXECUTE IMMEDIATE q'[ALTER TABLE audit_message ADD PRIMARY KEY (event_time, actor_user_id, id)]';
    ELSE
        EXECUTE IMMEDIATE 'ALTER TABLE audit_message ADD PRIMARY KEY (event_time, actor_user_id, id)';
    END IF;
END;

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit15::simonf
-- partition audit_message table on MySQL
-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit16::simonf
-- partition audit_message table on MSSQL
-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit17::jasonn
/
DECLARE
   partitioning VARCHAR2(10) := 'FALSE';
   primaryCount NUMBER(10) := 0;
BEGIN
    SELECT count(1) into primaryCount FROM user_constraints
        WHERE UPPER(table_name) = UPPER('audit_message') AND CONSTRAINT_TYPE = 'P';

    IF (primaryCount = 0) THEN
        select VALUE INTO partitioning from v$option where parameter = 'Partitioning';
        IF (partitioning = 'TRUE') THEN
            EXECUTE IMMEDIATE q'[ALTER TABLE audit_message MODIFY
            PARTITION BY RANGE (event_time) INTERVAL (NUMTOYMINTERVAL(1,'MONTH'))
            SUBPARTITION BY HASH (actor_user_id) SUBPARTITIONS 8
            (PARTITION dummy VALUES LESS THAN (TO_DATE('01-JAN-2017','dd-MON-yyyy')))]';

            EXECUTE IMMEDIATE q'[CREATE UNIQUE INDEX ix_am_event_time_actor_user_id_id
            ON audit_message (event_time, actor_user_id, id) LOCAL]';

            EXECUTE IMMEDIATE q'[ALTER TABLE audit_message ADD PRIMARY KEY (event_time, actor_user_id, id)]';
        ELSE
            EXECUTE IMMEDIATE 'ALTER TABLE audit_message ADD PRIMARY KEY (event_time, actor_user_id, id)';
        END IF;
    END IF;
END;
/


-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit18::jasonn
CREATE TABLE migration_progress_estimate (id NUMBER(38, 0) NOT NULL, success INTEGER NOT NULL, failed INTEGER NOT NULL, CONSTRAINT PK_MIGRATION_PROGRESS_ESTIMATE PRIMARY KEY (id));

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit19::jasonn
set serveroutput on;
DECLARE
  audit_message_constraint VARCHAR(255) := '';
  audit_message_index VARCHAR(255) := '';
  sql_statement1 VARCHAR(255) := 'na';
  sql_statement2 VARCHAR(255) := 'na';
  is_error BOOLEAN := FALSE;
BEGIN

  begin
    SELECT constraint_name, index_name INTO audit_message_constraint, audit_message_index FROM user_constraints WHERE table_name = 'AUDIT_MESSAGE' and constraint_type='P';
    exception
    when no_data_found then
      dbms_output.put_line('No data found');
      is_error := TRUE;
    when others then
      dbms_output.put_line('Other error');
      is_error := TRUE;
  end;

  if not is_error then

    sql_statement1 := 'ALTER TABLE AUDIT_MESSAGE RENAME CONSTRAINT '|| audit_message_constraint ||' TO PK_AUDIT_MESSAGE';
    sql_statement2 := 'ALTER INDEX ' || audit_message_index || ' RENAME TO PK_AUDIT_MESSAGE';

    EXECUTE IMMEDIATE sql_statement1;
    EXECUTE IMMEDIATE sql_statement2;

  end if;
end;
/


-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml::audit20::patrickn
-- Remove temporary migration tables
DROP TABLE migration_progress;

DROP TABLE migration_config;

