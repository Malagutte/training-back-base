-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4583
-- ============================================

-- --------------------------------------------
-- Add columns for storing original (raw) batch input, bank branch code, batch entry class, batch transaction code and batch transaction credit debit indicator. Dropped not null constraint from batch account and batch account scheme.
-- --------------------------------------------

ALTER TABLE batch_upload ADD raw_data NCLOB;

ALTER TABLE batch_error MODIFY error_code VARCHAR2(100);

ALTER TABLE batch_order ADD raw_data NCLOB;

ALTER TABLE batch_order ADD entry_class VARCHAR2(3);

ALTER TABLE batch_order ADD bank_branch_code VARCHAR2(11);

ALTER TABLE batch_order MODIFY account_number NULL;

ALTER TABLE batch_order MODIFY account_scheme NULL;

ALTER TABLE batch_transaction ADD raw_data NCLOB;

ALTER TABLE batch_transaction ADD transaction_code VARCHAR2(4);

ALTER TABLE batch_transaction ADD counterparty_bank_branch_code VARCHAR2(11);

ALTER TABLE batch_transaction ADD credit_debit_indicator VARCHAR2(6);

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-3
-- ============================================

-- --------------------------------------------
-- Update size for account_scheme to support A2A payments
-- --------------------------------------------

ALTER TABLE batch_order MODIFY account_scheme VARCHAR2(11);

ALTER TABLE pmt_order MODIFY account_scheme VARCHAR2(11);

ALTER TABLE pmt_txn MODIFY account_scheme VARCHAR2(11);

