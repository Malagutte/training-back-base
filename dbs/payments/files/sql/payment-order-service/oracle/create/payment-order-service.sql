-- ------------------------------------
-- Payment order table from PandP
-- Reference class:
--  - com.backbase.pandp.order.domain.order.PaymentOrder
-- ------------------------------------
CREATE TABLE pmt_order
(
  id                       VARCHAR2(36)  NOT NULL,
  internal_user_id         VARCHAR2(36)  NULL,
  bank_reference_id        VARCHAR2(64)  NULL,
  payment_setup_id         VARCHAR2(128) NULL,
  payment_submission_id    VARCHAR2(128) NULL,
  amount                   NUMBER(23,5)  NULL,
  currency                 VARCHAR2(3)   NULL,
  status                   VARCHAR2(64)  NULL,
  bank_status              VARCHAR2(35)  NULL,
  rejection_reason         VARCHAR2(128) NULL,
  pmt_mode                 VARCHAR2(45)  NULL,
  pmt_type                 VARCHAR2(22)  NULL,
  priority                 VARCHAR2(45)  NULL,
  batch                    CHAR(1)       NULL,
  requested_exec_date      DATE          NULL,
  reason_code              VARCHAR2(4)   NULL,
  reason_text              VARCHAR2(35)  NULL,
  error_description        VARCHAR2(105) NULL,
  created_at               TIMESTAMP(6)  NULL,
  updated_at               TIMESTAMP(6)  NULL,
  created_by               VARCHAR2(36)  NULL,
  updated_by               VARCHAR2(36)  NULL,
  start_date               DATE          NULL,
  end_date                 DATE          NULL,
  next_execution_date      DATE          NULL,
  frequency                VARCHAR2(9)   NULL,
  non_working_day_strategy VARCHAR2(6)   NULL,
  every                    VARCHAR2(10)  NULL,
  when_execute             NUMBER(38)    NULL,
  repetition               NUMBER(38)    NULL,
  role                     VARCHAR2(32)  NULL,
  arrangement_id           VARCHAR2(36)  NULL,
  ext_arrangement_id       VARCHAR2(70)  NULL,
  account_scheme           VARCHAR2(11)  NULL,
  account                  VARCHAR2(36)  NULL,
  name                     VARCHAR2(140) NULL,
  address_line1            VARCHAR2(70)  NULL,
  address_line2            VARCHAR2(70)  NULL,
  street_name              VARCHAR2(70)  NULL,
  post_code                VARCHAR2(16)  NULL,
  country_sub_division     VARCHAR2(35)  NULL,
  town                     VARCHAR2(35)  NULL,
  country                  VARCHAR2(2)   NULL,
  approval_id              VARCHAR2(36)  NULL,
  entry_class              VARCHAR2(3)   NULL,
  intra_legal_entity       CHAR(1)       NULL,
  service_agreement_id     VARCHAR2(36)  NULL,
  orig_acc_currency        VARCHAR2(3)   NULL,
  confirmation_id          VARCHAR2(36)  NULL,
  additions                NCLOB         NULL,
  CONSTRAINT pk_pmt_order PRIMARY KEY (id),
  CONSTRAINT ck_pmt_order_01 CHECK (batch IN ('0', '1')),
  CONSTRAINT ck_pmt_order_int_leg_ent CHECK (intra_legal_entity IN ('0', '1'))
) ;

-- Index for pmt_order

CREATE INDEX ix_pmt_order_03 ON pmt_order (bank_reference_id ASC);
CREATE INDEX ix_pmt_order_04 ON pmt_order (internal_user_id  ASC);
CREATE INDEX ix_pmt_order_05 ON pmt_order (arrangement_id    ASC);


