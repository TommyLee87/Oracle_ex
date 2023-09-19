-- FROM 절에 사용하는 서브쿼리 : 인라인뷰
-- FROM 절에 직접 테이블을 명시하여 사용하기에는 테이블 내 데이터 규모가 너무 큰 경우 사용하기에는
-- 보안이나 특정 목적으로 정보를 제공하는 경우
-- 10번 부서에 해당하는 테이블만 가지고 옴
SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROM (SELECT * FROM EMP WHERE DEPTNO = 10) E10
JOIN (SELECT * FROM DEPT) D
ON E10.DEPTNO = D.DEPTNO;

-- 먼저 정렬하고 해당 갯수만 가져오기
-- ROWNUM : 오라클에서 제공하는 문법으로 행 번호를 자동으로 매겨줌
-- 정렬된 결과에서 상위 3개를 뽑는 경우 테이블을 가져 올 때 아예 정렬된 상태로 가져올 수 있음
-- 일반적인 SELECT문에서는 ORDER BY 절이 가장 나중에 수행되기 때문
SELECT ROWNUM, ENAME, SAL
FROM(SELECT * FROM EMP ORDER BY SAL DESC )
WHERE ROWNUM <=3;

-- SELECT절에 사용하는 서브쿼리 : 스칼라 서브쿼리 라고도 부름(반드사 하나의 결과만 나와야함)
SELECT EMPNO, ENAME, JOB, SAL, 
(SELECT GRADE FROM SALGRADE WHERE E.SAL BETWEEN LOSAL AND HISAL) AS 급여등급,
DEPTNO, (SELECT DNAME FROM DEPT WHERE E.DEPTNO = DEPT.DEPTNO) AS DNAME
FROM EMP E;

-- 매 행마다 부서번호가 각 행의 부서번호와 동일한 사원들의 SAL 평균을 구해서 반환
SELECT ENAME, DEPTNO, SAL,
(SELECT TRUNC(AVG(SAL)) FROM EMP WHERE DEPTNO = E.DEPTNO) AS "부서별 평균급여"
FROM EMP E; 

-- 부서 위치가 NEW YORK 인 경우 본사로, 그 외 부서는 분점으로 반환
SELECT EMPNO, ENAME,
CASE WHEN DEPTNO = (SELECT DEPTNO FROM DEPT WHERE LOC = 'NEW YORK') THEN '본사'
ELSE '분점'
END 소속
FROM EMP
ORDER BY 소속;

-- 1. 전체 사원 중 ALLEN과 같은 직책(JOB)인 사원들의 사원 정보, 부서 정보를 출력
SELECT JOB, EMPNO, ENAME, SAL, DEPTNO,
(SELECT JOB FROM EMP WHERE ENAME = 'ALLEN') AS DNAME
FROM EMP
WHERE JOB = 'SALESMAN'
ORDER BY EMPNO DESC;

-- 조인과 서브쿼리 사용
SELECT JOB, EMPNO, ENAME, SAL, D.DEPTNO, DNAME
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE JOB = (SELECT JOB FROM EMP WHERE ENAME = 'ALLEN')
ORDER BY EMPNO DESC;

-- 2. 전체 사원의 평균 급여(SAL)보다 높은 급여를 받는 사원들의 사원 정보, 부서 정보, 급여 등급 정보를 출력
-- 단, 출력할 때 급여가 많은 순으로 정렬하되 급여가 같을 경우에는 사원 번호를 기준으로 오름차순으로 정렬
SELECT EMPNO, ENAME, DNAME, HIREDATE, LOC, SAL, GRADE
FROM EMP E, DEPT D, SALGRADE S
WHERE E.DEPTNO = D.DEPTNO
AND SAL BETWEEN LOSAL AND HISAL
AND SAL > (SELECT AVG(SAL) FROM EMP)
ORDER BY SAL DESC, EMPNO;

-- 조인과 서브쿼리 사용
SELECT EMPNO, ENAME, DNAME, HIREDATE, LOC, SAL, GRADE
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
JOIN SALGRADE ON SAL BETWEEN LOSAL AND HISAL
WHERE SAL > (SELECT AVG(SAL) FROM EMP)
ORDER BY SAL DESC, EMPNO;

-- 3. 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원 정보, 부서 정보를 출력
SELECT EMPNO, ENAME, JOB, D.DEPTNO, DNAME, LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.DEPTNO = 10 
AND JOB NOT IN(SELECT DISTINCT JOB FROM EMP WHERE DEPTNO = 30);

