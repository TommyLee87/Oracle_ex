-- 정렬을 위한 ORDER BY 절
SELECT * FROM EMP
ORDER BY SAL ASC;   -- ASC는 오름차순

-- 사원번호 기준으로 오름차순 정렬
SELECT * FROM EMP
ORDER BY SAL DESC;

-- 여러 컬럼 기준으로 정렬하기
-- 정렬 조건이 없으면 기본적으로 오름차순
-- 급여 순으로 정렬하고 급여가 같은 경우 이름순 정렬
SELECT * FROM EMP
ORDER BY SAL ASC , ENAME DESC;