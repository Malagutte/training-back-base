-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-5532
-- ============================================

ALTER TABLE pmt_order ADD intra_legal_entity CHAR(1) NULL;

UPDATE pmt_order SET intra_legal_entity = '0';

COMMIT;

-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4450
-- ============================================

-- --------------------------------------------
-- Extend batch upload type (file type) max length to 40 characters.
-- --------------------------------------------

ALTER TABLE batch_upload MODIFY file_type VARCHAR(40);
