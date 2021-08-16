UPDATE en_user u SET u.additions = (
	SELECT (
    		CASE COUNT(user_additions.add_prop_en_user_id)
    		WHEN 0 THEN NULL
    		ELSE '{' || LISTAGG(
    			'"' ||
    			REPLACE(REPLACE(REPLACE(property_key, '\', '\\'), '"', '\"'), '/', '\/') ||
    			'":"' ||
    			REPLACE(REPLACE(REPLACE(property_value, '\', '\\'), '"', '\"'), '/', '\/') ||
    			'"'
    		, ', ' ) WITHIN GROUP (ORDER BY add_prop_en_user_id) || '}'
    		END
    	)
	FROM add_prop_en_user user_additions
	WHERE user_additions.add_prop_en_user_id = u.id
);

COMMIT;