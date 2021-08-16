--  This upgrade script has been copied from the 'party-pandp-service'.
--  CB-3641 new indices for external id and service agreement id
CREATE INDEX ix_party_external_id ON party(external_id);

CREATE INDEX ix_party_service_agreement_id ON party(service_agreement_id);