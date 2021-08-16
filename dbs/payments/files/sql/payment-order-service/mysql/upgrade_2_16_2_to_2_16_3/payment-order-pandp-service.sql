-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-4732
-- ============================================

-- --------------------------------------------
-- Add new columns account_type and entry_class
-- --------------------------------------------

ALTER TABLE pmt_order ADD entry_class VARCHAR(3) NULL;

ALTER TABLE pmt_txn ADD account_type VARCHAR(10) NULL;

ALTER TABLE pmt_txn ADD recipient_id VARCHAR(15) NULL;