-- ------------------------------------
-- Transaction table from PandP
-- Reference class:
--  - com.backbase.pandp.order.domain.order.Transaction
-- ------------------------------------
CREATE TABLE pmt_txn
(
  id                   VARCHAR2(36)  NOT NULL,
  pmt_order_id         VARCHAR2(36)  NULL,
  amount               NUMBER(23,5)  NULL,
  currency             VARCHAR2(3)   NULL,
  e2e_id               VARCHAR2(35)  NULL,
  role                 VARCHAR2(32)  NULL,
  arrangement_id       VARCHAR2(36)  NULL,
  ext_arrangement_id   VARCHAR2(70)  NULL,
  account_scheme       VARCHAR2(11)  NULL,
  account              VARCHAR2(36)  NULL,
  account_type         VARCHAR2(10)  NULL,
  recipient_id         VARCHAR2(15)  NULL,
  name                 VARCHAR2(140) NULL,
  address_line1        VARCHAR2(70)  NULL,
  address_line2        VARCHAR2(70)  NULL,
  street_name          VARCHAR2(70)  NULL,
  post_code            VARCHAR2(16)  NULL,
  country_sub_division VARCHAR2(35)  NULL,
  town                 VARCHAR2(35)  NULL,
  country              VARCHAR2(2)   NULL,
  type                 VARCHAR2(45)  NULL,
  content              VARCHAR2(140) NULL,
  cp_bn_addr_ln1      VARCHAR2(70)  NULL,
  cp_bn_addr_ln2      VARCHAR2(70)  NULL,
  cp_bn_str_name      VARCHAR2(70)  NULL,
  cp_bn_post_code     VARCHAR2(16)  NULL,
  cp_bn_c_sb_div      VARCHAR2(35)  NULL,
  cp_bn_town          VARCHAR2(35)  NULL,
  cp_bn_country       VARCHAR2(2)   NULL,
  cp_bn_br_code       VARCHAR2(11)  NULL,
  cp_bn_name          VARCHAR2(140) NULL,
  cp_bn_bic           VARCHAR2(11)  NULL,
  cor_bn_addr_ln1      VARCHAR2(70)  NULL,
  cor_bn_addr_ln2      VARCHAR2(70)  NULL,
  cor_bn_str_name      VARCHAR2(70)  NULL,
  cor_bn_post_code     VARCHAR2(16)  NULL,
  cor_bn_c_sb_div      VARCHAR2(35)  NULL,
  cor_bn_town          VARCHAR2(35)  NULL,
  cor_bn_country       VARCHAR2(2)   NULL,
  cor_bn_br_code       VARCHAR2(11)  NULL,
  cor_bn_name          VARCHAR2(140) NULL,
  cor_bn_bic           VARCHAR2(11)  NULL,
  itm_bn_addr_ln1      VARCHAR2(70)  NULL,
  itm_bn_addr_ln2      VARCHAR2(70)  NULL,
  itm_bn_str_name      VARCHAR2(70)  NULL,
  itm_bn_post_code     VARCHAR2(16)  NULL,
  itm_bn_c_sb_div      VARCHAR2(35)  NULL,
  itm_bn_town          VARCHAR2(35)  NULL,
  itm_bn_country       VARCHAR2(2)   NULL,
  itm_bn_br_code       VARCHAR2(11)  NULL,
  itm_bn_name          VARCHAR2(140) NULL,
  itm_bn_bic           VARCHAR2(11)  NULL,
  message_to_bank      VARCHAR2(140) NULL,
  target_currency      VARCHAR2(3)   NULL,
  additions            NCLOB         NULL,
  mandate_id           VARCHAR2(15)  NULL,
  charge_bearer        VARCHAR2(3)   NULL,
  fee_amount           NUMBER(23,5)  NULL,
  fee_currency         VARCHAR2(3)   NULL,
  exc_rate_currency    VARCHAR2(3)   NULL,
  exc_rate             NUMBER(23,5)  NULL,
  exc_rate_type        VARCHAR2(35)  NULL,
  exc_rate_contract_id VARCHAR2(256) NULL,
  CONSTRAINT pk_pmt_txn PRIMARY KEY (id),
  CONSTRAINT fk_pmt_txn2pmt_order_01     FOREIGN KEY (pmt_order_id) REFERENCES pmt_order (id)
);

