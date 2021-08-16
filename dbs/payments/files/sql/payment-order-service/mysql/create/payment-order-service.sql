
-- ------------------------------------
-- Payment order table from PandP
-- Reference class:
--  - com.backbase.pandp.order.domain.order.PaymentOrder
-- ------------------------------------
CREATE TABLE pmt_order
(
  id                       VARCHAR(36)    NOT NULL,
  internal_user_id         VARCHAR(36)    NULL,
  bank_reference_id        VARCHAR(64)    NULL,
  payment_setup_id         VARCHAR(128)   NULL,
  payment_submission_id    VARCHAR(128)   NULL,
  amount                   DECIMAL(23, 5) NULL,
  currency                 VARCHAR(3)     NULL,
  status                   VARCHAR(64)    NULL,
  bank_status              VARCHAR(35)    NULL,
  rejection_reason         VARCHAR(128)   NULL,
  pmt_mode                 VARCHAR(45)    NULL,
  pmt_type                 VARCHAR(22)    NULL,
  priority                 VARCHAR(45)    NULL,
  batch                    CHAR(1)        NULL,
  requested_exec_date      DATE           NULL,
  reason_code              VARCHAR(4)     NULL,
  reason_text              VARCHAR(35)    NULL,
  error_description        VARCHAR(105)   NULL,
  created_at               DATETIME       NULL,
  updated_at               DATETIME       NULL,
  created_by               VARCHAR(36)    NULL,
  updated_by               VARCHAR(36)    NULL,
  start_date               DATE           NULL,
  end_date                 DATE           NULL,
  next_execution_date      DATE           NULL,
  frequency                VARCHAR(9)     NULL,
  non_working_day_strategy VARCHAR(6)     NULL,
  every                    VARCHAR(10)    NULL,
  when_execute             BIGINT(20)     NULL,
  repetition               BIGINT(20)     NULL,
  role                     VARCHAR(32)    NULL,
  arrangement_id           VARCHAR(36)    NULL,
  ext_arrangement_id       VARCHAR(70)    NULL,
  account_scheme           VARCHAR(11)    NULL,
  account                  VARCHAR(36)    NULL,
  name                     VARCHAR(140)   NULL,
  address_line1            VARCHAR(70)    NULL,
  address_line2            VARCHAR(70)    NULL,
  street_name              VARCHAR(70)    NULL,
  post_code                VARCHAR(16)    NULL,
  country_sub_division     VARCHAR(35)    NULL,
  town                     VARCHAR(35)    NULL,
  country                  VARCHAR(2)     NULL,
  approval_id              VARCHAR(36)    NULL,
  entry_class              VARCHAR(3)     NULL,
  intra_legal_entity       CHAR(1)        NULL,
  service_agreement_id     VARCHAR(36)    NULL,
  orig_acc_currency        VARCHAR(3)     NULL,
  confirmation_id          VARCHAR(36)    NULL,
  additions                LONGTEXT CHARACTER SET utf8 NULL,
  CONSTRAINT pk_pmt_order PRIMARY KEY (id),
  INDEX ix_pmt_order_03 (bank_reference_id),
  INDEX ix_pmt_order_04 (internal_user_id),
  INDEX ix_pmt_order_05 (arrangement_id)
);

