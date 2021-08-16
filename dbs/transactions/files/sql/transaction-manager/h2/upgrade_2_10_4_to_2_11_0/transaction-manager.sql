ALTER TABLE fin_txn ADD credit_debit_amount DECIMAL(15, 3) NOT NULL;
ALTER TABLE fin_txn ADD notes VARCHAR2(4000);
CREATE INDEX ix_arrangement ON fin_txn(arrangement_id);