--  CB-3133
--  Store additions as a json string in a CLOB field rather than in a separate table

ALTER TABLE party ADD additions LONGTEXT CHARACTER SET utf8 NULL;

ALTER TABLE account_information ADD additions LONGTEXT CHARACTER SET utf8 NULL;

SET SESSION group_concat_max_len = 1000000;

DROP TABLE IF EXISTS add_prop_party_json_formated;

CREATE TEMPORARY TABLE add_prop_party_json_formated
SELECT add_prop_party_id AS id, CONCAT('{',  GROUP_CONCAT(CONCAT(JSON_QUOTE(property_key),':', JSON_QUOTE(property_value))), '}') AS json_formated
FROM add_prop_party
GROUP BY add_prop_party_id;

UPDATE party p SET additions = (SELECT json_formated FROM add_prop_party_json_formated WHERE id = p.id);

DROP TABLE IF EXISTS add_prop_account_information_json_formated;

CREATE TEMPORARY TABLE add_prop_account_information_json_formated
SELECT add_prop_acc_id AS id, CONCAT('{',  GROUP_CONCAT(CONCAT(JSON_QUOTE(property_key), ':', JSON_QUOTE(property_value))), '}') AS json_formated
FROM add_prop_account_information
GROUP BY add_prop_acc_id;

UPDATE account_information ai SET additions = (SELECT json_formated FROM add_prop_account_information_json_formated WHERE id = ai.uuid);

COMMIT;

DROP TABLE add_prop_account_information;

DROP TABLE add_prop_party;

