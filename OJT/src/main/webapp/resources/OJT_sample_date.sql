
------ 사원 샘플 데이터
insert into member_info values(member_sequence.nextval, '홍길동', '891030-1234567', '02-123-1234', '010-1293-1211', 'hong12@member.com', '', '1', '서울시 금청구 가산로 122', 'hong12', '12345', 'testpic1.jpg', '1', to_date('2010.03.01'), '');
insert into member_info values(member_sequence.nextval, '아자아자', '900712-2133333', '', '010-9383-1231', 'ajaja31@naver.com', '2', '4', '서울시 금천구 가산로 123', 'ajaja31', 'aja!123', 'testpic2.jpg', '1', to_date('2013.10.12'), '');
insert into member_info values(member_sequence.nextval, '고래', '901024-1317821', '', '010-2901-1022', 'goreee89@gmail.com', '3', '7', '서울시 금천구 가산로 124', 'goreee', 'go123^^', 'testpic3.jpg', '3', to_date('2013.11.26'), to_date('2018.09.30'));
insert into member_info values(member_sequence.nextval, '토끼', '890101-2444131', '02-879-1234', '010-8797-6793', 'rabbit78@daum.com', '1', '4', '서울시 금천구 가산로 125', 'rabbit78', 'mak28889!@', 'testpic4.jpg', '1', to_date('2017.03.07'), '');
insert into member_info values(member_sequence.nextval, '호랑이', '981213-1902123', '02-144-1859', '010-8478-1895', 'ti1213@naver.com', '4', '5', '서울시 금천구 가산로 126', 'ti1213', 'akak928!88', 'testpic5.jpg', '1', to_date('2018.10.20'), '');
insert into member_info values(member_sequence.nextval, '감자', '950730-2491901', '', '010-6593-1829', 'gamja78@naver.com', '1', '8', '서울시 금천구 가산로 127', 'gamja78', 'gam9099', 'testpic6.jpg', '1', to_date('2019.04.10'), '');
insert into member_info values(member_sequence.nextval, '굿모닝', '000506-3020131', '02-478-1234', '010-3928-1923', 'www123www@gmail.com', '2', '8', '서울시 금천구 가산로 128', 'www123www', 'abc123^^', 'testpic7.jpg', '1', to_date('2020.12.11'), '');

select * from member_info;

------ 프로젝트 샘플 데이터
insert into project_info values(PROJECT_SEQUENCE.nextval, 'POS 개발', 5, to_date('2023-11-07'), to_date('2024-06-27'), '', '2');
insert into project_info values(PROJECT_SEQUENCE.nextval, 'SK 매직 DB 업그레이드 개발', 4, to_date('2023-12-29'), to_date('2024-03-02'), '', '2');
insert into project_info values(PROJECT_SEQUENCE.nextval, '삼성전자 S/W 설계 및 개발', 3, to_date('2024-01-11'), to_date('2024-04-27'), 'TEST', '2');
insert into project_info values(PROJECT_SEQUENCE.nextval, '현대 자동차 데이터베이스 이관', 1, to_date('2024-02-25'), to_date('2024-05-25'), '', '1');
insert into project_info values(PROJECT_SEQUENCE.nextval, '농협은행 S/W 개발', 2, to_date('2024-03-01'), to_date('2024-06-01'), '', '1');

select * from project_info;

------ 고객사
insert into customer values( CUSTOMER_SEQUNCE.nextval, '현대자동차');
insert into customer values( CUSTOMER_SEQUNCE.nextval, '농협');
insert into customer values( CUSTOMER_SEQUNCE.nextval, '삼성 전자');
insert into customer values( CUSTOMER_SEQUNCE.nextval, 'SK매직');
insert into customer values( CUSTOMER_SEQUNCE.nextval, '아모레퍼시픽');

select * from customer;

------ 사원 보유 기술 샘플 데이터
insert into member_sk values(1, '1');
insert into member_sk values(1, '3');
insert into member_sk values(1, '4');
insert into member_sk values(1, '7');
insert into member_sk values(1, '8');
insert into member_sk values(2, '1');
insert into member_sk values(2, '5');
insert into member_sk values(2, '6');
insert into member_sk values(3, '1');
insert into member_sk values(3, '8');
insert into member_sk values(3, '10');
insert into member_sk values(4, '1');
insert into member_sk values(4, '3');
insert into member_sk values(4, '4');
insert into member_sk values(4, '9');
insert into member_sk values(5, '1');
insert into member_sk values(5, '2');
insert into member_sk values(6, '1');
insert into member_sk values(6, '2');
insert into member_sk values(6, '7');
insert into member_sk values(6, '10');
insert into member_sk values(7, '1');
insert into member_sk values(7, '2');
insert into member_sk values(7, '3');
insert into member_sk values(7, '4');
insert into member_sk values(7, '8');

select * from member_sk;

------- 프로젝트 필요 기술 샘플 데이터
insert into project_sk values(1, '1');
insert into project_sk values(1, '2');
insert into project_sk values(1, '3');
insert into project_sk values(1, '5');
insert into project_sk values(1, '8');
insert into project_sk values(2, '1');
insert into project_sk values(2, '2');
insert into project_sk values(2, '3');
insert into project_sk values(2, '4');
insert into project_sk values(2, '7');
insert into project_sk values(3, '1');
insert into project_sk values(3, '2');
insert into project_sk values(3, '5');
insert into project_sk values(3, '8');
insert into project_sk values(3, '10');
insert into project_sk values(4, '1');
insert into project_sk values(4, '2');
insert into project_sk values(4, '8');
insert into project_sk values(5, '1');
insert into project_sk values(5, '2');
insert into project_sk values(5, '3');
insert into project_sk values(5, '6');
insert into project_sk values(5, '8');
insert into project_sk values(5, '9');
insert into project_sk values(5, '10');

select * from project_sk;

------ 프로젝트 - 멤버 샘플 데이터
insert into project_member_table values(1, 1, to_date('2023-11-07'), to_date('2024-06-27'));
insert into project_member_table values(1, 2, to_date('2023-11-07'), to_date('2024-06-27'));
insert into project_member_table values(2, 4, to_date('2023-12-29'), to_date('2024-03-02'));
insert into project_member_table values(2, 7, to_date('2023-12-29'), to_date('2024-03-02'));
insert into project_member_table values(3, 3, to_date('2024-01-11'), to_date('2024-04-27'));
insert into project_member_table values(3, 5, to_date('2024-01-11'), to_date('2024-04-27'));
insert into project_member_table values(4, 6, to_date('2024-02-25'), to_date('2024-05-25'));
insert into project_member_table values(5, 7, to_date('2024-03-01'), to_date('2024-06-01'));

select * from project_member_table;

commit;


