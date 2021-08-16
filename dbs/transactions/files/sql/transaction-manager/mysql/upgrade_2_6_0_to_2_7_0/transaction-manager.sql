alter table transaction DROP COLUMN product_id;
rename table transaction to fin_txn;
alter table fin_txn DROP primary key;
alter table fin_txn add constraint pk_fin_txn primary key (id);