-- ------------------------------------
-- Transaction table from PandP
-- Reference class:
--  - com.backbase.pandp.order.domain.order.Transaction
-- ------------------------------------
CREATE TABLE pmt_txn
(
  id                   VARCHAR(36)   NOT NULL,
  pmt_order_id         VARCHAR(36)   NULL,
  amount               DECIMAL(23,5) NULL,
  currency             VARCHAR(3)    NULL,
  e2e_id               VARCHAR(35)   NULL,
  role                 VARCHAR(32)   NULL,
  arrangement_id       VARCHAR(36)   NULL,
  ext_arrangement_id   VARCHAR(70)   NULL,
  account_scheme       VARCHAR(11)   NULL,
  account              VARCHAR(36)   NULL,
  account_type         VARCHAR(10)   NULL,
  recipient_id         VARCHAR(15)   NULL,
  name                 VARCHAR(140)  NULL,
  address_line1        VARCHAR(70)   NULL,
  address_line2        VARCHAR(70)   NULL,
  street_name          VARCHAR(70)   NULL,
  post_code            VARCHAR(16)   NULL,
  country_sub_division VARCHAR(35)   NULL,
  town                 VARCHAR(35)   NULL,
  country              VARCHAR(2)    NULL,
  type                 VARCHAR(45)   NULL,
  content              VARCHAR(140)  NULL,
  cp_bn_addr_ln1       VARCHAR(70)   NULL,
  cp_bn_addr_ln2       VARCHAR(70)   NULL,
  cp_bn_str_name       VARCHAR(70)   NULL,
  cp_bn_post_code      VARCHAR(16)   NULL,
  cp_bn_c_sb_div       VARCHAR(35)   NULL,
  cp_bn_town           VARCHAR(35)   NULL,
  cp_bn_country        VARCHAR(2)    NULL,
  cp_bn_br_code        VARCHAR(11)   NULL,
  cp_bn_name           VARCHAR(140)  NULL,
  cp_bn_bic            VARCHAR(11)   NULL,
  cor_bn_addr_ln1      VARCHAR(70)   NULL,
  cor_bn_addr_ln2      VARCHAR(70)   NULL,
  cor_bn_str_name      VARCHAR(70)   NULL,
  cor_bn_post_code     VARCHAR(16)   NULL,
  cor_bn_c_sb_div      VARCHAR(35)   NULL,
  cor_bn_town          VARCHAR(35)   NULL,
  cor_bn_country       VARCHAR(2)    NULL,
  cor_bn_br_code       VARCHAR(11)   NULL,
  cor_bn_name          VARCHAR(140)  NULL,
  cor_bn_bic           VARCHAR(11)   NULL,
  itm_bn_addr_ln1      VARCHAR(70)   NULL,
  itm_bn_addr_ln2      VARCHAR(70)   NULL,
  itm_bn_str_name      VARCHAR(70)   NULL,
  itm_bn_post_code     VARCHAR(16)   NULL,
  itm_bn_c_sb_div      VARCHAR(35)   NULL,
  itm_bn_town          VARCHAR(35)   NULL,
  itm_bn_country       VARCHAR(2)    NULL,
  itm_bn_br_code       VARCHAR(11)   NULL,
  itm_bn_name          VARCHAR(140)  NULL,
  itm_bn_bic           VARCHAR(11)   NULL,
  message_to_bank      VARCHAR(140)  NULL,
  target_currency      VARCHAR(3)    NULL,
  additions            LONGTEXT CHARACTER SET utf8 NULL,
  mandate_id           VARCHAR(15)    NULL,
  charge_bearer        VARCHAR(3)     NULL,
  fee_amount           DECIMAL(23,5)  NULL,
  fee_currency         VARCHAR(3)     NULL,
  exc_rate_currency    VARCHAR(3)     NULL,
  exc_rate             DECIMAL(23,5)  NULL,
  exc_rate_type        VARCHAR(35)    NULL,
  exc_rate_contract_id VARCHAR(256)   NULL,
  CONSTRAINT pk_pmt_txn PRIMARY KEY (id),
  CONSTRAINT fk_pmt_txn2pmt_order_01 FOREIGN KEY (pmt_order_id) REFERENCES pmt_order (id),
  INDEX ix_pmt_txn_02 (pmt_order_id ASC),
  INDEX ix_pmt_txn_04 (arrangement_id ASC)
);

