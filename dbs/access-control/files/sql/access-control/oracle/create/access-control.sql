-- START OF THE SCRIPT
-- TABLES CREATION

CREATE TABLE sequence_table (
  sequence_name                VARCHAR2(255) NOT NULL,
  next_val                     NUMBER(38, 0),
  CONSTRAINT pk_sequence_table PRIMARY KEY (sequence_name)
);

CREATE TABLE privilege
(
  id                         VARCHAR2(36) NOT NULL,
  code                       VARCHAR2(8)  NOT NULL,
  name                       VARCHAR2(16) NOT NULL,
  CONSTRAINT pk_privilege    PRIMARY KEY (id),
  CONSTRAINT uq_privilege_01 UNIQUE (name),
  CONSTRAINT uq_privilege_02 UNIQUE (code)
);

CREATE TABLE business_function
(
  id                                 VARCHAR2(36) NOT NULL,
  function_code                      VARCHAR2(32) NOT NULL,
  function_name                      VARCHAR2(32) NOT NULL,
  resource_code                      VARCHAR2(32) NOT NULL,
  resource_name                      VARCHAR2(32) NOT NULL,
  CONSTRAINT pk_business_function    PRIMARY KEY (id),
  CONSTRAINT uq_business_function_01 UNIQUE (function_name)
);

CREATE TABLE applicable_function_privilege
(
  id                     VARCHAR2(36) NOT NULL,
  business_function_name VARCHAR2(32) NOT NULL,
  function_resource_name VARCHAR2(32) NOT NULL,
  privilege_name         VARCHAR2(16) NOT NULL,
  supports_limit         NUMBER(3)    NOT NULL,
  business_function_id   VARCHAR2(36) NOT NULL,
  privilege_id           VARCHAR2(36) NOT NULL,
  CONSTRAINT pk_afp      PRIMARY KEY (id),
  CONSTRAINT fk_afp2bf   FOREIGN KEY (business_function_id) REFERENCES business_function (id),
  CONSTRAINT fk_afp2priv FOREIGN KEY (privilege_id)         REFERENCES privilege (id)
);
CREATE INDEX ix_afp_01 ON applicable_function_privilege (business_function_id);
CREATE INDEX ix_afp_02 ON applicable_function_privilege (privilege_id);

CREATE TABLE assignable_permission_set
(
  id                                      NUMBER(38, 0)                  NOT NULL,
  name                                    VARCHAR2(128)                  NOT NULL,
  description                             VARCHAR2(255)                  NOT NULL,
  type                                    NUMBER(3)         DEFAULT 2    NOT NULL,
  CONSTRAINT pk_assignable_permission_set PRIMARY KEY (id),
  CONSTRAINT uq_aps_01                    UNIQUE (name)
);
CREATE UNIQUE INDEX ix_aps_01
    ON assignable_permission_set (case when TYPE = 0 then TYPE when TYPE = 1 THEN TYPE ELSE NULL  end);

CREATE TABLE assignable_permission_set_item
(
  assignable_permission_set_id  NUMBER(38, 0)                 NOT NULL,
  function_privilege_id         VARCHAR2(36)                  NOT NULL,
  CONSTRAINT pk_aps_item        PRIMARY KEY (assignable_permission_set_id, function_privilege_id),
  CONSTRAINT fk_apsi2aps        FOREIGN KEY (assignable_permission_set_id) REFERENCES assignable_permission_set (id),
  CONSTRAINT fk_apsi2afp        FOREIGN KEY (function_privilege_id)        REFERENCES applicable_function_privilege (id)
);
CREATE INDEX ix_aps_item_01 ON assignable_permission_set_item (function_privilege_id);

CREATE TABLE legal_entity
(
  id                            VARCHAR2(36)                   NOT NULL,
  external_id                   VARCHAR2(64)                   NOT NULL,
  name                          VARCHAR2(128)                  NOT NULL,
  parent_id                     VARCHAR2(36),
  type                          VARCHAR2(8) DEFAULT 'CUSTOMER' NOT NULL,
  CONSTRAINT pk_legal_entity    PRIMARY KEY (id),
  CONSTRAINT uq_legal_entity_01 UNIQUE (external_id),
  CONSTRAINT fk_le2le           FOREIGN KEY (parent_id) REFERENCES legal_entity (id)
);
CREATE INDEX ix_legal_entity_02 ON legal_entity (name);
CREATE INDEX ix_legal_entity_03 ON legal_entity (parent_id);

CREATE TABLE legal_entity_ancestor
(
  descendent_id                          VARCHAR2(36) NOT NULL,
  ancestor_id                            VARCHAR2(36) NOT NULL,
  CONSTRAINT pk_legal_entity_ancestor    PRIMARY KEY (ancestor_id, descendent_id),
  CONSTRAINT fk_lea2le_01                FOREIGN KEY (descendent_id) REFERENCES legal_entity (id),
  CONSTRAINT fk_lea2le_02                FOREIGN KEY (ancestor_id)   REFERENCES legal_entity (id)
);
CREATE INDEX ix_legal_entity_ancestor_02 ON legal_entity_ancestor (descendent_id);

CREATE TABLE add_prop_legal_entity (
  add_prop_legal_entity_id            VARCHAR2(36) NOT NULL,
  property_key                        VARCHAR2(50) NOT NULL,
  property_value                      VARCHAR2(500),
  CONSTRAINT pk_add_prop_legal_entity PRIMARY KEY (add_prop_legal_entity_id, property_key),
  CONSTRAINT fk_aple2le               FOREIGN KEY (add_prop_legal_entity_id) REFERENCES legal_entity (id)
);

CREATE TABLE service_agreement
(
  id                                    VARCHAR2(36)                   NOT NULL,
  external_id                           VARCHAR2(64),
  name                                  VARCHAR2(128)                  NOT NULL,
  description                           VARCHAR2(255)                  NOT NULL,
  is_master                             NUMBER(3)                      NOT NULL,
  creator_legal_entity_id               VARCHAR2(36)                   NOT NULL,
  state                                 VARCHAR2(16) DEFAULT 'ENABLED' NOT NULL,
  start_date                            TIMESTAMP,
  end_date                              TIMESTAMP,
  state_changed_at                      TIMESTAMP,
  CONSTRAINT pk_service_agreement       PRIMARY KEY (id),
  CONSTRAINT uq_service_agreement_02    UNIQUE (external_id),
  CONSTRAINT fk_sa2le                   FOREIGN KEY (creator_legal_entity_id) REFERENCES legal_entity (id)
);
CREATE INDEX ix_service_agreement_03 ON service_agreement (creator_legal_entity_id);
CREATE UNIQUE INDEX ix_service_agreement_04
    ON service_agreement (case when IS_MASTER = 1 then CREATOR_LEGAL_ENTITY_ID end);

CREATE TABLE add_prop_service_agreement (
  add_prop_service_agreement_id            VARCHAR2(36)   NOT NULL,
  property_key                             VARCHAR2(50)   NOT NULL,
  property_value                           VARCHAR2(500),
  CONSTRAINT pk_add_prop_service_agreement PRIMARY KEY (add_prop_service_agreement_id, property_key),
  CONSTRAINT fk_apsa2sa                    FOREIGN KEY (add_prop_service_agreement_id) REFERENCES service_agreement (id)
);

