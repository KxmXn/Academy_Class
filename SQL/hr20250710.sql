SELECT    FIRST_NAME, LAST_NAME, HIRE_DATE, EMAIL, LOWER(JOB_ID)
 FROM     EMPLOYEES 
 WHERE    lower(JOB_ID) = 'it_prog'
 ;
 
---- SHIPPING 부서의 직원명단
-- 1) 부서명 SHIPPING 의 부서번호 : 50
SELECT    department_id
 FROM     DEPARTMENTS
 WHERE    UPPER(DEPARTMENT_NAME) = 'SHIPPING';

-- 2) 50번 부서의 직원 명단
SELECT    FIRST_NAME, LAST_NAME, HIRE_DATE
 FROM     EMPLOYEES
 WHERE    DEPARTMENT_ID = 50;
 
---- SHIPPING 부서의 직원명단 1) + 2)
-- SQL 문 안에 SQL 믄이들어있으면  SUBQUERY
-- 반드시 () 안에서 표시된다
-- 두번물어봐야할때

SELECT    FIRST_NAME, LAST_NAME, HIRE_DATE
 FROM     EMPLOYEES
 WHERE    DEPARTMENT_ID = (   
    SELECT    department_id
     FROM     DEPARTMENTS
     WHERE    UPPER(DEPARTMENT_NAME) = 'SHIPPING' 
 ) ;
 
 -----------------------------------
 -- JOIN : 여러개의 다른 테이블에 있는 칼럼들의 가지고 와서 새로운 테이블을 만든다

직원이름,  부서명  -- 출력줄수 : 109줄

-- ORACLE OLD 문법 
1) 카티션 프로덕트 == CROSS JOIN, 조건이 없는 
SELECT    FIRST_NAME, LAST_NAME,  DEPARTMENT_NAME 
 FROM     EMPLOYEES,  DEPARTMENTS   -- 2943 : 109 * 27

SELECT    109 * 27  FROM DUAL; 


2) INNER JOIN - 양쪽다 존재하는 데이터, 조건필수
SELECT    FIRST_NAME, LAST_NAME,  DEPARTMENT_NAME
 FROM     EMPLOYEES,  DEPARTMENTS
 WHERE    DEPARTMENT_ID = DEPARTMENT_ID;   -- 에러 ORA-00918: 열의 정의가 애매합니다
 
SELECT    EMPLOYEES.EMPLOYEE_ID,  EMPLOYEES.FIRST_NAME, EMPLOYEES.LAST_NAME,  DEPARTMENTS.DEPARTMENT_NAME
 FROM     EMPLOYEES,  DEPARTMENTS
 WHERE    EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID;   
   -- 106 : -3명(DEPARTMENT_ID 가 NULL)
 
 SELECT   e.employee_id, E.FIRST_NAME, e.last_name, d.department_name
  FROM    EMPLOYEES  E,  DEPARTMENTS D
  WHERE   E.DEPARTMENT_ID  = D.DEPARTMENT_ID;  -- 106
 
3) OUTER JOIN
부서명, 부서직원이름 
-- 모든 부서명 출력 : DEPARTMENTS 부서정보 27개 부서
-- 직원정보는 해당부서의 직원이 있으면 부서이름, 명단출력
--                       직원이 없으면 부서이름, '직원없음'
--   (+) : 자료가없는(NULL) 쪽에 붙인다

