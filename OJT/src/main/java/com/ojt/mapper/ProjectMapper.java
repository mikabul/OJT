package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;

public interface ProjectMapper {

	// 프로젝트 리스트
	@Select("select * from ( "
			+ "select prj.prj_seq, prj.prj_nm, cust.cust_nm, prj.prj_st_dt, prj.prj_ed_dt, "
			+ "dtl_cd_nm, row_number() over(order by prj.prj_seq) as rn "
			+ "from project_info prj "
			+ "left join code_detail cd on cd.mst_cd = 'PS01' and cd.dtl_cd = prj.ed_cd "
			+ "inner join customer cust on cust.cust_seq = prj.prj_seq "
			+ "where "
			+ "prj.prj_nm like #{prj_nm} ${optionalQuery} ) "
			+ "where rn between #{startIndex} and #{endIndex}")
	public ArrayList<ProjectBean> getProjectInfoList(@Param("prj_nm") String prj_nm, 
													@Param("optionalQuery") String optionalQuery,
													@Param("startIndex") int startIndex,
													@Param("endIndex") int endIndex);
	
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
			+ "select prj.prj_seq, prj.prj_nm, cust.cust_nm, prj.prj_st_dt, prj.prj_ed_dt, "
			+ "dtl_cd_nm, row_number() over(order by prj.prj_seq) as rn "
			+ "from project_info prj "
			+ "left join code_detail cd on cd.mst_cd = 'PS01' and cd.dtl_cd = prj.ed_cd "
			+ "inner join customer cust on cust.cust_seq = prj.prj_seq "
			+ "where "
			+ "prj.prj_nm like #{prj_nm} ${optionalQuery} ) ")
	public int getMaxSearchCount(@Param("prj_nm") String prj_nm, @Param("optionalQuery") String optionalQuery);
	
	// 프로젝트에 참여한 인원 검색 리스트
	@Select("select * from "
			+ "(select mi.mem_seq, mi.mem_nm, to_char(mi.mem_hire_date, 'yyyy.mm.dd') as mem_hire_date, "
			+ "pmt.st_dt, pmt.ed_dt, row_number() over (order by mi.mem_seq) as rn, "
			+ "dept.dtl_cd_nm as prj_dept, position.dtl_cd_nm as prj_position, role.dtl_cd_nm as prj_role "
			+ "from member_info mi "
			+ "left join project_member_table pmt on pmt.prj_seq = #{prj_seq} "
			+ "left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mi.dp_cd "
			+ "left join code_detail position on position.mst_cd = 'RA01' and position.dtl_cd = mi.ra_cd "
			+ "left join code_detail role on role.mst_cd = 'RO01' and role.dtl_cd = pmt.ro_cd "
			+ "where mi.mem_seq = pmt.mem_seq and mi.mem_nm || mi.mem_seq like #{searchWord} "
			+ "and role.dtl_cd_nm like #{prj_role} "
			+ "and pmt.${dateType} between to_date(#{firstDate}) and to_date(#{secondDate})) "
			+ "where rn between #{index} and #{endIndex}")
	public ArrayList<ProjectMemberBean> getProjectMember(@Param("prj_seq") int prj_seq,
														@Param("searchWord") String searchWord,
														@Param("prj_role") String prj_role,
														@Param("firstDate") String firstDate,
														@Param("secondDate") String secondDate,
														@Param("dateType") String dateType,
														@Param("index") int index, @Param("endIndex") int endIndex);
	
	// 프로젝트에 참여한 인원의 기술 리스트
	@Select("select dtl_cd_nm "
			+ "from code_detail cd "
			+ "inner join member_sk ms on ms.mem_seq = #{mem_seq} "
			+ "where cd.mst_cd = 'SK01' and cd.dtl_cd = ms.sk_cd")
	public ArrayList<String> getProjectMemberSKList(int mem_seq);
	
	// 프로젝트에 참여한 인원 검색 최대 갯수
		@Select("select count(*) from "
				+ "(select mi.mem_seq, mi.mem_nm, to_char(mi.mem_hire_date, 'yyyy.mm.dd') as mem_hire_date, "
				+ "pmt.st_dt, pmt.ed_dt, row_number() over (order by mi.mem_seq) as rn, "
				+ "dept.dtl_cd_nm as prj_dept, position.dtl_cd_nm as prj_position, role.dtl_cd_nm as prj_role "
				+ "from member_info mi "
				+ "left join project_member_table pmt on pmt.prj_seq = #{prj_seq} "
				+ "left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mi.dp_cd "
				+ "left join code_detail position on position.mst_cd = 'RA01' and position.dtl_cd = mi.ra_cd "
				+ "left join code_detail role on role.mst_cd = 'RO01' and role.dtl_cd = pmt.ro_cd "
				+ "where mi.mem_seq = pmt.mem_seq and mi.mem_nm || mi.mem_seq like #{searchWord} "
				+ "and role.dtl_cd_nm like #{prj_role} "
				+ "and pmt.${dateType} between to_date(#{firstDate}) and to_date(#{secondDate})) ")
		public int getProjectMemberMaxCount(@Param("prj_seq") int prj_seq,
															@Param("searchWord") String searchWord,
															@Param("prj_role") String prj_role,
															@Param("firstDate") String firstDate,
															@Param("secondDate") String secondDate,
															@Param("dateType") String dateType);
}
