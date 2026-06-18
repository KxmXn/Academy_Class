SELECT  DEPARTMENT_ID  FROM EMPLOYEES;
SELECT  COUNT(DEPARTMENT_ID)  FROM EMPLOYEES;

SELECT     DEPARTMENT_ID,  COUNT(DEPARTMENT_ID)  
 FROM      EMPLOYEES
 GROUP BY  DEPARTMENT_ID;
 
-- 60번 부서 최소월급과 같은 월급자의 명단출력
1) 60 부서의 최소월긊
  SELECT   MIN(E.SALARY)  FROM   EMPLOYEES  E
   WHERE   E.DEPARTMENT_ID = 60 ; -- 2100
  
2) 1) 월급을 받는 사람의 이름
  SELECT  FIRST_NAME, LAST_NAME
   FROM   EMPLOYEES
   WHERE  SALARY = 4200;

3) 
  SELECT  FIRST_NAME, LAST_NAME
   FROM   EMPLOYEES
   WHERE  SALARY = (   
     SELECT   MIN(E.SALARY)  FROM   EMPLOYEES  E
       WHERE   E.DEPARTMENT_ID = (
           SELECT DEPARTMENT_ID FROM DEPARTMENTS
            WHERE DEPARTMENT_NAME = 'IT'
       )    
   );

----------------------------------------------
직원이름, 담당업무
SELECT   EMPLOYEE_ID, FIRST_NAME, LAST_NAME, HIRE_DATE, JOB_TITLE, E.JOB_ID
 FROM    EMPLOYEES  E,   JOBS  J
 WHERE   E.JOB_ID      =   J.JOB_ID;
 
-- 사번,   업무시작일,  업무종료일, 담당업무, 부서번호
SELECT    EMPLOYEE_ID, 
          TO_CHAR(START_DATE, 'YYYY-MM-DD'), 
          TO_CHAR(END_DATE, 'YYYY-MM-DD'), 
          JOB_ID, 
          DEPARTMENT_ID
 FROM     JOB_HISTORY
UNION  
SELECT    EMPLOYEE_ID, 
          TO_CHAR(HIRE_DATE,'YYYY-MM-DD'), 
          '근무중',  
          JOB_ID, 
          DEPARTMENT_ID 
 FROM     EMPLOYEES
 
 ORDER BY EMPLOYEE_ID ASC;
 
 -----------------------------------------
 0) VIEW - SQL 문을 테이블 처럼 사용하는 기술
 
 1) INLINE VIEW -- 중요 :임시존재 , 
     -- FROM 뒤에 있는 괄호는 INLINE VIEW 내부에 ORDER BY 사용가능
     -- 그외 SQUBQUERY  내부에 ORDER BY 사용 x
    SELECT * 
     FROM
    ( 
     SELECT   EMPLOYEE_ID                      사번, 
              FIRST_NAME ||  ' ' || LAST_NAME  이름,
              EMAIL || '@grren.com'            이메일,
              PHONE_NUMBER                     전회  
      FROM    EMPLOYEES 
      ORDER BY  이름
    )  T
    WHERE  T.사번 IN (100, 101, 102)
 
 
 2) VIEW 생성  -- 중요 : 영구 보관
 
  CREATE OR REPLACE  VIEW "HR"."VIEW_T" ("사번", "이름", "이메일", "전회") 
  AS 
      SELECT   EMPLOYEE_ID                      사번, 
                  FIRST_NAME ||  ' ' || LAST_NAME  이름,
                  EMAIL || '@grren.com'            이메일,
                  PHONE_NUMBER                     전회  
          FROM    EMPLOYEES;

 SELECT  * FROM VIEW_T;
 
 3) WITH  
   WITH A ("사번", "이름", "이메일", "전회")
     AS (
       SELECT   EMPLOYEE_ID                      사번, 
                  FIRST_NAME ||  ' ' || LAST_NAME  이름,
                  EMAIL || '@grren.com'            이메일,
                  PHONE_NUMBER                     전회  
          FROM    EMPLOYEES   
   )
   SELECT * FROM A;
   
 ---------------------------------------------
 -- 사번,   업무시작일,  업무종료일, 담당업무, 부서번호
   SELECT EMPID, SDATE, EDATE, JOBID, DEPT_ID
    FROM 
    (
        SELECT    EMPLOYEE_ID                        EMPID, 
                  TO_CHAR(START_DATE, 'YYYY-MM-DD')  SDATE, 
                  TO_CHAR(END_DATE, 'YYYY-MM-DD')    EDATE, 
                  JOB_ID                             JOBID, 
                  DEPARTMENT_ID                      DEPT_ID
         FROM     JOB_HISTORY
        UNION  
        SELECT    EMPLOYEE_ID, 
                  TO_CHAR(HIRE_DATE,'YYYY-MM-DD'), 
                  '근무중',  
                  JOB_ID, 
                  DEPARTMENT_ID 
         FROM     EMPLOYEES
   )  T
   WHERE  SUBSTR(T.SDATE, 1, 4) = '2015';
 
 -- CROSS 조인 - 카티션 프로덕트 :조건없는 조인
 SELECT   D.DEPRTMENT_NAME,  E.FORST_NAME, E.LAST_NAME 
  FROM    DEPARTMENTS      D, EMPLOYEES  E;
  
 -- 등가 조인 : EQUI JOIN - 조건에 = 사용하는 조인
 ---  INNER JOIN  : 양쪽 다 존재하는 DATA , NULL 빼고
 부서명, 직원이름 , 부서이름순으로 출력하되 같은부서는 FIRST_NAME 순으로
 SELECT     D.DEPARTMENT_NAME,  E.FIRST_NAME, E.LAST_NAME 
  FROM      DEPARTMENTS      D, EMPLOYEES  E
  WHERE     D.DEPARTMENT_ID = E.DEPARTMENT_ID
  ORDER BY  D.DEPARTMENT_NAME ASC, FIRST_NAME ASC;  -- 106
  
 SELECT     D.DEPARTMENT_NAME,  E.FIRST_NAME, E.LAST_NAME 
  FROM      DEPARTMENTS      D  INNER JOIN  EMPLOYEES  E
    ON      D.DEPARTMENT_ID = E.DEPARTMENT_ID
  ORDER BY  D.DEPARTMENT_NAME ASC, FIRST_NAME ASC;   
  
  
