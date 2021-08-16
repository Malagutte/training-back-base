ALTER TABLE fin_txn ADD sequence_number bigint(20);
ALTER TABLE fin_txn MODIFY reference varchar(36);
ALTER TABLE fin_txn MODIFY counter_party_name varchar(128);
ALTER TABLE fin_txn DROP INDEX external_id;
alter table fin_txn add constraint uq_external_id UNIQUE(external_id);