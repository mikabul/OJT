-- 생성자 Oracle SQL Developer Data Modeler 21.4.2.059.0838
--   위치:        2024-02-21 15:33:04 KST
--   사이트:      Oracle Database 11g
--   유형:      Oracle Database 11g



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE code_detail (
    mst_cd    VARCHAR2(10) NOT NULL,
    dtl_cd    VARCHAR2(10) NOT NULL,
    dtl_cd_nm VARCHAR2(40) NOT NULL
);

ALTER TABLE code_detail ADD CONSTRAINT code_detail_pk PRIMARY KEY ( mst_cd,
                                                                    dtl_cd );

CREATE TABLE code_master (
    mst_cd    VARCHAR2(10) NOT NULL,
    mst_cd_nm VARCHAR2(40) NOT NULL
);

ALTER TABLE code_master ADD CONSTRAINT code_master_pk PRIMARY KEY ( mst_cd );

CREATE TABLE customer (
    cust_seq NUMBER(10) NOT NULL,
    cust_nm  VARCHAR2(60) NOT NULL
);

ALTER TABLE customer ADD CONSTRAINT customer_pk PRIMARY KEY ( cust_seq );

CREATE TABLE member_info (
    mem_seq              NUMBER(10) NOT NULL,
    mem_nm               VARCHAR2(20) NOT NULL,
    mem_rnn              VARCHAR2(15) NOT NULL,
    mem_tel              VARCHAR2(15),
    mem_phone            VARCHAR2(15) NOT NULL,
    mem_email            VARCHAR2(40),
    dp_cd                VARCHAR2(10),
    ra_cd                VARCHAR2(10) NOT NULL,
    mem_addr             VARCHAR2(100) NOT NULL,
    mem_id               VARCHAR2(20) NOT NULL unique,
    mem_pw               VARCHAR2(40) NOT NULL,
    mem_pic              VARCHAR2(70) NOT NULL,
    st_cd                VARCHAR2(10) NOT NULL,
    mem_hire_date        DATE NOT NULL,
    mem_resignation_date DATE
);

ALTER TABLE member_info ADD CONSTRAINT member_info_pk PRIMARY KEY ( mem_seq );

CREATE TABLE member_sk (
    mem_seq NUMBER(10) NOT NULL,
    sk_cd   VARCHAR2(10) NOT NULL
);

ALTER TABLE member_sk ADD CONSTRAINT member_sk_pk PRIMARY KEY ( mem_seq,
                                                                sk_cd );

CREATE TABLE project_member_table (
    prj_seq NUMBER(10) NOT NULL,
    mem_seq NUMBER(10) NOT NULL,
    st_dt   DATE NOT NULL,
    ed_dt   DATE NOT NULL
);

ALTER TABLE project_member_table ADD CONSTRAINT project_member_table_pk PRIMARY KEY ( prj_seq,
                                                                                      mem_seq );

CREATE TABLE project_sk (
    prj_seq NUMBER(10) NOT NULL,
    sk_cd   VARCHAR2(10) NOT NULL
);

ALTER TABLE project_sk ADD CONSTRAINT project_sk_pk PRIMARY KEY ( prj_seq,
                                                                  sk_cd );

CREATE TABLE project_info (
    prj_seq   NUMBER(10) NOT NULL,
    prj_nm    VARCHAR2(60) NOT NULL,
    cust_seq  NUMBER(10) NOT NULL,
    prj_st_dt DATE NOT NULL,
    prj_ed_dt DATE NOT NULL,
    prj_dtl   VARCHAR2(1500),
    ed_cd     VARCHAR2(10) NOT NULL
);

ALTER TABLE prokect_info ADD CONSTRAINT prokect_info_pk PRIMARY KEY ( prj_seq );

ALTER TABLE code_detail
    ADD CONSTRAINT code_detail_code_master_fk FOREIGN KEY ( mst_cd )
        REFERENCES code_master ( mst_cd );

CREATE SEQUENCE MEMBER_SEQUENCE START WITH 1 INCREMENT BY 1 MINVALUE 1;
CREATE SEQUENCE PROJECT_SEQUENCE START WITH 1 INCREMENT BY 1 MINVALUE 1;
CREATE SEQUENCE CUSTOMER_SEQUNCE START WITH 1 INCREMENT BY 1 MINVALUE 1;

COMMIT;