CREATE TABLE service_agreement_aps
(
  service_agreement_id           VARCHAR2(36)                NOT NULL,
  assignable_permission_set_id   NUMBER(38, 0)               NOT NULL,
  type                           NUMBER(3)                   NOT NULL,
  CONSTRAINT pk_sa_aps           PRIMARY KEY (service_agreement_id, assignable_permission_set_id, type),
  CONSTRAINT fk_saapsd2sa        FOREIGN KEY (service_agreement_id)         REFERENCES service_agreement (id),
  CONSTRAINT fk_saapsd2aps       FOREIGN KEY (assignable_permission_set_id) REFERENCES assignable_permission_set (id)
);
CREATE INDEX ix_sa_aps_01 ON service_agreement_aps (assignable_permission_set_id);

CREATE TABLE participant
(
  id                            VARCHAR2(36) NOT NULL,
  legal_entity_id               VARCHAR2(36) NOT NULL,
  service_agreement_id          VARCHAR2(36) NOT NULL,
  share_users                   NUMBER(3)    NOT NULL,
  share_accounts                NUMBER(3)    NOT NULL,
  CONSTRAINT pk_participant     PRIMARY KEY (id),
  CONSTRAINT uq_participant_01  UNIQUE (legal_entity_id, service_agreement_id),
  CONSTRAINT fk_prtc2le         FOREIGN KEY (legal_entity_id)      REFERENCES legal_entity (id),
  CONSTRAINT fk_prtc2sa         FOREIGN KEY (service_agreement_id) REFERENCES service_agreement (id)
);
CREATE INDEX ix_participant_02 ON participant (service_agreement_id);

CREATE TABLE participant_user
(
  id                                VARCHAR2(36) NOT NULL,
  user_id                           VARCHAR2(36) NOT NULL,
  participant_id                    VARCHAR2(36) NOT NULL,
  CONSTRAINT pk_participant_user    PRIMARY KEY (id),
  CONSTRAINT uq_participant_user_01 UNIQUE (user_id, participant_id),
  CONSTRAINT fk_pu2prtc             FOREIGN KEY (participant_id) REFERENCES participant (id)
);
CREATE INDEX ix_participant_user_02 ON participant_user (participant_id);

CREATE TABLE sa_admin
(
  id                        VARCHAR2(36) NOT NULL,
  user_id                   VARCHAR2(36) NOT NULL,
  participant_id            VARCHAR2(36) NOT NULL,
  CONSTRAINT pk_sa_admin    PRIMARY KEY (id),
  CONSTRAINT uq_sa_admin_01 UNIQUE (user_id, participant_id),
  CONSTRAINT fk_adm2prtc    FOREIGN KEY (participant_id) REFERENCES participant (id)
);
CREATE INDEX ix_sa_admin_02 ON sa_admin (participant_id);

CREATE TABLE function_group
(
  id                              VARCHAR2(36)        NOT NULL,
  name                            VARCHAR2(128)       NOT NULL,
  description                     VARCHAR2(255)       NOT NULL,
  type                            NUMBER(3) DEFAULT 0 NOT NULL,
  service_agreement_id            VARCHAR2(36)        NOT NULL,
  start_date                      TIMESTAMP,
  end_date                        TIMESTAMP,
  aps_id                          NUMBER(38, 0),
  CONSTRAINT pk_function_group    PRIMARY KEY (id),
  CONSTRAINT uq_function_group_01 UNIQUE (service_agreement_id, name),
  CONSTRAINT fk_fg2sa             FOREIGN KEY (service_agreement_id) REFERENCES service_agreement (id),
  CONSTRAINT fk_fg2aps            FOREIGN KEY (aps_id)               REFERENCES assignable_permission_set (id)
);
CREATE INDEX ix_function_group_01 ON function_group (aps_id);

CREATE TABLE function_group_item
(
  function_group_id      VARCHAR2(36) NOT NULL,
  afp_id                 VARCHAR2(36) NOT NULL,
  CONSTRAINT pk_fgi      PRIMARY KEY (function_group_id, afp_id),
  CONSTRAINT fk_fgi2fg   FOREIGN KEY (function_group_id) REFERENCES function_group (id),
  CONSTRAINT fk_fgi2afp  FOREIGN KEY (afp_id)            REFERENCES applicable_function_privilege (id)
);
CREATE INDEX ix_fgi_01 ON function_group_item (afp_id);

CREATE TABLE data_group
(
  id                          VARCHAR2(36)  NOT NULL,
  name                        VARCHAR2(128) NOT NULL,
  description                 VARCHAR2(255) NOT NULL,
  type                        VARCHAR2(36)  NOT NULL,
  service_agreement_id        VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_data_group    PRIMARY KEY (id),
  CONSTRAINT uq_data_group_01 UNIQUE (service_agreement_id, name),
  CONSTRAINT fk_dg2sa         FOREIGN KEY (service_agreement_id) REFERENCES service_agreement (id)
);

CREATE TABLE data_group_item
(
  data_group_id                 VARCHAR2(36) NOT NULL,
  data_item_id                  VARCHAR2(36) NOT NULL,
  CONSTRAINT pk_data_group_item PRIMARY KEY (data_group_id, data_item_id),
  CONSTRAINT fk_dgi2dg          FOREIGN KEY (data_group_id) REFERENCES data_group (id)
);
CREATE INDEX ix_data_group_item_01 ON data_group_item (data_item_id);

CREATE TABLE user_context
(
  id                            NUMBER(38, 0) NOT NULL,
  service_agreement_id          VARCHAR2(36)  NOT NULL,
  user_id                       VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_user_context    PRIMARY KEY (id),
  CONSTRAINT uq_user_context_01 UNIQUE (user_id, service_agreement_id),
  CONSTRAINT fk_uc2sa           FOREIGN KEY (service_agreement_id) REFERENCES service_agreement (id)
);
CREATE INDEX ix_user_context_01 ON user_context (service_agreement_id);

CREATE TABLE user_assigned_function_group
(
  id                     NUMBER(38, 0) NOT NULL,
  user_context_id        NUMBER(38, 0) NOT NULL,
  function_group_id      VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_uafg     PRIMARY KEY (id),
  CONSTRAINT uq_uafg_01  UNIQUE (user_context_id, function_group_id),
  CONSTRAINT fk_uafg2ua2 FOREIGN KEY (user_context_id)   REFERENCES user_context (id),
  CONSTRAINT fk_uafg2fg  FOREIGN KEY (function_group_id) REFERENCES function_group (id)
);
CREATE INDEX ix_uafg_03 ON user_assigned_function_group (function_group_id);

CREATE TABLE user_assigned_fg_dg
(
  user_assigned_fg_id                NUMBER(38, 0) NOT NULL,
  data_group_id                      VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_user_assigned_fg_dg  PRIMARY KEY (user_assigned_fg_id, data_group_id),
  CONSTRAINT fk_uafgdg2dg            FOREIGN KEY (data_group_id)       REFERENCES data_group (id),
  CONSTRAINT fk_uafgdg2uafg          FOREIGN KEY (user_assigned_fg_id) REFERENCES user_assigned_function_group (id)
);
CREATE INDEX ix_user_assigned_fg_dg_02 ON user_assigned_fg_dg (data_group_id);

