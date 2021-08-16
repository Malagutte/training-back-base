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

UPDATE PMT_TXN pt SET pt.ADDITIONS = (
	SELECT (
		CASE COUNT(ptp.TXN_ID)
		WHEN 0 THEN NULL
		ELSE '{' || LISTAGG(
			'"' ||
			REPLACE(REPLACE(REPLACE(PROPERTY_KEY, '\', '\\'), '"', '\"'), '/', '\/') ||
			'":"' ||
			REPLACE(REPLACE(REPLACE(PROPERTY_VALUE, '\', '\\'), '"', '\"'), '/', '\/') ||
			'"'
		, ', ' ) WITHIN GROUP (ORDER BY PROPERTY_KEY) || '}'
		END
	)
	FROM PMT_TXN_ADD_PROP ptp
	WHERE ptp.TXN_ID = pt.ID
);

COMMIT;