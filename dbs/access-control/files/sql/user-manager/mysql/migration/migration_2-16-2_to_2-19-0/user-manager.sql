ALTER TABLE en_user
    ADD additions LONGTEXT NULL;

CREATE INDEX ix_en_user_leid ON en_user (legal_entity_id);