CREATE TABLE access_control_approval (
  id                                    NUMBER(38, 0) NOT NULL,
  approval_id                           VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_access_control_approval PRIMARY KEY (id)
);

CREATE TABLE approval_user_context (
  id                                     NUMBER(38, 0) NOT NULL,
  user_id                                VARCHAR2(36)  NOT NULL,
  service_agreement_id                   VARCHAR2(36)  NOT NULL,
  legal_entity_id                        VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_approval_user_context    PRIMARY KEY (id),
  CONSTRAINT fk_auc2aca                  FOREIGN KEY (id) REFERENCES access_control_approval (id)
);

CREATE TABLE approval_uc_assign_fg (
  id                                  NUMBER(38, 0) NOT NULL,
  approval_user_context_id            NUMBER(38, 0) NOT NULL,
  function_group_id                   VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_approval_uc_assign_fg PRIMARY KEY (id),
  CONSTRAINT fk_aucafg2auc            FOREIGN KEY (approval_user_context_id) REFERENCES approval_user_context (id),
  CONSTRAINT fk_aucafg2fg             FOREIGN KEY (function_group_id)        REFERENCES function_group (id)
);
CREATE INDEX ix_aucafg_01 ON approval_uc_assign_fg (approval_user_context_id);
CREATE INDEX ix_aucafg_02 ON approval_uc_assign_fg (function_group_id);

CREATE TABLE approval_uc_assign_fg_dg (
  approval_uc_assign_fg_id                NUMBER(38, 0) NOT NULL,
  data_group_id                           VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_approval_uc_assign_fg_dg  PRIMARY KEY (approval_uc_assign_fg_id, data_group_id),
  CONSTRAINT fk_aucafgdg2aucafg           FOREIGN KEY (approval_uc_assign_fg_id) REFERENCES approval_uc_assign_fg (id),
  CONSTRAINT fk_aucafgdg2dg               FOREIGN KEY (data_group_id)            REFERENCES data_group (id)
);
CREATE INDEX ix_aucafgdg_02 ON approval_uc_assign_fg_dg (data_group_id);

CREATE TABLE approval_data_group (
  id                                NUMBER(38, 0) NOT NULL,
  data_group_id                     VARCHAR2(36),
  CONSTRAINT pk_approval_data_group PRIMARY KEY (id),
  CONSTRAINT fk_adg2aca             FOREIGN KEY (id) REFERENCES access_control_approval (id)
);

CREATE TABLE approval_data_group_detail (
  id                                        NUMBER(38, 0) NOT NULL,
  service_agreement_id                      VARCHAR2(36)  NOT NULL,
  name                                      VARCHAR2(128) NOT NULL,
  description                               VARCHAR2(255) NOT NULL,
  type                                      VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_approval_data_group_detail  PRIMARY KEY (id),
  CONSTRAINT uq_adgd_01                     UNIQUE (service_agreement_id, name),
  CONSTRAINT fk_adgd2adg                    FOREIGN KEY (id) REFERENCES approval_data_group (id)
);

CREATE TABLE  approval_data_group_item(
  approval_data_group_id                  NUMBER(38, 0) NOT NULL,
  data_item_id                            VARCHAR2(36)  NOT NULL,
  CONSTRAINT pk_approval_data_group_item  PRIMARY KEY (approval_data_group_id, data_item_id),
  CONSTRAINT fk_adgi2adgd                 FOREIGN KEY (approval_data_group_id) REFERENCES approval_data_group_detail (id)
);

CREATE TABLE approval_function_group_ref
(
    id                                          NUMBER(38, 0)     NOT NULL,
    function_group_id                           VARCHAR2(36)      NULL,
    CONSTRAINT pk_approval_function_group_ref   PRIMARY KEY (id),
    CONSTRAINT fk_afgr2aca                      FOREIGN KEY (id) REFERENCES access_control_approval(id)
);

CREATE TABLE approval_function_group
(
    id                                      NUMBER(38, 0)     NOT NULL,
    name                                    VARCHAR2(128)     NOT NULL,
    description                             VARCHAR2(255)     NOT NULL,
    service_agreement_id                    VARCHAR2(36)      NOT NULL,
    start_date                              TIMESTAMP         NULL,
    end_date                                TIMESTAMP         NULL,
    approval_type_id                        VARCHAR2(36)      NULL,
    CONSTRAINT pk_approval_function_group   PRIMARY KEY (id),
    CONSTRAINT fk_afg2afgr                  FOREIGN KEY (id) REFERENCES approval_function_group_ref(id)
);

CREATE TABLE approval_function_group_item
(
    id                     NUMBER(38, 0)   NOT NULL,
    afp_id                 VARCHAR2(36)    NOT NULL,
    CONSTRAINT pk_afgi     PRIMARY KEY (id, afp_id),
    CONSTRAINT fk_afgi2afg FOREIGN KEY (id) REFERENCES approval_function_group(id)
);

CREATE TABLE approval_service_agreement_ref
(
    id                                             NUMBER(38, 0)     NOT NULL,
    service_agreement_id                           VARCHAR2(36)      NULL,
    CONSTRAINT pk_approval_sa_ref                  PRIMARY KEY (id),
    CONSTRAINT fk_asar2aca                         FOREIGN KEY (id) REFERENCES access_control_approval(id)
);

CREATE TABLE approval_service_agreement
(
    id                                             NUMBER(38, 0)                  NOT NULL,
    external_id                                    VARCHAR2(64),
    name                                           VARCHAR2(128)                  NOT NULL,
    description                                    VARCHAR2(255)                  NOT NULL,
    is_master                                      NUMBER(3)                      NOT NULL,
    creator_legal_entity_id                        VARCHAR2(36)                   NOT NULL,
    state                                          VARCHAR2(16) DEFAULT 'ENABLED' NOT NULL,
    start_date                                     TIMESTAMP,
    end_date                                       TIMESTAMP,
    CONSTRAINT pk_approval_service_agreement       PRIMARY KEY (id),
    CONSTRAINT uq_approval_sa_01                   UNIQUE (external_id),
    CONSTRAINT fk_asa2asar                         FOREIGN KEY (id) REFERENCES approval_service_agreement_ref (id)
);

CREATE TABLE approval_add_prop_sa (
    id                                                NUMBER(38, 0)  NOT NULL,
    property_key                                      VARCHAR2(50)   NOT NULL,
    property_value                                    VARCHAR2(500),
    CONSTRAINT pk_approval_add_prop_sa                PRIMARY KEY (id,property_key),
    CONSTRAINT fk_aapsa2asa                           FOREIGN KEY (id) REFERENCES approval_service_agreement (id)
    );

