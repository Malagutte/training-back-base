-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-3814
-- ============================================

-- --------------------------------------------
-- Extend status column length for batch_order, add status and external_key columns to batch_transaction
-- --------------------------------------------

ALTER TABLE batch_order MODIFY status VARCHAR2(12);

ALTER TABLE batch_transaction ADD external_key VARCHAR2(36);

ALTER TABLE batch_transaction ADD status VARCHAR2(12);

UPDATE batch_transaction SET external_key = lower(regexp_replace(rawtohex(sys_guid()), '([A-F0-9]{8})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{4})([A-F0-9]{12})', '\1-\2-\3-\4-\5'));

ALTER TABLE batch_transaction MODIFY external_key NOT NULL;

ALTER TABLE batch_transaction ADD CONSTRAINT uq_batch_txn_orderid_extkey UNIQUE (batch_order_id, external_key);