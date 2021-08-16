create table fin_txn
(
  id                           varchar(36) not null,
  arrangement_id               varchar(36) not null,
  external_id                  varchar(300),
  external_arrangement_id      varchar(50) not null,
  reference                    varchar(36),
  description                  varchar(140) not null,
  type_group                   varchar(36) not null,
  type                         varchar(36) not null,
  category                     varchar(50),
  booking_date                 date not null,
  value_date                   date,
  amount                       decimal(15, 3) not null,
  currency                     varchar(3) not null,
  credit_debit_indicator       varchar(4) not null,
  instructed_amount            decimal(15, 3),
  instructed_currency          varchar(3),
  currency_exchange_rate       decimal(15, 6),
  counter_party_name           varchar(128),
  counter_party_account_number varchar(36),
  counter_party_bic            varchar(11),
  counter_party_city           varchar(35),
  counter_party_address        varchar(140),
  counter_party_country        varchar(2),
  counter_party_bank_name      varchar(64),
  creditor_id                  varchar(19),
  mandate_reference            varchar(128),
  billing_status               varchar(8),
  check_serial_number          bigint(20),
  credit_debit_amount          DECIMAL(15, 3) NOT NULL,
  notes                        varchar(4000),
  sequence_number              DECIMAL(20, 0),
  running_balance              decimal(15, 3),
  additions                    LONGTEXT,
  creation_time                timestamp NULL,
  creation_time_offset         varchar(6) NULL,
  creation_timestamp           TIMESTAMP NULL,
  inserted_at                  timestamp NULL,
  updated_at                   timestamp NULL
);


alter table fin_txn add constraint pk_fin_txn primary key (id);
alter table fin_txn add constraint uq_external_id UNIQUE(external_id);

create table add_prop_transaction
(
  add_prop_transaction_id varchar(36) not null,
  property_value text,
  property_key varchar(50) not null,
  constraint pk_add_prop_transaction primary key (add_prop_transaction_id, property_key)
);

ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_txn FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id);

create index ix_ap_trans on add_prop_transaction(add_prop_transaction_id);
CREATE INDEX ix_arrangement ON fin_txn(arrangement_id);
CREATE INDEX ix_ext_arrangement ON fin_txn(external_arrangement_id);