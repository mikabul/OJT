-- 생성자 Oracle SQL Developer Data Modeler 21.4.2.059.0838
--   위치:        2024-03-14 11:00:41 KST
--   사이트:      Oracle Database 11g
--   유형:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE code_detail (
    mst_cd    VARCHAR2(4) NOT NULL,
    dtl_cd    VARCHAR2(2) NOT NULL,
    dtl_cd_nm VARCHAR2(40) NOT NULL
);

ALTER TABLE code_detail ADD CONSTRAINT code_detail_pk PRIMARY KEY ( mst_cd,
                                                                    dtl_cd );

CREATE TABLE code_master (
    mst_cd    VARCHAR2(4) NOT NULL,
    mst_cd_nm VARCHAR2(40) NOT NULL
);

ALTER TABLE code_master ADD CONSTRAINT code_master_pk PRIMARY KEY ( mst_cd );

CREATE TABLE customer (
    cust_seq NUMBER(10) NOT NULL,
    cust_nm  VARCHAR2(60) NOT NULL
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( cust_seq );

CREATE TABLE member_address (
    mem_seq        NUMBER(10) NOT NULL,
    mem_zonecode   VARCHAR2(5) NOT NULL,
    mem_addr       VARCHAR2(120) NOT NULL,
    mem_detailaddr VARCHAR2(60),
    mem_extraaddr  VARCHAR2(30)
);

ALTER TABLE member_address ADD CONSTRAINT member_address_pk PRIMARY KEY ( mem_seq );

CREATE TABLE member_company (
    mem_seq              NUMBER(10) NOT NULL,
    dp_cd                VARCHAR2(2),
    ra_cd                VARCHAR2(2) NOT NULL,
    mem_pic              VARCHAR2(70),
    st_cd                VARCHAR2(2) NOT NULL,
    mem_hire_date        VARCHAR2(12) NOT NULL,
    mem_resignation_date VARCHAR2(12)
);

ALTER TABLE member_company ADD CONSTRAINT member_company_pk PRIMARY KEY ( mem_seq );

CREATE TABLE member_info (
    mem_seq        NUMBER(10) NOT NULL,
    mem_nm         VARCHAR2(20) NOT NULL,
    mem_id         VARCHAR2(45) NOT NULL,
    mem_pw         VARCHAR2(64) NOT NULL,
    mem_rrn_prefix VARCHAR2(6) NOT NULL,
    mem_rrn_suffix VARCHAR2(64) NOT NULL,
    mem_tel        VARCHAR2(15) NOT NULL,
    mem_emtel      VARCHAR2(15),
    mem_email      VARCHAR2(40),
    gd_cd          VARCHAR2(2) NOT NULL
);

ALTER TABLE member_info ADD CONSTRAINT member_info_pk PRIMARY KEY ( mem_seq );

CREATE TABLE member_sk (
    mem_seq NUMBER(10) NOT NULL,
    sk_cd   VARCHAR2(2) NOT NULL
);

ALTER TABLE member_sk ADD CONSTRAINT member_sk_pk PRIMARY KEY ( mem_seq,
                                                                sk_cd );

CREATE TABLE project_info (
    prj_seq     NUMBER(10) NOT NULL,
    prj_nm      VARCHAR2(60) NOT NULL,
    cust_seq    NUMBER(10) NOT NULL,
    prj_st_dt   VARCHAR2(12) NOT NULL,
    prj_ed_dt   VARCHAR2(12) NOT NULL,
    prj_dtl     VARCHAR2(1500),
    ps_cd       VARCHAR2(2) NOT NULL,
    maint_st_dt VARCHAR2(12),
    maint_ed_dt VARCHAR2(12)
);

ALTER TABLE project_info ADD CONSTRAINT prokect_info_pk PRIMARY KEY ( prj_seq );

CREATE TABLE project_member_table (
    prj_seq NUMBER(10) NOT NULL,
    mem_seq NUMBER(10) NOT NULL,
    st_dt   VARCHAR2(12),
    ed_dt   VARCHAR2(12),
    ro_cd   VARCHAR2(2)
);

ALTER TABLE project_member_table ADD CONSTRAINT project_member_table_pk PRIMARY KEY ( prj_seq,
                                                                                      mem_seq );

CREATE TABLE project_sk (
    prj_seq NUMBER(10) NOT NULL,
    sk_cd   VARCHAR2(2) NOT NULL
);

ALTER TABLE project_sk ADD CONSTRAINT project_sk_pk PRIMARY KEY ( prj_seq,
                                                                  sk_cd );
-- 권한                                                                  
CREATE TABLE AUTHORITY (
    AUTHORITY_NUM NUMBER(3),
    AUTHORITY_NM VARCHAR2(100) NOT NULL
);

ALTER TABLE AUTHORITY ADD CONSTRAINT AUTHORITY_PK PRIMARY KEY ( AUTHORITY_NUM );

CREATE TABLE MEMBER_AUTHORITY (
    MEM_SEQ NUMBER(10),
    AUTHORITY_NUM NUMBER(10) NOT NULL
);

ALTER TABLE MEMBER_AUTHORITY ADD CONSTRAINT MEMBER_AUTHORITY_PK PRIMARY KEY ( MEM_SEQ,
                                                                              AUTHORITY_NUM );
                                                                              
CREATE TABLE MENU (
    MENU_NUM NUMBER(3),
    MENU_NM VARCHAR2(100) NOT NULL,
    MENU_URL VARCHAR2(100) NOT NULL,
    MENU_SHOW VARCHAR2(5) NOT NULL
);

ALTER TABLE MENU ADD CONSTRAINT MEMU_PK PRIMARY KEY ( MENU_NUM );

CREATE TABLE AUTHORITY_MENU (
    AUTHORITY_NUM NUMBER(3),
    MENU_NUM NUMBER(3)
);

ALTER TABLE AUTHORITY_MENU ADD CONSTRAINT AUTHORITY_MENU_PK PRIMARY KEY ( AUTHORITY_NUM, MENU_NUM );

ALTER TABLE code_detail
    ADD CONSTRAINT code_detail_code_master_fk FOREIGN KEY ( mst_cd )
        REFERENCES code_master ( mst_cd )
            on delete cascade;

ALTER TABLE member_address
    ADD CONSTRAINT member_address_member_info_fk FOREIGN KEY ( mem_seq )
        REFERENCES member_info ( mem_seq )
            on delete cascade;

ALTER TABLE member_company
    ADD CONSTRAINT member_company_member_info_fk FOREIGN KEY ( mem_seq )
        REFERENCES member_info ( mem_seq )
            on delete cascade;

ALTER TABLE member_sk
    ADD CONSTRAINT member_sk_member_info_fk FOREIGN KEY ( mem_seq )
        REFERENCES member_info ( mem_seq )
            on delete cascade;

ALTER TABLE project_member_table
    ADD CONSTRAINT pm_table_member_info_fk FOREIGN KEY ( mem_seq )
        REFERENCES member_info ( mem_seq )
            on delete cascade;

ALTER TABLE project_member_table
    ADD CONSTRAINT pm_table_project_info_fk FOREIGN KEY ( prj_seq )
        REFERENCES project_info ( prj_seq )
            on delete cascade;

ALTER TABLE project_info
    ADD CONSTRAINT project_info_customer_fk FOREIGN KEY ( cust_seq )
        REFERENCES customer ( cust_seq )
            on delete cascade;

ALTER TABLE project_sk
    ADD CONSTRAINT project_sk_project_info_fk FOREIGN KEY ( prj_seq )
        REFERENCES project_info ( prj_seq )
            on delete cascade;
            
-- 권한
ALTER TABLE MEMBER_AUTHORITY
    ADD CONSTRAINT MEMBER_INFO_MEMBER_AUTHORITY_FK FOREIGN KEY (MEM_SEQ)
        REFERENCES MEMBER_INFO (MEM_SEQ)
            ON DELETE CASCADE;
            
ALTER TABLE MEMBER_AUTHORITY
    ADD CONSTRAINT MEMBER_AUTHORITY_AUTHORITY_FK FOREIGN KEY (AUTHORITY_NUM)
        REFERENCES AUTHORITY (AUTHORITY_NUM)
            ON DELETE CASCADE;
            
ALTER TABLE AUTHORITY_MENU
    ADD CONSTRAINT AUTHORITY_MENU_AUTHORITY_FK FOREIGN KEY (AUTHORITY_NUM)
        REFERENCES AUTHORITY (AUTHORITY_NUM)
            ON DELETE CASCADE;
            
ALTER TABLE AUTHORITY_MENU
    ADD CONSTRAINT AUTHORITY_MENU_MENU_KF FOREIGN KEY (MENU_NUM)
        REFERENCES MENU (MENU_NUM)
            ON DELETE CASCADE;

-- 시퀀스
CREATE SEQUENCE MEMBER_SEQUENCE START WITH 1 INCREMENT BY 1 MINVALUE 1 nocache;
CREATE SEQUENCE PROJECT_SEQUENCE START WITH 1 INCREMENT BY 1 MINVALUE 1 nocache;
CREATE SEQUENCE CUSTOMER_SEQUENCE START WITH 1 INCREMENT BY 1 MINVALUE 1 nocache;
CREATE SEQUENCE AUTHORITY_SEQUENCE START WITH 0 INCREMENT BY 1 MINVALUE 0 NOCACHE;
CREATE SEQUENCE MENU_SEQUENCE START WITH 1 INCREMENT BY 1 MINVALUE 1 NOCACHE;


commit;