SET DEFINE OFF;
ALTER TABLE fin_txn ADD creation_time TIMESTAMP;
ALTER TABLE fin_txn ADD creation_time_offset VARCHAR2(6);
ALTER TABLE fin_txn ADD creation_timestamp TIMESTAMP;
ALTER TABLE fin_txn ADD inserted_at TIMESTAMP NULL;
ALTER TABLE fin_txn ADD updated_at TIMESTAMP;