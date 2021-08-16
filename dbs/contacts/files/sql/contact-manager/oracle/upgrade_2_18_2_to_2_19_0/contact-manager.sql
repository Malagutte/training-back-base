-- CB-3133
-- Store additions as a json string in a CLOB field rather than in a separate table
ALTER TABLE party ADD additions NCLOB;

ALTER TABLE account_information ADD additions NCLOB;

UPDATE PARTY p SET p.ADDITIONS = (
    SELECT (
        CASE COUNT(app.ADD_PROP_PARTY_ID)
        WHEN 0 THEN NULL
        ELSE '{' || LISTAGG(
            '"' ||
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTY_KEY, '\', '\\'), '"', '\"'), '/', '\/'), CHR(8) , '\b'), CHR(9) , '\t'), CHR(10), '\n'), CHR(12), '\f'), CHR(13), '\r') ||
            '":"' ||
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTY_VALUE, '\', '\\'), '"', '\"'), '/', '\/'), CHR(8) , '\b'), CHR(9) , '\t'), CHR(10), '\n'), CHR(12), '\f'), CHR(13), '\r') ||
            '"'
        , ', ' ) WITHIN GROUP (ORDER BY PROPERTY_KEY) || '}'
        END
    )
    FROM ADD_PROP_PARTY app
    WHERE app.ADD_PROP_PARTY_ID = p.ID
);

COMMIT;

UPDATE ACCOUNT_INFORMATION ai SET ai.ADDITIONS = (
    SELECT (
        CASE COUNT(apai.ADD_PROP_ACC_ID)
        WHEN 0 THEN NULL
        ELSE '{' || LISTAGG(
            '"' ||
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTY_KEY, '\', '\\'), '"', '\"'), '/', '\/'), CHR(8) , '\b'), CHR(9) , '\t'), CHR(10), '\n'), CHR(12), '\f'), CHR(13), '\r') ||
            '":"' ||
            REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(PROPERTY_VALUE, '\', '\\'), '"', '\"'), '/', '\/'), CHR(8) , '\b'), CHR(9) , '\t'), CHR(10), '\n'), CHR(12), '\f'), CHR(13), '\r') ||
            '"'
        , ', ' ) WITHIN GROUP (ORDER BY PROPERTY_KEY) || '}'
        END
    )
    FROM ADD_PROP_ACCOUNT_INFORMATION apai
    WHERE apai.ADD_PROP_ACC_ID = ai.UUID
);

COMMIT;

DROP TABLE add_prop_account_information;

DROP TABLE add_prop_party;

