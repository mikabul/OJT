insert into code_master values('DP01','부서 코드');
insert into code_master values('RA01','직급 코드');
insert into code_master values('ST01','재직 상태 코드');
insert into code_master values('SK01','기술 코드');
insert into code_master values('PS01','프로젝트 상태 코드');
insert into code_master values('RO01','역할 코드');
insert into code_master values('GD01','성별 코드');
insert into code_master values('EM01','이메일 코드');

select * from code_master;

------ 부서
insert into code_detail values('DP01','0','없음');
insert into code_detail values('DP01','1','개발');
insert into code_detail values('DP01','2','디자인');
insert into code_detail values('DP01','3','테스터');
insert into code_detail values('DP01','4','인사');

------- 직급
insert into code_detail values('RA01','1','사장');
insert into code_detail values('RA01','2','상무');
insert into code_detail values('RA01','3','이사');
insert into code_detail values('RA01','4','부장');
insert into code_detail values('RA01','5','차장');
insert into code_detail values('RA01','6','과장');
insert into code_detail values('RA01','7','대리');
insert into code_detail values('RA01','8','사원');

------- 재직 상태
insert into code_detail values('ST01','1','재직');
insert into code_detail values('ST01','2','휴직');
insert into code_detail values('ST01','3','퇴직');

------- 기술
insert into code_detail values('SK01','1','Java');
insert into code_detail values('SK01','2','HTML/CSS');
insert into code_detail values('SK01','3','Javascript');
insert into code_detail values('SK01','4','jQuery');
insert into code_detail values('SK01','5','Spring');
insert into code_detail values('SK01','6','JSP');
insert into code_detail values('SK01','7','React');
insert into code_detail values('SK01','8','SQL');
insert into code_detail values('SK01','9','Kotlin');
insert into code_detail values('SK01','10','C#');

------- 프로젝트 상태
insert into code_detail values('PS01','1','진행 예정');
insert into code_detail values('PS01','2','진행 중');
insert into code_detail values('PS01','3','유지보수');
insert into code_detail values('PS01','4','종료');
insert into code_detail values('PS01','5','중단');

------- 역할
insert into code_detail values('RO01','1','없음');
insert into code_detail values('RO01','2','PM');
insert into code_detail values('RO01','3','PL');
insert into code_detail values('RO01','4','PE');
insert into code_detail values('RO01','5','QA');

------- 성별
insert into code_detail values('GD01', '1', '남');
insert into code_detail values('GD01', '2', '여');

------- 이메일
insert into code_detail values('EM01', '0', '직접입력');
insert into code_detail values('EM01', '1', 'naver.com');
insert into code_detail values('EM01', '2', 'gmail.com');
insert into code_detail values('EM01', '3', 'daum.net');
insert into code_detail values('EM01', '4', 'hanmail.net');
insert into code_detail values('EM01', '5', 'yahoo.com');

select * from code_detail;
select * from code_detail where mst_cd='EM01';

COMMIT;