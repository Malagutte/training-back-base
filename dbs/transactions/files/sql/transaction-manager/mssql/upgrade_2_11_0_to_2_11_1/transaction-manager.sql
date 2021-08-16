ALTER TABLE fin_txn ADD sequence_number NUMERIC(20)
GO

ALTER TABLE fin_txn ALTER COLUMN reference NVARCHAR(36)
GO

ALTER TABLE fin_txn ALTER COLUMN counter_party_name NVARCHAR(128)
GO

DECLARE @uq_ext NVARCHAR(30)
DECLARE @Command NVARCHAR(255)
SET @uq_ext = (SELECT name
FROM sys.objects WHERE type = 'UQ' AND OBJECT_NAME(parent_object_id) = 'fin_txn')
SELECT @Command = 'ALTER TABLE fin_txn drop constraint '+@uq_ext
execute (@Command)
GO

alter table fin_txn add constraint uq_external_id UNIQUE (external_id);
GO
