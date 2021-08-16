-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml
-- Ran at: 04/09/20 08:18
-- Against: null@offline:mssql?version=12&outputLiquibaseSql=none&changeLogFile=/Users/jasonn/Documents/workspace/stash-repos/audit/audit-service/target/liquibase/mssql-changelog-full.csv
-- Liquibase version: 3.5.3
-- *********************************************************************

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_13_1.yml::audit1::richardj
CREATE TABLE [audit_record] ([id] [nvarchar](36) NOT NULL, [message_set_id] [nvarchar](36), [event_category] [nvarchar](35) NOT NULL, [event_action] [nvarchar](35) NOT NULL, [object_type] [nvarchar](35) NOT NULL, [actor_username] [nvarchar](64) NOT NULL, [actor_user_id] [nvarchar](36) NOT NULL, [event_time] [datetime2](7) NOT NULL, [event_desc] [nvarchar](255) NOT NULL, [legal_entity_id] [nvarchar](36), [sa_id] [nvarchar](36), CONSTRAINT [pk_audit_record] PRIMARY KEY ([id]))
GO

CREATE TABLE [ext_audit_record] ([id] [nvarchar](36) NOT NULL, [value] [nvarchar](500), [key_name] [nvarchar](50) NOT NULL, CONSTRAINT [pk_ear_id_key_name] PRIMARY KEY ([id], [key_name]))
GO

CREATE TABLE [audit_event_data] ([id] [nvarchar](36) NOT NULL, [audit_record_id] [nvarchar](36) NOT NULL, [key_name] [nvarchar](255) NOT NULL, [value] [nvarchar](255), CONSTRAINT [pk_audit_event_data] PRIMARY KEY ([id]))
GO

ALTER TABLE [ext_audit_record] ADD CONSTRAINT [fk_ear2ar] FOREIGN KEY ([id]) REFERENCES [audit_record] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION
GO

ALTER TABLE [audit_event_data] ADD CONSTRAINT [fk_aed2ar] FOREIGN KEY ([audit_record_id]) REFERENCES [audit_record] ([id]) ON UPDATE NO ACTION ON DELETE NO ACTION
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_13_1.yml::audit3::richardj
CREATE NONCLUSTERED INDEX ix_ear_id ON [ext_audit_record]([id])
GO

CREATE NONCLUSTERED INDEX ix_aed_audit_record_id ON [audit_event_data]([audit_record_id])
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_14_0.yml::audit4::richardj
-- Creates a non-nullable status column with the default value set to 'Unknown'
ALTER TABLE [audit_record] ADD [status] [nvarchar](11) CONSTRAINT DF_audit_record_status DEFAULT 'Unknown' NOT NULL
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_14_1.yml::audit5::gavin
-- Creates a nullable ipAddress column
ALTER TABLE [audit_record] ADD [ip_address] [nvarchar](45)
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_16_4.yml::audit6::jasonn
-- Creates a nullable schema_version column
ALTER TABLE [audit_record] ADD [schema_version] [nvarchar](36)
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_17_0.yml::audit7::jasonn
-- Alters the width of event_desc column to 511
ALTER TABLE [audit_record] ALTER COLUMN [event_desc] [nvarchar](511)
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_17_0.yml::audit8::jasonn
-- Creates a nullable user_agent column
ALTER TABLE [audit_record] ADD [user_agent] [nvarchar](255)
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit9::patrickn
-- Add new tables with greater efficiency
CREATE TABLE [audit_message] ([id] [bigint] NOT NULL, [status] [varchar](11) CONSTRAINT [DF_audit_message_status] DEFAULT 'Unknown' NOT NULL, [event_time] [datetime2](7) NOT NULL, [actor_user_id] [varchar](36) NOT NULL, [actor_username] [nvarchar](64) NOT NULL, [event_category] [varchar](35) NOT NULL, [object_type] [varchar](35) NOT NULL, [event_action] [varchar](35) NOT NULL, [event_desc] [nvarchar](511) NOT NULL, [message_set_id] [varchar](36), [legal_entity_id] [varchar](36), [sa_id] [varchar](36), [ip_address] [varchar](45), [user_agent] [varchar](255), [schema_version] [varchar](36), [error] [varchar](255), [metadata] [nvarchar](MAX), [additions] [nvarchar](MAX), [temp_legacy_id] [nvarchar](36))
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit10::jasonn
CREATE TABLE [sequence_table] ([sequence_name] [varchar](255) NOT NULL, [next_val] [bigint])
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit11::jasonn
-- Creates a nullable error column
ALTER TABLE [audit_record] ADD [error] [varchar](255)
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit12::jasonn
CREATE TABLE [migration_progress] ([audit_message_id] [bigint] NOT NULL, [audit_record_id] [nvarchar](36) NOT NULL, [success] [char](1), [migrated_date] [datetime2](7), CONSTRAINT [PK_MIGRATION_PROGRESS] PRIMARY KEY ([audit_record_id]))
GO

CREATE NONCLUSTERED INDEX ix_mp_success ON [migration_progress]([success])
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit13::jasonn
CREATE TABLE [migration_config] ([id] [bigint] NOT NULL, [active] [char](1) NOT NULL, [max_migrations_per_minute] [int] NOT NULL, CONSTRAINT [PK_MIGRATION_CONFIG] PRIMARY KEY ([id]))
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit14::simonf
-- partition audit_message table on Oracle
-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit15::simonf
-- partition audit_message table on MySQL
-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_0.yml::audit16::simonf
-- partition audit_message table on MSSQL
-- define partition function: partitions for whole 2020 year
CREATE PARTITION FUNCTION auditDateRangePF (datetime2)
AS RANGE RIGHT FOR VALUES ('20200101', '20200201', '20200301', '20200401', '20200501', '20200601', '20200701', '20200801', '20200901', '20201001', '20201101', '20201201', '20210101')
GO

-- define partition scheme: for simplicity of internal testing - put all partitions into Primary filegroup
-- customers can define custom filegroups and files, map partitions to filegroups to simplify backup, archiving and make improve performance by distributing IO between disk drives

CREATE PARTITION SCHEME auditPartitionScheme
AS PARTITION auditDateRangePF ALL TO ( [PRIMARY] );
GO

ALTER TABLE [audit_message]
ADD PRIMARY KEY CLUSTERED (event_time, actor_user_id, id)
ON auditPartitionScheme(event_time);
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit17::jasonn
-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit18::jasonn
CREATE TABLE [migration_progress_estimate] ([id] [bigint] NOT NULL, [success] [int] NOT NULL, [failed] [int] NOT NULL, CONSTRAINT [PK_MIGRATION_PROGRESS_ESTIMATE] PRIMARY KEY ([id]))
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_18_2.yml::audit19::jasonn
DECLARE @index_name varchar(255);
select @index_name = name from sys.indexes where name like 'PK__audit_me%'
select @index_name = 'audit_message.' + @index_name
EXEC sp_rename @index_name, 'pk_am_id_event_time_actor_user_id'
GO

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml::audit20::patrickn
-- Remove temporary migration tables
DROP TABLE [migration_progress]
GO

DROP TABLE [migration_config]
GO

