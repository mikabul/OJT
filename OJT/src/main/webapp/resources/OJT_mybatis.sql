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