CREATE TABLE approval_service_agreement_aps
(
    id                             NUMBER(38, 0)               NOT NULL,
    assignable_permission_set_id   NUMBER(38, 0)               NOT NULL,
    type                           NUMBER(3)                   NOT NULL,
    CONSTRAINT pk_asa_aps          PRIMARY KEY (id, assignable_permission_set_id, type),
    CONSTRAINT fk_asaa2asa         FOREIGN KEY (id)   REFERENCES approval_service_agreement (id)
);

CREATE TABLE approval_sa_participant
(
    id                                                       NUMBER(38, 0) NOT NULL,
    legal_entity_id                                          VARCHAR2(36)  NOT NULL,
    share_users                                              NUMBER(3)     NOT NULL,
    share_accounts                                           NUMBER(3)     NOT NULL,
    CONSTRAINT pk_approval_sa_participant                    PRIMARY KEY (id,legal_entity_id),
    CONSTRAINT fk_asap2asa                                   FOREIGN KEY (id) REFERENCES approval_service_agreement (id)
);

CREATE TABLE approval_sa_admins
(
    id                                                 NUMBER(38, 0) NOT NULL,
    legal_entity_id                                    VARCHAR2(36)  NOT NULL,
    user_id                                            VARCHAR2(36)  NOT NULL,
    CONSTRAINT pk_approval_sa_admins                   PRIMARY KEY (id,legal_entity_id,user_id),
    CONSTRAINT fk_asaa2asap                            FOREIGN KEY (id,legal_entity_id) REFERENCES approval_sa_participant(id,legal_entity_id)
);

-- END OF TABLES CREATION

-- DATA INITIALIZATIONS STARTS HERE

-- INITIALIZING PRIVILEGES

INSERT INTO PRIVILEGE
(id, code, name)
VALUES
  ('1', 'execute', 'execute');

INSERT INTO PRIVILEGE
(id, code, name)
VALUES
  ('2', 'view', 'view');

INSERT INTO PRIVILEGE
(ID, CODE, NAME)
VALUES
  ('3', 'create', 'create');

INSERT INTO PRIVILEGE
(ID, CODE, NAME)
VALUES
  ('4', 'edit', 'edit');

INSERT INTO PRIVILEGE
(ID, CODE, NAME)
VALUES
  ('5', 'delete', 'delete');

INSERT INTO PRIVILEGE
(ID, CODE, NAME)
VALUES
  ('6', 'approve', 'approve');

INSERT INTO PRIVILEGE
(ID, CODE, NAME)
VALUES
  ('7', 'cancel', 'cancel');

-- INITIALIZING DATA FOR BUSINESS FUNCTIONS --

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1002', 'payments.sepa', 'SEPA CT', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1003', 'transactions', 'Transactions', 'transactions', 'Transactions');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1005', 'contacts', 'Contacts', 'contacts', 'Contacts');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1006', 'product.summary', 'Product Summary', 'product.summary', 'Product Summary');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1007', 'assign.users', 'Assign Users', 'service.agreement', 'Service Agreement');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1009', 'assign.permissions', 'Assign Permissions', 'service.agreement', 'Service Agreement');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1010', 'manage.users', 'Manage Users', 'user', 'User');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1011', 'manage.legalentities', 'Manage Legal Entities', 'legalentity', 'Legal Entity');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1012', 'manage.limits', 'Manage Limits', 'limits', 'Limits');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1013', 'audit', 'Audit', 'audit', 'Audit');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1014', 'manage.shadow.limits', 'Manage Shadow Limits', 'limits', 'Limits');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1015', 'intra.company.payments', 'Intra Company Payments', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1016', 'manage.statements', 'Manage Statements', 'account.statements', 'Account Statements');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1017', 'us.domestic.wire', 'US Domestic Wire', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1018', 'us.foreign.wire', 'US Foreign Wire', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1019', 'manage.data.groups', 'Manage Data Groups', 'entitlements', 'Entitlements');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1020', 'manage.function.groups', 'Manage Function Groups', 'entitlements', 'Entitlements');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1021', 'us.billpay.payments', 'US Billpay Payments', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1022', 'us.billpay.payees', 'US Billpay Payees', 'contacts', 'Contacts');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1023', 'us.billpay.accounts', 'US Billpay Accounts', 'arrangements', 'Arrangements');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1024', 'us.billpay.payees.search', 'US Billpay Payees-Search', 'contacts', 'Contacts');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1025', 'us.billpay.payees.summary', 'US Billpay Payees-Summary', 'contacts', 'Contacts');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1026', 'us.billpay.enrolment', 'US Billpay Enrolment', 'billpay', 'Billpay');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1027', 'access.actions.history', 'Access Actions History', 'actions', 'Actions');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1028', 'manage.service.agreements', 'Manage Service Agreements', 'service.agreement', 'Service Agreement');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1029', 'manage.actions.recipes', 'Manage Action Recipes', 'actions', 'Actions');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1030', 'manage.notifications', 'Manage Notifications', 'notifications', 'Notifications');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1031', 'manage.topics', 'Manage Topics', 'message.center', 'Message Center');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1032', 'assign.approval.policies', 'Assign Approval Policies', 'approvals', 'Approvals');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1033', 'manage.approval.policy.level', 'Manage Approval Policy and Level', 'approvals', 'Approvals');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1034', 'manage.identities', 'Manage Identities', 'identities', 'Identities');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1035', 'manage.user.profiles', 'Manage User Profiles', 'user.profiles', 'User Profiles');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1036', 'support.access.payments', 'Support Access for Payments', 'support.access', 'Support Access');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1037', 'batch.sepa', 'Batch - SEPA CT', 'batch', 'Batch');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
  ('1038', 'manage.messages', 'Manage Messages', 'message.center', 'Message Center');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1039', 'supervise.messages', 'Supervise Messages', 'message.center', 'Message Center');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1040', 'manage.global.limits', 'Manage Global Limits', 'limits', 'Limits');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1041', 'ach.credit.transfer', 'ACH Credit Transfer', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1042', 'ach.credit.intc', 'ACH Credit - Intracompany', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1043', 'sepa.credit.transfer.intc', 'SEPA CT - Intracompany', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1044', 'us.domestic.wire.intc', 'US Domestic Wire - Intracompany', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1045', 'us.foreign.wire.intc', 'US Foreign Wire - Intracompany', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1046', 'ach.debit', 'ACH Debit', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1047', 'manage.budgets', 'Manage Budgets', 'personal.finance.management', 'Personal Finance Management');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1048', 'manage.saving.goals', 'Manage Saving Goals', 'personal.finance.management', 'Personal Finance Management');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1049', 'lock.user', 'Lock User', 'identities', 'Identities');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1050', 'unlock.user', 'Unlock User', 'identities', 'Identities');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1051', 'manage.devices', 'Manage Devices', 'device', 'Device');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1052', 'sepa.credit.transfer.closed', 'SEPA CT - closed', 'payments', 'Payments');

