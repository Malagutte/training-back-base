create table fin_txn
  (
    id                           NVARCHAR(36) not null,
    arrangement_id               NVARCHAR(36) not null,
    external_id                  NVARCHAR(300),
    external_arrangement_id      NVARCHAR(50) not null,
    reference                    NVARCHAR(36),
    description                  NVARCHAR(140) not null,
    type_group                   NVARCHAR(36) not null,
    type                         NVARCHAR(36) not null,
    category                     NVARCHAR(50),
    booking_date                 date not null,
    value_date                   date,
    amount                       decimal(15, 3) not null,
    currency                     NVARCHAR(3) not null,
    credit_debit_indicator       NVARCHAR(4) not null,
    instructed_amount            decimal(15, 3),
    instructed_currency          NVARCHAR(3),
    currency_exchange_rate       decimal(15, 6),
    counter_party_name           NVARCHAR(128),
    counter_party_account_number NVARCHAR(36),
    counter_party_bic            NVARCHAR(11),
    counter_party_city           NVARCHAR(35),
    counter_party_address        NVARCHAR(140),
    counter_party_country        NVARCHAR(2),
    counter_party_bank_name      NVARCHAR(64),
    creditor_id                  NVARCHAR(19),
    mandate_reference            NVARCHAR(128),
    billing_status               NVARCHAR(8),
    check_serial_number          bigint,
    credit_debit_amount          DECIMAL(15, 3) NOT NULL,
    notes                        NVARCHAR(4000),
    sequence_number              DECIMAL(20, 0),
    running_balance              DECIMAL(15, 3),
    additions                    NVARCHAR(MAX),
    creation_time                datetime,
    creation_time_offset         NVARCHAR(6),
    creation_timestamp           datetime,
    inserted_at                  datetime NULL,
    updated_at                   datetime
)
GO

alter table fin_txn add constraint pk_fin_txn primary key (id)
GO

alter table fin_txn add constraint uq_external_id UNIQUE (external_id);
GO

create table add_prop_transaction
  (
    add_prop_transaction_id NVARCHAR(36) not null,
    property_value NVARCHAR(MAX),
    property_key NVARCHAR(50) not null,
    constraint pk_add_prop_transaction primary key (add_prop_transaction_id, property_key)
  )
GO

ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_txn FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn(id)
GO

create index ix_ap_trans on add_prop_transaction(add_prop_transaction_id)
GO

CREATE INDEX ix_arrangement ON fin_txn(arrangement_id)
GO

CREATE INDEX ix_ext_arrangement ON fin_txn(external_arrangement_id);
GO