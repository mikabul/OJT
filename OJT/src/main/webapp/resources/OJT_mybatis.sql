
-- 프로젝트 검색(ProjectMapper)
select * from(
select prj.prj_seq, prj.prj_nm, cust.cust_nm, prj.prj_st_dt, prj.prj_ed_dt,
dtl_cd_nm as ps_nm, row_number() over (order by prj.prj_seq desc) as rn
from project_info prj
left join code_detail cd on cd.mst_cd = 'PS01' and prj.ps_cd = cd.dtl_cd
left join customer cust on cust.cust_seq = prj.cust_seq
where prj.prj_nm like '%%'
and to_date(prj.prj_st_dt) between to_date('2023-12-01') and to_date('2024-12-31')
and prj.ps_cd = 1)
where rn between 1 and 20;

-- 페이징 처리를 위한 프로젝트 검색 최대 개수(ProjectMapper)
select count(prj.prj_seq)
from project_info prj
left join code_detail cd on cd.mst_cd = 'PS01' and prj.ps_cd = cd.dtl_cd
left join customer cust on cust.cust_seq = prj.cust_seq
where prj.prj_nm like '%%'
and to_date(prj.prj_st_dt) > to_date('2023-03-02');

-- 고객사 검색(ProjectMapper)
select * from customer where cust_nm like '%%';

-- 프로젝트 등록
insert into project_info values(PROJECT_SEQUENCE.nextval, '', 1, '', '', '', '');

-- 프로젝트 상태 수정
update project_info set ps_cd = '' where prj_seq = 1;

-- 프로젝트 수정
update project_info set prj_nm = '', cust_seq = 1, prj_st_dt = '',
prj_ed_dt = '', prj_dtl = '', ps_cd = ''
where prj_seq = 1;

-- 프로젝트 삭제
delete project_info where prj_seq = 1;

-- 프로젝트 필요기술 조회
select dtl_cd, dtl_cd_nm from code_detail cd
left join project_sk ps on ps.sk_cd = cd.dtl_cd
where cd.mst_cd='SK01' and ps.prj_seq = 1;

-- 기술 조회
select * from code_detail
where mst_cd = 'SK01';

-- 프로젝트 필요기술 등록
insert into project_sk values(1, '01');

-- 프로젝트 필요기술 삭제
delete project_sk where prj_seq = 1;

-- 프로젝트 멤버 조회
select mem.mem_seq, mem.mem_nm, dept.dtl_cd_nm as dept,
pos.dtl_cd_nm as position, pm.st_dt, pm.ed_dt
from project_member_table pm
inner join member_info mem on mem.mem_seq = pm.mem_seq
inner join member_company mc on mc.mem_seq = mem.mem_seq
left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mc.dp_cd
left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mc.ra_cd
where pm.prj_seq = 1
;

-- 프로젝트 멤버 인원 등록 조회
select mem.mem_seq, mem.mem_nm, dept.dtl_cd_nm as dept,
pos.dtl_cd_nm as position
from member_info mem
inner join member_company mc on mc.mem_seq = mem.mem_seq
left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mc.dp_cd
left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mc.ra_cd
where mem.mem_seq not in (select pm.mem_seq from project_member_table pm 
where pm.prj_seq = 1)
and mem.mem_nm like '%감%';

-- 신규 프로젝트 멤버 등록 조회
select mem.mem_seq, mem.mem_nm, dept.dtl_cd_nm as dept,
pos.dtl_cd_nm as position
from member_info mem
inner join member_company mc on mc.mem_seq = mem.mem_seq
left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mc.dp_cd
left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mc.ra_cd
where mem.mem_seq not in (1,2,3,4)
and mem.mem_nm like '%%';

-- 프로젝트 멤버 등록
insert into project_member_table values(1, 1, '', '', '');

-- 프로젝트 멤버 수정
update project_member_table set st_dt = '', ed_dt = '', ro_cd = ''
where prj_seq = 1 and mem_seq = 1;

-- 프로젝트 멤버 삭제
delete project_member_table where prj_seq = 1 and mem_seq = 1;


select * from code_detail where mst_cd = 'RO01';

select cust_seq from customer where cust_seq = 1;

select count(dtl_cd) from code_detail
where mst_cd = 'SK01' and dtl_cd in ('1', '3', '4', '5', '1');

select count(mem_seq) from member_info where mem_seq in (1,2,3);



select * from project_info;
select * from project_member_table;
select * from project_sk;

