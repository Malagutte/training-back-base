-- The create scripts have been copied from the former 'party-pandp-service'.
-- Old upgrade scripts remain in there and are shipped until DBS 2.18.x.
-- You only need these scripts if you want to update from a DBS version prior to 2.12.0.

create table account_information
(
  uuid                        varchar2(36),
  account_number              varchar2(34),
  alias                       varchar2(34),
  bank_address_line1          varchar2(70),
  bank_address_line2          varchar2(70),
  bank_street_name            varchar2(70),
  bank_town                   varchar2(35),
  bank_code                   varchar2(11),
  bank_country                varchar2(2),
  bank_name                   varchar2(140),
  bank_post_code              varchar2(16),
  bank_country_sub_division   varchar2(35),
  bic                         varchar2(11),
  iban                        varchar2(34),
  name                        varchar2(140),
  acc_holder_addr_line1       varchar2(70),
  acc_holder_addr_line2       varchar2(70),
  acc_holder_street_name      varchar2(70),
  acc_holder_town             varchar2(35),
  acc_holder_country          varchar2(2),
  acc_holder_post_code        varchar2(16),
  acc_holder_country_sub_div  varchar2(35),
  external_id                 varchar2(32),
  additions                   nclob
);

alter table account_information add constraint pk_account_information primary key(uuid);
create index ix_acc_inf_acc_num on account_information(account_number);
create index ix_acc_inf_alias on account_information(alias);
create index ix_acc_inf_iban on account_information(iban);
create index ix_acc_inf_name on account_information(name);

------

create table party
(
  id                   varchar2(36),
  access_context_scope integer,
  address_line1        varchar2(70),
  address_line2        varchar2(70),
  street_name          varchar2(70),
  town                 varchar2(35),
  alias                varchar2(70),
  bb_id                varchar2(36),
  category             varchar2(70),
  contact_person       varchar2(70),
  country              varchar2(2),
  email_id             varchar2(255),
  legal_entity_id      varchar2(36),
  name                 varchar2(140),
  phone_number         varchar2(30),
  service_agreement_id varchar2(36),
  post_code            varchar(16),
  country_sub_division varchar(35),
  external_id          varchar2(32),
  approval_id          varchar2(36),
  active_party_id      varchar2(36),
  status               varchar2(16) DEFAULT 'ACTIVE',
  created_at           timestamp(6),
  updated_at           timestamp(6),
  action               varchar2(6),
  additions            nclob
);

alter table party add constraint pk_party primary key(id);
create index ix_party_alias on party(alias);
create index ix_party_bb_id_id on party(bb_id,id);
create index ix_party_name on party(name);
create index ix_party_external_id ON party(external_id);
create index ix_party_service_agreement_id ON party(service_agreement_id);
create index ix_party_legal_entity_id ON party(legal_entity_id);

------

create table party_accounts
(
  party_id      varchar2(36),
	accounts_uuid varchar2(36)
);

alter table party_accounts add constraint uk_account_id unique (accounts_uuid);
alter table party_accounts add constraint fk_account_id foreign key (accounts_uuid) references account_information (uuid);
alter table party_accounts add constraint fk_party_id foreign key (party_id) references party (id);
create index ix_party_accounts_party_id on party_accounts(party_id);


