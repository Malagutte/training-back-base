ALTER TABLE fin_txn ADD credit_debit_amount DECIMAL(15, 3)
GO
UPDATE fin_txn SET credit_debit_amount = amount WHERE credit_debit_indicator='CRDT'
GO
UPDATE fin_txn SET credit_debit_amount = -amount WHERE credit_debit_indicator='DBIT'
GO
ALTER TABLE fin_txn ALTER COLUMN credit_debit_amount DECIMAL(15, 3) NOT NULL
GO
ALTER TABLE fin_txn ADD notes NVARCHAR(4000)
GO
CREATE INDEX ix_arrangement ON fin_txn(arrangement_id)
GO
