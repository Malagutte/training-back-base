ALTER TABLE fin_txn ADD counter_party_city varchar(35)
GO

ALTER TABLE fin_txn ADD counter_party_address varchar(140)
GO

ALTER TABLE fin_txn ALTER COLUMN description varchar(140)
GO