
-- ------------------------------------
-- Payment order table from PandP
-- Reference class:
--  - com.backbase.pandp.order.domain.order.PaymentOrder
-- ------------------------------------
CREATE TABLE pmt_order
(
  id                       NVARCHAR(36)  NOT NULL,
  internal_user_id         NVARCHAR(36)  NULL,
  bank_reference_id        NVARCHAR(64)  NULL,
  payment_setup_id         NVARCHAR(128) NULL,
  payment_submission_id    NVARCHAR(128) NULL,
  amount                   decimal(23,5) NULL,
  currency                 NVARCHAR(3)   NULL,
  status                   NVARCHAR(64)  NULL,
  bank_status              NVARCHAR(35)  NULL,
  rejection_reason         NVARCHAR(128) NULL,
  pmt_mode                 NVARCHAR(45)  NULL,
  pmt_type                 NVARCHAR(22)  NULL,
  priority                 NVARCHAR(45)  NULL,
  batch                    BIT           NULL,
  requested_exec_date      DATE          NULL,
  reason_code              NVARCHAR(4)   NULL,
  reason_text              NVARCHAR(35)  NULL,
  error_description        NVARCHAR(105) NULL,
  created_at               DATETIME      NULL,
  updated_at               DATETIME      NULL,
  created_by               NVARCHAR(36)  NULL,
  updated_by               NVARCHAR(36)  NULL,
  start_date               DATE          NULL,
  end_date                 DATE          NULL,
  next_execution_date      DATE          NULL,
  frequency                NVARCHAR(9)   NULL,
  non_working_day_strategy NVARCHAR(6)   NULL,
  every                    NVARCHAR(10)  NULL,
  when_execute             BIGINT        NULL,
  repetition               BIGINT        NULL,
  role                     NVARCHAR(32)  NULL,
  arrangement_id           NVARCHAR(36)  NULL,
  ext_arrangement_id       NVARCHAR(70)  NULL,
  account_scheme           NVARCHAR(11)  NULL,
  account                  NVARCHAR(36)  NULL,
  name                     NVARCHAR(140) NULL,
  address_line1            NVARCHAR(70)  NULL,
  address_line2            NVARCHAR(70)  NULL,
  street_name              NVARCHAR(70)  NULL,
  post_code                NVARCHAR(16)  NULL,
  country_sub_division     NVARCHAR(35)  NULL,
  town                     NVARCHAR(35)  NULL,
  country                  NVARCHAR(2)   NULL,
  approval_id              NVARCHAR(36)  NULL,
  entry_class              NVARCHAR(3)   NULL,
  intra_legal_entity       BIT           NULL,
  service_agreement_id     NVARCHAR(36)  NULL,
  orig_acc_currency        NVARCHAR(3)   NULL,
  confirmation_id          NVARCHAR(36)  NULL,
  additions                NVARCHAR(MAX) NULL,
  CONSTRAINT pk_pmt_order PRIMARY KEY CLUSTERED (id),
  INDEX ix_pmt_order_03 (bank_reference_id ASC),
  INDEX ix_pmt_order_04 (internal_user_id  ASC),
  INDEX ix_pmt_order_05 (arrangement_id    ASC),
)
GO