SELECT  COUNT(DEPARTMENT_ID)  FROM EMPLOYEES;    -- 106
SELECT  COUNT(DISTINCT DEPARTMENT_ID)  FROM EMPLOYEES;    -- 11
SELECT  COUNT(DEPARTMENT_ID)  FROM DEPARTMENTS;  -- 27
  
 ---  OUTER JOIN
 -- LEFT OUTER JOIN : 모든 부서(기준,왼쪽)를 출력 
  SELECT    D.DEPARTMENT_NAME,  E.FIRST_NAME, E.LAST_NAME 
  FROM      DEPARTMENTS      D, EMPLOYEES  E
  WHERE     D.DEPARTMENT_ID = E.DEPARTMENT_ID(+)
  ORDER BY  D.DEPARTMENT_ID ASC;  -- 122 (106 + 27-11 )
  
  SELECT    D.DEPARTMENT_NAME,  E.FIRST_NAME, E.LAST_NAME 
  FROM      DEPARTMENTS      D LEFT OUTER JOIN  EMPLOYEES  E
    ON      D.DEPARTMENT_ID = E.DEPARTMENT_ID
  ORDER BY  D.DEPARTMENT_ID ASC;  
  
 
 -- RIGHT OUTER JOIN : 모든 부서(기준,왼쪽)를 출력 
  SELECT    D.DEPARTMENT_NAME,  E.FIRST_NAME, E.LAST_NAME 
  FROM      DEPARTMENTS      D, EMPLOYEES  E
  WHERE     D.DEPARTMENT_ID(+) = E.DEPARTMENT_ID
  ORDER BY  D.DEPARTMENT_ID ASC;  -- 106 부서번호가 NULL 인 + 3명 : 109 명
  
 SELECT    D.DEPARTMENT_NAME,  E.FIRST_NAME, E.LAST_NAME 
  FROM      DEPARTMENTS      D RIGHT OUTER JOIN  EMPLOYEES  E
    ON      D.DEPARTMENT_ID = E.DEPARTMENT_ID
  ORDER BY  D.DEPARTMENT_ID ASC;  
 
 4) FULL OUTER JOIN : 부서전체, 직원전체   122 + 3
  SELECT    D.DEPARTMENT_NAME,  E.FIRST_NAME, E.LAST_NAME 
  FROM      DEPARTMENTS      D  FULL OUTER JOIN  EMPLOYEES  E
    ON      D.DEPARTMENT_ID = E.DEPARTMENT_ID
  ORDER BY  D.DEPARTMENT_ID ASC;  
  
 
 -- SELF JOIN
 직원번호, 직속상사번호
 SELECT    EMPLOYEE_ID, MANAGER_ID
  FROM     EMPLOYEES;
  
 직원이름, 직속상사이름 , 상사정보 : E1, 부하정보 : E2
 SELECT    E2.EMPLOYEE_ID, E2.FIRST_NAME, E2.LAST_NAME,  E1.FIRST_NAME, E1.LAST_NAME
  FROM     EMPLOYEES   E1,  EMPLOYEES E2
  WHERE    E1.EMPLOYEE_ID = E2.MANAGER_ID
  ORDER BY E2.EMPLOYEE_ID;
  
 SELECT    E2.EMPLOYEE_ID, E2.FIRST_NAME, E2.LAST_NAME,  E1.FIRST_NAME, E1.LAST_NAME
  FROM     EMPLOYEES   E1  RIGHT JOIN  EMPLOYEES E2  ON   E1.EMPLOYEE_ID = E2.MANAGER_ID
  ORDER BY E2.EMPLOYEE_ID; 
  
  -- 계층형 쿼리  CASCADING 
  계층형 쿼리 - 계층구조 hirerachy  
 LEVEL  :  계층형 쿼리의 레벨을 구하는 예약어
 직원번호, 직원명, 레벨, 부서명
 SELECT              E.EMPLOYEE_ID                                                 직원번호, 
                     LPAD(' ', 3*(LEVEL-1)) || E.FIRST_NAME || ' ' || E.LAST_NAME  직원명, 
                     LEVEL                                                         레벨,    -- 1~
                     D.DEPARTMENT_NAME                                             부서명
  FROM               EMPLOYEES  E, DEPARTMENTS D
  WHERE              E.DEPARTMENT_ID  =  D.DEPARTMENT_ID
 -- START WITH         E.MANAGER_ID = 100
  START WITH         E.MANAGER_ID  IS NULL                  -- 출발점
  CONNECT BY PRIOR   E.EMPLOYEE_ID = E.MANAGER_ID;

