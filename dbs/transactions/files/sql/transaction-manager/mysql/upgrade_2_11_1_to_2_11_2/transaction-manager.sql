ALTER TABLE fin_txn ADD running_balance decimal(15,3);
ALTER TABLE fin_txn MODIFY external_id VARCHAR2(300);