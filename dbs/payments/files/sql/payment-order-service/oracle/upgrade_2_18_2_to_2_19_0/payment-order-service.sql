-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-483
-- ============================================

-- --------------------------------------------
-- Extend payment type column length for international transfer
-- --------------------------------------------

ALTER TABLE pmt_order MODIFY pmt_type VARCHAR2(22);

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
    payment_type                VARCHAR2(20)     NULL,
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