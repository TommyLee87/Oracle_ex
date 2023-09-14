DESC EMP;
DESC DEPT;
DESC BONUS;
DESC SALGRADE;
----------------------------------------------------------------------------
-- 기본 SELECT *(열을 의미) FROM EMP(테이블 이름);(세미콜론으로 끝남)
SELECT * FROM EMP;
-- EMP 테이블에서 사원 번호, 이름, 부서 번호 조회
SELECT EMPNO, ENAME, DEPTNO
FROM EMP;
-- SQL문 작성 시 유의사항
-- SQL문은 대소문자를 구분하지 않음
-- SQL문장은 한줄 또는 여러 줄에 입력 될 수 있음
-- 일반 적으로 키워드는 대문자로 입력한다.
-- 일반적으로 이름, 열 이름 등은 소문자로 작성한다.
-- SQL문의 마지막 절은 ;으로 끝난다.
-- 사원 번호와 부서 번호만 나오도롣 EMP 테이블 조회
SELECT EMPNO,DEPTNO FROM EMP;
-- 별칭 설정하기 : AS, 열 이름 또는 컬럼을 별칭으로 표시 할 수 있음
SELECT ENAME AS 이름, SAL AS 급여, SAL*12+COMM AS 연봉, COMM AS 성과급 FROM EMP;

-- 중복 제거하기 : DISTINCT, 데이터를 조회할 때 값이 중복되는 행이 여러개 조회되는 경우, 값이 중복된 행을 한개씩만 선택하고자 하는 경우
SELECT DISTINCT JOB, DEPTNO FROM EMP;
-- 컬럼 값을 계산하는 산술 연산자 : +, -, *, /
SELECT ENAME, SAL, SAL - 12
FROM EMP;
-- WHERE 구문 : 사용자가 원하는 조건에 맞는 데이터만 조회할 때 사용
-- 여러 연산자와 함께 사용 함.
SELECT * FROM EMP
WHERE DEPTNO = 10;  -- 데이터 베이스에서는 = 는 '같다'라는 의미

SELECT * FROM EMP
WHERE EMPNO = 7369;
-- 급여가 2500 초과인 사원번호, 이름, 직무,급여
SELECT EMPNO, ENAME, JOB, SAL 
FROM EMP
WHERE SAL > 2500;

SELECT *
FROM EMP
WHERE SAL * 12 = 36000;

-- 성과급이 500 초과인 사원 출력
SELECT *
FROM EMP
WHERE COMM > 500;

-- 입사일이 81년01월01일 이전인 데이터 조회
-- 날짜를 비교할 경우 날짜 형식에 맞춰서 비교
SELECT * FROM EMP
WHERE HIREDATE < '81/01/01';
-- 같지 않음을 표현하는 방법은 여러가지 <>, !=, ^=, NOT
SELECT * FROM EMP
WHERE NOT DEPTNO = 30;

-- 급여가 3000 이상, 부서가 20번인 사원 조회(2가지 조건 모두 만족)
SELECT *
FROM EMP
WHERE SAL >= 3000 AND DEPTNO = 20;
-- 급여가 3000 이상, 부서가 20번, 입사일이 82년 1월 1일 이전인 사원조회

SELECT *
FROM EMP
WHERE SAL >= 3000 AND DEPTNO = 20 AND HIREDATE < '82/01/01';

-- 급여가 3000 이상이고 부서가 20번이거나 입사일이 입사일이 82년 1월 1일 이전인 사원조회
SELECT *
FROM EMP
WHERE SAL >= 3000 AND(DEPTNO = 20 OR HIREDATE < '82/01/01');

-- 급여가 2500 이상이고 직업이 MANAGER인 사원 정보만 출력
SELECT *
FROM EMP
WHERE SAL >= 2500 AND JOB = 'MANAGER';

-- IN 연산자 : 
SELECT *
FROM EMP
WHERE JOB = 'MANAGER'
    OR JOB = 'SALESMAN'
    OR JOB = 'CLERK';
 
SELECT *
FROM EMP
WHERE JOB IN('MANAGER','SALESMAN','CLERK');

SELECT *
FROM EMP
WHERE DEPTNO NOT IN(20,30);

-- BETWEEN A AND B : 일정한 범위를 조회 할 때 사용하는 연산자
-- 급여가 2500 이상 3000 이하인 사원 조회
SELECT *
FROM EMP
WHERE SAL >= 2000 AND SAL <= 3000;

SELECT *
FROM EMP
WHERE SAL NOT BETWEEN 2000 AND 3000;

-- 사원번호가 7689 ~ 9702 사이인 사원
SELECT *
FROM EMP
WHERE EMPNO BETWEEN 7689 AND 9702;

-- 1980년에 입사 하지 않은 사원 조회

SELECT *
FROM EMP
WHERE NOT HIREDATE BETWEEN '1980/01/01' AND '1980/12/31';

-- LIKE, NOT LIKE 연산자 : 일부 문자열이 포함되어 있는지 확인하는 연산자, 주로 검색할 때 사용
-- % : 길이와 상관없이 모든 문자를 의미
-- _ : 문자 1자를 의미
SELECT EMPNO, ENAME
FROM EMP
WHERE ENAME LIKE '%K%';


SELECT *
FROM EMP
WHERE ENAME LIKE '_L%';
-- 사원 이름에 AM이 포함되어 있는 사원데이터 출력
SELECT *
FROM EMP
WHERE ENAME LIKE '%AM%';
-- 사원 이름에 AM이 포함되어 있지 않은 사원데이터 출력
SELECT *
FROM EMP
WHERE ENAME NOT LIKE '%AM%';

-- NULL : 미확정 또는 알 수 없는 값을 의미. 연산, 비교, 할당이 불가(-, IN)
SELECT ENAME, SAL * 12 + COMM AS 연봉, COMM
FROM EMP;

SELECT *
FROM EMP
WHERE COMM = NULL;  -- 연산 불가

-- IS NULL
SELECT *
FROM EMP
WHERE COMM IS NULL;  -- NULL 여부를 확인 할 때 사용하는 연산자

-- MANAGER가 있는 사원만 조회
SELECT *
FROM EMP
WHERE MGR IS NOT NULL;





