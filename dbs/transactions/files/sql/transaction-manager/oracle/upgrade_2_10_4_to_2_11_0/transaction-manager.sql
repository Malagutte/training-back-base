ALTER TABLE fin_txn ADD credit_debit_amount DECIMAL(15, 3);
UPDATE fin_txn SET credit_debit_amount = amount WHERE credit_debit_indicator='CRDT';
UPDATE fin_txn SET credit_debit_amount = -amount WHERE credit_debit_indicator='DBIT';
ALTER TABLE fin_txn MODIFY credit_debit_amount DECIMAL(15, 3) NOT NULL;
ALTER TABLE fin_txn ADD notes VARCHAR2(4000);
CREATE INDEX ix_arrangement ON fin_txn(arrangement_id);