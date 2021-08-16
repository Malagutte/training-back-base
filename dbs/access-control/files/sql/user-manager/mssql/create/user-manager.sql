CREATE TABLE [en_user]
(
    [id]                 [NVARCHAR](36)  NOT NULL,
    [external_id]        [NVARCHAR](64)  NOT NULL,
    [legal_entity_id]    [NVARCHAR](36)  NOT NULL,
    [full_name]          [NVARCHAR](255) NOT NULL,
    [preferred_language] [NVARCHAR](8)   DEFAULT NULL,
    [external_id_up]     AS UPPER([external_id]),
    [full_name_up]       AS UPPER([full_name]),
    [additions]          [NVARCHAR](max) DEFAULT NULL,
    CONSTRAINT [pk_en_user] PRIMARY KEY ([id]),
    CONSTRAINT uq_en_user_01 UNIQUE (external_id)
)
GO

CREATE NONCLUSTERED INDEX ix_en_user_leid
    ON [en_user] ([legal_entity_id])
GO

CREATE UNIQUE NONCLUSTERED INDEX uq_external_id_up ON [en_user] ([external_id_up])
GO

CREATE NONCLUSTERED INDEX ix_full_name_up ON [en_user] ([full_name_up])
GO


CREATE TABLE [realm]
(
    [id]         [NVARCHAR](36)  NOT NULL,
    [realm_name] [NVARCHAR](255) NOT NULL,
    CONSTRAINT [pk_realm] PRIMARY KEY ([id]),
    CONSTRAINT [uq_rlm_realm_name] UNIQUE ([realm_name])
)
GO

INSERT INTO [realm] ([id], [realm_name])
VALUES ('0006f11c-366d-43cc-83ce-9277cda55092', 'backbase')
GO

CREATE TABLE [legal_entity_assigned_realm]
(
    [legal_entity_id] [NVARCHAR](36) NOT NULL,
    [realm_id]        [NVARCHAR](36) NOT NULL,
    CONSTRAINT [pk_le_assign_realm] PRIMARY KEY ([legal_entity_id]),
    CONSTRAINT [fk_lear2realm] FOREIGN KEY ([realm_id]) REFERENCES [realm] ([id]) ON DELETE CASCADE
)
GO

create TABLE [approval_user]
(
    [approval_id]   [NVARCHAR](36)   NOT NULL,
    [user_id]       [NVARCHAR](36)   NOT NULL,
    [status]        [NVARCHAR](36)   NOT NULL,
    [approval_type] [NVARCHAR](36)   NOT NULL,
    [patch]         [NVARCHAR](2000) NOT NULL,
    [created_at]    [DATETIME]       NOT NULL,
    CONSTRAINT [pk_approval_user] PRIMARY KEY ([approval_id]),
    CONSTRAINT [uq_approval_id] UNIQUE ([approval_id])
)
GO
