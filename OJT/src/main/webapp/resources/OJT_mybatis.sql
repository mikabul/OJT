
-- 프로젝트 검색(ProjectMapper)
select * from(
select prj.prj_seq, prj.prj_nm, cust.cust_nm, prj.prj_st_dt, prj.prj_ed_dt,
dtl_cd_nm as ps_nm, row_number() over (order by prj.prj_seq desc) as rn
from project_info prj
left join code_detail cd on cd.mst_cd = 'PS01' and prj.ps_cd = cd.dtl_cd
left join customer cust on cust.cust_seq = prj.cust_seq
where prj.prj_nm like '%%'
and cust.cust_seq = 5
and to_date(prj.prj_st_dt) > to_date('2023-03-02'))
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

select mem.mem_seq, mem.mem_nm, dept.dtl_cd_nm as dept,
pos.dtl_cd_nm as position
from member_info mem
left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mem.dp_cd
left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mem.ra_cd
where mem.mem_seq not in (1, 2, 3);


select mem.mem_seq, mem.mem_nm, dept.dtl_cd_nm as dept,
pos.dtl_cd_nm as position
from member_info mem left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mem.dp_cd
left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mem.ra_cd
where mem.mem_nm like '%%'  and mem.mem_seq not in ();