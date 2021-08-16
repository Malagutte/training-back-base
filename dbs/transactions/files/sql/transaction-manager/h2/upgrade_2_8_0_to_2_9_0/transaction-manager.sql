alter table fin_txn add counter_party_bic varchar2(11);
alter table fin_txn add counter_party_country varchar2(2);
alter table fin_txn add counter_party_bank_name varchar2(128);
alter table fin_txn add creditor_id varchar2(19);
alter table fin_txn add mandate_reference varchar2(128);