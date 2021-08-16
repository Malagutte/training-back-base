-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-756
-- ============================================

-- --------------------------------------------
-- Add new column originating account currency
-- --------------------------------------------

ALTER TABLE pmt_order ADD orig_acc_currency NVARCHAR(3) NULL
GO

-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-5421
-- ============================================

-- --------------------------------------------
--  Adds company id and company name columns to batch order table
-- --------------------------------------------

ALTER TABLE batch_order ADD company_id nvarchar(36)
GO

ALTER TABLE batch_order ADD company_name nvarchar(140)
GO

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-785
-- ============================================

-- --------------------------------------------
-- Add confirmation_id to reference a confirmation/txn signing entry
ALTER TABLE pmt_order ADD confirmation_id NVARCHAR(36) NULL
GO