-- ------------------------------------
-- Transaction table from PandP
-- Reference class:
--  - com.backbase.pandp.order.domain.order.Transaction
-- ------------------------------------
CREATE TABLE pmt_txn
(
  id                   NVARCHAR(36)   NOT NULL,
  pmt_order_id         NVARCHAR(36)   NULL,
  amount               decimal(23,5)  NULL,
  currency             NVARCHAR(3)    NULL,
  e2e_id               NVARCHAR(35)   NULL,
  role                 NVARCHAR(32)   NULL,
  arrangement_id       NVARCHAR(36)   NULL,
  ext_arrangement_id   NVARCHAR(70)   NULL,
  account_scheme       NVARCHAR(11)   NULL,
  account              NVARCHAR(36)   NULL,
  account_type         NVARCHAR(10)   NULL,
  recipient_id         NVARCHAR(15)   NULL,
  name                 NVARCHAR(140)  NULL,
  address_line1        NVARCHAR(70)   NULL,
  address_line2        NVARCHAR(70)   NULL,
  street_name          NVARCHAR(70)   NULL,
  post_code            NVARCHAR(16)   NULL,
  country_sub_division NVARCHAR(35)   NULL,
  town                 NVARCHAR(35)   NULL,
  country              NVARCHAR(2)    NULL,
  type                 NVARCHAR(45)   NULL,
  content              NVARCHAR(140)  NULL,
  cp_bn_addr_ln1       NVARCHAR(70)   NULL,
  cp_bn_addr_ln2       NVARCHAR(70)   NULL,
  cp_bn_str_name       NVARCHAR(70)   NULL,
  cp_bn_post_code      NVARCHAR(16)   NULL,
  cp_bn_c_sb_div       NVARCHAR(35)   NULL,
  cp_bn_town           NVARCHAR(35)   NULL,
  cp_bn_country        NVARCHAR(2)    NULL,
  cp_bn_br_code        NVARCHAR(11)   NULL,
  cp_bn_name           NVARCHAR(140)  NULL,
  cp_bn_bic            NVARCHAR(11)   NULL,
  cor_bn_addr_ln1      NVARCHAR(70)   NULL,
  cor_bn_addr_ln2      NVARCHAR(70)   NULL,
  cor_bn_str_name      NVARCHAR(70)   NULL,
  cor_bn_post_code     NVARCHAR(16)   NULL,
  cor_bn_c_sb_div      NVARCHAR(35)   NULL,
  cor_bn_town          NVARCHAR(35)   NULL,
  cor_bn_country       NVARCHAR(2)    NULL,
  cor_bn_br_code       NVARCHAR(11)   NULL,
  cor_bn_name          NVARCHAR(140)  NULL,
  cor_bn_bic           NVARCHAR(11)   NULL,
  itm_bn_addr_ln1      NVARCHAR(70)   NULL,
  itm_bn_addr_ln2      NVARCHAR(70)   NULL,
  itm_bn_str_name      NVARCHAR(70)   NULL,
  itm_bn_post_code     NVARCHAR(16)   NULL,
  itm_bn_c_sb_div      NVARCHAR(35)   NULL,
  itm_bn_town          NVARCHAR(35)   NULL,
  itm_bn_country       NVARCHAR(2)    NULL,
  itm_bn_br_code       NVARCHAR(11)   NULL,
  itm_bn_name          NVARCHAR(140)  NULL,
  itm_bn_bic           NVARCHAR(11)   NULL,
  message_to_bank      NVARCHAR(140)  NULL,
  target_currency      NVARCHAR(3)    NULL,
  additions            NVARCHAR(MAX)  NULL,
  mandate_id           NVARCHAR(15)   NULL,
  charge_bearer        VARCHAR(3)     NULL,
  fee_amount           DECIMAL(23,5)  NULL,
  fee_currency         VARCHAR(3)     NULL,
  exc_rate_currency    NVARCHAR(3)    NULL,
  exc_rate             DECIMAL(23,5)  NULL,
  exc_rate_type        NVARCHAR(35)   NULL,
  exc_rate_contract_id NVARCHAR(256)  NULL,
  CONSTRAINT pk_pmt_txn PRIMARY KEY CLUSTERED (id),
  CONSTRAINT fk_pmt_txn2pmt_order_01     FOREIGN KEY (pmt_order_id) REFERENCES pmt_order,
  INDEX ix_pmt_txn_02 (pmt_order_id    ASC),
  INDEX ix_pmt_txn_04 (arrangement_id  ASC)
)
GO


