  -- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4113
-- ============================================

-- --------------------------------------------
-- Add index for faster duplicate checks.
-- --------------------------------------------

CREATE INDEX ix_batch_upload_said_size ON batch_upload(service_agreement_id, reported_bytes);