-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-5533
-- ============================================

-- --------------------------------------------
-- Add new column service_agreement_id
-- --------------------------------------------

ALTER TABLE pmt_order ADD service_agreement_id NVARCHAR(36) NULL;