-- START WITH : 시작점
-- CONNECT BY PRIOR - 연결 조건
-- LEVEL : 계층형구조에서만 사용하는 의사칼럼으로 자동으로 레벨을 부여  
  
----------------------------
-- NOT EQUI JOIN : 비등가 조인 조인조건에 = 을 사용하지 않는 조인
직원등급
 월급             등급
 20000 초과    :   S 
 15001 ~ 20000 :   A
 10001 ~ 15000 :   B
  5001 ~ 10000 :   C
  3001 ~  5000 :   D
     0 ~  3000 :   E

직원번호   직원명    월급    등급
SELECT    EMPLOYEE_ID                      직원번호,   
          FIRST_NAME || ' ' || LAST_NAME   직원명,    
          SALARY                           월급,    
          CASE  
            WHEN   SALARY > 20000                       THEN   'S' 
            WHEN   SALARY  BETWEEN   15001 AND  20000   THEN   'A'
            WHEN   SALARY  BETWEEN   10001 AND  15000   THEN   'B'
            WHEN   SALARY  BETWEEN    5001 AND  10000   THEN   'C'
            WHEN   SALARY  BETWEEN    3001 AND   5000   THEN   'D'
            WHEN   SALARY  BETWEEN       0 AND   3000   THEN   'E'
          END                              등급 
 FROM     EMPLOYEES;
 
---- TABLE  생성   
CREATE   TABLE    SALGRADE
(
     GRADE     VARCHAR2(1)   PRIMARY KEY
    ,LOSAL     NUMBER(11) 
    ,HISAL     NUMBER(11) 
);

INSERT  INTO   SALGRADE ( GRADE, LOSAL, HISAL         )
 VALUES                 ( 'S',   20001, 99999999999   );
INSERT  INTO   SALGRADE  VALUES  ( 'A', 15001, 20000  ); 
INSERT  INTO   SALGRADE  VALUES  ( 'B', 10001, 20000  ); 
INSERT  INTO   SALGRADE  VALUES  ( 'C',  5001, 10000  ); 
INSERT  INTO   SALGRADE  VALUES  ( 'D',  3001,  5000  ); 
INSERT  INTO   SALGRADE  VALUES  ( 'E',    0,   3000  ); 
COMMIT;