-- 4. 직책이 'SALESMAN'인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원 정보, 급여 등급 정보를 출력
-- 사원 번호를 기준으로 오름차순으로 정렬

-- 다중행 함수를 사용
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP E JOIN SALGRADE S
ON SAL BETWEEN LOSAL AND HISAL
WHERE SAL > ALL(SELECT SAL FROM EMP WHERE JOB = 'SALESMAN')
ORDER BY EMPNO;

-- 다중행 함수를 사용하지 않는 방법
SELECT EMPNO, ENAME, SAL, GRADE
FROM EMP E JOIN SALGRADE S
ON SAL BETWEEN LOSAL AND HISAL
WHERE SAL > (SELECT MAX(SAL) FROM EMP WHERE JOB = 'SALESMAN')
ORDER BY EMPNO;

-- DML (Data Manipulation Language) : 데이터를 입력(INSERT) 조회(SELECT), 변경(UPDATE), 삭제(DELETE)
-- 테이블이 아닌 데이터를 조작

-- DML을 하기 위해서 임시 테이블 생성
CREATE TABLE DEPT_TEMP      -- 테이븡 생성 명령
AS SELECT * FROM DEPT;        -- 기존의 DEPT 테이블을 복사

SELECT * FROM DEPT_TEMP;

DROP TABLE DEPT_TEMP;        -- 테이블 삭제 명령

-- 테이블에 데이터를 추가하기
INSERT INTO DEPT_TEMP(DEPTNO, DNAME, LOC)
VALUES(50, 'DATABAST', 'SEOUL');

INSERT INTO DEPT_TEMP(DEPTNO, LOC, DNAME)
VALUES(60, 'BUSAN', 'DEVELOPMENT');

INSERT INTO DEPT_TEMP(DEPTNO, LOC, DNAME)
VALUES(70, 'INCHON', NULL);

-- 2번째 방법
INSERT INTO DEPT_TEMP VALUES (80, 'FRONT-END', NULL);
INSERT INTO DEPT_TEMP VALUES (90, 'BACK-END');      -- 추가 안됨 (3개를 모두 써야함)
INSERT INTO DEPT_TEMP(DEPTNO, DNAME) VALUES (90, 'BACK-END');     -- 추가 됨(2개만 넣겠다고 명확히 표시함)

-- 테이블에 날짜 데이터 입력하기
CREATE TABLE EMP_TEMP
AS SELECT * FROM EMP
WHERE 1 != 1;      -- 테이블 복사할 때 데이터는 지우고 틀만 가져오고 싶을 때

SELECT * FROM EMP_TEMP;
-- 테이블에 날짜 데이터 입력하기
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(9001, '나영석', 'PRESIDENT', NULL, SYSDATE, 2000, 1000, 10);
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(9002, '짭영석', 'PRESIDENT', NULL, '23-SEP-23', 2000, 1000, 10);
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(9003, '안유진', 'MANAGER', 9000, TO_DATE('2023/09/23', 'YYYY/MM/DD'), 2000, 1000, 10);
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
VALUES(9004, '가을', 'MANAGER', 9000, SYSDATE, 2000, 1000, 10);

-- 서브쿼리를 이용한 INSERT
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
SELECT E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, E.DEPTNO
FROM EMP E JOIN SALGRADE S
ON E.SAL BETWEEN LOSAL AND HISAL
WHERE GRADE = 1;

-- UPDATE : 행이 정보를 변경하는 명령어
-- UPDATE : UPDATE '테이블 이름' SET '변경 할 열의 이름과 데이터' WHERE 조건식
SELECT * FROM DEPT_TEMP2;

CREATE TABLE DEPT_TEMP2
AS SELECT * FROM DEPT_TEMP;

UPDATE DEPT_TEMP2 
SET DNAME = '프론트';

UPDATE DEPT_TEMP2 
SET DNAME = '백엔드', LOC = 'GWANGJU'
WHERE DEPTNO = 30;

-- 테이블에 있는 데이터 삭제하기
CREATE TABLE EMP_TEMP2
AS SELECT * FROM EMP;

SELECT * FROM EMP_TEMP2;

-- 조건절 없이 쓰면 데이터가 다 지워짐
DELETE FROM EMP_TEMP2
WHERE JOB = 'SALESMAN';

CREATE TABLE DEPT_TCL
AS SELECT * 
FROM DEPT;

SELECT * FROM DEPT_TCL;

INSERT INTO DEPT_TCL VALUES(50, 'DATABASE','SEOUL');

COMMIT;

UPDATE DEPT_TCL
SET LOC = 'DAEGU'
WHERE DEPTNO = 30;
