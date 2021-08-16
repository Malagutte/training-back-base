CREATE TABLE `account_information` (
  `uuid` varchar(36) NOT NULL,
  `account_number` varchar(34) DEFAULT NULL,
  `alias` varchar(34) DEFAULT NULL,
  `bank_address_line1` varchar(70) DEFAULT NULL,
  `bank_address_line2` varchar(70) DEFAULT NULL,
  `bank_street_name` varchar(70) DEFAULT NULL,
  `bank_town` varchar(35) DEFAULT NULL,
  `bank_code` varchar(11) DEFAULT NULL,
  `bank_country` varchar(2) DEFAULT NULL,
  `bank_name` varchar(140) DEFAULT NULL,
  `bank_post_code` varchar(16) DEFAULT NULL,
  `bank_country_sub_division` varchar(35) DEFAULT NULL,
  `bic` varchar(11) DEFAULT NULL,
  `iban` varchar(34) DEFAULT NULL,
  `name` varchar(140) DEFAULT NULL,
  `acc_holder_addr_line1` varchar(70) DEFAULT NULL,
  `acc_holder_addr_line2` varchar(70) DEFAULT NULL,
  `acc_holder_street_name` varchar(70) DEFAULT NULL,
  `acc_holder_town` varchar(35) DEFAULT NULL,
  `acc_holder_country` varchar(2) DEFAULT NULL,
  `acc_holder_post_code` varchar(16) DEFAULT NULL,
  `acc_holder_country_sub_div` varchar(35) DEFAULT NULL,
  `external_id` varchar(32) DEFAULT NULL,
  `additions` longtext character set utf8 DEFAULT NULL
);

ALTER TABLE `account_information`
  ADD PRIMARY KEY (`uuid`),
  ADD KEY `idx_account_number` (`account_number`),
  ADD KEY `idx_party_alias` (`alias`),
  ADD KEY `idx_iban` (`iban`),
  ADD KEY `idx_name` (`name`);

######

CREATE TABLE `party` (
  `id` varchar(36) NOT NULL,
  `access_context_scope` int(11) DEFAULT NULL,
  `address_line1` varchar(70) DEFAULT NULL,
  `address_line2` varchar(70) DEFAULT NULL,
  `street_name` varchar(70) DEFAULT NULL,
  `town` varchar(35) DEFAULT NULL,
  `alias` varchar(70) DEFAULT NULL,
  `bb_id` varchar(36) DEFAULT NULL,
  `category` varchar(70) DEFAULT NULL,
  `contact_person` varchar(70) DEFAULT NULL,
  `country` varchar(2) DEFAULT NULL,
  `email_id` varchar(255) DEFAULT NULL,
  `legal_entity_id` varchar(36) DEFAULT NULL,
  `name` varchar(140) DEFAULT NULL,
  `phone_number` varchar(30) DEFAULT NULL,
  `service_agreement_id` varchar(36) DEFAULT NULL,
  `post_code` varchar(16) DEFAULT NULL,
  `country_sub_division` varchar(35) DEFAULT NULL,
  `external_id` varchar(32) DEFAULT NULL,
  `approval_id` varchar(36) DEFAULT NULL,
  `active_party_id` varchar(36) DEFAULT NULL,
  `status` varchar(16) DEFAULT 'ACTIVE',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `action` varchar(6) DEFAULT NULL,
  `additions` longtext character set utf8 DEFAULT NULL
);

ALTER TABLE `party`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_alias` (`alias`),
  ADD KEY `idx_bbid_id` (`bb_id`,`id`),
  ADD KEY `idx_party_name` (`name`),
  ADD KEY `ix_party_external_id` (`external_id`),
  ADD KEY `ix_party_service_agreement_id` (`service_agreement_id`);

######

CREATE TABLE `party_accounts` (
  `party_id` varchar(36) DEFAULT NULL,
  `accounts_uuid` varchar(36) DEFAULT NULL
);

ALTER TABLE `party_accounts`
  ADD UNIQUE KEY `uk_account_id` (`accounts_uuid`),
  ADD KEY `fk_party_id` (`party_id`);

ALTER TABLE `party_accounts`
  ADD CONSTRAINT `fk_account_id` FOREIGN KEY (`accounts_uuid`) REFERENCES `account_information` (`uuid`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_party_id` FOREIGN KEY (`party_id`) REFERENCES `party` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE index `ix_party_accounts_01` on `party_accounts`(`accounts_uuid`);
CREATE index `ix_party_accounts_02` on `party_accounts`(`party_id`);

######

