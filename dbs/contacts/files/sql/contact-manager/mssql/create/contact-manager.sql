-- The create scripts have been copied from the former 'party-pandp-service'.
-- Old upgrade scripts remain in there and are shipped until DBS 2.18.x.
-- You only need these scripts if you want to update from a DBS version prior to 2.12.0.

create table account_information (
   uuid                         nvarchar(36)         not null,
   account_number               nvarchar(34)         null,
   alias                        nvarchar(34)         null,
   bank_address_line1           nvarchar(70)         null,
   bank_address_line2           nvarchar(70)         null,
   bank_street_name             nvarchar(70)         null,
   bank_town                    nvarchar(35)         null,
   bank_post_code               nvarchar(16)         null,
   bank_country_sub_division    nvarchar(35)         null,
   bank_code                    nvarchar(11)         null,
   bank_country                 nvarchar(2)          null,
   bank_name                    nvarchar(140)        null,
   bic                          nvarchar(11)         null,
   iban                         nvarchar(34)         null,
   name                         nvarchar(140)        null,
   acc_holder_addr_line1        nvarchar(70)         null,
   acc_holder_addr_line2        nvarchar(70)         null,
   acc_holder_street_name       nvarchar(70)         null,
   acc_holder_town              nvarchar(35)         null,
   acc_holder_post_code         nvarchar(16)         null,
   acc_holder_country_sub_div   nvarchar(35)         null,
   acc_holder_country           nvarchar(2)          null,
   external_id                  nvarchar(32)         null,
   additions                    nvarchar(MAX)        null
);

alter table account_information
   add constraint pk_account_information primary key clustered (uuid);

create nonclustered index ix_acc_inf_acc_num on account_information (account_number asc);

create nonclustered index ix_acc_inf_alias on account_information (alias asc);

create nonclustered index ix_acc_inf_iban on account_information (iban asc);

create nonclustered index ix_acc_inf_name on account_information (name asc);

create table party (
   id                   nvarchar(36)         not null,
   access_context_scope numeric              null,
   address_line1        nvarchar(70)         null,
   address_line2        nvarchar(70)         null,
   street_name          nvarchar(70)         null,
   town                 nvarchar(35)         null,
   post_code            nvarchar(16)         null,
   country_sub_division nvarchar(35)         null,
   alias                nvarchar(70)         null,
   bb_id                nvarchar(36)         null,
   category             nvarchar(70)         null,
   contact_person       nvarchar(70)         null,
   country              nvarchar(2)          null,
   email_id             nvarchar(255)        null,
   legal_entity_id      nvarchar(36)         null,
   name                 nvarchar(140)        null,
   phone_number         nvarchar(30)         null,
   service_agreement_id nvarchar(36)         null,
   external_id          nvarchar(32)         null,
   approval_id          nvarchar(36)         null,
   active_party_id      nvarchar(36)         null,
   status               nvarchar(16)         DEFAULT 'ACTIVE',
   created_at           datetime             null,
   updated_at           datetime             null,
   action               nvarchar(6)          null,
   additions            nvarchar(MAX)        null
);

alter table party
   add constraint pk_party primary key clustered (id);

create nonclustered index ix_party_alias on party (alias asc);

create nonclustered index ix_party_bb_id_id on party (bb_id, id asc);

create nonclustered index ix_party_name on party (name asc);

create nonclustered index ix_party_external_id ON party(external_id)

create nonclustered index ix_party_service_agreement_id ON party(service_agreement_id)

create nonclustered index ix_party_legal_entity_id ON party(legal_entity_id);


create table party_accounts (
   party_id             nvarchar(36)         null,
   accounts_uuid        nvarchar(36)         null,
   constraint uk_account_id unique clustered (accounts_uuid)
);


alter table party_accounts
  add constraint fk_account_id foreign key (accounts_uuid)
references account_information (uuid);

alter table party_accounts
  add constraint fk_pa2prty foreign key (party_id)
references party (id);

create nonclustered index ix_party_accounts_party_id on party_accounts (party_id);

go
