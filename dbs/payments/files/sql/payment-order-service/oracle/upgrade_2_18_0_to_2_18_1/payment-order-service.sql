-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-5532
-- ============================================

ALTER TABLE pmt_order ADD intra_legal_entity CHAR(1) NULL;

UPDATE pmt_order SET intra_legal_entity = '0';

ALTER TABLE pmt_order ADD CONSTRAINT ck_pmt_order_int_leg_ent CHECK (intra_legal_entity IN ('0', '1'));

-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4450
-- ============================================

-- --------------------------------------------
-- Extend batch upload type (file type) max length to 40 characters.
-- --------------------------------------------

ALTER TABLE batch_upload MODIFY file_type VARCHAR2(40);