INSERT
INTO BUSINESS_FUNCTION
(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1053', 'a2a.transfer', 'A2A Transfer', 'payments', 'Payments');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1054','flow.case', 'Manage Case', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1055','flow.case.archive', 'Archive Case', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
 ('1056','flow.case.document', 'Manage Case Documents', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
 ('1057','flow.case.comment', 'Manage Case Comments', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1058','flow.case.changelog', 'Access Case Changelog', 'flow', 'Flow');
INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
 VALUES
 ('1059','flow.case.statistics', 'Access Case Statistics', 'flow', 'Flow');
INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1060','flow.journey.statistics', 'Access Journey Statistics', 'flow', 'Flow');
INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1061','flow.journey.definitions', 'Access Journey Definitions', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1062','flow.task.assign', 'Assign Task', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1063','flow.task.dates', 'Manage Task Dates', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1064','flow.task', 'Manage Task', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1065','stop.checks', 'Stop Checks', 'payments', 'Payments');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1066','manage.other.users.devices', 'Manage Other User''s Devices', 'device', 'Device');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1067','batch.ach.credit', 'Batch - ACH Credit', 'batch', 'Batch');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1068','cash.flow.forecasting', 'Cash Flow Forecasting', 'cash.flow', 'Cash Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1069','batch.ach.debit', 'Batch - ACH Debit', 'batch', 'Batch');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1070','p2p.transfer', 'P2P Transfer', 'payments', 'Payments');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1071','payment.templates', 'Payment Templates', 'payments', 'Payments');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1072','flow.task.statistics', 'Access Task Statistics', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1073','uk.chaps', 'UK CHAPS', 'payments', 'Payments');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1074','uk.faster.payments', 'UK Faster Payments', 'payments', 'Payments');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1075','emulate', 'Emulate', 'employee', 'Employee');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1076','act.on.behalf.of', 'Act on behalf of', 'employee', 'Employee');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1077','flow.collection', 'Access Collections', 'flow', 'Flow');

INSERT INTO BUSINESS_FUNCTION(ID, FUNCTION_CODE, FUNCTION_NAME, RESOURCE_CODE, RESOURCE_NAME)
VALUES
('1078', 'manage.authorized.users', 'Manage Authorized Users', 'user', 'User');

