-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-3814
-- ============================================

-- --------------------------------------------
-- Extend status column length for batch_order, add status and external_key columns to batch_transaction
-- --------------------------------------------

ALTER TABLE batch_order MODIFY status VARCHAR(12);

ALTER TABLE batch_transaction ADD external_key VARCHAR(36) NULL, ADD status VARCHAR(12) NULL;

UPDATE batch_transaction SET external_key = uuid();

ALTER TABLE batch_transaction MODIFY external_key VARCHAR(36) NOT NULL;

ALTER TABLE batch_transaction ADD CONSTRAINT uq_batch_txn_orderid_extkey UNIQUE (batch_order_id, external_key);