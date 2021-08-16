ALTER TABLE fin_txn ADD sequence_number DECIMAL(20);
ALTER TABLE fin_txn ALTER COLUMN reference VARCHAR(36);
ALTER TABLE fin_txn ALTER COLUMN counter_party_name VARCHAR(128);
ALTER TABLE fin_txn ADD CONSTRAINT uq_external_id UNIQUE (external_id);