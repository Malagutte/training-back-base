ALTER TABLE [en_user]
    ADD [external_id_up] AS UPPER([external_id]),
        [full_name_up] AS UPPER([full_name]),
        [additions] [NVARCHAR](max) DEFAULT NULL
GO

CREATE NONCLUSTERED INDEX ix_en_user_leid ON [en_user] ([legal_entity_id])
GO

CREATE UNIQUE NONCLUSTERED INDEX uq_external_id_up ON [en_user] ([external_id_up])
GO

CREATE NONCLUSTERED INDEX ix_full_name_up ON [en_user] ([full_name_up])
GO