직원번호   직원명    월급    등급
SELECT     E.EMPLOYEE_ID                          직원번호,   
           E.FIRST_NAME ||  ' ' ||  E.LAST_NAME   직원명,    
           E.SALARY                               월급,    
           SG.GRADE                               등급
 FROM      EMPLOYEES   E,  SALGRADE SG
 WHERE     E.SALARY  BETWEEN  SG.LOSAL   AND  SG.HISAL
 ORDER BY  E.EMPLOYEE_ID ASC;
 
-------------------------------------------------------
--  분석함수와 WINDOW 함수
1. ROW_NUMBER() : 줄번호
2. RANK()       : 석차   1 2 2 4 4 6 
3. DENSE_RANK() : 석차   1 2 2 3 4 5
4. NTILE()      : 그룹으로 분류 
5. LIST_AGG()

자료를 10개만 출력 - 페이징기법 : DATABASE 에서 자료를 10개만 조회한다
전체
 SELECT      EMPLOYEE_ID,  FIRST_NAME, LAST_NAME,  SALARY
  FROM       EMPLOYEES  E
  ORDER BY   SALARY   DESC   NULLS  LAST;

1)  OLD 문법 ROWNUM - 의사칼럼 기능
  SELECT     ROWNUM, EMPLOYEE_ID,  FIRST_NAME, LAST_NAME,  SALARY
   FROM      EMPLOYEES  E
   WHERE     ROWNUM   BETWEEN  1   AND  10
   ORDER BY  SALARY   DESC  NULLS LAST;
   
   정렬하거나 할때 순서 문제로 사용하기가 어려운 점 있다 - 비추
    
2)  ANSI 문법 : ROW_NUMBER() : 11G
  
   SELECT   *
    FROM 
    (
    SELECT  ROW_NUMBER() OVER (ORDER BY SALARY DESC NULLS LAST)  AS RN,
            EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY
     FROM   EMPLOYEES    
    )  T   
    WHERE  T.RN BETWEEN  11 AND 20;
    
    MYSQL 페이징
     SELECT * FROM TABLE1  LIMIT 1, 10;  -- 1~10까지 조회한다 ROW_NUMBER() 속도가 빠름
    
3) ORACLE 12C 부터 가능한 OFFSET
    SELECT      *
     FROM       EMPLOYEES
     ORDER BY   SALARY    DESC   NULLS LAST
     OFFSET     11 ROWS  FETCH  NEXT 10 ROWS ONLY;
       -- 11부터 10개 : ROW_NUMBER() 보다 속도가 빠르다

----------------------------------------------------------------

2. RANK()
월긊순으로 석차를 출력 
SELECT   EMPLOYEE_ID                                       사번, 
         FIRST_NAME || ' ' || LAST_NAME                    이름, 
         SALARY                                            월긊, 
         RANK() OVER (ORDER BY SALARY DESC NULLS LAST )    석차
 FROM    EMPLOYEES;

SELECT   EMPLOYEE_ID                                           사번, 
         FIRST_NAME || ' ' || LAST_NAME                         이름, 
         SALARY                                                 월긊, 
         DENSE_RANK() OVER (ORDER BY SALARY DESC NULLS LAST )    석차
 FROM    EMPLOYEES;

월긊순으로 석차를 출력  1~10 등까지
  SELECT *
   FROM
   (
    SELECT   EMPLOYEE_ID                                       사번, 
             FIRST_NAME || ' ' || LAST_NAME                    이름, 
             SALARY                                            월긊, 
             RANK() OVER (ORDER BY SALARY DESC NULLS LAST )    석차
     FROM    EMPLOYEES
   )  T
   WHERE  T.석차   BETWEEN 1 AND 10
 ;

------------------------------------
 LISTAGG () 여려줄을 한줄 짜리 문자열로 변경
   
    SELECT  DEPARTMENT_ID
     FROM   EMPLOYEES;
    
    SELECT  DISTINCT DEPARTMENT_ID
     FROM   EMPLOYEES; 
    
    SELECT  LISTAGG(DISTINCT DEPARTMENT_ID, ',')
     FROM   EMPLOYEES;  
    
    SELECT  LISTAGG(DISTINCT DEPARTMENT_ID, ',') WITHIN GROUP(ORDER BY DEPARTMENT_ID DESC)
     FROM   EMPLOYEES;  
     
     