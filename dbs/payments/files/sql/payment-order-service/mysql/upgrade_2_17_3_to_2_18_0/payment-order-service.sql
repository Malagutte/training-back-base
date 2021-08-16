-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4688
-- ============================================

-- --------------------------------------------
-- Align batch_order_type column length for MySql
-- --------------------------------------------

ALTER TABLE batch_order MODIFY batch_order_type VARCHAR(40) NOT NULL;

-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4583
-- ============================================

-- --------------------------------------------
-- Add columns for storing original (raw) batch input, bank branch code, batch entry class, batch transaction code and batch transaction credit debit indicator. Dropped not null constraint from batch account and batch account scheme.
-- --------------------------------------------

ALTER TABLE batch_upload ADD raw_data LONGTEXT CHARACTER SET utf8 NULL;

ALTER TABLE batch_error MODIFY error_code VARCHAR(100);

ALTER TABLE batch_order ADD raw_data LONGTEXT CHARACTER SET utf8 NULL, ADD entry_class VARCHAR(3) NULL, ADD bank_branch_code VARCHAR(11) NULL;

ALTER TABLE batch_order MODIFY account_number VARCHAR(36) NULL;

ALTER TABLE batch_order MODIFY account_scheme VARCHAR(4) NULL;

ALTER TABLE batch_transaction ADD raw_data LONGTEXT CHARACTER SET utf8 NULL, ADD transaction_code VARCHAR(4) NULL, ADD counterparty_bank_branch_code VARCHAR(11) NULL, ADD credit_debit_indicator VARCHAR(6) NULL;

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-3
-- ============================================

-- --------------------------------------------
-- Update size for account_scheme to support A2A payments
-- --------------------------------------------

ALTER TABLE batch_order MODIFY account_scheme VARCHAR(11) NULL;

ALTER TABLE pmt_order MODIFY account_scheme VARCHAR(11) NULL;

ALTER TABLE pmt_txn MODIFY account_scheme VARCHAR(11) NULL;