SELECT   d.department_name                      부서명,           
         e.first_name ||  ' ' || e.last_name    부서직원이름 
 FROM    DEPARTMENTS  D,   EMPLOYEES   E
 WHERE   D.DEPARTMENT_ID  =  E.DEPARTMENT_ID(+);  
    -- 122 : 106 ( 11개부서 ) - 직원이 근무하는 부서
    --       + 16 (27-11)      직원이 근무하지 않는 부서          
 
 -- LEFT OUTER JOIN : 기준이 왼쪽이다 (+0 가 없는 쪽이다
 --                   기준칼럼은 모두 출력하고 반쪽은 있으면 DATA 없으면 NULL 이다.
SELECT   D.DEPARTMENT_NAME                                                    부서명,           
         DECODE (E.FIRST_NAME || ' ' || E.LAST_NAME, ' ' , 
                            '직원없음',
                             E.FIRST_NAME || ' ' || E.LAST_NAME )       부서직원이름 
 FROM    DEPARTMENTS  D,   EMPLOYEES   E
 WHERE   D.DEPARTMENT_ID  =  E.DEPARTMENT_ID(+);  
    -- 122 : 106 ( 11개부서 ) - 직원이 근무하는 부서
    --       + 16 (27-11)      직원이 근무하지 않는 부서          
                  
 -- RIGHT OUTER JOIN : 이겨우의 결과는  위와 동일하다 (조건만 위치를 변경했다)
 SELECT   D.DEPARTMENT_NAME                                                    부서명,           
         DECODE (E.FIRST_NAME || ' ' || E.LAST_NAME, ' ' , 
                            '직원없음',
                             E.FIRST_NAME || ' ' || E.LAST_NAME )       부서직원이름 
 FROM    DEPARTMENTS  D,   EMPLOYEES   E
 WHERE   E.DEPARTMENT_ID(+) =  D.DEPARTMENT_ID ;  
    -- 122 : 106 ( 11개부서 ) - 직원이 근무하는 부서
    --       + 16 (27-11)      직원이 근무하지 않는 부서  
 
 
 -- RIGHT OUTER JOIN
 SELECT   D.DEPARTMENT_NAME                                                    부서명,           
         DECODE (E.FIRST_NAME || ' ' || E.LAST_NAME, ' ' , 
                            '직원없음',
                             E.FIRST_NAME || ' ' || E.LAST_NAME )       부서직원이름 
 FROM    DEPARTMENTS  D,   EMPLOYEES   E
 WHERE   D.DEPARTMENT_ID(+)  =  E.DEPARTMENT_ID;  -- 109 
 
 -- FULL OUTER JOIN 문법이 없다
 
 ------------------------------------------------------------
 1) CROSS JOIN
 SELECT    FIRST_NAME, LAST_NAME,  DEPARTMENT_NAME 
  FROM     EMPLOYEES CROSS JOIN  DEPARTMENTS;   -- 2943 : 109 * 2
 
 2) (INNER) JOIN
 SELECT   EMPLOYEE_ID, FIRST_NAME, LAST_NAME,  DEPARTMENT_NAME
  FROM    EMPLOYEES E INNER JOIN  DEPARTMENTS D  ON E.DEPARTMENT_ID = D.DEPARTMENT_ID ;

3) LEFT ( OUTER ) JOIN 
 SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
  FROM    EMPLOYEES E LEFT OUTER JOIN DEPARTMENTS D
          ON   E.DEPARTMENT_ID =  D.DEPARTMENT_ID ;   -- 109
 