-- Indexes for pmt_txn
CREATE INDEX ix_pmt_txn_02
  ON pmt_txn (pmt_order_id);

CREATE INDEX ix_pmt_txn_04
  ON pmt_txn (arrangement_id);

-- ----------------------------
-- table structure for pmt_order_add_prop
-- ----------------------------
CREATE TABLE pmt_order_add_prop (
  payment_id     VARCHAR2(36 BYTE) NOT NULL ,
  property_key   VARCHAR2(50 BYTE) NOT NULL ,
  property_value CLOB              NULL ,
  CONSTRAINT pk_pmt_order_add_prop       PRIMARY KEY (payment_id, property_key),
  CONSTRAINT fk_pmt_ord_add_prop2pmt_ord FOREIGN KEY (payment_id) REFERENCES pmt_order (id) ON DELETE CASCADE
);

-- ----------------------------
-- table structure for pmt_txn_add_prop
-- ----------------------------
CREATE TABLE pmt_txn_add_prop (
  txn_id         VARCHAR2(36 BYTE) NOT NULL ,
  property_key   VARCHAR2(50 BYTE) NOT NULL ,
  property_value CLOB              NULL ,
  CONSTRAINT pk_pmt_txn_add_prop         PRIMARY KEY (txn_id, property_key),
  CONSTRAINT fk_pmt_txn_add_prop2pmt_txn FOREIGN KEY (txn_id) REFERENCES pmt_txn (id) ON DELETE CASCADE
);

-- ------------------------------------
-- Batch Upload table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchUpload
-- ------------------------------------

CREATE SEQUENCE batch_upload_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE batch_upload
(
  id                   NUMBER(38, 0)  NOT NULL,
  external_key         VARCHAR2(36)   NOT NULL,
  file_name            NVARCHAR2(255) NOT NULL,
  file_last_modified   TIMESTAMP,
  reported_bytes       NUMBER(38, 0)  NOT NULL,
  received_bytes       NUMBER(38, 0)  NOT NULL,
  created_by           VARCHAR2(36)   NOT NULL,
  service_agreement_id VARCHAR2(36)   NOT NULL,
  started_at           TIMESTAMP      NOT NULL,
  digest_algorithm     VARCHAR2(12),
  digest               VARCHAR2(64),
  ended_at             TIMESTAMP,
  file_type            VARCHAR2(40),
  batch_count          INTEGER,
  status               VARCHAR2(10)   NOT NULL,
  raw_data             NCLOB,
  additions            NCLOB,
  CONSTRAINT pk_batch_upload PRIMARY KEY (id),
  CONSTRAINT uq_batch_upload_external_key UNIQUE (external_key)
);

CREATE INDEX ix_batch_upload_said_size ON batch_upload(service_agreement_id, reported_bytes);

-- ------------------------------------
-- Batch Upload Error table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchError
-- ------------------------------------

CREATE SEQUENCE batch_error_seq START WITH 1 INCREMENT BY 5;

CREATE TABLE batch_error
(
  id              NUMBER(38, 0) NOT NULL,
  batch_upload_id NUMBER(38, 0) NOT NULL,
  error_code      VARCHAR2(100),
  error_message   VARCHAR2(255),
  parameters      NCLOB,
  CONSTRAINT pk_batch_error PRIMARY KEY (id),
  CONSTRAINT fk_batch_error2batch_upload FOREIGN KEY (batch_upload_id) REFERENCES batch_upload (id) ON DELETE CASCADE
);

-- ------------------------------------
-- Batch Order table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchOrder
-- ------------------------------------