-- INITIALIZING APPLICABLE FUNCTION PRIVILEGES

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('3', 'SEPA CT', 'Payments', 'create', '1', '1002', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('4', 'Transactions', 'Transactions', 'view', '0', '1003', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('5', 'Transactions', 'Transactions', 'edit', '0', '1003', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('7', 'Contacts', 'Contacts', 'view', '0', '1005', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('8', 'Contacts', 'Contacts', 'create', '0', '1005', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('9', 'Contacts', 'Contacts', 'edit', '0', '1005', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('10', 'Contacts', 'Contacts', 'delete', '0', '1005', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('11', 'Product Summary', 'Product Summary', 'view', '0', '1006', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('12', 'Product Summary', 'Product Summary', 'edit', '0', '1006', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('13', 'Assign Users', 'Service Agreement', 'view', '0', '1007', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('14', 'Assign Users', 'Service Agreement', 'create', '0', '1007', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('15', 'Assign Users', 'Service Agreement', 'edit', '0', '1007', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('19', 'Assign Permissions', 'Service Agreement', 'view', '0', '1009', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('20', 'Assign Permissions', 'Service Agreement', 'create', '0', '1009', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('21', 'Assign Permissions', 'Service Agreement', 'edit', '0', '1009', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('22', 'Manage Users', 'User', 'view', '0', '1010', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('23', 'Manage Legal Entities', 'Legal Entity', 'view', '0', '1011', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('24', 'SEPA CT', 'Payments', 'view', '0', '1002', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('25', 'SEPA CT', 'Payments', 'edit', '0', '1002', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('26', 'SEPA CT', 'Payments', 'delete', '0', '1002', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('27', 'Manage Limits', 'Limits', 'view', '0', '1012', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('28', 'Manage Limits', 'Limits', 'create', '0', '1012', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('29', 'Manage Limits', 'Limits', 'edit', '0', '1012', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('30', 'Manage Limits', 'Limits', 'delete', '0', '1012', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('31', 'Audit', 'Audit', 'view', '0', '1013', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('32', 'Audit', 'Audit', 'create', '0', '1013', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('33', 'Manage Shadow Limits', 'Limits', 'view', '0', '1014', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('34', 'Manage Shadow Limits', 'Limits', 'create', '0', '1014', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('35', 'Manage Shadow Limits', 'Limits', 'edit', '0', '1014', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('36', 'Manage Shadow Limits', 'Limits', 'delete', '0', '1014', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('37', 'Intra Company Payments', 'Payments', 'view', '0', '1015', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('38', 'Intra Company Payments', 'Payments', 'create', '1', '1015', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('39', 'Intra Company Payments', 'Payments', 'edit', '0', '1015', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('40', 'Intra Company Payments', 'Payments', 'delete', '0', '1015', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('41', 'Intra Company Payments', 'Payments', 'approve', '0', '1015', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('42', 'Manage Statements', 'Account Statements', 'view', '0', '1016', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('43', 'US Domestic Wire', 'Payments', 'view', '0', '1017', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('44', 'US Domestic Wire', 'Payments', 'create', '1', '1017', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('45', 'US Domestic Wire', 'Payments', 'edit', '0', '1017', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('46', 'US Domestic Wire', 'Payments', 'delete', '0', '1017', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('47', 'US Domestic Wire', 'Payments', 'approve', '0', '1017', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('48', 'US Foreign Wire', 'Payments', 'view', '0', '1018', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('49', 'US Foreign Wire', 'Payments', 'create', '1', '1018', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('50', 'US Foreign Wire', 'Payments', 'edit', '0', '1018', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('51', 'US Foreign Wire', 'Payments', 'delete', '0', '1018', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('52', 'US Foreign Wire', 'Payments', 'approve', '0', '1018', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('53', 'SEPA CT', 'Payments', 'approve', '0', '1002', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('54', 'Manage Data Groups', 'Entitlements', 'view', '0', '1019', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('55', 'Manage Data Groups', 'Entitlements', 'create', '0', '1019', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('56', 'Manage Data Groups', 'Entitlements', 'edit', '0', '1019', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('57', 'Manage Data Groups', 'Entitlements', 'delete', '0', '1019', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('58', 'Manage Data Groups', 'Entitlements', 'approve', '0', '1019', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('59', 'Manage Function Groups', 'Entitlements', 'view', '0', '1020', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('60', 'Manage Function Groups', 'Entitlements', 'create', '0', '1020', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('61', 'Manage Function Groups', 'Entitlements', 'edit', '0', '1020', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('62', 'Manage Function Groups', 'Entitlements', 'delete', '0', '1020', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('63', 'Manage Function Groups', 'Entitlements', 'approve', '0', '1020', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('64', 'US Billpay Payments', 'Payments', 'view', '0', '1021', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('65', 'US Billpay Payments', 'Payments', 'create', '0', '1021', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('66', 'US Billpay Payments', 'Payments', 'edit', '0', '1021', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('67', 'US Billpay Payments', 'Payments', 'delete', '0', '1021', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('68', 'US Billpay Payees', 'Contacts', 'view', '0', '1022', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('69', 'US Billpay Payees', 'Contacts', 'create', '0', '1022', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('70', 'US Billpay Payees', 'Contacts', 'edit', '0', '1022', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('71', 'US Billpay Payees', 'Contacts', 'delete', '0', '1022', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('72', 'US Billpay Accounts', 'Arrangements', 'view', '0', '1023', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('73', 'US Billpay Payees-Search', 'Contacts', 'execute', '0', '1024', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('74', 'US Billpay Payees-Summary', 'Contacts', 'view', '0', '1025', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('75', 'US Billpay Enrolment', 'Billpay', 'execute', '0', '1026', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('76', 'US Billpay Enrolment', 'Billpay', 'view', '0', '1026', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('77', 'Access Actions History', 'Actions', 'execute', '0', '1027', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('78', 'Access Actions History', 'Actions', 'view', '0', '1027', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('79', 'Intra Company Payments', 'Payments', 'cancel', '0', '1015', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('80', 'US Domestic Wire', 'Payments', 'cancel', '0', '1017', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('81', 'US Foreign Wire', 'Payments', 'cancel', '0', '1018', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('82', 'SEPA CT', 'Payments', 'cancel', '0', '1002', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('83', 'Manage Service Agreements', 'Service Agreement', 'view', 0, '1028', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('84', 'Manage Service Agreements', 'Service Agreement', 'create', 0, '1028', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('85', 'Manage Service Agreements', 'Service Agreement', 'edit', 0, '1028', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('86', 'Manage Service Agreements', 'Service Agreement', 'delete', 0, '1028', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('87', 'Manage Service Agreements', 'Service Agreement', 'approve', 0, '1028', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('88', 'Manage Action Recipes', 'Actions', 'execute', '0', '1029', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('89', 'Manage Action Recipes', 'Actions', 'view', '0', '1029', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('90', 'Manage Action Recipes', 'Actions', 'create', '0', '1029', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('91', 'Manage Action Recipes', 'Actions', 'edit', '0', '1029', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('92', 'Manage Action Recipes', 'Actions', 'delete', '0', '1029', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('93', 'Manage Notifications', 'Notifications', 'view', '0', '1030', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('94', 'Manage Notifications', 'Notifications', 'create', '0', '1030', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('95', 'Manage Notifications', 'Notifications', 'delete', '0', '1030', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('96', 'Contacts', 'Contacts', 'approve', '0', '1005', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('97', 'Manage Topics', 'Message Center', 'execute', '0', '1031', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('98', 'Manage Topics', 'Message Center', 'view', '0', '1031', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('99', 'Manage Topics', 'Message Center', 'create', '0', '1031', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('100', 'Manage Topics', 'Message Center', 'edit', '0', '1031', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('101', 'Manage Topics', 'Message Center', 'delete', '0', '1031', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('102', 'Assign Approval Policies', 'Approvals', 'view', 0, '1032', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('103', 'Assign Approval Policies', 'Approvals', 'create', 0, '1032', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('104', 'Assign Approval Policies', 'Approvals', 'edit', 0, '1032', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('105', 'Assign Approval Policies', 'Approvals', 'delete', 0, '1032', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('106', 'Assign Approval Policies', 'Approvals', 'approve', 0, '1032', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('107', 'Manage Approval Policy and Level', 'Approvals', 'view', 0, '1033', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('108', 'Manage Approval Policy and Level', 'Approvals', 'create', 0, '1033', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('109', 'Manage Approval Policy and Level', 'Approvals', 'edit', 0, '1033', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('110', 'Manage Approval Policy and Level', 'Approvals', 'delete', 0, '1033', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('111', 'Manage Approval Policy and Level', 'Approvals', 'approve', 0, '1033', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('112', 'Manage Identities', 'Identities', 'view', 0, '1034', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('113', 'Manage Identities', 'Identities', 'create', 0, '1034', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('114', 'Manage Identities', 'Identities', 'edit', 0, '1034', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('115', 'Assign Permissions', 'Service Agreement', 'approve', 0, '1009', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('116', 'Manage User Profiles', 'User Profiles', 'view', 0, '1035', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('117', 'Manage User Profiles', 'User Profiles', 'edit', 0, '1035', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('118', 'Support Access for Payments', 'Support Access', 'view', 0, '1036', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('119', 'Batch - SEPA CT', 'Batch', 'view', 1, '1037', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('120', 'Batch - SEPA CT', 'Batch', 'create', 1, '1037', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('121', 'Batch - SEPA CT', 'Batch', 'edit', 1, '1037', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('122', 'Batch - SEPA CT', 'Batch', 'delete', 1, '1037', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('123', 'Batch - SEPA CT', 'Batch', 'approve', 1, '1037', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('124', 'Batch - SEPA CT', 'Batch', 'cancel', 1, '1037', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('125', 'Manage Messages', 'Message Center', 'view', 0, '1038', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('126', 'Manage Messages', 'Message Center', 'create', 0, '1038', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('127', 'Manage Messages', 'Message Center', 'edit', 0, '1038', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('128', 'Manage Messages', 'Message Center', 'delete', 0, '1038', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
  ('129', 'Manage Messages', 'Message Center', 'approve', 0, '1038', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('130', 'Supervise Messages', 'Message Center', 'view', 0, '1039', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('131', 'Supervise Messages', 'Message Center', 'create', 0, '1039', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('132', 'Supervise Messages', 'Message Center', 'edit', 0, '1039', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('133', 'Supervise Messages', 'Message Center', 'delete', 0, '1039', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('134', 'Supervise Messages', 'Message Center', 'approve', 0, '1039', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('135', 'Manage Global Limits', 'Limits', 'view', 0, '1040', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('136', 'Manage Global Limits', 'Limits', 'create', 0, '1040', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('137', 'Manage Global Limits', 'Limits', 'edit', 0, '1040', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('138', 'Manage Global Limits', 'Limits', 'delete', 0, '1040', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('139', 'Manage Global Limits', 'Limits', 'approve', 0, '1040', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('140', 'Manage Notifications', 'Notifications', 'edit', 0, '1030', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('141', 'Manage Notifications', 'Notifications', 'approve', 0, '1030', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('142', 'ACH Credit Transfer', 'Payments', 'view', 1, '1041', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('143', 'ACH Credit Transfer', 'Payments', 'create', 1, '1041', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('144', 'ACH Credit Transfer', 'Payments', 'edit', 1, '1041', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('145', 'ACH Credit Transfer', 'Payments', 'delete', 1, '1041', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('146', 'ACH Credit Transfer', 'Payments', 'approve', 1, '1041', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('147', 'ACH Credit Transfer', 'Payments', 'cancel', 1, '1041', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('148', 'ACH Credit - Intracompany', 'Payments', 'view', 1, '1042', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('149', 'ACH Credit - Intracompany', 'Payments', 'create', 1, '1042', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('150', 'ACH Credit - Intracompany', 'Payments', 'edit', 1, '1042', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('151', 'ACH Credit - Intracompany', 'Payments', 'delete', 1, '1042', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('152', 'ACH Credit - Intracompany', 'Payments', 'approve', 1, '1042', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('153', 'ACH Credit - Intracompany', 'Payments', 'cancel', 1, '1042', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('154', 'SEPA CT - Intracompany', 'Payments', 'view', 1, '1043', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('155', 'SEPA CT - Intracompany', 'Payments', 'create', 1, '1043', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('156', 'SEPA CT - Intracompany', 'Payments', 'edit', 1, '1043', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('157', 'SEPA CT - Intracompany', 'Payments', 'delete', 1, '1043', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('158', 'SEPA CT - Intracompany', 'Payments', 'approve', 1, '1043', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('159', 'SEPA CT - Intracompany', 'Payments', 'cancel', 1, '1043', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('160', 'US Domestic Wire - Intracompany', 'Payments', 'view', 1, '1044', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('161', 'US Domestic Wire - Intracompany', 'Payments', 'create', 1, '1044', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('162', 'US Domestic Wire - Intracompany', 'Payments', 'edit', 1, '1044', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('163', 'US Domestic Wire - Intracompany', 'Payments', 'delete', 1, '1044', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('164', 'US Domestic Wire - Intracompany', 'Payments', 'approve', 1, '1044', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('165', 'US Domestic Wire - Intracompany', 'Payments', 'cancel', 1, '1044', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('166', 'US Foreign Wire - Intracompany', 'Payments', 'view', 1, '1045', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('167', 'US Foreign Wire - Intracompany', 'Payments', 'create', 1, '1045', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('168', 'US Foreign Wire - Intracompany', 'Payments', 'edit', 1, '1045', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('169', 'US Foreign Wire - Intracompany', 'Payments', 'delete', 1, '1045', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('170', 'US Foreign Wire - Intracompany', 'Payments', 'approve', 1, '1045', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('171', 'US Foreign Wire - Intracompany', 'Payments', 'cancel', 1, '1045', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('172', 'Manage Legal Entities', 'Legal Entity', 'create', '0', '1011', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('173', 'Manage Legal Entities', 'Legal Entity', 'edit', '0', '1011', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('174', 'Manage Legal Entities', 'Legal Entity', 'delete', '0', '1011', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('175', 'Manage Legal Entities', 'Legal Entity', 'approve', '0', '1011', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('176', 'ACH Debit', 'Payments', 'view', 1, '1046', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('177', 'ACH Debit', 'Payments', 'create', 1, '1046', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('178', 'ACH Debit', 'Payments', 'edit', 1, '1046', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('179', 'ACH Debit', 'Payments', 'delete', 1, '1046', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('180', 'ACH Debit', 'Payments', 'approve', 1, '1046', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('181', 'ACH Debit', 'Payments', 'cancel', 1, '1046', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('182', 'Manage Budgets', 'Personal Finance Management', 'view', 0, '1047', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('183', 'Manage Budgets', 'Personal Finance Management', 'create', 0, '1047', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('184', 'Manage Budgets', 'Personal Finance Management', 'edit', 0, '1047', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('185', 'Manage Budgets', 'Personal Finance Management', 'delete', 0, '1047', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('186', 'Manage Saving Goals', 'Personal Finance Management', 'view', 0, '1048', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('187', 'Manage Saving Goals', 'Personal Finance Management', 'create', 0, '1048', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('188', 'Manage Saving Goals', 'Personal Finance Management', 'edit', 0, '1048', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('189', 'Manage Saving Goals', 'Personal Finance Management', 'delete', 0, '1048', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('190', 'Manage Shadow Limits', 'Limits', 'approve', 0, '1014', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('191', 'Manage Limits', 'Limits', 'approve', 0, '1012', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('192', 'Lock User', 'Identities', 'view', 0, '1049', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('193', 'Lock User', 'Identities', 'create', 0, '1049', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('194', 'Lock User', 'Identities', 'edit', 0, '1049', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('195', 'Lock User', 'Identities', 'approve', 0, '1049', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('196', 'Unlock User', 'Identities', 'view', 0, '1050', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('197', 'Unlock User', 'Identities', 'create', 0, '1050', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('198', 'Unlock User', 'Identities', 'edit', 0, '1050', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('199', 'Unlock User', 'Identities', 'approve', 0, '1050', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('200', 'Manage Identities', 'Identities', 'approve', 0, '1034', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('201', 'Manage Devices', 'Device', 'view', 0, '1051', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('202', 'Manage Devices', 'Device', 'edit', 0, '1051', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('203', 'SEPA CT - closed', 'Payments', 'view', 1, '1052', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('204', 'SEPA CT - closed', 'Payments', 'create', 1, '1052', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('205', 'SEPA CT - closed', 'Payments', 'edit', 1, '1052', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('206', 'SEPA CT - closed', 'Payments', 'delete', 1, '1052', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('207', 'SEPA CT - closed', 'Payments', 'approve', 1, '1052', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('208', 'SEPA CT - closed', 'Payments', 'cancel', 1, '1052', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('209', 'A2A Transfer', 'Payments', 'view', 1, '1053', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('210', 'A2A Transfer', 'Payments', 'create', 1, '1053', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('211', 'A2A Transfer', 'Payments', 'edit', 1, '1053', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('212', 'A2A Transfer', 'Payments', 'delete', 1, '1053', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('213', 'A2A Transfer', 'Payments', 'approve', 1, '1053', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('214', 'A2A Transfer', 'Payments', 'cancel', 1, '1053', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('215', 'Manage Case', 'Flow', 'view', '0', '1054', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('216', 'Manage Case', 'Flow', 'create', '0', '1054', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('217', 'Manage Case', 'Flow', 'edit', '0', '1054', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('218', 'Manage Case', 'Flow', 'delete', '0', '1054', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('219', 'Archive Case', 'Flow', 'execute', '0', '1055', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('220', 'Manage Case Documents', 'Flow', 'view', '0', '1056', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('221', 'Manage Case Documents', 'Flow', 'create', '0', '1056', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('222', 'Manage Case Documents', 'Flow', 'delete', '0', '1056', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('223', 'Manage Case Comments', 'Flow', 'view', '0', '1057', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('224', 'Manage Case Comments', 'Flow', 'create', '0', '1057', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('225', 'Manage Case Comments', 'Flow', 'edit', '0', '1057', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('226', 'Manage Case Comments', 'Flow', 'delete', '0', '1057', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('227', 'Access Case Changelog', 'Flow', 'view', '0', '1058', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('228', 'Access Case Statistics', 'Flow', 'view', '0', '1059', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('229', 'Access Journey Statistics', 'Flow', 'view', '0', '1060', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('230', 'Access Journey Definitions', 'Flow', 'view', '0', '1061', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('231', 'Assign Task', 'Flow', 'execute', '0', '1062', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('232', 'Manage Task Dates', 'Flow', 'view', '0', '1063', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('233', 'Manage Task Dates', 'Flow', 'create', '0', '1063', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('234', 'Manage Task Dates', 'Flow', 'edit', '0', '1063', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('235', 'Manage Task Dates', 'Flow', 'delete', '0', '1063', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('236', 'Manage Task', 'Flow', 'execute', '0', '1064', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('237', 'Manage Task', 'Flow', 'view', '0', '1064', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('238', 'Stop Checks', 'Payments', 'view', '0', '1065', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('239', 'Stop Checks', 'Payments', 'create', '0', '1065', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('240', 'Stop Checks', 'Payments', 'edit', '0', '1065', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('241', 'Stop Checks', 'Payments', 'delete', '0', '1065', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('242', 'Stop Checks', 'Payments', 'approve', '0', '1065', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('243', 'Stop Checks', 'Payments', 'cancel', '0', '1065', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('244', 'Manage Devices', 'Device', 'delete', '0', '1051', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('245', 'Manage Other User''s Devices', 'Device', 'view', '0', '1066', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('246', 'Manage Other User''s Devices', 'Device', 'edit', '0', '1066', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('247', 'Manage Other User''s Devices', 'Device', 'delete', '0', '1066', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('248', 'Batch - ACH Credit', 'Batch', 'view', 1, '1067', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('249', 'Batch - ACH Credit', 'Batch', 'create', 1, '1067', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('250', 'Batch - ACH Credit', 'Batch', 'edit', 1, '1067', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('251', 'Batch - ACH Credit', 'Batch', 'delete', 1, '1067', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('252', 'Batch - ACH Credit', 'Batch', 'approve', 1, '1067', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('253', 'Batch - ACH Credit', 'Batch', 'cancel', 1, '1067', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('254', 'Cash Flow Forecasting', 'Cash Flow', 'view', '1', '1068', '2');
INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('255', 'Cash Flow Forecasting', 'Cash Flow', 'create', '1', '1068', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('256', 'Cash Flow Forecasting', 'Cash Flow', 'edit', '1', '1068', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('257', 'Cash Flow Forecasting', 'Cash Flow', 'delete', '1', '1068', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('258', 'Manage User Profiles', 'User Profiles', 'create', '0', '1035', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('259', 'Manage User Profiles', 'User Profiles', 'delete', '0', '1035', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('260', 'Batch - ACH Debit', 'Batch', 'view', 1, '1069', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('261', 'Batch - ACH Debit', 'Batch', 'create', 1, '1069', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('262', 'Batch - ACH Debit', 'Batch', 'edit', 1, '1069', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('263', 'Batch - ACH Debit', 'Batch', 'delete', 1, '1069', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('264', 'Batch - ACH Debit', 'Batch', 'approve', 1, '1069', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('265', 'Batch - ACH Debit', 'Batch', 'cancel', 1, '1069', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('266', 'P2P Transfer', 'Payments', 'view', 1, '1070', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('267', 'P2P Transfer', 'Payments', 'create', 1, '1070', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('268', 'P2P Transfer', 'Payments', 'edit', 1, '1070', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('269', 'P2P Transfer', 'Payments', 'delete', 1, '1070', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('270', 'P2P Transfer', 'Payments', 'approve', 1, '1070', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('271', 'P2P Transfer', 'Payments', 'cancel', 1, '1070', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('272', 'Payment Templates', 'Payments', 'view', 0, '1071', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('273', 'Payment Templates', 'Payments', 'create', 0, '1071', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('274', 'Payment Templates', 'Payments', 'edit', 0, '1071', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('275', 'Payment Templates', 'Payments', 'delete', 0, '1071', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('276', 'Payment Templates', 'Payments', 'approve', 0, '1071', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('277', 'Access Task Statistics', 'Flow', 'view', 0, '1072', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('278', 'UK CHAPS', 'Payments', 'view', 1, '1073', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('279', 'UK CHAPS', 'Payments', 'create', 1, '1073', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('280', 'UK CHAPS', 'Payments', 'edit', 1, '1073', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('281', 'UK CHAPS', 'Payments', 'delete', 1, '1073', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('282', 'UK CHAPS', 'Payments', 'approve', 1, '1073', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('283', 'UK CHAPS', 'Payments', 'cancel', 1, '1073', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('284', 'UK Faster Payments', 'Payments', 'view', 1, '1074', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('285', 'UK Faster Payments', 'Payments', 'create', 1, '1074', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('286', 'UK Faster Payments', 'Payments', 'edit', 1, '1074', '4');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('287', 'UK Faster Payments', 'Payments', 'delete', 1, '1074', '5');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('288', 'UK Faster Payments', 'Payments', 'approve', 1, '1074', '6');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('289', 'UK Faster Payments', 'Payments', 'cancel', 1, '1074', '7');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('290', 'Emulate', 'Employee', 'view', 0, '1075', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
 ('291', 'Emulate', 'Employee', 'execute', 0, '1075', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('292', 'Act on behalf of', 'Employee', 'execute', 0, '1076', '1');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('293', 'Access Collections', 'Flow', 'view', 0, '1077', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('294', 'Manage Authorized Users', 'User', 'view', 1, '1078', '2');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('295', 'Manage Authorized Users', 'User', 'create', 1, '1078', '3');

INSERT INTO APPLICABLE_FUNCTION_PRIVILEGE
(ID, BUSINESS_FUNCTION_NAME, FUNCTION_RESOURCE_NAME, PRIVILEGE_NAME, SUPPORTS_LIMIT, BUSINESS_FUNCTION_ID, PRIVILEGE_ID)
VALUES
('296', 'Manage Authorized Users', 'User', 'edit', 1, '1078', '4');

-- INITIALIZING USER ASSIGNABLE PERMISSION SET

INSERT INTO assignable_permission_set (
    id,
    description,
    name,
    type
) VALUES (
    1,
    'This Assignable Permission Set (APS) contains all available Business Function/Privilege pairs',
    'Regular user APS',
    0
);

-- INITIALIZING ADMIN ASSIGNABLE PERMISSION SET

INSERT INTO assignable_permission_set (
    id,
    description,
    name,
    type
) VALUES (
    2,
    'This Assignable Permission Set (APS) contains all available Entitlements Business Function/Privilege pairs.',
    'Admin user APS',
    1
);

-- INITIALIZING USA ASSIGNABLE PERMISSION SET

INSERT INTO assignable_permission_set (
    id,
    description,
    name,
    type
) VALUES (
    3,
    'Assignable permission set applicable for USA.',
    'USA APS',
    2
);

-- CUSTOMIZING ALREADY INITIALIZED ASSIGNABLE PERMISSION SETS

INSERT INTO assignable_permission_set_item (
    assignable_permission_set_id,
    function_privilege_id
)
    SELECT
        2,
        afp.id
    FROM
        applicable_function_privilege afp
    WHERE
        afp.id
            IN (
            '13',
            '14',
            '15',
            '19',
            '20',
            '21',
            '22',
            '23',
            '54',
            '55',
            '56',
            '57',
            '59',
            '60',
            '61',
            '62',
            '83',
            '84',
            '85',
            '86',
            '172',
            '173',
            '174'
        );


INSERT INTO assignable_permission_set_item (
    assignable_permission_set_id,
    function_privilege_id
)
    SELECT
        1,
        id
    FROM
        applicable_function_privilege;

COMMIT;

INSERT INTO assignable_permission_set_item (
    assignable_permission_set_id,
    function_privilege_id
)
    SELECT
        3,
        afp.id
    FROM
        applicable_function_privilege afp
    WHERE
    afp.business_function_id NOT IN ('1043', '1052', '1002', '1037', '1015');

COMMIT;
