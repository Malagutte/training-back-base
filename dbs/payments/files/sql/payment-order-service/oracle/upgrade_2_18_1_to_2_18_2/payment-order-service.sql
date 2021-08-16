-- ============================================
-- ## https://backbase.atlassian.net/browse/CB-4763
-- ============================================

-- An example of hidden batch payment is the balancing debit payment in a credit batch order.
ALTER TABLE batch_transaction ADD hidden NUMBER(1) DEFAULT 0 NOT NULL;

-- ============================================
-- ## https://backbase.atlassian.net/browse/PAYM-462
-- ============================================

ALTER TABLE pmt_txn ADD charge_bearer VARCHAR2(3);

ALTER TABLE pmt_txn ADD fee_amount NUMBER(23,5);

ALTER TABLE pmt_txn ADD fee_currency VARCHAR2(3);