CREATE SEQUENCE batch_order_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE batch_order
(
  id                       NUMBER(38, 0) NOT NULL,
  batch_upload_id          NUMBER(38, 0),
  external_key             VARCHAR2(36)  NOT NULL,
  account_scheme           VARCHAR2(11),
  account_number           VARCHAR2(36),
  account_name             VARCHAR2(50),
  bank_branch_code         VARCHAR2(11),
  arrangement_id           VARCHAR2(36),
  company_id               VARCHAR2(36),
  company_name             NVARCHAR2(140),
  requested_execution_date date          NOT NULL,
  currency                 CHAR(3),
  total_amount             DECIMAL(23, 5),
  transactions_count       INTEGER,
  batch_order_type         VARCHAR2(40)  NOT NULL,
  entry_class              VARCHAR2(3),
  batch_name               NVARCHAR2(256),
  status                   VARCHAR2(12)  NOT NULL,
  approval_id              VARCHAR2(36),
  bank_status              VARCHAR2(35),
  rejection_reason         VARCHAR2(128),
  reason_code              VARCHAR2(4),
  reason_text              VARCHAR2(35),
  updated_at               TIMESTAMP,
  created_at               TIMESTAMP,
  created_by               VARCHAR2(36),
  raw_data                 NCLOB,
  additions                NCLOB,
  CONSTRAINT pk_batch_order PRIMARY KEY (id),
  CONSTRAINT fk_batch_order2batch_upload FOREIGN KEY (batch_upload_id) REFERENCES batch_upload (id) ON DELETE SET NULL,
  CONSTRAINT uq_batch_order_external_key UNIQUE (external_key)
);

-- ------------------------------------
-- Batch Transaction table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchTransaction
-- ------------------------------------

CREATE SEQUENCE batch_transaction_seq START WITH 1 INCREMENT BY 100;

CREATE TABLE batch_transaction
(
  id                          NUMBER(38, 0)  NOT NULL,
  batch_order_id              NUMBER(38, 0)  NOT NULL,
  external_key                VARCHAR2(36)   NOT NULL,
  counterparty_name           NVARCHAR2(140),
  counterparty_account_number VARCHAR2(36)   NOT NULL,
  counterparty_bank_branch_code VARCHAR2(11),
  credit_debit_indicator      VARCHAR2(6),
  currency                    CHAR(3)        NOT NULL,
  amount                      DECIMAL(23, 5) NOT NULL,
  description                 VARCHAR2(140),
  reference                   VARCHAR2(35),
  transaction_code            VARCHAR2(4),
  bank_status                 VARCHAR2(35),
  rejection_reason            VARCHAR2(128),
  reason_code                 VARCHAR2(4),
  reason_text                 VARCHAR2(35),
  status                      VARCHAR2(12),
  hidden                      NUMBER(1) DEFAULT 0 NOT NULL,
  raw_data                    NCLOB,
  additions                   NCLOB,
  CONSTRAINT pk_batch_transaction PRIMARY KEY (id),
  CONSTRAINT uq_batch_txn_orderid_extkey UNIQUE (batch_order_id, external_key),
  CONSTRAINT fk_batch_txn2batch_order FOREIGN KEY (batch_order_id) REFERENCES batch_order (id) ON DELETE CASCADE
);

