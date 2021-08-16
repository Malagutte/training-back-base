-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-756
-- ============================================

-- --------------------------------------------
-- Add new column originating account currency
-- --------------------------------------------

ALTER TABLE pmt_order ADD orig_acc_currency VARCHAR(3) NULL;

-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-5421
-- ============================================

-- --------------------------------------------
--  Adds company id and company name columns to batch order table
-- --------------------------------------------

ALTER TABLE batch_order ADD company_id VARCHAR(36) NULL, ADD company_name NVARCHAR(140) NULL;

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-785
-- ============================================

-- --------------------------------------------
-- Add confirmation_id to reference a confirmation/txn signing entry
-- --------------------------------------------
ALTER TABLE pmt_order ADD confirmation_id VARCHAR(36) NULL;