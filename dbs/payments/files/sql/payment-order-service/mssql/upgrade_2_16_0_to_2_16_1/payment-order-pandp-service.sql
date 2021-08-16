-- ============================================
-- ## https://backbase.atlassian.net/browse/NEOP-90
-- ============================================

-- --------------------------------------------
-- Add mandate_id to payment transaction
-- --------------------------------------------

ALTER TABLE pmt_txn ADD
 mandate_id  NVARCHAR(15)
GO