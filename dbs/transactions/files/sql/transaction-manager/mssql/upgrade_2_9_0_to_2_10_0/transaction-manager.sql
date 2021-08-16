DROP INDEX add_prop_transaction.ix_ap_trans
GO

ALTER TABLE add_prop_transaction ALTER COLUMN add_prop_transaction_id NVARCHAR(255) NOT NULL
GO

ALTER TABLE add_prop_transaction ALTER COLUMN property_key NVARCHAR(50) NOT NULL
GO

ALTER TABLE add_prop_transaction ADD CONSTRAINT pk_add_prop_transaction PRIMARY KEY (add_prop_transaction_id, property_key)
GO

ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_txn FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id)
GO

CREATE INDEX ix_ap_trans ON add_prop_transaction(add_prop_transaction_id)
GO