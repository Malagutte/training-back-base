ALTER TABLE fin_txn ADD running_balance DECIMAL(15,3)
GO
ALTER TABLE fin_txn ALTER COLUMN external_id NVARCHAR(300)
GO