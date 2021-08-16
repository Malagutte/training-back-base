-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-3814
-- ============================================

-- --------------------------------------------
-- Extend status column length for batch_order, add status and external_key columns to batch_transaction
-- --------------------------------------------

ALTER TABLE batch_order ALTER COLUMN status varchar(12)
GO

ALTER TABLE batch_transaction ADD external_key varchar(36)
GO

ALTER TABLE batch_transaction ADD status varchar(12)
GO

UPDATE batch_transaction SET external_key = lower(newid())
GO

ALTER TABLE batch_transaction ALTER COLUMN external_key varchar(36) NOT NULL
GO

ALTER TABLE batch_transaction ADD CONSTRAINT uq_batch_txn_orderid_extkey UNIQUE (batch_order_id, external_key)
GO