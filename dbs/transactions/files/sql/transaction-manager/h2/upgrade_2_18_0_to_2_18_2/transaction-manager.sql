SET DEFINE OFF;
ALTER TABLE fin_txn ADD counter_party_city VARCHAR2(35);
ALTER TABLE fin_txn ADD counter_party_address VARCHAR2(140);
ALTER TABLE fin_txn MODIFY description VARCHAR2(140);