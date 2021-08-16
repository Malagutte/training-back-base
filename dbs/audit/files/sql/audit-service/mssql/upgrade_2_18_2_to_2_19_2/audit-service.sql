-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml
-- Ran at: 04/09/20 08:18
-- Against: null@offline:mssql?version=12&outputLiquibaseSql=none&changeLogFile=/Users/jasonn/Documents/workspace/stash-repos/audit/audit-service/target/liquibase/mssql-changelog.csv
-- Liquibase version: 3.5.3
-- *********************************************************************

-- Changeset src/main/resources/db/changelog/db.changelog-audit-2_19_2.yml::audit20::patrickn
-- Remove temporary migration tables
DROP TABLE [migration_progress]
GO

DROP TABLE [migration_config]
GO