-- ------------------------------------
-- Payment template table
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.template.PersistedPaymentTemplate
-- ------------------------------------
CREATE TABLE template
(
    id                          VARCHAR2(36)     NOT NULL,
    name                        VARCHAR2(50)     NULL,
    created_at                  TIMESTAMP        NOT NULL,
    service_agreement_id        VARCHAR2(36)     NOT NULL,
    payment_type                VARCHAR2(22)     NULL,
    orig_acc_account_scheme     VARCHAR2(11)     NULL,
    orig_acc_account            VARCHAR2(36)     NULL,
    orig_acc_name               VARCHAR2(50)     NULL,
    orig_acc_arrangement_id     VARCHAR2(36)     NULL,
    orig_acc_ext_arrangement_id VARCHAR2(50)     NULL,
    instruction_priority        VARCHAR2(45)     NULL,
    entry_class                 VARCHAR2(3)      NULL,
    cp_name                     VARCHAR2(140)    NULL,
    cp_role                     VARCHAR2(32)     NULL,
    cp_addr_ln1                 VARCHAR2(70)     NULL,
    cp_addr_ln2                 VARCHAR2(70)     NULL,
    cp_str_name                 VARCHAR2(70)     NULL,
    cp_post_code                VARCHAR2(16)     NULL,
    cp_town                     VARCHAR2(35)     NULL,
    cp_c_sb_div                 VARCHAR2(35)     NULL,
    cp_country                  VARCHAR2(2)      NULL,
    cp_recipient_id             VARCHAR2(15)     NULL,
    cp_acc_account_scheme       VARCHAR2(11)     NULL,
    cp_acc_account              VARCHAR2(36)     NULL,
    cp_acc_name                 VARCHAR2(140)     NULL,
    cp_acc_type                 VARCHAR2(10)     NULL,
    cp_acc_contact_id           VARCHAR2(36)     NULL,
    cp_acc_account_id           VARCHAR2(36)     NULL,
    cp_bn_br_code               VARCHAR2(11)     NULL,
    cp_bn_name                  VARCHAR2(140)    NULL,
    cp_bn_bic                   VARCHAR2(11)     NULL,
    cp_bn_addr_ln1              VARCHAR2(70)     NULL,
    cp_bn_addr_ln2              VARCHAR2(70)     NULL,
    cp_bn_str_name              VARCHAR2(70)     NULL,
    cp_bn_post_code             VARCHAR2(16)     NULL,
    cp_bn_c_sb_div              VARCHAR2(35)     NULL,
    cp_bn_town                  VARCHAR2(35)     NULL,
    cp_bn_country               VARCHAR2(2)      NULL,
    amount                      DECIMAL(23, 5)   NULL,
    currency                    VARCHAR2(3)      NULL,
    cor_bn_br_code              VARCHAR2(11)     NULL,
    cor_bn_name                 VARCHAR2(140)    NULL,
    cor_bn_bic                  VARCHAR2(11)     NULL,
    cor_bn_addr_ln1             VARCHAR2(70)     NULL,
    cor_bn_addr_ln2             VARCHAR2(70)     NULL,
    cor_bn_str_name             VARCHAR2(70)     NULL,
    cor_bn_post_code            VARCHAR2(16)     NULL,
    cor_bn_c_sb_div             VARCHAR2(35)     NULL,
    cor_bn_town                 VARCHAR2(35)     NULL,
    cor_bn_country              VARCHAR2(2)      NULL,
    itm_bn_br_code              VARCHAR2(11)     NULL,
    itm_bn_name                 VARCHAR2(140)    NULL,
    itm_bn_bic                  VARCHAR2(11)     NULL,
    itm_bn_addr_ln1             VARCHAR2(70)     NULL,
    itm_bn_addr_ln2             VARCHAR2(70)     NULL,
    itm_bn_str_name             VARCHAR2(70)     NULL,
    itm_bn_post_code            VARCHAR2(16)     NULL,
    itm_bn_c_sb_div             VARCHAR2(35)     NULL,
    itm_bn_town                 VARCHAR2(35)     NULL,
    itm_bn_country              VARCHAR2(2)      NULL,
    message_to_bank             VARCHAR2(140)    NULL,
    target_currency             VARCHAR2(3)      NULL,
    rem_info_type               VARCHAR2(45)     NULL,
    rem_info_content            VARCHAR2(140)    NULL,
    mandate_id                  VARCHAR2(15)     NULL,
    e2e_id                      VARCHAR2(35)     NULL,
    charge_bearer               VARCHAR2(3)      NULL,
    additions                   NCLOB,
    CONSTRAINT pk_template PRIMARY KEY (id)
);

CREATE INDEX ix_template_said ON template (service_agreement_id);