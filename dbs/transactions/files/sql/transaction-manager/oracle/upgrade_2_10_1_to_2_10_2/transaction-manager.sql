-- drop constraints
DROP INDEX ix_ap_trans_01;
ALTER TABLE add_prop_transaction DROP CONSTRAINT fk_add_prop_tran2fin_txn;
ALTER TABLE add_prop_transaction DROP PRIMARY KEY;
ALTER TABLE fin_txn DROP PRIMARY KEY;
-- alter id columns
ALTER TABLE add_prop_transaction MODIFY add_prop_transaction_id VARCHAR(36);
ALTER TABLE fin_txn MODIFY id VARCHAR2(36);
-- set constraints
ALTER TABLE fin_txn ADD CONSTRAINT pk_fin_txn PRIMARY KEY (id);
ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_txn FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id);
ALTER TABLE add_prop_transaction ADD CONSTRAINT pk_add_prop_transaction PRIMARY KEY (add_prop_transaction_id, property_key);
CREATE INDEX ix_ap_trans_01 ON add_prop_transaction(add_prop_transaction_id);

ALTER TABLE fin_txn MODIFY arrangement_id VARCHAR2(36);
ALTER TABLE fin_txn MODIFY external_id VARCHAR2(50);
ALTER TABLE fin_txn MODIFY external_arrangement_id VARCHAR2(50);
ALTER TABLE fin_txn MODIFY reference VARCHAR2(36);
ALTER TABLE fin_txn MODIFY description VARCHAR2(128);
ALTER TABLE fin_txn MODIFY type_group VARCHAR2(36);
ALTER TABLE fin_txn MODIFY type VARCHAR2(36);
ALTER TABLE fin_txn MODIFY category VARCHAR2(50);
ALTER TABLE fin_txn MODIFY amount DECIMAL(15, 3);
ALTER TABLE fin_txn MODIFY currency VARCHAR2(3);
ALTER TABLE fin_txn MODIFY credit_debit_indicator VARCHAR2(4);
ALTER TABLE fin_txn MODIFY instructed_amount DECIMAL(15, 3);
ALTER TABLE fin_txn MODIFY instructed_currency VARCHAR2(3);
ALTER TABLE fin_txn MODIFY currency_exchange_rate DECIMAL(15, 6);
ALTER TABLE fin_txn MODIFY counter_party_name VARCHAR2(128);
ALTER TABLE fin_txn MODIFY counter_party_account_number VARCHAR2(36);
ALTER TABLE fin_txn MODIFY counter_party_bank_name VARCHAR2(64);

ALTER TABLE fin_txn ADD billing_status VARCHAR2(8);