alter table fin_txn add counter_party_bic varchar(11);
alter table fin_txn add counter_party_country varchar(2);
alter table fin_txn add counter_party_bank_name varchar(128);
alter table fin_txn add creditor_id varchar(19);
alter table fin_txn add mandate_reference varchar(128);