ALTER TABLE fin_txn ADD UNIQUE (external_id);
ALTER TABLE fin_txn MODIFY booking_date datetime;