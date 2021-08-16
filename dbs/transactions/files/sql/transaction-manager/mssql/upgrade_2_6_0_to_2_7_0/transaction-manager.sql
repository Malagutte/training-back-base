alter table [transaction] drop column product_id
go
exec sp_rename [transaction], [fin_txn]
go
alter table [fin_txn] drop constraint pk_transaction
go
alter table [fin_txn] add constraint pk_fin_txn primary key (id)
go