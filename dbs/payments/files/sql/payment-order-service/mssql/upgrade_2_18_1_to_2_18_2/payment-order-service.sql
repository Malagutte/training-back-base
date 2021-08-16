-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-5532
-- ============================================

-- An example of hidden batch payment is the balancing debit payment in a credit batch order.
ALTER TABLE batch_transaction ADD hidden bit CONSTRAINT DF_batch_transaction_hidden DEFAULT 0 NOT NULL
GO

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-462
-- ============================================

ALTER TABLE pmt_txn ADD charge_bearer varchar(3)
GO

ALTER TABLE pmt_txn ADD fee_amount decimal(23,5)
GO

ALTER TABLE pmt_txn ADD fee_currency varchar(3)
GO

