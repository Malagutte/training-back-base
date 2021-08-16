DROP INDEX ix_ap_trans;

ALTER TABLE add_prop_transaction ALTER COLUMN add_prop_transaction_id VARCHAR2(255) NOT NULL;

ALTER TABLE add_prop_transaction ALTER COLUMN property_key VARCHAR2(50) NOT NULL;

ALTER TABLE add_prop_transaction ADD CONSTRAINT pk_add_prop_transaction PRIMARY KEY (add_prop_transaction_id, property_key);

ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_tx FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id);

CREATE INDEX ix_ap_trans ON add_prop_transaction(add_prop_transaction_id);