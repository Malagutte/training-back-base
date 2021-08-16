-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-4732
-- ============================================

-- --------------------------------------------
-- Add new columns account_type and entry_class
-- --------------------------------------------

ALTER TABLE pmt_order ADD
 entry_class  NVARCHAR(3)
GO

ALTER TABLE pmt_txn ADD
 account_type  NVARCHAR(10)
GO

ALTER TABLE pmt_txn ADD
 recipient_id  NVARCHAR(15)
GO