-- CB-3133
-- Store additions as a json string in a CLOB field rather than in a separate table

ALTER TABLE party ADD additions nvarchar(MAX)
GO

ALTER TABLE account_information ADD additions nvarchar(MAX)
GO

BEGIN TRAN
GO

WITH add_prop_party_json_formated AS (
    SELECT add_prop_party_id, CONCAT( '{' , STUFF(
        (SELECT N', ' +  CONCAT('"', STRING_ESCAPE(CONVERT(nvarchar(MAX), property_key), 'json'), '":"', STRING_ESCAPE(CONVERT(nvarchar(MAX), property_value), 'json'), '"')
            FROM add_prop_party AS app2
            WHERE app2.add_prop_party_id = app.add_prop_party_id
            ORDER BY add_prop_party_id
            FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''), '}') AS json_formated
    FROM add_prop_party AS app
    GROUP BY add_prop_party_id
)
UPDATE party SET additions = (SELECT json_formated FROM add_prop_party_json_formated WHERE add_prop_party_id = party.id);
GO

WITH add_prop_account_information_json_formated AS (
    SELECT add_prop_acc_id, CONCAT( '{' , STUFF(
        (SELECT N', ' +  CONCAT('"', STRING_ESCAPE(CONVERT(nvarchar(MAX), property_key), 'json'), '":"', STRING_ESCAPE(CONVERT(nvarchar(MAX), property_value), 'json'), '"')
            FROM add_prop_account_information AS apai2
            WHERE apai2.add_prop_acc_id = apai.add_prop_acc_id
            ORDER BY add_prop_acc_id
            FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''), '}') AS json_formated
    FROM add_prop_account_information AS apai
    GROUP BY add_prop_acc_id
)
UPDATE account_information SET additions = (SELECT json_formated FROM add_prop_account_information_json_formated WHERE add_prop_acc_id = account_information.uuid);
GO

COMMIT TRAN
GO

DROP TABLE add_prop_account_information
GO

DROP TABLE add_prop_party
GO

