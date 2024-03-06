package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.ojt.bean.CustomerBean;
import com.ojt.bean.ProjectBean;

public interface ProjectMapper {

	// 프로젝트 검색
	// 프로젝트 번호, 프로젝트 이름, 고객사 이름, 시작일, 종료일, 프로젝트 상태
	// 'optionalQuery'는 ProjectService에서 쿼리를 작성한 것
	@Select("select * from( "
			+ "select prj.prj_seq, prj.prj_nm, cust.cust_nm, prj.prj_st_dt, prj.prj_ed_dt, "
			+ "dtl_cd_nm as ps_nm, row_number() over (order by prj.prj_seq desc) as rn "
			+ "from project_info prj "
			+ "left join code_detail cd on cd.mst_cd = 'PS01' and prj.ps_cd = cd.dtl_cd "
			+ "left join customer cust on cust.cust_seq = prj.cust_seq "
			+ "where prj.prj_nm like #{prj_nm} "
			+ "${optionalQuery} ) "
			+ "where rn between #{index} and #{endIndex}")
	public ArrayList<ProjectBean> searchProjectList(@Param("prj_nm") String prj_nm,
													@Param("optionalQuery") String optionalQuery,
													@Param("index") int index,
													@Param("endIndex") int endIndex);
	
	// 프로젝트 검색 - 페이징 처리
	// 같은 조건으로 검색시의 최대 개수
	@Select("select count(prj.prj_seq) "
			+ "from project_info prj "
			+ "left join code_detail cd on cd.mst_cd = 'PS01' and prj.ps_cd = cd.dtl_cd "
			+ "left join customer cust on cust.cust_seq = prj.cust_seq "
			+ "where prj.prj_nm like #{prj_nm} ${optionalQuery}")
	public ArrayList<ProjectBean> searchProjectListMaxCount(@Param("prj_nm") String prj_nm,
													@Param("optionalQuery") String optionalQuery);
	
	// '/project/main' 고객사 검색
	// select2의 데이터 리스트
	// 고객사 번호, 이름
	@Select("select * from customer where cust_nm like #{cust_nm}")
	public ArrayList<CustomerBean> getCustomerList(@Param("cust_nm") String cust_nm);
	
}
