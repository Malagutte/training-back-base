CREATE TABLE id_group (
    id bigint NOT NULL,
    ref_id varchar(36) NOT NULL,
    info varchar(40) NOT NULL,
    CONSTRAINT id_group_PK PRIMARY KEY (id, ref_id)
);
CREATE INDEX ix_id_group_id ON id_group (id);