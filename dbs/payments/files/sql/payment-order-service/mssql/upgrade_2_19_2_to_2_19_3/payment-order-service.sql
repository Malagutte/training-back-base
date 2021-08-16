-- =================================================
-- ## https://backbase.atlassian.net/browse/PAYM-484
-- =================================================

-- -----------------------------------------------------------------------
-- Add columns to transaction table to store exchange rate information
-- -----------------------------------------------------------------------

ALTER TABLE pmt_txn ADD exc_rate_currency NVARCHAR(3) NULL
GO

ALTER TABLE pmt_txn ADD exc_rate DECIMAL(23,5) NULL
GO

ALTER TABLE pmt_txn ADD exc_rate_type NVARCHAR(35) NULL
GO

ALTER TABLE pmt_txn ADD exc_rate_contract_id NVARCHAR(256) NULL
GO

-- -----------------------------------------------------------------------
-- Fit size of payment_type in templates to one in payments.
-- -----------------------------------------------------------------------

ALTER TABLE template ALTER COLUMN payment_type NVARCHAR(22)
GO