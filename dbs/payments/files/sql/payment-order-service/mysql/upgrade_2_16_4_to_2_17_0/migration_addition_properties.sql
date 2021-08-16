-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-3965
-- ============================================

-- --------------------------------------------
-- This migration need to be executed in case project use data model extension in a separate table
-- and choose to flatten the additional properties, which means storing additions as a json string
-- in a BLOB field rather than in a separate table
--
-- Increase "group_concat_max_len" parameter to 18446744073709551615 in case you run into this error
-- "ERROR 1260 (HY000): %d line(s) were cut by GROUP_CONCAT()"
--
-- https://community.backbase.com/documentation/DBS/latest/payments_extend_data_model
-- --------------------------------------------

SET SESSION group_concat_max_len = 1000000;

DROP TABLE IF EXISTS pmt_order_add_prop_json_formated;

CREATE TEMPORARY TABLE pmt_order_add_prop_json_formated
SELECT payment_id AS id, CONCAT('{',  GROUP_CONCAT(CONCAT(JSON_QUOTE(property_key),':', JSON_QUOTE(property_value))), '}') AS json_formated
FROM pmt_order_add_prop
GROUP BY payment_id;

UPDATE pmt_order po SET additions = (SELECT json_formated FROM pmt_order_add_prop_json_formated WHERE id = po.id);

DROP TABLE IF EXISTS pmt_txn_add_prop_json_formated;

CREATE TEMPORARY TABLE pmt_txn_add_prop_json_formated
SELECT txn_id AS id, CONCAT('{',  GROUP_CONCAT(CONCAT(JSON_QUOTE(property_key), ':', JSON_QUOTE(property_value))), '}') AS json_formated
FROM pmt_txn_add_prop
GROUP BY txn_id;

UPDATE pmt_txn pt SET additions = (SELECT json_formated FROM pmt_txn_add_prop_json_formated WHERE id = pt.id);

COMMIT;