-- CB-5521 new indices for legal entity id
CREATE NONCLUSTERED INDEX ix_party_legal_entity_id ON party(legal_entity_id)
GO