ALTER TABLE fin_txn ADD sequence_number NUMBER(20);
ALTER TABLE fin_txn MODIFY reference VARCHAR2(36) NULL;
ALTER TABLE fin_txn MODIFY counter_party_name VARCHAR2(128) NULL;
ALTER TABLE fin_txn DROP UNIQUE(external_id);
ALTER TABLE fin_txn ADD CONSTRAINT uq_external_id UNIQUE (external_id);
