CREATE TABLE [user_profile] (
    [id]                 [NVARCHAR](36)     NOT NULL,
    [external_id]        [NVARCHAR](64)     NOT NULL,
    [user_id]            [NVARCHAR](36)     NOT NULL,
    [username]           [NVARCHAR](64)     NOT NULL,
    [representation]     [VARBINARY](MAX)   NOT NULL
)
GO

ALTER TABLE [user_profile] ADD CONSTRAINT [pk_user_profile] PRIMARY KEY (id)
GO

ALTER TABLE [user_profile] ADD CONSTRAINT [uq_user_profile_externalid] UNIQUE (external_id)
ALTER TABLE [user_profile] ADD CONSTRAINT [uq_user_profile_username] UNIQUE (username)
ALTER TABLE [user_profile] ADD CONSTRAINT [uq_user_profile_userid] UNIQUE (user_id)
GO
