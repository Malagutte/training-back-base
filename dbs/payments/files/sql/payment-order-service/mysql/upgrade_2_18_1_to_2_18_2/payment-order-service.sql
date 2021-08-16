-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4763
-- ============================================

--  An example of hidden batch payment is the balancing debit payment in a credit batch order.
ALTER TABLE batch_transaction ADD hidden BIT(1) DEFAULT 0 NOT NULL;

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-462
-- ============================================

ALTER TABLE pmt_txn ADD charge_bearer varchar(3) NULL, ADD fee_amount decimal(23,5) NULL, ADD fee_currency varchar(3) NULL;