alter table [fin_txn] add counter_party_bic NVARCHAR(11)
go
alter table [fin_txn] add counter_party_country NVARCHAR(2)
go
alter table [fin_txn] add counter_party_bank_name NVARCHAR(128)
go
alter table [fin_txn] add creditor_id NVARCHAR(19)
go
alter table [fin_txn] add mandate_reference NVARCHAR(128)
go