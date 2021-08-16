create table arrangement
(
  id                           varchar(36) not null,
  bban                         varchar(50),
  iban                         varchar(34),
  accrued_interest             decimal(23, 5),
  alias                        varchar(50),
  available_balance            decimal(23, 5),
  booked_balance               decimal(23, 5),
  credit_limit                 decimal(23, 5),
  currency                     varchar(3),
  current_investment_value     decimal(23, 5),
  external_arrangement_id      varchar(50),
  external_product_id          varchar(50) not null,
  external_transfer_allowed    tinyint,
  name                         varchar(50),
  pan_suffix                   varchar(36),
  principal_amount             decimal(23, 5),
  product_id                   varchar(36) not null,
  product_number               varchar(36),
  urgent_transfer_allowed      tinyint,
  bic                          varchar(11),
  bank_branch_code             varchar(20),
  visible                      tinyint,
  account_opening_date         DATETIME(3) null default null,
  account_interest_rate        decimal(8, 2),
  value_date_balance           decimal(23, 5),
  credit_limit_usage           decimal(23, 5),
  credit_limit_interest_rate   decimal(8, 2),
  credit_limit_expiry_date     timestamp(3) null default null,
  start_date                   timestamp(3) null default null,
  term_unit                    varchar(1),
  term_number                  numeric(16),
  maturity_date                timestamp(3) null default null,
  maturity_amount              decimal(23, 5),
  auto_renewal_indicator       tinyint,
  interest_payment_freq_unit   varchar(1),
  interest_payment_freq_number numeric(16),
  interest_settlement_account  varchar(32),
  outstanding_principal_amount decimal(23, 5),
  monthly_instalment_amount    decimal(23, 5),
  amount_in_arrear             decimal(23, 5),
  minimum_required_balance     decimal(23, 5),
  credit_card_account_number   varchar(32),
  valid_thru                   timestamp(3) null default null,
  applicable_interest_rate     decimal(8, 2),
  account_holder_country       varchar(2),
  remaining_credit             decimal(23, 5),
  outstanding_payment          decimal(23, 5),
  minimum_payment              decimal(23, 5),
  minimum_payment_due_date     timestamp(3) null default null,
  total_investment_value       decimal(23, 5),
  account_holder_address_line1 varchar(70),
  account_holder_address_line2 varchar(70),
  account_holder_street_name   varchar(70),
  town                         varchar(35),
  post_code                    varchar(16),
  country_sub_division         varchar(35),
  credit_account               tinyint,
  debit_account                tinyint,
  account_holder_name          varchar(256),
  last_update_date             timestamp(3) null default null,
  date_deleted                 timestamp(3) null default null,
  is_deleted                   tinyint,
  deleted_ext_arr_id           varchar(50),
  custom_order                 int(10) not null default 0,
  source_id                    varchar(11),
  state_id                     int(10) unsigned,
  parent_id                    varchar(36),
  external_parent_id           varchar(50),
  additions                    longtext character set utf8 null
);

alter table arrangement add constraint pk_arrangement primary key (id);

create unique index ix_arrangement_1 on arrangement(external_arrangement_id);

/** adding indexes for improving performance **/
create index ix_arrangement_ex_trn_allowed on arrangement(external_transfer_allowed);
create index ix_arrangement_credit_account on arrangement(credit_account);
create index ix_arrangement_debit_account on arrangement(debit_account);
create index ix_arrangement_ext_prod_id on arrangement(external_product_id);
create index ix_arrangement_custom_order on arrangement(custom_order);
create index ix_arrangement_iban on arrangement(iban);

create table debit_card
(
  id                varchar(36) not null,
  arrangement_id    varchar(36) not null,
  pan_suffix        varchar(36),
  expiry_date       varchar(32),
  card_id           varchar(32),
  card_holder_name  varchar(64),
  card_type         varchar(32)
);

alter table debit_card add constraint pk_debit_card primary key (id);

alter table debit_card add constraint fk_debit_card2arrangement foreign key (arrangement_id) references arrangement(id);

create index ix_dc_arrangement_id on debit_card(arrangement_id);

/** product_kind **/
create table product_kind
(
  id           int(10),
  external_kind_id  varchar(50) not null,
  kind_name    varchar(50) not null,
  kind_uri  varchar(50) not null,
  custom_order int(10) not null default 0,
  translations longtext character set utf8 null,
  additions longtext character set utf8 null
);

alter table product_kind modify id int(10) unsigned not null auto_increment primary key;
alter table product_kind add constraint uq_prod_kind_ext_kind_id unique (external_kind_id);
alter table product_kind add constraint uq_prod_kind_kind_name unique (kind_name);
alter table product_kind add constraint uq_prod_kind_kind_uri unique (kind_uri);

