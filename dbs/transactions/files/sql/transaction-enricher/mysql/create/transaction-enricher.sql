CREATE TABLE location (id INT AUTO_INCREMENT NOT NULL, external_id VARCHAR(255) NOT NULL, latitude DECIMAL(10, 6) NULL, longitude DECIMAL(10, 6) NULL, address_line_1 VARCHAR(255) NULL, address_line_2 VARCHAR(255) NULL, post_code VARCHAR(255) NULL, city VARCHAR(255) NULL, state VARCHAR(50) NULL, country VARCHAR(255) NULL, complete_address VARCHAR(255) NULL, source VARCHAR(255) NOT NULL, inserted_at timestamp NOT NULL, updated_at timestamp NULL, CONSTRAINT PK_LOCATION PRIMARY KEY (id));

CREATE TABLE merchant (id INT AUTO_INCREMENT NOT NULL, external_id VARCHAR(255) NOT NULL, name VARCHAR(255) NOT NULL, logo VARCHAR(255) NULL, website VARCHAR(255) NULL, location_id INT NULL, source VARCHAR(255) NOT NULL, inserted_at timestamp NOT NULL, updated_at timestamp NULL, CONSTRAINT PK_MERCHANT PRIMARY KEY (id), CONSTRAINT fk_location_id FOREIGN KEY (location_id) REFERENCES location(id));

CREATE TABLE enriched_transaction (id INT AUTO_INCREMENT NOT NULL, arrangement_id VARCHAR(36) NOT NULL, transaction_id VARCHAR(36) NOT NULL, category_id INT NOT NULL, merchant_id INT NULL, `description` VARCHAR(255) NOT NULL, source VARCHAR(255) NOT NULL, inserted_at timestamp NOT NULL, CONSTRAINT PK_ENRICHED_TRANSACTION PRIMARY KEY (id), CONSTRAINT fk_merchant_id FOREIGN KEY (merchant_id) REFERENCES merchant(id));

CREATE TABLE user_transaction_override (id INT AUTO_INCREMENT NOT NULL, transaction_id VARCHAR(36) NOT NULL, category_id INT NOT NULL, inserted_at timestamp NOT NULL, updated_at timestamp NULL, CONSTRAINT PK_USER_TRANSACTION_OVERRIDE PRIMARY KEY (id));

CREATE INDEX ix_enriched_transaction_transaction_id ON enriched_transaction(transaction_id);

CREATE UNIQUE INDEX uq_merchant_external_id_source ON merchant(external_id, source);

CREATE INDEX ix_user_transaction_override_transaction_id ON user_transaction_override(transaction_id);

CREATE INDEX ix_location_external_id_source ON location(external_id, source);

