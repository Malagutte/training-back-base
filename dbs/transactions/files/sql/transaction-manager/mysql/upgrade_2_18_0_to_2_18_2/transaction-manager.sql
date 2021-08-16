ALTER TABLE fin_txn ADD counter_party_city VARCHAR(35) NULL, ADD counter_party_address VARCHAR(140) NULL;
ALTER TABLE fin_txn MODIFY description VARCHAR(140);
