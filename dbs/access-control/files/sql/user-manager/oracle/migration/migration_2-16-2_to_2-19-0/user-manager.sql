ALTER TABLE en_user
    ADD additions NCLOB NULL;
COMMIT;

CREATE INDEX ix_en_user_leid on en_user (legal_entity_id);
COMMIT;