create unique index ix_product_kind_custom_order on product_kind (custom_order);

insert into product_kind (external_kind_id, kind_name, kind_uri, custom_order) values ('kind1', 'Current Account', 'current-account', 1);
insert into product_kind (external_kind_id, kind_name, kind_uri, custom_order) values ('kind2', 'Savings Account', 'savings-account', 2);
insert into product_kind (external_kind_id, kind_name, kind_uri, custom_order) values ('kind3', 'Debit Card', 'debit-card', 3);
insert into product_kind (external_kind_id, kind_name, kind_uri, custom_order) values ('kind4', 'Credit Card', 'credit-card', 4);
insert into product_kind (external_kind_id, kind_name, kind_uri, custom_order) values ('kind5', 'Loan', 'loan', 5);
insert into product_kind (external_kind_id, kind_name, kind_uri, custom_order) values ('kind6', 'Term Deposit', 'term-deposit', 6);
insert into product_kind (external_kind_id, kind_name, kind_uri, custom_order) values ('kind7', 'Investment Account', 'investment-account', 7);

/** product **/
create table product
(
  id                       varchar(36) not null,
  external_id              varchar(50) not null,
  external_type_id         varchar(50),
  type_name                varchar(50),
  product_kind_id          int(10) unsigned not null,
  translations             longtext character set utf8 null,
  additions                longtext character set utf8 null
);

alter table product add constraint pk_product primary key (id);
alter table product add constraint fk_product2product_kind foreign key (product_kind_id) references product_kind(id);

/** adding indexes for improving performance **/
create index IX_EXTERNAL_ID on product(external_id);
create index ix_prod_type_name on product(type_name);

alter table arrangement add constraint fk_arrangement2product foreign key (product_id) references product(id);

create table balance_history_item
(
  id varchar(36) not null,
  external_arrangement_id varchar(50) not null,
  arrangement_id varchar(36) not null,
  balance decimal(23, 5) not null,
  updated_date timestamp(3) not null,
  constraint pk_balance_history_id primary key (id)
);

alter table balance_history_item add constraint fk_balance_history2arr foreign key (arrangement_id) references arrangement (id);

create table arrangement_legal_entities
(
  arrangement_id varchar(36) not null,
  legal_entity_id varchar(36) not null,
  constraint arr_le_pk primary key (arrangement_id, legal_entity_id)
);

alter table arrangement_legal_entities add constraint fk_arrangement2legalEntity foreign key (arrangement_id)    references arrangement(id);

create index ix_legal_entity_id on arrangement_legal_entities(legal_entity_id);

create table user_preferences
(
  user_id varchar(36) not null,
  arrangement_id varchar(36) not null,
  alias varchar(50),
  visible tinyint,
  favorite tinyint
);

alter table user_preferences add constraint pk_usr_pref_user_id_arr_id primary key (user_id, arrangement_id);

alter table user_preferences add constraint fk_usr_pref_arr2arrangement foreign key (arrangement_id) references arrangement(id);

create index ix_usr_pref_user_id on user_preferences(user_id);

/** arrangement_state **/
create table arrangement_state
(
  id                 int(10),
  external_state_id  varchar(50) not null,
  state              varchar(50) not null,
  description        varchar(200)
);

alter table arrangement_state modify id int(10) unsigned not null auto_increment primary key;
alter table arrangement_state add constraint uq_arr_state_external_id unique (external_state_id);
alter table arrangement_state add constraint uq_arr_state_state unique (state);

insert into arrangement_state (external_state_id, state, description) values ('Active', 'Active', 'Active state');
insert into arrangement_state (external_state_id, state, description) values ('Inactive', 'Inactive', 'Inactive state');
insert into arrangement_state (external_state_id, state, description) values ('Closed', 'Closed', 'Closed state');

alter table arrangement add constraint fk_arrangement2as foreign key (state_id) references arrangement_state(id);

create table translation_entity
(
    translated_entity varchar(50) not null,
    translated_column varchar(50) not null,
    constraint pk_translation_entity primary key (translated_entity, translated_column)
);

insert into translation_entity (translated_entity, translated_column) values ('product_kind', 'kind_name');
insert into translation_entity (translated_entity, translated_column) values ('product', 'type_name');

CREATE TABLE id_group (
    id bigint NOT NULL,
    ref_id varchar(36) NOT NULL,
    info varchar(40) NOT NULL,
    CONSTRAINT id_group_PK PRIMARY KEY (id, ref_id)
);
CREATE INDEX ix_id_group_id ON id_group (id);
