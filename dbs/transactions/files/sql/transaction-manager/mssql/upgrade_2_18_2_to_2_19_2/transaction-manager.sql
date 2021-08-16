SET DEFINE OFF;
ALTER TABLE fin_txn ADD creation_time datetime
GO

ALTER TABLE fin_txn ADD creation_time_offset nvarchar(6)
GO

ALTER TABLE fin_txn ADD creation_timestamp datetime
GO

ALTER TABLE fin_txn ADD inserted_at datetime NULL
GO

ALTER TABLE fin_txn ADD updated_at datetime
GO

ALTER TABLE fin_txn ALTER COLUMN counter_party_city NVARCHAR(35)
GO

ALTER TABLE fin_txn ALTER COLUMN counter_party_address NVARCHAR(140)
GO