4) RIGHT ( OUTER ) JOIN 
 SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
  FROM    EMPLOYEES E RIGHT JOIN DEPARTMENTS D
          ON   E.DEPARTMENT_ID =  D.DEPARTMENT_ID ;   -- 122
 
 
 5) FULL (OUTER) JOIN
  SELECT   FIRST_NAME, LAST_NAME, DEPARTMENT_NAME
  FROM    EMPLOYEES E FULL JOIN DEPARTMENTS D
          ON   E.DEPARTMENT_ID =  D.DEPARTMENT_ID ;  -- 125 
 
 ----------------------------------------------------------
 
 -- 직원이름, 담당업무(JOB_TITLE) 
 -- INNER JOIN : 양쪽다 존재하는 DATA
 SELECT      E.FIRST_NAME, E.LAST_NAME,   J.JOB_TITLE
  FROM       EMPLOYEES   E,  JOBS  J
  WHERE      E.JOB_ID    =   J.JOB_ID
  ORDER BY   J.JOB_TITLE ASC;   -- 109
  
 SELECT      E.FIRST_NAME,  E.LAST_NAME,  J.JOB_TITLE 
  FROM       EMPLOYEES   E  JOIN  JOBS  J
   ON        E.JOB_ID    =   J.JOB_ID
  ORDER BY  J.JOB_TITLE; 
  
 
 
 -- LEFT OUTER JOIN 
 SELECT      E.FIRST_NAME,  E.LAST_NAME, J.JOB_TITLE
  FROM       EMPLOYEES  E,  JOBS  J
  WHERE      E.JOB_ID   =   J.JOB_ID(+); -- 109
  
 SELECT     E.FIRST_NAME,  E.LAST_NAME,  J.JOB_TITLE
  FROM      EMPLOYEES  E  LEFT JOIN  JOBS  J  
   ON       E.JOB_ID   =   J.JOB_ID;  
 
 -- RIGHT OUTER JOIN 
 SELECT      E.FIRST_NAME,  E.LAST_NAME, J.JOB_TITLE
  FROM       EMPLOYEES  E,  JOBS  J
  WHERE      E.JOB_ID(+)   =   J.JOB_ID;  -- 109
  
 SELECT     E.FIRST_NAME,  E.LAST_NAME,  J.JOB_TITLE
  FROM      EMPLOYEES  E  RIGHT JOIN  JOBS  J  
   ON       E.JOB_ID   =   J.JOB_ID;  
 
 -- 부서명, 부서위치(CITY, STREE_ADDRESS)
 -- INNER JOIN
 SELECT   D.DEPARTMENT_NAME,  L.STATE_PROVINCE ,  L.CITY, L.STREET_ADDRESS
  FROM    DEPARTMENTS   D,  LOCATIONS  L 
  WHERE   D.LOCATION_ID   =  L.LOCATION_ID;
  
 SELECT   D.DEPARTMENT_NAME,  L.STATE_PROVINCE ,  L.CITY, L.STREET_ADDRESS
  FROM    DEPARTMENTS   D  JOIN  LOCATIONS  L 
   ON   D.LOCATION_ID   =  L.LOCATION_ID; 
    
  -- LEFT JOIN
  
  -- RIGHT JOIN
   
  
 -- 직원명, 부서명, 부서위치(CITY, STREE_ADDRESS)
 -- INNER JOIN
 SELECT   E.FIRST_NAME || ' ' || E.LAST_NAME   직원명, 
          D.DEPARTMENT_NAME                    부서명, 
          L.STATE_PROVINCE, 
          L.CITY, 
          L.STREET_ADDRESS
  FROM    EMPLOYEES   E,  DEPARTMENTS  D, LOCATIONS  L
  WHERE   E.DEPARTMENT_ID   =  D.DEPARTMENT_ID
   AND    D.LOCATION_ID     =  L.LOCATION_ID;  -- 106
 
 -- OUTER JOIN : 모든 직원 정보를 추력
 SELECT   E.FIRST_NAME || ' ' || E.LAST_NAME   직원명, 
          D.DEPARTMENT_NAME                    부서명, 
          L.STATE_PROVINCE, 
          L.CITY, 
          L.STREET_ADDRESS
  FROM    EMPLOYEES   E,  DEPARTMENTS  D, LOCATIONS  L
  WHERE   E.DEPARTMENT_ID   =  D.DEPARTMENT_ID(+)
   AND    D.LOCATION_ID     =  L.LOCATION_ID(+);  -- 109
   
 SELECT   E.FIRST_NAME || ' ' || E.LAST_NAME   직원명, 
          D.DEPARTMENT_NAME                    부서명, 
          L.STATE_PROVINCE, 
          L.CITY, 
          L.STREET_ADDRESS
  FROM    EMPLOYEES   E
          LEFT OUTER JOIN  DEPARTMENTS  D ON  E.DEPARTMENT_ID   =  D.DEPARTMENT_ID
          LEFT OUTER JOIN  LOCATIONS  L   ON  D.LOCATION_ID     =  L.LOCATION_ID;  -- 109
  
 -- 직원명, 부서명, 국가, 부서위치(CITY, STREE_ADDRESS) 
 -- INNER JOIN
 SELECT   D.DEPARTMENT_ID                      부서명,         
          E.FIRST_NAME || ' ' || E.LAST_NAME   직원명,
          C.COUNTRY_NAME                        국가, 
          L.STATE_PROVINCE, L.CITY, L.STREET_ADDRESS
  FROM    DEPARTMENTS  D,  EMPLOYEES E, LOCATIONS L, COUNTRIES C
  WHERE   D.DEPARTMENT_ID  =  E.DEPARTMENT_ID
   AND    D.LOCATION_ID    =  L.LOCATION_ID
   AND    L.COUNTRY_ID     =  C.COUNTRY_ID;
 
 SELECT   D.DEPARTMENT_NAME                    부서명,         
          E.FIRST_NAME || ' ' || E.LAST_NAME   직원명,
          C.COUNTRY_NAME                       국가, 
          L.STATE_PROVINCE, L.CITY, L.STREET_ADDRESS
  FROM    DEPARTMENTS  D
          JOIN   EMPLOYEES E   ON    D.DEPARTMENT_ID  =  E.DEPARTMENT_ID
          JOIN   LOCATIONS L   ON    D.LOCATION_ID    =  L.LOCATION_ID
          JOIN   COUNTRIES C   ON    L.COUNTRY_ID     =  C.COUNTRY_ID;
  
  SELECT  D.DEPARTMENT_NAME                    부서명,         
          E.FIRST_NAME || ' ' || E.LAST_NAME   직원명,
          C.COUNTRY_NAME                       국가, 
          L.STATE_PROVINCE, L.CITY, L.STREET_ADDRESS
  FROM    DEPARTMENTS  D
          LEFT   JOIN   EMPLOYEES E   ON    D.DEPARTMENT_ID  =  E.DEPARTMENT_ID
          LEFT   JOIN   LOCATIONS L   ON    D.LOCATION_ID    =  L.LOCATION_ID
          LEFT   JOIN   COUNTRIES C   ON    L.COUNTRY_ID     =  C.COUNTRY_ID;  
 
 -- 부서명 , 국가 : 모든 부서 : 27줄이상  
 SELECT   D.DEPARTMENT_NAME    부서명,  C.COUNTRY_NAME     국가
  FROM    DEPARTMENTS  D,    LOCATIONS  L,   COUNTRIES  C
  WHERE   D.LOCATION_ID   =  L.LOCATION_ID 
   AND    L.COUNTRY_ID    =  C.COUNTRY_ID;  -- 27
 
 SELECT   D.DEPARTMENT_NAME    부서명,  C.COUNTRY_NAME     국가
  FROM    DEPARTMENTS  D
          JOIN   LOCATIONS  L   ON   D.LOCATION_ID   =  L.LOCATION_ID
          JOIN   COUNTRIES  C   ON    L.COUNTRY_ID    =  C.COUNTRY_ID; 
 -- 27 
 
 -- 직원명, 부서위치 단 it 부서만
 
 ----------------------
 SELECT  DEPARTMENT_ID   FROM  EMPLOYEES;
 SELECT  DISTINCT DEPARTMENT_ID   FROM  EMPLOYEES;         -- 12
 SELECT  COUNT(DEPARTMENT_ID)   FROM  EMPLOYEES;           -- 106 NULL 제외한 갯수 
 SELECT  COUNT(DISTINCT DEPARTMENT_ID)   FROM  EMPLOYEES;  -- 11
 SELECT  COUNT(DEPARTMENT_ID)   FROM  DEPARTMENTs;         -- 27 
 
 -- 부서명별 월급평균
 --1) 부서번호, 월급평균
 SELECT      DEPARTMENT_ID, 
             ROUND( AVG(SALARY), 3)   -- 통계 부서번호별 월급평균
  FROM       EMPLOYEES
  GROUP BY   DEPARTMENT_ID
  
 --2) 부서명, 월급 평균
 -- INNER JOIN
 SELECT      D.DEPARTMENT_NAME, 
             ROUND( AVG(SALARY), 3)   -- 통계 부서번호별 월급평균
  FROM       EMPLOYEES  E, DEPARTMENTS  D
  WHERE      E.DEPARTMENT_ID  = D.DEPARTMENT_ID
  GROUP BY   D.DEPARTMENT_NAME
 
 SELECT      D.DEPARTMENT_NAME, 
             ROUND( AVG(SALARY), 3)   -- 통계 부서번호별 월급평균
  FROM       EMPLOYEES  E 
             JOIN   DEPARTMENTS  D  ON  E.DEPARTMENT_ID  = D.DEPARTMENT_ID
  GROUP BY   D.DEPARTMENT_NAME
 
 -- RIGHT OUT JOIN
  SELECT     D.DEPARTMENT_NAME, 
             ROUND( AVG(SALARY), 3)   -- 통계 부서번호별 월급평균
  FROM       EMPLOYEES  E, DEPARTMENTS  D
  WHERE      E.DEPARTMENT_ID(+)  = D.DEPARTMENT_ID
  GROUP BY   D.DEPARTMENT_NAME;
 
 SELECT      D.DEPARTMENT_NAME, 
             ROUND( AVG(SALARY), 3)   -- 통계 부서번호별 월급평균
  FROM       EMPLOYEES  E 
             RIGHT JOIN   DEPARTMENTS  D  ON  E.DEPARTMENT_ID  = D.DEPARTMENT_ID
  GROUP BY   D.DEPARTMENT_NAME
 
 -------------------------------------------------------------
 결합연산자 - 줄단위 결합
   조건     -  두테이블의 칸수와 타입이 동일해야한다  
 1)  UNION        중복 제거
 2)  UNION ALL    중복 포함
 3)  INTERSECT    교집합 : 공통부분
 4)  MINUS        차집합  A-B
 
 SELECT  * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80;   -- 34
 SELECT  * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;   -- 45
 
 SELECT  * FROM EMPLOYEES WHERE DEPARTMENT_ID = 80
 UNION ALL 
 SELECT  * FROM EMPLOYEES WHERE DEPARTMENT_ID = 50;   -- 79
 
 주의사항) 규칙만 만즈면 의미없는 데이터도 UNION 가능 -> 비추
 SELECT   EMPLOYEE_ID , FIRST_NAME  FROM  EMPLOYEES
 UNION
 SELECT   DEPARTMENT_ID, DEPARTMENT_NAME FROM DEPARTMENTS;
 
 ---------------
 직원의 근무 연수
 SELECT  FIRST_NAME  ||  ' ' || LAST_NAME                이름, 
         ROUND(SYSDATE -  HIRE_DATE, 5)                  근무일수, 
         TRUNC((SYSDATE - HIRE_DATE) / 365.2422)         근무연수,
         TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12)  근무연수
  FROM   EMPLOYEES;
 
 
 
 직원명, 담당업무, 담당업무 히스토리
 
 
 
 
 
 
 
 
 
 