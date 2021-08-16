-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-4732
-- ============================================

-- --------------------------------------------
-- Add new columns account_type and entry_class
-- --------------------------------------------

ALTER TABLE pmt_order ADD entry_class VARCHAR2(3);

ALTER TABLE pmt_txn ADD account_type VARCHAR2(10);

ALTER TABLE pmt_txn ADD recipient_id VARCHAR2(15);