select * from code_detail
where mst_cd='SK01' and
dtl_cd in (select sk_cd from project_sk where prj_seq = 1);

select 
    prj.prj_seq,
    prj.prj_nm,
    prj.cust_seq,
    cust.cust_nm,
    prj.prj_st_dt,
    prj.prj_ed_dt,
    prj.maint_st_dt,
    prj.maint_ed_dt,
    prj.ps_cd,
    ps.dtl_cd_nm as ps_nm
from project_info prj
inner join code_detail ps on ps.mst_cd = 'PS01' and prj.ps_cd = ps.dtl_cd
inner join customer cust on cust.cust_seq = prj.cust_seq
where prj.prj_seq = 1;

select 
			mem.mem_seq, 
			mem.mem_nm, 
			dept.dtl_cd_nm as dept, 
			pos.dtl_cd_nm as position, 
			pm.st_dt, pm.ed_dt,
            ro.dtl_cd as ro_cd,
            ro.dtl_cd_nm as role
		from project_member_table pm 
		inner join member_info mem on mem.mem_seq = pm.mem_seq 
		inner join member_company mc on mc.mem_seq = mem.mem_seq 
		left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mc.dp_cd 
		left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mc.ra_cd 
        left join code_detail ro on ro.mst_cd = 'RO01' and ro.dtl_cd = pm.ro_cd
		where pm.prj_seq = 1;
        
        
select PRJ_DTL from project_info;


select 
			mem.mem_seq, 
			mem.mem_nm, 
			dept.dtl_cd_nm as dept, 
			pos.dtl_cd_nm as position, 
			pm.st_dt, pm.ed_dt,
            ro.dtl_cd as ro_cd,
            ro.dtl_cd_nm as role
		from project_member_table pm 
		inner join member_info mem on mem.mem_seq = pm.mem_seq 
		inner join member_company mc on mc.mem_seq = mem.mem_seq 
		left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mc.dp_cd 
		left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mc.ra_cd 
        left join code_detail ro on ro.mst_cd = 'RO01' and ro.dtl_cd = pm.ro_cd
		where pm.prj_seq =1;
        

select 
			mem.mem_seq as memberNumber, 
			mem.mem_nm as memberName, 
			dept.dtl_cd_nm as department, 
			pos.dtl_cd_nm as position 
		from member_info mem 
		inner join member_company mc on mc.mem_seq = mem.mem_seq 
		left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mc.dp_cd 
		left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mc.ra_cd 
		where mem.mem_nm like '%%'
		
		and mem.mem_seq not in
			(6)

		order by mem.mem_seq;
        
        
select count(mem_seq) from project_member_table where mem_seq in (1,2) and prj_seq = 1;
select * from project_member_table where prj_seq = 1;
delete project_member_table where prj_seq = 1 and mem_seq in (1,2);


select count(prj_seq)
from project_info
where prj_seq = 763
    and prj_st_dt = '2024-04-03'
    and prj_ed_dt = '2024-04-04';
   

select * from project_info where prj_seq = 763;
SELECT * FROM project_info;

SELECT count(mem_seq)
FROM MEMBER_INFO
WHERE mem_seq IN (1,2,3);



select
    mi.mem_seq,
    mi.mem_nm,
    mc.mem_hire_date,
    de.dtl_cd as departmentCode,
    ps.dtl_cd as positionCode,
    st.dtl_cd as statusCode,
    de.dtl_cd_nm as depatment,
    ps.dtl_cd_nm as position,
    st.dtl_cd_nm as status
from member_info mi
join member_company mc on mi.mem_seq = mc.mem_seq
left join code_detail de on de.mst_cd='DP01' and mc.dp_cd = de.dtl_cd
left join code_detail ps on ps.mst_cd='RA01' and mc.ra_cd = ps.dtl_cd
left join code_detail st on st.mst_cd='ST01' and mc.st_cd = st.dtl_cd;

