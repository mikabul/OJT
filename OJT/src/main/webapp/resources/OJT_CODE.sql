insert into code_master values('DP01','�μ� �ڵ�');
insert into code_master values('RA01','���� �ڵ�');
insert into code_master values('ST01','���� ���� �ڵ�');
insert into code_master values('SK01','��� �ڵ�');
insert into code_master values('PS01','������Ʈ ���� �ڵ�');

select * from code_master;

------ �μ�
insert into code_detail values('DP01','1','����');
insert into code_detail values('DP01','2','������');
insert into code_detail values('DP01','3','�׽���');
insert into code_detail values('DP01','4','�λ�');

------- ����
insert into code_detail values('RA01','1','����');
insert into code_detail values('RA01','2','��');
insert into code_detail values('RA01','3','�̻�');
insert into code_detail values('RA01','4','����');
insert into code_detail values('RA01','5','����');
insert into code_detail values('RA01','6','����');
insert into code_detail values('RA01','7','�븮');
insert into code_detail values('RA01','8','���');

------- ���� ����
insert into code_detail values('ST01','1','����');
insert into code_detail values('ST01','2','����');
insert into code_detail values('ST01','3','����');

------- ���
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

------- ������Ʈ ����
insert into code_detail values('PS01','1','���� ����');
insert into code_detail values('PS01','2','���� ��');
insert into code_detail values('PS01','3','��������');
insert into code_detail values('PS01','4','�Ϸ�');

select * from code_detail;

COMMIT;