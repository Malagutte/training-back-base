SET SESSION group_concat_max_len = 1000000;

DROP TABLE IF EXISTS user_additions_json_formated;

CREATE TEMPORARY TABLE user_additions_json_formated
SELECT add_prop_en_user_id                                                                               AS id,
       CONCAT('{', GROUP_CONCAT(CONCAT(JSON_QUOTE(property_key), ':', JSON_QUOTE(property_value))),
              '}')                                                                                       AS json_formated
FROM add_prop_en_user
GROUP BY add_prop_en_user_id;

UPDATE en_user u
SET additions = (SELECT json_formated FROM user_additions_json_formated WHERE id = u.id);

COMMIT;