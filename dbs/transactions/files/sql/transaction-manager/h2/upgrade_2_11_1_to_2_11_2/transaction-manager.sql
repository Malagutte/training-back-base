ALTER TABLE fin_txn ADD running_balance DECIMAL(19,2);
ALTER TABLE fin_txn ALTER COLUMN external_id VARCHAR(300);