SET DEFINE OFF;
DROP TABLE events;
DROP TABLE commands;
DROP TABLE snapshots;
CREATE INDEX ix_ext_arrangement ON fin_txn(external_arrangement_id);