-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-483
-- ============================================

-- --------------------------------------------
-- Extend payment type column length for international transfer
-- --------------------------------------------

ALTER TABLE pmt_order ALTER COLUMN pmt_type NVARCHAR(22)

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
    payment_type                NVARCHAR(20)     NULL,
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