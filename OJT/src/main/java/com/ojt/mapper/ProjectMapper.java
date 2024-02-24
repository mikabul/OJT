package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;

public interface ProjectMapper {

	// 프로젝트 리스트
	// 프로젝트 명, 고객사, 날짜(시작일 또는 종료일), 첫(두) 번째날짜(혹은 둘다), 시작 끝 인덱스를 매개변수로 사용
	@Select("select * from ( "
			+ "select prj_seq, prj_nm, cust_nm, "
			+ "to_char(prj_st_dt,'yyyy.mm.dd') as prj_st_dt, to_char(prj_ed_dt, 'yyyy.mm.dd') as prj_ed_dt, "
			+ "row_number() over (order by prj_seq desc) as rn "
			+ "from project_info "
			+ "left join customer cust on cust.cust_seq = project_info.cust_seq "
			+ "where prj_nm like #{prj_nm} and cust_nm like #{cust_nm} "
			+ "and ${prj_dt_type} between to_date(#{firstDate}) and to_date(#{secondDate})) "
			+ "where rn between #{startIndex} and #{endIndex}")
	public ArrayList<ProjectBean> getProjectInfoList(@Param("prj_nm") String prj_nm, @Param("cust_nm") String cust_nm,
													@Param("prj_dt_type") String prj_dt_type, @Param("firstDate") String firstDate,
													@Param("secondDate") String secondDate, @Param("startIndex") int startIndex, @Param("endIndex") int endIndex);
	
	// 프로젝트 별 필요기술 리스트
	@Select("select dtl_cd_nm from code_detail, "
			+ "(select sk_cd from project_sk "
			+ "where project_sk.prj_seq = #{prj_seq}) "
			+ "where code_detail.dtl_cd = sk_cd and mst_cd = 'SK01'")
	public ArrayList<String> getProjectSKList(int prj_seq);
	
	// 고객사 검색 리스트
	@Select("select cust_seq, cust_nm from customer where cust_nm like #{cusr_nm}")
	public ArrayList<CustomerBean> getCustomerList(String cust_nm);
	
	// 프로젝트 검색 시 최개 갯수
	// 페이징 처리를 위해 검색시 최대 갯수를 조회
	@Select("select count(*) from ( "
			+ "select prj_seq, prj_nm, cust_nm, "
			+ "to_char(prj_st_dt,'yyyy.mm.dd') as prj_st_dt, to_char(prj_ed_dt, 'yyyy.mm.dd') as prj_ed_dt, "
			+ "row_number() over (order by prj_seq desc) as rn "
			+ "from project_info "
			+ "left join customer cust on cust.cust_seq = project_info.cust_seq "
			+ "where prj_nm like #{arg0} and cust_nm like #{arg1} "
			+ "and ${arg2} between to_date(#{arg3}) and to_date(#{arg4}))")
	
	public int getMaxSearchCount(String prj_nm, String cust_nm, String prj_dt_type, String firstDate, String secondDate);
}
