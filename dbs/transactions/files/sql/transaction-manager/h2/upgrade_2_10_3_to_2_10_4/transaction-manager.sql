ALTER TABLE fin_txn ADD UNIQUE (external_id);
alter table fin_txn alter column booking_date datetime;