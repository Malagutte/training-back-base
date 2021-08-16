-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4198
-- ============================================

-- --------------------------------------------
-- Add created_by for batch order
-- Copies created_by value from batch upload into related batch order.
-- --------------------------------------------

ALTER TABLE batch_order ADD created_by VARCHAR(36) NULL;

UPDATE batch_order SET created_by = (
  SELECT created_by
  FROM batch_upload
  WHERE batch_upload.id = batch_order.batch_upload_id)
WHERE created_by IS NULL;

COMMIT