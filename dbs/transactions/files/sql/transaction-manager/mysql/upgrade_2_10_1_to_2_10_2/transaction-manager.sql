-- drop constraints
ALTER TABLE add_prop_transaction DROP FOREIGN KEY fk_add_prop_tran2fin_txn;
-- alter id columns
ALTER TABLE add_prop_transaction MODIFY add_prop_transaction_id VARCHAR(36) NOT NULL;
ALTER TABLE fin_txn MODIFY id VARCHAR(36) NOT NULL;
-- set constraints
ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_txn FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id);

ALTER TABLE fin_txn MODIFY arrangement_id VARCHAR(36) NOT NULL;
ALTER TABLE fin_txn MODIFY external_id VARCHAR(50);
ALTER TABLE fin_txn MODIFY external_arrangement_id VARCHAR(50) NOT NULL;
ALTER TABLE fin_txn MODIFY reference VARCHAR(36) NOT NULL;
ALTER TABLE fin_txn MODIFY description VARCHAR(128) NOT NULL;
ALTER TABLE fin_txn MODIFY type_group VARCHAR(36) NOT NULL;
ALTER TABLE fin_txn MODIFY type VARCHAR(36) NOT NULL;
ALTER TABLE fin_txn MODIFY category VARCHAR(50);
ALTER TABLE fin_txn MODIFY amount DECIMAL(15, 3) NOT NULL;
ALTER TABLE fin_txn MODIFY currency VARCHAR(3) NOT NULL;
ALTER TABLE fin_txn MODIFY credit_debit_indicator VARCHAR(4) NOT NULL;
ALTER TABLE fin_txn MODIFY instructed_amount DECIMAL(15, 3);
ALTER TABLE fin_txn MODIFY instructed_currency VARCHAR(3);
ALTER TABLE fin_txn MODIFY currency_exchange_rate DECIMAL(15, 6);
ALTER TABLE fin_txn MODIFY counter_party_name VARCHAR(128) NOT NULL;
ALTER TABLE fin_txn MODIFY counter_party_account_number VARCHAR(36);
ALTER TABLE fin_txn MODIFY counter_party_bank_name VARCHAR(64);

ALTER TABLE fin_txn ADD billing_status VARCHAR(8);