select * from member_info;

select mem_id, mem_pw from member_info where mem_id='hong12';

select * from project_info;

select * from (
select prj_seq, prj_nm, cust_nm,
to_char(prj_st_dt,'yyyy.mm.dd') as prj_st_dt, to_char(prj_ed_dt, 'yyyy.mm.dd') as prj_ed_dt, listAgg(dtl_cd_nm) as dtl_ed_dt,
row_number() over (order by prj_seq desc) as rn
from project_info
left join customer on customer.cust_seq = project_info.cust_seq
left join code_detail cd on cd.dtl_cd in (select project_sk.sk_cd from project_sk where project_sk.prj_seq = project_info.prj_seq)
where cd.mst_cd = 'SK01'
group by prj_seq, prj_nm, cust_nm, prj_st_dt, prj_ed_dt)
where rn BETWEEN 1 and 3;

select * from (
select prj_seq, prj_nm, cust_nm,
to_char(prj_st_dt,'yyyy.mm.dd') as prj_st_dt, to_char(prj_ed_dt, 'yyyy.mm.dd') as prj_ed_dt,
row_number() over (order by prj_seq desc) as rn
from project_info
left join customer cust on cust.cust_seq = project_info.cust_seq)
where rn between 1 and 3;

select * from code_detail;
select * from project_sk;

select dtl_cd_nm from code_detail,
(select sk_cd from project_sk
where project_sk.prj_seq = 1)
where code_detail.dtl_cd = sk_cd and mst_cd = 'SK01';

select cust_seq, cust_nm from customer where cust_nm like '%%';

-- 사이 날짜
select * from (
select prj_seq, prj_nm, cust_nm,
to_char(prj_st_dt,'yyyy.mm.dd') as prj_st_dt, to_char(prj_ed_dt, 'yyyy.mm.dd') as prj_ed_dt,
row_number() over (order by prj_seq desc) as rn
from project_info
left join customer cust on cust.cust_seq = project_info.cust_seq
where prj_nm like '%%' and cust_nm like '%%'
and prj_st_dt between to_date('2000-01-01') and to_date('9999-12-31'))
where rn between 1 and 5;

select count(*) from (
select prj_seq, prj_nm, cust_nm,
to_char(prj_st_dt,'yyyy.mm.dd') as prj_st_dt, to_char(prj_ed_dt, 'yyyy.mm.dd') as prj_ed_dt,
row_number() over (order by prj_seq desc) as rn
from project_info
left join customer cust on cust.cust_seq = project_info.cust_seq
where prj_nm like '%%' and cust_nm like '%%'
and prj_st_dt between to_date('2000-01-01') and to_date('9999-12-31'))
where rn between 1 and 5;

select * from member_info;
select * from project_member_table;


select *from 
(select mi.mem_seq, mi.mem_nm, to_char(mi.mem_hire_date, 'yyyy.mm.dd') as mem_hire_date,
pmt.st_dt, pmt.ed_dt, row_number() over (order by mi.mem_seq) as rn,
dept.dtl_cd_nm as prj_dept, position.dtl_cd_nm as prj_position, role.dtl_cd_nm as prj_role
from member_info mi
left join project_member_table pmt on pmt.prj_seq = 1
left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mi.dp_cd
left join code_detail position on position.mst_cd = 'RA01' and position.dtl_cd = mi.ra_cd
left join code_detail role on role.mst_cd = 'RO01' and role.dtl_cd = pmt.ro_cd
where mi.mem_seq = pmt.mem_seq and mi.mem_nm || mi.mem_seq like '%%'
and role.dtl_cd_nm like '%%'
and pmt.st_dt between to_date('2000-01-01') and to_date('9999-12-31'))
where rn between 1 and 5;

select dtl_cd_nm
from code_detail cd
inner join member_sk ms on ms.mem_seq = 1
where cd.mst_cd = 'SK01' and cd.dtl_cd = ms.sk_cd;


select * from (
select prj.prj_seq, prj.prj_nm, cust.cust_nm, prj.prj_st_dt, prj.prj_ed_dt, 
dtl_cd_nm, row_number() over(order by prj.prj_seq) as rn
from project_info prj
left join code_detail cd on cd.mst_cd = 'PS01' and cd.dtl_cd = prj.ed_cd
inner join customer cust on cust.cust_seq = prj.prj_seq
where
prj.prj_nm like '%%'
and cust.cust_seq=2
and prj.prj_st_dt between '20000101' and '99991231')
where rn between 1 and 5;







