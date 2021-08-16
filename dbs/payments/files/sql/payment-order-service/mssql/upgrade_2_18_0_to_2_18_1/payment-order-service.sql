-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-5532
-- ============================================

ALTER TABLE pmt_order ADD intra_legal_entity BIT
GO

UPDATE pmt_order SET intra_legal_entity = 0;
GO

-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4450
-- ============================================

-- --------------------------------------------
-- Extend batch upload type (file type) max length to 40 characters.
-- --------------------------------------------

ALTER TABLE batch_upload ALTER COLUMN file_type varchar(40)
GO
