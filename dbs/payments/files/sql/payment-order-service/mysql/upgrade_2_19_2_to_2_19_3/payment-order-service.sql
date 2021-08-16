-- =================================================
-- ## https://backbase.atlassian.net/browse/PAYM-484
-- =================================================

-- -----------------------------------------------------------------------
-- Add columns to transaction table to store exchange rate information
-- -----------------------------------------------------------------------

ALTER TABLE pmt_txn ADD exc_rate_currency VARCHAR(3) NULL;

ALTER TABLE pmt_txn ADD exc_rate DECIMAL(23,5) NULL;

ALTER TABLE pmt_txn ADD exc_rate_type VARCHAR(35) NULL;

ALTER TABLE pmt_txn ADD exc_rate_contract_id VARCHAR(256) NULL;

-- -----------------------------------------------------------------------
-- Fit size of payment_type in templates to one in payments.
-- -----------------------------------------------------------------------

ALTER TABLE template MODIFY payment_type varchar(22);