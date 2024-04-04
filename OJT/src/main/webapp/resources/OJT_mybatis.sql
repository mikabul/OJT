
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
where prj.prj_seq = 203;

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
    and prj_ed_dt = '2024-04-04'
    AND maint_st_dt = ''
    and maint_ed_dt = '';

select * from project_info where prj_seq = 763;
SELECT * FROM project_info;

SELECT count(mem_seq)
FROM MEMBER_INFO
WHERE mem_seq IN (1,2,3);