-- ----------------------------
-- Table structure for pmt_order_add_prop
-- ----------------------------
CREATE TABLE pmt_order_add_prop (
  payment_id     NVARCHAR(36)  NOT NULL ,
  property_key   NVARCHAR(50)  NOT NULL ,
  property_value NVARCHAR(MAX) NULL ,
  CONSTRAINT pk_pmt_order_add_prop       PRIMARY KEY CLUSTERED (payment_id, property_key),
  CONSTRAINT fk_pmt_ord_add_prop2pmt_ord FOREIGN KEY (payment_id) REFERENCES pmt_order (id) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

-- ----------------------------
-- Table structure for pmt_txn_add_prop
-- ----------------------------
CREATE TABLE pmt_txn_add_prop (
  txn_id         NVARCHAR(36)  NOT NULL ,
  property_key   NVARCHAR(50)  NOT NULL ,
  property_value NVARCHAR(MAX) NULL ,
  CONSTRAINT pk_pmt_txn_add_prop         PRIMARY KEY CLUSTERED (txn_id, property_key),
  CONSTRAINT fk_pmt_txn_add_prop2pmt_txn FOREIGN KEY (txn_id) REFERENCES pmt_txn (id) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

-- ------------------------------------
-- Batch Upload table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchUpload
-- ------------------------------------

CREATE SEQUENCE batch_upload_seq START WITH 1 INCREMENT BY 1
GO

CREATE TABLE batch_upload
(
  id                   bigint        NOT NULL,
  external_key         varchar(36)   NOT NULL,
  file_name            nvarchar(255) NOT NULL,
  file_last_modified   datetime,
  reported_bytes       bigint        NOT NULL,
  received_bytes       bigint        NOT NULL,
  created_by           varchar(36)   NOT NULL,
  service_agreement_id varchar(36)   NOT NULL,
  started_at           datetime      NOT NULL,
  digest_algorithm     varchar(12),
  digest               varchar(64),
  ended_at             datetime,
  file_type            varchar(40),
  batch_count          int,
  status               varchar(10)   NOT NULL,
  raw_data             nvarchar(MAX),
  additions            nvarchar(MAX),
  CONSTRAINT pk_batch_upload PRIMARY KEY (id),
  CONSTRAINT uq_batch_upload_external_key UNIQUE (external_key)
)
GO

CREATE NONCLUSTERED INDEX ix_batch_upload_said_size ON batch_upload(service_agreement_id, reported_bytes)
GO

-- ------------------------------------
-- Batch Upload Error table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchError
-- ------------------------------------

CREATE SEQUENCE batch_error_seq START WITH 1 INCREMENT BY 5
GO

CREATE TABLE batch_error
(
  id              bigint NOT NULL,
  batch_upload_id bigint NOT NULL,
  error_code      varchar(100),
  error_message   varchar(255),
  parameters      nvarchar(MAX),
  CONSTRAINT pk_batch_error PRIMARY KEY (id),
  CONSTRAINT fk_batch_error2batch_upload FOREIGN KEY (batch_upload_id) REFERENCES batch_upload (id) ON DELETE CASCADE
)
GO

-- ------------------------------------
-- Batch Order table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchOrder
-- ------------------------------------

CREATE SEQUENCE batch_order_seq START WITH 1 INCREMENT BY 1
GO

CREATE TABLE batch_order
(
  id                       bigint      NOT NULL,
  batch_upload_id          bigint,
  external_key             varchar(36) NOT NULL,
  account_scheme           varchar(11),
  account_number           varchar(36),
  account_name             varchar(50),
  bank_branch_code         varchar(11),
  arrangement_id           varchar(36),
  company_id               nvarchar(36),
  company_name             nvarchar(140),
  requested_execution_date date        NOT NULL,
  currency                 char(3),
  total_amount             decimal(23, 5),
  transactions_count       int,
  batch_order_type         varchar(40) NOT NULL,
  entry_class              varchar(3),
  batch_name               nvarchar(256),
  status                   varchar(12) NOT NULL,
  approval_id              varchar(36),
  bank_status              varchar(35),
  rejection_reason         varchar(128),
  reason_code              varchar(4),
  reason_text              varchar(35),
  updated_at               datetime,
  created_at               datetime,
  created_by               varchar(36),
  raw_data                 nvarchar(MAX),
  additions                nvarchar(MAX),
  CONSTRAINT pk_batch_order PRIMARY KEY (id),
  CONSTRAINT fk_batch_order2batch_upload FOREIGN KEY (batch_upload_id) REFERENCES batch_upload (id) ON DELETE SET NULL,
  CONSTRAINT uq_batch_order_external_key UNIQUE (external_key)
)
GO

-- ------------------------------------
-- Batch Transaction table with corresponding sequence from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchTransaction
-- ------------------------------------

CREATE SEQUENCE batch_transaction_seq START WITH 1 INCREMENT BY 100
GO

CREATE TABLE batch_transaction
(
  id                          bigint         NOT NULL,
  batch_order_id              bigint         NOT NULL,
  external_key                varchar(36)    NOT NULL,
  counterparty_name           nvarchar(140),
  counterparty_account_number varchar(36)    NOT NULL,
  counterparty_bank_branch_code varchar(11),
  credit_debit_indicator      varchar(6),
  currency                    char(3)        NOT NULL,
  amount                      decimal(23, 5) NOT NULL,
  description                 varchar(140),
  reference                   varchar(35),
  transaction_code            varchar(4),
  bank_status                 varchar(35),
  rejection_reason            varchar(128),
  reason_code                 varchar(4),
  reason_text                 varchar(35),
  status                      varchar(12),
  hidden                      bit CONSTRAINT DF_batch_transaction_hidden DEFAULT 0 NOT NULL,
  raw_data                    nvarchar(MAX),
  additions                   nvarchar(MAX),
  CONSTRAINT pk_batch_transaction PRIMARY KEY (id),
  CONSTRAINT uq_batch_txn_orderid_extkey UNIQUE (batch_order_id, external_key),
  CONSTRAINT fk_batch_txn2batch_order FOREIGN KEY (batch_order_id) REFERENCES batch_order (id) ON DELETE CASCADE
)

-- ------------------------------------
-- Payment template table
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.template.PersistedPaymentTemplate
-- ------------------------------------
CREATE TABLE template
(
    id                          NVARCHAR(36)     NOT NULL,
    name                        NVARCHAR(50)     NULL,
    created_at                  DATETIME         NOT NULL,
    service_agreement_id        NVARCHAR(36)     NOT NULL,
    payment_type                NVARCHAR(22)     NULL,
    orig_acc_account_scheme     NVARCHAR(11)     NULL,
    orig_acc_account            NVARCHAR(36)     NULL,
    orig_acc_name               NVARCHAR(50)     NULL,
    orig_acc_arrangement_id     NVARCHAR(36)     NULL,
    orig_acc_ext_arrangement_id NVARCHAR(50)     NULL,
    instruction_priority        NVARCHAR(45)     NULL,
    entry_class                 NVARCHAR(3)      NULL,
    cp_name                     NVARCHAR(140)    NULL,
    cp_role                     NVARCHAR(32)     NULL,
    cp_addr_ln1                 NVARCHAR(70)     NULL,
    cp_addr_ln2                 NVARCHAR(70)     NULL,
    cp_str_name                 NVARCHAR(70)     NULL,
    cp_post_code                NVARCHAR(16)     NULL,
    cp_town                     NVARCHAR(35)     NULL,
    cp_c_sb_div                 NVARCHAR(35)     NULL,
    cp_country                  NVARCHAR(2)      NULL,
    cp_recipient_id             NVARCHAR(15)     NULL,
    cp_acc_account_scheme       NVARCHAR(11)     NULL,
    cp_acc_account              NVARCHAR(36)     NULL,
    cp_acc_name                 NVARCHAR(140)     NULL,
    cp_acc_type                 NVARCHAR(10)     NULL,
    cp_acc_contact_id           NVARCHAR(36)     NULL,
    cp_acc_account_id           NVARCHAR(36)     NULL,
    cp_bn_br_code               NVARCHAR(11)     NULL,
    cp_bn_name                  NVARCHAR(140)    NULL,
    cp_bn_bic                   NVARCHAR(11)     NULL,
    cp_bn_addr_ln1              NVARCHAR(70)     NULL,
    cp_bn_addr_ln2              NVARCHAR(70)     NULL,
    cp_bn_str_name              NVARCHAR(70)     NULL,
    cp_bn_post_code             NVARCHAR(16)     NULL,
    cp_bn_c_sb_div              NVARCHAR(35)     NULL,
    cp_bn_town                  NVARCHAR(35)     NULL,
    cp_bn_country               NVARCHAR(2)      NULL,
    amount                      DECIMAL(23, 5)   NULL,
    currency                    NVARCHAR(3)      NULL,
    cor_bn_br_code              NVARCHAR(11)     NULL,
    cor_bn_name                 NVARCHAR(140)    NULL,
    cor_bn_bic                  NVARCHAR(11)     NULL,
    cor_bn_addr_ln1             NVARCHAR(70)     NULL,
    cor_bn_addr_ln2             NVARCHAR(70)     NULL,
    cor_bn_str_name             NVARCHAR(70)     NULL,
    cor_bn_post_code            NVARCHAR(16)     NULL,
    cor_bn_c_sb_div             NVARCHAR(35)     NULL,
    cor_bn_town                 NVARCHAR(35)     NULL,
    cor_bn_country              NVARCHAR(2)      NULL,
    itm_bn_br_code              NVARCHAR(11)     NULL,
    itm_bn_name                 NVARCHAR(140)    NULL,
    itm_bn_bic                  NVARCHAR(11)     NULL,
    itm_bn_addr_ln1             NVARCHAR(70)     NULL,
    itm_bn_addr_ln2             NVARCHAR(70)     NULL,
    itm_bn_str_name             NVARCHAR(70)     NULL,
    itm_bn_post_code            NVARCHAR(16)     NULL,
    itm_bn_c_sb_div             NVARCHAR(35)     NULL,
    itm_bn_town                 NVARCHAR(35)     NULL,
    itm_bn_country              NVARCHAR(2)      NULL,
    message_to_bank             NVARCHAR(140)    NULL,
    target_currency             NVARCHAR(3)      NULL,
    rem_info_type               NVARCHAR(45)     NULL,
    rem_info_content            NVARCHAR(140)    NULL,
    mandate_id                  NVARCHAR(15)     NULL,
    e2e_id                      NVARCHAR(35)     NULL,
    charge_bearer               NVARCHAR(3)      NULL,
    additions                   NVARCHAR(MAX)    NULL,
    CONSTRAINT pk_template PRIMARY KEY (id),
    INDEX ix_template_said (service_agreement_id ASC)
)
GO