select * from(
    select
        mi.mem_seq,
        mi.mem_nm,
        mc.mem_hire_date,
        de.dtl_cd as departmentCode,
        ps.dtl_cd as positionCode,
        st.dtl_cd as statusCode,
        de.dtl_cd_nm as depatment,
        ps.dtl_cd_nm as position,
        st.dtl_cd_nm as status,
        row_number() over (order by mi.mem_seq) as rn
    from member_info mi
    join member_company mc on mi.mem_seq = mc.mem_seq
    left join code_detail de on de.mst_cd='DP01' and mc.dp_cd = de.dtl_cd
    left join code_detail ps on ps.mst_cd='RA01' and mc.ra_cd = ps.dtl_cd
    left join code_detail st on st.mst_cd='ST01' and mc.st_cd = st.dtl_cd
    where
        mi.mem_nm like '%%'
        and to_date(mc.mem_hire_date) between to_date('2000-01-01') and to_date('2024-12-31')
--        and de.dtl_cd = '0'
--          and ps.dtl_cd = '1'
--        and st.dtl_cd = '1'
)
where rn between 4 and 6;

select * from member_info;
select * from member_company;
select * from member_address;
select * from code_detail;
select * from code_master;

select
    mi.mem_nm,
    mi.mem_seq,
    mi.mem_id,
    mi.mem_rrn_prefix,
    mi.mem_tel,
    mi.mem_phone,
    mi.mem_email,
    mc.mem_pic,
    mc.mem_hire_date,
    mc.mem_resignation_date,
    ma.mem_zonecode,
    ma.mem_addr,
    ma.mem_detailaddr,
    ma.mem_extraaddr,
    dept.dtl_cd_nm,
    posi.dtl_cd_nm,
    st.dtl_cd_nm
from member_info mi
inner join member_company mc on mc.mem_seq = mi.mem_seq
inner join member_address ma on ma.mem_seq = mi.mem_seq
left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mc.dp_cd
left join code_detail posi on posi.mst_cd = 'RA01' and posi.dtl_cd = mc.ra_cd
left join code_detail st on st.mst_cd = 'ST01' and st.dtl_cd = mc.st_cd
where mi.mem_seq = 1;

select
    prj.prj_seq,
    prj.prj_nm,
    cust.cust_nm,
    mem.st_dt,
    mem.ed_dt,
    ro.dtl_cd as role
from project_member_table mem
inner join project_info prj on mem.prj_seq = prj.prj_seq
inner join customer cust on prj.cust_seq = cust.cust_seq
left join code_detail ro on ro.mst_cd = 'RO01' and ro.dtl_cd = mem.ro_cd
where mem_seq = 7;

select
    count(mem_seq)
from member_info
where mem_id = 'hong12';

select MEMBER_SEQUENCE.nextval from dual;

insert into member_info values(member_sequence.nextval, '홍길동', 'hong12', '12345', '891030', '1234567', '02-123-1234', '010-1293-1211', 'hong12@member.com', '1');
insert into member_address values(member_sequence.currval, '12345', '서울시 금천구 가산로 122', '', '');
insert into member_company values(member_sequence.currval, '0', '1', 'testpic1.jpg', '1', '2010-03-01', '');



select * from member_company;

update member_company set mem_pic='default.jpg'; 
commit;

alter table member_address modify mem_addr varchar2(120);
alter table member_address modify mem_detailaddr varchar2(60);



select * from project_sk;

select * from member_info;
select mem_id from member_info;

select mem_id
from member_info
where
    mem_seq != 1
    and mem_id = 'ajaja31';

select * from member_info;

select * from project_member_table;

UPDATE PROJECT_MEMBER_TABLE
SET ST_DT = '', ED_DT = '', RO_CD = ''
WHERE PRJ_SEQ = '' AND MEM_SEQ = '';

INSERT INTO PROJECT_MEMBER_TABLE
(PRJ_SEQ, MEM_SEQ, ST_DT, ED_DT, RO_CD)
VALUES(2, 1, '2000-01-01', '2000-01-01', '1');

INSERT ALL
INTO PROJECT_MEMBER_TABLE
(PRJ_SEQ, MEM_SEQ, ST_DT, ED_DT, RO_CD)
VALUES(2, 1, '2000-01-01', '2000-01-01', '1')
INTO PROJECT_MEMBER_TABLE
(PRJ_SEQ, MEM_SEQ, ST_DT, ED_DT, RO_CD)
VALUES(2, 2, '2000-01-01', '2000-01-01', '1')
SELECT * FROM DUAL;

SELECT
    PRJ.PRJ_SEQ,
    PRJ.PRJ_NM,
    CUST.CUST_NM,
    PRJ.PRJ_ST_DT,
    PRJ.PRJ_ED_DT,
    PRJ.MAINT_ST_DT,
    PRJ.MAINT_ED_DT
