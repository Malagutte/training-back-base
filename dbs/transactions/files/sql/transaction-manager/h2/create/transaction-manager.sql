CREATE TABLE fin_txn
(
  id                           VARCHAR(36)   NOT NULL,
  arrangement_id               VARCHAR(36)   NOT NULL,
  external_id                  VARCHAR(300),
  external_arrangement_id      VARCHAR(50)   NOT NULL,
  reference                    VARCHAR(36),
  description                  VARCHAR(140)   NOT NULL,
  type_group                   VARCHAR(36)   NOT NULL,
  type                         VARCHAR(36)   NOT NULL,
  category                     VARCHAR(50),
  booking_date                 DATE          NOT NULL,
  value_date                   DATE,
  amount                       DECIMAL(15, 3) NOT NULL,
  currency                     VARCHAR(3)   NOT NULL,
  credit_debit_indicator       VARCHAR(4)   NOT NULL,
  instructed_amount            DECIMAL(15, 3),
  instructed_currency          VARCHAR(3),
  currency_exchange_rate       DECIMAL(15, 6),
  counter_party_name           VARCHAR(128),
  counter_party_account_number VARCHAR(36),
  counter_party_bic            VARCHAR(11),
  counter_party_city           VARCHAR(35),
  counter_party_address        VARCHAR(140),
  counter_party_country        VARCHAR(2),
  counter_party_bank_name      VARCHAR(64),
  creditor_id                  VARCHAR(19),
  mandate_reference            VARCHAR(128),
  billing_status               VARCHAR(8),
  check_serial_number          BIGINT(20),
  credit_debit_amount          DECIMAL(15, 3) NOT NULL,
  notes                        VARCHAR(4000),
  sequence_number              DECIMAL(20, 0),
  running_balance              DECIMAL(19, 2),
  additions                    CLOB,
  creation_time                TIMESTAMP,
  creation_time_offset         VARCHAR(6),
  creation_timestamp           TIMESTAMP,
  inserted_at                  TIMESTAMP NULL,
  updated_at                   TIMESTAMP
);

ALTER TABLE fin_txn ADD CONSTRAINT pk_fin_txn PRIMARY KEY (id);
ALTER TABLE fin_txn ADD CONSTRAINT uq_external_id UNIQUE (external_id);

CREATE TABLE add_prop_transaction
(
  add_prop_transaction_id VARCHAR(36) NOT NULL,
  property_value          TEXT,
  property_key            VARCHAR(50)  NOT NULL,
  CONSTRAINT pk_add_prop_arrangement PRIMARY KEY (add_prop_transaction_id, property_key)
);

ALTER TABLE add_prop_transaction ADD CONSTRAINT fk_add_prop_tran2fin_txn FOREIGN KEY (add_prop_transaction_id) REFERENCES fin_txn (id);

CREATE INDEX ix_ap_trans ON add_prop_transaction (add_prop_transaction_id);
CREATE INDEX ix_arrangement ON fin_txn(arrangement_id);
CREATE INDEX ix_ext_arrangement ON fin_txn(external_arrangement_id);
