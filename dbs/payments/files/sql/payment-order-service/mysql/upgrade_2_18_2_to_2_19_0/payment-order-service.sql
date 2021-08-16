-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-483
-- ============================================

-- --------------------------------------------
-- Extend payment type column length for international transfer
-- --------------------------------------------

ALTER TABLE pmt_order MODIFY pmt_type varchar(22);

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
    payment_type                VARCHAR(20)     NULL,
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
