DROP TABLE events
GO

DROP TABLE commands
GO

DROP TABLE snapshots
GO

CREATE INDEX ix_ext_arrangement ON fin_txn(external_arrangement_id)
GO