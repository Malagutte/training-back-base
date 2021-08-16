-- ============================================
-- ## https://backbase.atlassian.net/browse/DBSA-3965
-- ============================================

-- --------------------------------------------
-- This migration need to be executed in case project use data model extension in a separate table
-- and choose to flatten the additional properties, which means storing additions as a json string
-- in a BLOB field rather than in a separate table
--
-- https://community.backbase.com/documentation/DBS/latest/payments_extend_data_model
-- --------------------------------------------

BEGIN TRAN;

WITH pmt_order_add_prop_json_formated AS (
	SELECT payment_id, CONCAT( '{' , STUFF(
		(SELECT N', ' +  CONCAT('"', STRING_ESCAPE(property_key, 'json'), '":"', STRING_ESCAPE(property_value, 'json'), '"')
			FROM pmt_order_add_prop AS p2
			WHERE p2.payment_id = p.payment_id 
			ORDER BY payment_id
			FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''), '}') AS json_formated
	FROM pmt_order_add_prop AS p
	GROUP BY payment_id
)
UPDATE pmt_order SET additions = (SELECT json_formated FROM pmt_order_add_prop_json_formated WHERE payment_id = pmt_order.id);

WITH pmt_txn_add_prop_json_formated AS (
	SELECT txn_id, CONCAT( '{' , STUFF(
		(SELECT N', ' +  CONCAT('"', STRING_ESCAPE(property_key, 'json'), '":"', STRING_ESCAPE(property_value, 'json'), '"')
			FROM pmt_txn_add_prop AS p2
			WHERE p2.txn_id = p.txn_id 
			ORDER BY txn_id
			FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''), '}') AS json_formated
	FROM pmt_txn_add_prop AS p
	GROUP BY txn_id
)
UPDATE pmt_txn SET additions = (SELECT json_formated FROM pmt_txn_add_prop_json_formated WHERE txn_id = pmt_txn.id);

COMMIT TRAN;