ALTER TABLE fin_txn ADD UNIQUE (external_id)
GO
ALTER TABLE fin_txn ALTER COLUMN booking_date datetime
GO