CREATE TABLE location (id int IDENTITY (1, 1) NOT NULL, external_id varchar(255) NOT NULL, latitude decimal(10, 6), longitude decimal(10, 6), address_line_1 varchar(255), address_line_2 varchar(255), post_code varchar(255), city varchar(255), state varchar(50), country varchar(255), complete_address varchar(255), source varchar(255) NOT NULL, inserted_at datetime NOT NULL, updated_at datetime, CONSTRAINT PK_LOCATION PRIMARY KEY (id))
GO

CREATE TABLE merchant (id int IDENTITY (1, 1) NOT NULL, external_id varchar(255) NOT NULL, name varchar(255) NOT NULL, logo varchar(255), website varchar(255), location_id int, source varchar(255) NOT NULL, inserted_at datetime NOT NULL, updated_at datetime, CONSTRAINT PK_MERCHANT PRIMARY KEY (id), CONSTRAINT fk_location_id FOREIGN KEY (location_id) REFERENCES location(id))
GO

CREATE TABLE enriched_transaction (id int IDENTITY (1, 1) NOT NULL, arrangement_id varchar(36) NOT NULL, transaction_id varchar(36) NOT NULL, category_id int NOT NULL, merchant_id int, description varchar(255) NOT NULL, source varchar(255) NOT NULL, inserted_at datetime NOT NULL, CONSTRAINT PK_ENRICHED_TRANSACTION PRIMARY KEY (id), CONSTRAINT fk_merchant_id FOREIGN KEY (merchant_id) REFERENCES merchant(id))
GO

CREATE TABLE user_transaction_override (id int IDENTITY (1, 1) NOT NULL, transaction_id varchar(36) NOT NULL, category_id int NOT NULL, inserted_at datetime NOT NULL, updated_at datetime, CONSTRAINT PK_USER_TRANSACTION_OVERRIDE PRIMARY KEY (id))
GO

CREATE NONCLUSTERED INDEX ix_enriched_transaction_transaction_id ON enriched_transaction(transaction_id)
GO

CREATE UNIQUE NONCLUSTERED INDEX uq_merchant_external_id_source ON merchant(external_id, source)
GO

CREATE NONCLUSTERED INDEX ix_user_transaction_override_transaction_id ON user_transaction_override(transaction_id)
GO

CREATE NONCLUSTERED INDEX ix_location_external_id_source ON location(external_id, source)
GO

