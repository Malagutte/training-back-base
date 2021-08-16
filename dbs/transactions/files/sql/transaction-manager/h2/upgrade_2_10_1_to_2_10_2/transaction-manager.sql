-- drop constraints
DROP INDEX ix_ap_trans;
ALTER TABLE add_prop_transaction DROP CONSTRAINT fk_add_prop_tran2fin_tx;
ALTER TABLE add_prop_transaction DROP CONSTRAINT pk_add_prop_transaction;
ALTER TABLE fin_txn DROP CONSTRAINT pk_fin_txn;
-- alter id columns
ALTER TABLE add_prop_transaction ALTER COLUMN add_prop_transaction_id VARCHAR(36);
ALTER TABLE fin_txn ALTER COLUMN id VARCHAR(36);
-- set constraints
ALTER TABLE add_prop_transaction ADD CONSTRAINT pk_add_prop_transaction PRIMARY KEY (add_prop_transaction_id, property_key);
ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_tx FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id);
ALTER TABLE fin_txn ADD CONSTRAINT pk_fin_txn PRIMARY KEY (id);
CREATE INDEX ix_ap_trans ON add_prop_transaction(add_prop_transaction_id);

ALTER TABLE fin_txn ALTER COLUMN arrangement_id VARCHAR2(36);
ALTER TABLE fin_txn ALTER COLUMN external_id VARCHAR2(50);
ALTER TABLE fin_txn ALTER COLUMN external_arrangement_id VARCHAR2(50);
ALTER TABLE fin_txn ALTER COLUMN reference VARCHAR2(36);
ALTER TABLE fin_txn ALTER COLUMN description VARCHAR2(128);
ALTER TABLE fin_txn ALTER COLUMN type_group VARCHAR2(36);
ALTER TABLE fin_txn ALTER COLUMN type VARCHAR2(36);
ALTER TABLE fin_txn ALTER COLUMN category VARCHAR2(50);
ALTER TABLE fin_txn ALTER COLUMN amount DECIMAL(15, 3);
ALTER TABLE fin_txn ALTER COLUMN currency VARCHAR2(3);
ALTER TABLE fin_txn ALTER COLUMN credit_debit_indicator VARCHAR2(4);
ALTER TABLE fin_txn ALTER COLUMN instructed_amount DECIMAL(15, 3);
ALTER TABLE fin_txn ALTER COLUMN instructed_currency VARCHAR2(3);
ALTER TABLE fin_txn ALTER COLUMN currency_exchange_rate DECIMAL(15, 6);
ALTER TABLE fin_txn ALTER COLUMN counter_party_name VARCHAR2(128);
ALTER TABLE fin_txn ALTER COLUMN counter_party_account_number VARCHAR2(36);
ALTER TABLE fin_txn ALTER COLUMN counter_party_bank_name VARCHAR2(64);

ALTER TABLE fin_txn ADD billing_status VARCHAR2(8);
