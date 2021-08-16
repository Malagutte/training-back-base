BEGIN TRAN;

WITH add_prop_en_user_json AS (
    SELECT add_prop_en_user_id,
           CONCAT('{', STUFF(
                   (SELECT N', ' + CONCAT('"', STRING_ESCAPE(property_key, 'json'), '":"',
                                          STRING_ESCAPE(property_value, 'json'), '"')
                    FROM add_prop_en_user AS user_add
                    WHERE user_add.add_prop_en_user_id = user_add2.add_prop_en_user_id
                    ORDER BY add_prop_en_user_id
                    FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''), '}') AS json_formated
    FROM add_prop_en_user AS user_add2
    GROUP BY add_prop_en_user_id
)
UPDATE en_user
SET additions = (SELECT json_formated FROM add_prop_en_user_json WHERE add_prop_en_user_id = en_user.id);

COMMIT TRAN;
