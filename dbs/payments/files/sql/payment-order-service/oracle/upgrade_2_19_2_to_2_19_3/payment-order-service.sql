-- =================================================
-- ## https://backbase.atlassian.net/browse/PAYM-484
-- =================================================

-- -----------------------------------------------------------------------
-- Add columns to transaction table to store exchange rate information
-- -----------------------------------------------------------------------

ALTER TABLE pmt_txn ADD exc_rate_currency VARCHAR2(3) NULL;

ALTER TABLE pmt_txn ADD exc_rate NUMBER(23,5) NULL;

ALTER TABLE pmt_txn ADD exc_rate_type VARCHAR2(35) NULL;

ALTER TABLE pmt_txn ADD exc_rate_contract_id VARCHAR2(256) NULL;

-- -----------------------------------------------------------------------
-- Fit size of payment_type in templates to one in payments.
-- -----------------------------------------------------------------------

ALTER TABLE template MODIFY payment_type VARCHAR2(22);