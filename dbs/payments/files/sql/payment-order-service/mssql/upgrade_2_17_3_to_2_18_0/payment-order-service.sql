-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4583
-- ============================================

-- --------------------------------------------
-- Add columns for storing original (raw) batch input, bank branch code, batch entry class, batch transaction code and batch transaction credit debit indicator. Dropped not null constraint from batch account and batch account scheme.
-- --------------------------------------------

ALTER TABLE batch_upload ADD raw_data nvarchar(MAX)
GO

ALTER TABLE batch_error ALTER COLUMN error_code varchar(100)
GO

ALTER TABLE batch_order ADD raw_data nvarchar(MAX)
GO

ALTER TABLE batch_order ADD entry_class varchar(3)
GO

ALTER TABLE batch_order ADD bank_branch_code varchar(11)
GO

ALTER TABLE batch_order ALTER COLUMN account_number varchar(36) NULL
GO

ALTER TABLE batch_order ALTER COLUMN account_scheme varchar(4) NULL
GO

ALTER TABLE batch_transaction ADD raw_data nvarchar(MAX)
GO

ALTER TABLE batch_transaction ADD transaction_code varchar(4)
GO

ALTER TABLE batch_transaction ADD counterparty_bank_branch_code varchar(11)
GO

ALTER TABLE batch_transaction ADD credit_debit_indicator varchar(6)
GO

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-3
-- ============================================

-- --------------------------------------------
-- Update size for account_scheme to support A2A payments
-- --------------------------------------------

ALTER TABLE batch_order ALTER COLUMN account_scheme VARCHAR(11) NULL;
GO

ALTER TABLE pmt_order ALTER COLUMN account_scheme NVARCHAR(11) NULL;
GO

ALTER TABLE pmt_txn ALTER COLUMN account_scheme NVARCHAR(11) NULL;
GO