FROM PROJECT_INFO PRJ
INNER JOIN CUSTOMER CUST ON CUST.CUST_SEQ = PRJ.CUST_SEQ
WHERE
    PRJ.PRJ_SEQ NOT IN (
        SELECT PRJ_SEQ
        FROM PROJECT_MEMBER_TABLE
        WHERE MEM_SEQ = 1
    );

ROLLBACK;

select * from project_info where prj_seq = 1;

select count(*) from (
    select prj_seq
    from project_info
    where prj_seq = 1
        and prj_st_dt = '2023-11-07'
        and prj_ed_dt = '2024-06-27'
        and maint_st_dt IS NULL
        and maint_ed_dt IS NULL
    union all
    select mem_seq
    from member_info
    where mem_seq = 1
);


SELECT
    MI.MEM_SEQ,
    MI.MEM_ID,
    MI.MEM_PW,
    LISTAGG(AUTH.AUTHORITY_NM, ',') AS ROLES
FROM MEMBER_INFO MI
LEFT JOIN MEMBER_AUTHORITY MA ON MA.MEM_SEQ = MI.MEM_SEQ
LEFT JOIN AUTHORITY AUTH ON AUTH.AUTHORITY_NUM = MA.AUTHORITY_NUM
GROUP BY MI.MEM_SEQ, MI.MEM_ID, MI.MEM_PW;

SELECT
    MI.MEM_ID,
    MI.MEM_PW,
    MI.MEM_NM,
    LISTAGG(AUTH.AUTHORITY_NM, ',') AS ROLES
FROM MEMBER_INFO MI
LEFT JOIN MEMBER_AUTHORITY MA ON MA.MEM_SEQ = MI.MEM_SEQ
LEFT JOIN AUTHORITY AUTH ON AUTH.AUTHORITY_NUM = MA.AUTHORITY_NUM
where mi.mem_id = 'hong12'
GROUP BY MI.MEM_ID, MI.MEM_PW, MI.MEM_NM;

SELECT
    AUTH.AUTHORITY_NM,
    LISTAGG(CONCAT(MENU.MENU_URL, '/**'), ',')
FROM AUTHORITY AUTH
LEFT JOIN AUTHORITY_MENU AM ON AM.AUTHORITY_NUM = AUTH.AUTHORITY_NUM
LEFT JOIN MENU ON MENU.MENU_NUM = AM.MENU_NUM
GROUP BY AUTH.AUTHORITY_NUM, AUTH.AUTHORITY_NM
ORDER BY AUTH.AUTHORITY_NUM DESC;

SELECT * FROM MENU;
SELECT * FROM AUTHORITY;
SELECT * FROM AUTHORITY_MENU;
SELECT * FROM MEMBER_AUTHORITY;

SELECT
    CONCAT(MENU.MENU_URL, '/**') AS MENU_URL,
    LISTAGG(AUTH.AUTHORITY_NM, ',') AS AUTHORITY_NMS
FROM AUTHORITY AUTH
LEFT JOIN AUTHORITY_MENU AM ON AM.AUTHORITY_NUM = AUTH.AUTHORITY_NUM
LEFT JOIN MENU ON MENU.MENU_NUM = AM.MENU_NUM
GROUP BY MENU.MENU_URL;


select * from menu;
update menu set menu_url='/' where menu_num = 1;

SELECT
    MENU.MENU_URL ||
    CASE WHEN (SUBSTR(MENU.MENU_URL, -1)) != '/' 
    THEN '/' END || '**' AS MENU_URL,
    LISTAGG(AUTH.AUTHORITY_NM, ',') AS AUTHORITY_NMS
FROM AUTHORITY AUTH
LEFT JOIN AUTHORITY_MENU AM ON AM.AUTHORITY_NUM = AUTH.AUTHORITY_NUM
LEFT JOIN MENU ON MENU.MENU_NUM = AM.MENU_NUM
GROUP BY MENU.MENU_PRIORITU, MENU.MENU_URL
ORDER BY REGEXP_COUNT(MENU.MENU_URL, '/') DESC, MENU.MENU_PRIORITU DESC;

SELECT
    *
FROM MENU
WHERE
    MENU_NUM IN (SELECT
                    AM.MENU_NUM
                FROM AUTHORITY_MENU AM
                INNER JOIN MEMBER_AUTHORITY MA ON MA.MEM_SEQ = 7
                WHERE
                    AM.AUTHORITY_NUM = ma.authority_num
                )
    AND MENU_SHOW = 'Y';

select * from member_company;
select * from authority;
select * from authority_menu;