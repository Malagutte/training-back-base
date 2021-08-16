-- drop constraints
DROP INDEX add_prop_transaction.ix_ap_trans
GO
ALTER TABLE add_prop_transaction DROP CONSTRAINT fk_add_prop_tran2fin_txn;
GO
ALTER TABLE add_prop_transaction DROP CONSTRAINT pk_add_prop_transaction;
GO
ALTER TABLE fin_txn DROP CONSTRAINT pk_fin_txn;
GO
-- alter id columns
ALTER TABLE add_prop_transaction ALTER COLUMN add_prop_transaction_id NVARCHAR(36) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN id NVARCHAR(36) NOT NULL
GO
-- set constraints
ALTER TABLE fin_txn ADD CONSTRAINT pk_fin_txn PRIMARY KEY (id)
GO
ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_txn FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id)
GO
ALTER TABLE add_prop_transaction ADD CONSTRAINT pk_add_prop_transaction PRIMARY KEY (add_prop_transaction_id, property_key)
GO
CREATE INDEX ix_ap_trans ON add_prop_transaction(add_prop_transaction_id)
GO

ALTER TABLE fin_txn ALTER COLUMN arrangement_id NVARCHAR(36) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN external_id NVARCHAR(50)
GO
ALTER TABLE fin_txn ALTER COLUMN external_arrangement_id NVARCHAR(50) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN reference NVARCHAR(36) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN [description] NVARCHAR(128) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN type_group NVARCHAR(36) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN [type] NVARCHAR(36) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN category NVARCHAR(50)
GO
ALTER TABLE fin_txn ALTER COLUMN amount DECIMAL(15, 3) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN currency NVARCHAR(3) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN credit_debit_indicator NVARCHAR(4) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN instructed_amount DECIMAL(15, 3)
GO
ALTER TABLE fin_txn ALTER COLUMN instructed_currency NVARCHAR(3)
GO
ALTER TABLE fin_txn ALTER COLUMN currency_exchange_rate DECIMAL(15, 6)
GO
ALTER TABLE fin_txn ALTER COLUMN counter_party_name NVARCHAR(128) NOT NULL
GO
ALTER TABLE fin_txn ALTER COLUMN counter_party_account_number NVARCHAR(36)
GO
ALTER TABLE fin_txn ALTER COLUMN counter_party_bank_name NVARCHAR(64)
GO


ALTER TABLE fin_txn ADD billing_status NVARCHAR(8)
GO