-- ----------------------------
-- Table structure for pmt_order_add_prop
-- ----------------------------
CREATE TABLE pmt_order_add_prop (
  payment_id     VARCHAR(36) NOT NULL,
  property_key   VARCHAR(50) NOT NULL,
  property_value LONGTEXT    NULL,
  CONSTRAINT pk_pmt_order_add_prop PRIMARY KEY (payment_id, property_key),
  CONSTRAINT fk_pmt_ord_add_prop2pmt_ord FOREIGN KEY (payment_id) REFERENCES pmt_order (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);


-- ----------------------------
-- Table structure for pmt_txn_add_prop
-- ----------------------------
CREATE TABLE pmt_txn_add_prop (
  txn_id         VARCHAR(36) NOT NULL,
  property_key   VARCHAR(50) NOT NULL,
  property_value LONGTEXT    NULL,
  CONSTRAINT pk_pmt_txn_add_prop PRIMARY KEY (txn_id, property_key),
  CONSTRAINT fk_pmt_txn_add_prop2pmt_txn FOREIGN KEY (txn_id) REFERENCES pmt_txn (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- ------------------------------------
-- Batch Upload table from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchUpload
-- ------------------------------------

CREATE TABLE batch_upload
(
  id                   BIGINT AUTO_INCREMENT       NOT NULL,
  external_key         VARCHAR(36)                 NOT NULL,
  file_name            NVARCHAR(255)               NOT NULL,
  file_last_modified   datetime                    NULL,
  reported_bytes       BIGINT                      NOT NULL,
  received_bytes       BIGINT                      NOT NULL,
  created_by           VARCHAR(36)                 NOT NULL,
  service_agreement_id VARCHAR(36)                 NOT NULL,
  started_at           datetime                    NOT NULL,
  digest_algorithm     VARCHAR(12)                 NULL,
  digest               VARCHAR(64)                 NULL,
  ended_at             datetime                    NULL,
  file_type            VARCHAR(40)                 NULL,
  batch_count          INT                         NULL,
  status               VARCHAR(10)                 NOT NULL,
  raw_data             LONGTEXT CHARACTER SET utf8 NULL,
  additions            LONGTEXT CHARACTER SET utf8 NULL,
  CONSTRAINT pk_batch_upload PRIMARY KEY (id),
  CONSTRAINT uq_batch_upload_external_key UNIQUE (external_key)
);

CREATE INDEX ix_batch_upload_said_size ON batch_upload(service_agreement_id, reported_bytes);

-- ------------------------------------
-- Batch Upload Error table from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchError
-- ------------------------------------

CREATE TABLE batch_error
(
  id              BIGINT AUTO_INCREMENT       NOT NULL,
  batch_upload_id BIGINT                      NOT NULL,
  error_code      VARCHAR(100)                 NULL,
  error_message   VARCHAR(255)                NULL,
  parameters      LONGTEXT CHARACTER SET utf8 NULL,
  CONSTRAINT pk_batch_error PRIMARY KEY (id),
  CONSTRAINT fk_batch_error2batch_upload FOREIGN KEY (batch_upload_id) REFERENCES batch_upload (id) ON DELETE CASCADE
);

-- ------------------------------------
-- Batch Order table from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchOrder
-- ------------------------------------

CREATE TABLE batch_order
(
  id                       BIGINT AUTO_INCREMENT       NOT NULL,
  batch_upload_id          BIGINT                      NULL,
  external_key             VARCHAR(36)                 NOT NULL,
  account_scheme           VARCHAR(11)                 NULL,
  account_number           VARCHAR(36)                 NULL,
  account_name             VARCHAR(50)                 NULL,
  bank_branch_code         VARCHAR(11)                 NULL,
  arrangement_id           VARCHAR(36)                 NULL,
  company_id               VARCHAR(36)                 NULL,
  company_name             NVARCHAR(140)               NULL,
  requested_execution_date date                        NOT NULL,
  currency                 CHAR(3)                     NULL,
  total_amount             DECIMAL(23, 5)              NULL,
  transactions_count       INT                         NULL,
  batch_order_type         VARCHAR(40)                 NOT NULL,
  entry_class              VARCHAR(3)                  NULL,
  batch_name               NVARCHAR(256)               NULL,
  status                   VARCHAR(12)                 NOT NULL,
  approval_id              VARCHAR(36)                 NULL,
  bank_status              VARCHAR(35)                 NULL,
  rejection_reason         VARCHAR(128)                NULL,
  reason_code              VARCHAR(4)                  NULL,
  reason_text              VARCHAR(35)                 NULL,
  updated_at               datetime                    NULL,
  created_at               datetime                    NULL,
  created_by               VARCHAR(36)                 NULL,
  raw_data                 LONGTEXT CHARACTER SET utf8 NULL,
  additions                LONGTEXT CHARACTER SET utf8 NULL,
  CONSTRAINT pk_batch_order PRIMARY KEY (id),
  CONSTRAINT fk_batch_order2batch_upload FOREIGN KEY (batch_upload_id) REFERENCES batch_upload (id) ON DELETE SET NULL,
  CONSTRAINT uq_batch_order_external_key UNIQUE (external_key)
);

-- ------------------------------------
-- Batch Transaction table from PandP
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.batch.BatchTransaction
-- ------------------------------------

CREATE TABLE batch_transaction
(
  id                          BIGINT AUTO_INCREMENT       NOT NULL,
  batch_order_id              BIGINT                      NOT NULL,
  external_key                VARCHAR(36)                 NOT NULL,
  counterparty_name           NVARCHAR(140)               NULL,
  counterparty_account_number VARCHAR(36)                 NOT NULL,
  counterparty_bank_branch_code VARCHAR(11)               NULL,
  credit_debit_indicator      VARCHAR(6)                  NULL,
  currency                    CHAR(3)                     NOT NULL,
  amount                      DECIMAL(23, 5)              NOT NULL,
  `description`               VARCHAR(140)                NULL,
  `reference`                 VARCHAR(35)                 NULL,
  transaction_code            VARCHAR(4)                  NULL,
  bank_status                 VARCHAR(35)                 NULL,
  rejection_reason            VARCHAR(128)                NULL,
  reason_code                 VARCHAR(4)                  NULL,
  reason_text                 VARCHAR(35)                 NULL,
  status                      VARCHAR(12)                 NULL,
  hidden                      BIT(1) DEFAULT 0            NOT NULL,
  raw_data                    LONGTEXT CHARACTER SET utf8 NULL,
  additions                   LONGTEXT CHARACTER SET utf8 NULL,
  CONSTRAINT pk_batch_transaction PRIMARY KEY (id),
  CONSTRAINT uq_batch_txn_orderid_extkey UNIQUE (batch_order_id, external_key),
  CONSTRAINT fk_batch_txn2batch_order FOREIGN KEY (batch_order_id) REFERENCES batch_order (id) ON DELETE CASCADE
);

-- ------------------------------------
-- Payment template table
-- Reference class:
--  - com.backbase.dbs.payment.persistence.domain.model.template.PersistedPaymentTemplate
-- ------------------------------------
create table template
(
    id                          VARCHAR(36)     NOT NULL,
    name                        VARCHAR(50)     NULL,
    created_at                  DATETIME        NOT NULL,
    service_agreement_id        VARCHAR(36)     NOT NULL,
    payment_type                VARCHAR(22)     NULL,
    orig_acc_account_scheme     VARCHAR(11)     NULL,
    orig_acc_account            VARCHAR(36)     NULL,
    orig_acc_name               VARCHAR(50)     NULL,
    orig_acc_arrangement_id     VARCHAR(36)     NULL,
    orig_acc_ext_arrangement_id VARCHAR(50)     NULL,
    instruction_priority        VARCHAR(45)     NULL,
    entry_class                 VARCHAR(3)      NULL,
    cp_name                     VARCHAR(140)    NULL,
    cp_role                     VARCHAR(32)     NULL,
    cp_addr_ln1                 VARCHAR(70)     NULL,
    cp_addr_ln2                 VARCHAR(70)     NULL,
    cp_str_name                 VARCHAR(70)     NULL,
    cp_post_code                VARCHAR(16)     NULL,
    cp_town                     VARCHAR(35)     NULL,
    cp_c_sb_div                 VARCHAR(35)     NULL,
    cp_country                  VARCHAR(2)      NULL,
    cp_recipient_id             VARCHAR(15)     NULL,
    cp_acc_account_scheme       VARCHAR(11)     NULL,
    cp_acc_account              VARCHAR(36)     NULL,
    cp_acc_name                 VARCHAR(140)     NULL,
    cp_acc_type                 VARCHAR(10)     NULL,
    cp_acc_contact_id           VARCHAR(36)     NULL,
    cp_acc_account_id           VARCHAR(36)     NULL,
    cp_bn_br_code               VARCHAR(11)     NULL,
    cp_bn_name                  VARCHAR(140)    NULL,
    cp_bn_bic                   VARCHAR(11)     NULL,
    cp_bn_addr_ln1              VARCHAR(70)     NULL,
    cp_bn_addr_ln2              VARCHAR(70)     NULL,
    cp_bn_str_name              VARCHAR(70)     NULL,
    cp_bn_post_code             VARCHAR(16)     NULL,
    cp_bn_c_sb_div              VARCHAR(35)     NULL,
    cp_bn_town                  VARCHAR(35)     NULL,
    cp_bn_country               VARCHAR(2)      NULL,
    amount                      DECIMAL(23, 5)  NULL,
    currency                    VARCHAR(3)      NULL,
    cor_bn_br_code              VARCHAR(11)     NULL,
    cor_bn_name                 VARCHAR(140)    NULL,
    cor_bn_bic                  VARCHAR(11)     NULL,
    cor_bn_addr_ln1             VARCHAR(70)     NULL,
    cor_bn_addr_ln2             VARCHAR(70)     NULL,
    cor_bn_str_name             VARCHAR(70)     NULL,
    cor_bn_post_code            VARCHAR(16)     NULL,
    cor_bn_c_sb_div             VARCHAR(35)     NULL,
    cor_bn_town                 VARCHAR(35)     NULL,
    cor_bn_country              VARCHAR(2)      NULL,
    itm_bn_br_code              VARCHAR(11)     NULL,
    itm_bn_name                 VARCHAR(140)    NULL,
    itm_bn_bic                  VARCHAR(11)     NULL,
    itm_bn_addr_ln1             VARCHAR(70)     NULL,
    itm_bn_addr_ln2             VARCHAR(70)     NULL,
    itm_bn_str_name             VARCHAR(70)     NULL,
    itm_bn_post_code            VARCHAR(16)     NULL,
    itm_bn_c_sb_div             VARCHAR(35)     NULL,
    itm_bn_town                 VARCHAR(35)     NULL,
    itm_bn_country              VARCHAR(2)      NULL,
    message_to_bank             VARCHAR(140)    NULL,
    target_currency             VARCHAR(3)      NULL,
    rem_info_type               VARCHAR(45)     NULL,
    rem_info_content            VARCHAR(140)    NULL,
    mandate_id                  VARCHAR(15)     NULL,
    e2e_id                      VARCHAR(35)     NULL,
    charge_bearer               VARCHAR(3)      NULL,
    additions                   LONGTEXT        CHARACTER SET utf8 NULL,
    CONSTRAINT pk_template PRIMARY KEY (id),
    INDEX ix_template_said (service_agreement_id)
);