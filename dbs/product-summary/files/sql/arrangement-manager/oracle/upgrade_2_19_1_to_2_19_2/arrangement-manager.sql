CREATE TABLE id_group (
    id NUMBER(38, 0) NOT NULL,
    ref_id varchar2(36) NOT NULL,
    info varchar2(40) NOT NULL,
    CONSTRAINT id_group_PK PRIMARY KEY (id, ref_id)
);
CREATE INDEX ix_id_group_id ON id_group (id);