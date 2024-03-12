package com.ojt.mapper;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.ojt.bean.CodeBean;
import com.ojt.bean.CustomerBean;
import com.ojt.bean.MemberBean;
import com.ojt.bean.ProjectBean;
import com.ojt.bean.ProjectMemberBean;

public interface ProjectMapper {

	//=============== 프로젝트 ==============
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
	public int searchProjectListMaxCount(@Param("prj_nm") String prj_nm,
															@Param("optionalQuery") String optionalQuery);
	
	// select2의 데이터 리스트
	// 고객사 번호, 이름
	@Select("select * from customer where cust_nm like #{customer}")
	public ArrayList<CustomerBean> getCustomerList(String customer);
	
	// 프로젝트 등록
	@Insert("insert into project_info values(PROJECT_SEQUENCE.nextval, #{prj_nm}, "
			+ "#{cust_seq}, #{prj_st_dt}, #{prj_ed_dt}, #{prj_dtl}, #{ps_cd})")
	public void insertProject(ProjectBean insertProjectBean);
	
	// 프로젝트 상태 수정
	@Update("update project_info set ps_cd = #{ps_cd} where prj_seq = #{prj_seq}")
	public void updateProjectState(ProjectBean updateProjectBean);
	
	// 프로젝트 수정
	@Update("update project_info set prj_nm = #{prj_nm}, cust_seq = #{cust_seq}, prj_st_dt = #{prj_st_dt}, "
			+ "prj_ed_dt = #{prj_ed_dt}, prj_dtl = #{prj_dtl}, ps_cd = #{ps_cd} "
			+ "where prj_seq = #{prj_seq}")
	public void updateProject(ProjectBean updateProjectBean);
	
	// 프로젝트 삭제
	@Delete("delete project_info where prj_seq = #{prj_seq}")
	public void deleteProject(int prj_seq);
	
	//========== 프로젝트 필요 기술 ===========
	// 프로젝트 필요기술 조회
	@Select("select dtl_cd_nm from code_detail "
			+ "where mst_cd = 'SK01' and dtl_cd = #{sk_cd}")
	public String[] getProjectSKList(String sk_cd);
	
	// 프로젝트 필요기술 등록
	@Insert("insert into project_sk values(#{prj_seq}, #{sk_cd})")
	public void insertProjectSK(@Param("prj_seq") int prj_seq, @Param("sk_cd") String sk_cd);
	
	// 프로젝트 필요기술 삭제
	@Delete("delete project_sk where prj_seq = #{prj_seq}")
	public void deleteProjectSK(int prj_seq);
	
	//============== 프로젝트 멤버 ====================
	// 프로젝트 멤버 조회
	@Select("select pm.mem_seq, mem.mem_nm, pm.st_dt, pm.ed_dt, "
			+ "dept.dtl_cd_nm as dept, pos.dtl_cd_nm as position, ro.dtl_cd_nm as role "
			+ "from project_member_table pm "
			+ "inner join member_info mem on mem.mem_seq = pm.mem_seq "
			+ "inner join code_detail pos on pos.dtl_cd = mem.ra_cd and pos.mst_cd = 'RA01' "
			+ "inner join code_detail ro on ro.dtl_cd = pm.ro_cd and ro.mst_cd = 'RO01' "
			+ "left join code_detail dept on dept.dtl_cd = mem.dp_cd and dept.mst_cd = 'DP01' "
			+ "where pm.prj_seq = #{prj_seq}")
	public ArrayList<ProjectMemberBean> getProjectMemberList(int prj_seq);
	
	// 프로젝트 멤버 인원 등록 조회
	@Select("select mem.mem_seq, mem.mem_nm, dept.dtl_cd_nm as dept, "
			+ "pos.dtl_cd_nm as position "
			+ "from member_info mem "
			+ "left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mem.dp_cd "
			+ "left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mem.ra_cd "
			+ "where mem.mem_seq not in (select pm.mem_seq from project_member_table pm  "
			+ "where pm.prj_seq = #{prj_seq}) "
			+ "and mem.mem_nm like #{mem_nm}")
	public ArrayList<MemberBean> searchNotProjectMember(@Param("prj_seq") int prj_seq, @Param("mem_nm") String mem_nm);
	
	// 신규 프로젝트 멤버 인원 등록 조회
	@Select("select mem.mem_seq, mem.mem_nm, dept.dtl_cd_nm as dept, "
			+ "pos.dtl_cd_nm as position "
			+ "from member_info mem "
			+ "left join code_detail dept on dept.mst_cd = 'DP01' and dept.dtl_cd = mem.dp_cd "
			+ "left join code_detail pos on pos.mst_cd = 'RA01' and pos.dtl_cd = mem.ra_cd "
			+ "where mem.mem_nm like #{str} ${optionalQuery} "
			+ "order by mem.mem_seq")
	public ArrayList<MemberBean> getNotAddProjectMember(@Param("str") String str, 
														@Param("optionalQuery") String optionalQuery);
	
	// 프로젝트 멤버 등록
	@Insert("insert into project_member_table values(#{prj_seq}, #{mem_seq}, #{st_dt}, #{ed_dt}, #{ro_cd})")
	public void insertProjectMember(ProjectMemberBean insertProjectMemberBean);
	
	// 프로젝트 멤버 수정
	@Update("update project_member_table set st_dt = #{st_dt}, ed_dt = #{ed_dt}, ro_cd = #{ro_cd} "
			+ "where prj_seq = #{prj_seq} and mem_seq = #{mem_seq}")
	public void updateProjectMember(ProjectMemberBean updateProjectMemberBean);
	
	// 프로젝트 멤버 삭제
	@Delete("delete project_member_table where prj_seq = #{prj_seq} and mem_seq = #{mem_seq}")
	public void deleteProjectMember(ProjectMemberBean deleteProjectMemberBean);
	
	// 프로젝트 역할 리스트
	@Select("select * from code_detail where mst_cd = 'RO01'")
	public ArrayList<CodeBean> getRole();
}
