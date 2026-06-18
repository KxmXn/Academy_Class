   -- SQL  명령순서
   --  FROM -> WHERE -> GROPU BY -> SELECT -> ORDER BY
   -- WHERE 문안에 집계함수 사용불가

--   부서번호 80 이 아닌 직원
SELECT     employee_id              사번, 
           first_name, LAST_NAME    이름, 
           phone_number             전화, 
           department_id            부서번호     
 FROM      EMPLOYEES
 WHERE     DEPARTMENT_ID   <>  80;    -- 아니다  !=, <>, ^=

-- *, %, +, -
-- >, <. >=, <=, =, != ( <> )
-- 나머지 MOD(7, 2)
SELECT   7 / 2, 
         ROUND(123.456, 2), ROUND(163.456, -2),
         TRUNC(123.456, 2), TRUNC(163.456, -2)
 FROM    DUAL;
 
 
/*  직원사번,입사일 */
SELECT     employee_id  사번, 
           hire_date    입사일,
           TO_CHAR( HIRE_DATE, 'YYYY-MM-DD D DY' ) 
FROM       EMPLOYEES;


-- 2025년 07 월 09일  10 시 05 분 04 초 오전 슈요일

SELECT     SYSDATE,
           TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM DAY') 날짜,
           TO_CHAR(SYSDATE, 'YYYY"년"MM"월"DD"일"HH"시"MI"분"SS"초" AM DAY') 날짜2,
           TO_CHAR(SYSDATE, 'YYYY"年"MM"月"DD"日"HH"時"MI"分"SS"秒" AM DAY') 날짜3
 FROM      DUAL;
 
-- 년월일시분초오전오후 : 
-- 年 月 日 時 分 秒 午前 午後 
-- 日月火水木金土 曜日


SELECT       TO_CHAR(SYSDATE, 'YYYY')  || '年 '
          || TO_CHAR(SYSDATE, 'MM')    || '月 '
          || TO_CHAR(SYSDATE, 'DD')    || '日 '
          || TO_CHAR(SYSDATE, 'HH')    || '時 '
          || TO_CHAR(SYSDATE, 'MI')    || '分 '
          || TO_CHAR(SYSDATE, 'SS')    || '秒 '
          || DECODE (TO_CHAR(SYSDATE, 'AM'), '오전', '午前 ', 
                                             '오후', '午後 ' )
          || DECODE (TO_CHAR(SYSDATE, 'DY'), '일', '日'    
                                           , '월', '月'
                                           , '화', '火'
                                           , '수', '水'
                                           , '목', '木'
                                           , '금', '金'
                                           , '토', '土'
             )  ||  '曜日' 
 FROM     DUAL; 
 
 -----------------------------------------------
  -- IF 를 사용한다
-- 1)  NVL(), NVL2()
SELECT     employee_id                          사번, 
           first_name || ' ' || LAST_NAME       이름, 
           SALARY                               월급, 
           NVL( commission_pct,  0)             보너스
           -- , NVL( commission_pct,  '보너스없음')  보너스  -- 에러 ORA-01722: 수치가 부적합합니다
           , DECODE( commission_pct, NULL,  '보너스없음'   )
 FROM      EMPLOYEES;
 
-- 2) NULLIF( expr1, expr2 ) 
-- 들을 비교해서 같으면 null, 같지않으면  expr1

   3) DECODE
   DECODE (expr, search1, result1, search2, result2, …, default) : IF 문
   DECODE는 expr과 search1을 비교해 두 값이 같으면 result1을, 
       같지 않으면 다시 search2와 비교해 값이 같으면 result2를 반환하고, 
       이런 식으로 계속 비교한 뒤 최종적으로 같은 값이 없으면 default 값을 반환한다. 
  
    IF( DEPARTMENT_ID IS  NULL)
       '부서없음'
    ELSE
       DEPARTMENT_ID
       
   SELECT   EMPLOYEE_ID, 
            DEPARTMENT_ID, 
            DECODE( DEPARTMENT_ID,  NULL, '부서없음',
                                           DEPARTMENT_ID )  부서번호           
    FROM    EMPLOYEES;   
    
    SELECT   TO_CHAR(SYSDATE, 'PM'),
             DECODE (TO_CHAR(SYSDATE, 'PM'), '오전', '午前',  
                                                     '午後')
     FROM    DUAL; 
  
 --------------------------------------------------------------
/* 
10	Administration
20	Marketing
30	Purchasing
40	Human Resources
50	Shipping
60	IT
70	Public Relations
80	Sales
90	Executive
100	Finance
110	Accounting
*/ 

-- DECODE() 함수 :  다중 IF
-- 사번, 이름, 부서명 
SELECT  employee_id    사번, 
        first_name || ' ' || last_name   이름, 
        DECODE( department_id,  60, 'IT',
                                50,	'Shipping',
                                80,	'Sales', 
                                    '그외 부서'     
        ) AS  부서명 
 FROM   EMPLOYEES;
 
   ------------------------------------------

    NULL 은 게산식에 포함되면 결과는 NULL 이다
   
    직원명단, 직원의 월급, 보너스 출력 연봉출력 
    
 SELECT  EMPLOYEE_ID                                    직원명단, 
         DECODE(SALARY, NULL, '신입사원', SALARY)       직원월급, 
         NVL(SALARY * commission_pct, 0)                보너스, 
         SALARY * 13 + NVL(SALARY * commission_pct, 0)  연봉
  FROM   EMPLOYEES ;
  
 4) CASE  When
   -- WHEN   SCORE  BETWEEN 90 AND 100      THEN 'A'
   -- WHEN   90 <= SCORE  AND SCORE <= 100  THEN 'A'
   
    SELECT   EMPLOYEE_ID                       사번,
             FIRST_NAME || ' ' || LAST_NAME    이름,
             CASE    DEPARTMENT_ID
                WHEN      90   THEN    'Executive' 
                WHEN      80   THEN    'Sales' 
                WHEN      50   THEN    'Shipping' 
                WHEN      60   THEN    'IT' 
                ELSE                   '그외'
             END                    AS         부서명
     FROM    EMPLOYEES;
 
 
   SELECT   EMPLOYEE_ID                       사번,
             FIRST_NAME || ' ' || LAST_NAME    이름,
             CASE    
                WHEN  DEPARTMENT_ID = 90   THEN    'Executive' 
                WHEN  DEPARTMENT_ID = 80   THEN    'Sales' 
                WHEN  DEPARTMENT_ID = 50   THEN    'Shipping' 
                WHEN  DEPARTMENT_ID = 60   THEN    'IT' 
                ELSE                   '그외'
             END                    AS         부서명
     FROM    EMPLOYEES;
 
 ----------------------------------------------------
 --  집계 함수 : AGGREGATE  함수
 --  모든 집계 함수는 null 값은 포함하지 않는다
 --   ~별 인원수
 --  집계함수  COUNT(), SUM(), AVG(), MIN(), MAX(), VARIANCE(expr)분산, STDDEV(expr)표준편차
 --  그룹핑    GROUP BY
 

 SELECT  *                      FROM EMPLOYEES;    -- 전체 명단
 SELECT  COUNT(*)               FROM EMPLOYEES;    --  직원의 인원수 : 109
 SELECT  COUNT(EMPLOYEE_ID)     FROM EMPLOYEES;    -- 109
 SELECT  COUNT(DEPARTMENT_ID)   FROM EMPLOYEES;  -- 106 (NULL 3명 178, 207, 208)
 
 SELECT  *   FROM   EMPLOYEES
  WHERE  DEPARTMENT_ID  IS  NULL;
 
 -- 전체직원의 월급합 : 세로합(NULL 제외)
 SELECT  COUNT(SALARY)  FROM EMPLOYEES;    -- 107
 SELECT  SUM(SALARY)    FROM EMPLOYEES;    -- 691416 월급합
 SELECT  AVG(SALARY)    FROM EMPLOYEES;    -- 6461.831775700934579439252336448598130841 월급평균
 SELECT  MIN(SALARY)    FROM EMPLOYEES;    -- 2100
 SELECT  MAX(SALARY)    FROM EMPLOYEES;    -- 24000
 
 SELECT  691416 / 109  FROM DUAL;          -- 6343.266055045871559633027522935779816514
 SELECT  691416 / 107  FROM DUAL;          -- 6461.831775700934579439252336448598130841
 
 -- 60번 부서의 평균월긊
 SELECT  AVG(SALARY)    FROM  EMPLOYEES
  WHERE  DEPARTMENT_ID  = 60;              -- 5760
  
 -- EMPLOYEES 테이블의 부서수를 알고 싶다 
  SELECT  DEPARTMENT_ID         FROM  EMPLOYEES;  -- 109
  SELECT  COUNT(DEPARTMENT_ID)  FROM  EMPLOYEES;  -- 106
  
 -- 중복을 제거(DISTINCT )한 부서의 수를 출력
  SELECT  DISTINCT DEPARTMENT_ID          FROM  EMPLOYEES;  -- 12
  SELECT  COUNT(DISTINCT  DEPARTMENT_ID)  FROM  EMPLOYEES;  -- 11
  
  SELECT  COUNT(*) FROM DEPARTMENTS;   -- 27
 
 
 --  직원이름, 부서번호, 부서명 - CASE WHEN
SELECT    FIRST_NAME || ' ' || LAST_NAME    직원이름, 
          DEPARTMENT_ID                     부서번호, 
          CASE   DEPARTMENT_ID
            WHEN  10   THEN	'Administration'
            WHEN  20   THEN	'Marketing'
            WHEN  30   THEN	'Purchasing'
            WHEN  40   THEN	'Human Resources'
            WHEN  50   THEN	'Shipping'
            WHEN  60   THEN	'IT'
            WHEN  70   THEN	'Public Relations'
            WHEN  80   THEN	'Sales'
            WHEN  90   THEN	'Executive'
            WHEN  100  THEN	'Finance'
            WHEN  110  THEN	'Accounting'
          END                               부서명
 FROM     EMPLOYEES;

 
 --   입사일에 해당되는 달의 첫번째 날짜와 마지막 날짜를 출력 
 SELECT   employee_id                                         사번, 
          TO_CHAR( HIRE_DATE, 'YYYY-MM-DD')                   입사일, 
          TO_CHAR( TRUNC(HIRE_DATE, 'MONTH'), 'YYYY-MM-DD')   입사월첫날, 
          TO_CHAR( LAST_DAY(HIRE_DATE), 'YYYY-MM-DD')         입사월마지막낧짜
  FROM    EMPLOYEES ;

 --   직원이 근무하는 부서의 수 : 부서장이 있는 부서수
 SELECT   COUNT(DEPARTMENT_ID)    "직원이 근무하는 부서수"
  FROM    DEPARTMENTS
  WHERE   MANAGER_ID IS NOT NULL;
 
  -- 직원수, 월급합, 월급평균, 최대월급, 최소월급
  SELECT     COUNT(EMPLOYEE_ID)         직원수, 
             SUM(SALARY)                월급합, 
             ROUND(AVG(SALARY), 3)      월급평균, 
             MAX(SALARY)                최대월급, 
             MIN(SALARY)                최소월급
   FROM      EMPLOYEES;

--   부서 60번 부서 인원수, 월급합, 월급평균
SELECT    COUNT( EMPLOYEE_ID )      부서인원수, 
          SUM( SALARY  )            월급합, 
          ROUND(AVG( SALARY ), 3)   월급평균
 FROM     EMPLOYEES
 WHERE    DEPARTMENT_ID  =   60;

--   부서 50, 60, 80번 부서가 아닌 인원수, 월급합, 월급평균
SELECT    COUNT( EMPLOYEE_ID )      부서인원수, 
          SUM( SALARY  )            월급합, 
          ROUND(AVG( SALARY ), 3)   월급평균
 FROM     EMPLOYEES
 WHERE    DEPARTMENT_ID  NOT IN  (60, 50, 80);
/* WHERE    DEPARTMENT_ID  =   60
  OR      DEPARTMENT_ID  =   50
  OR      DEPARTMENT_ID  =   80; */
 
  
  --   부서 60번 부서 인원수, 월급합, 월급평균
SELECT    COUNT( EMPLOYEE_ID )      부서인원수, 
          SUM( SALARY  )            월급합, 
          ROUND(AVG( SALARY ), 3)   월급평균
 FROM     EMPLOYEES
 WHERE    DEPARTMENT_ID  =   60;
 
 ------------------------------------------------------------
 부서별 사원수
  SELECT      DEPARTMENT_ID       부서번호, 
             COUNT(EMPLOYEE_ID)  사원수
  FROM       EMPLOYEES -- ORA-00937: 단일 그룹의 그룹 함수가 아닙니다 (NOT A SINGLE GROUP)
                       -- GROUP BY 명령이 없어서 에러
                       -- 일반칼럼과 집계함수를 동시에 사용하면 ~별 통계의 의미로 쓴다  

 -- 부서별 사원수 통계
 SELECT      DEPARTMENT_ID       부서번호, 
             COUNT(EMPLOYEE_ID)  사원수
  FROM       EMPLOYEES 
  GROUP BY   DEPARTMENT_ID
  ORDER BY   DEPARTMENT_ID  ASC;    
 
 -- 부서별 인원수, 월급합
 SELECT      DEPARTMENT_ID          "부서번호"
           , COUNT(EMPLOYEE_ID )    "부서별 인원수"
           , SUM(SALARY)            "월급합"
  FROM       EMPLOYEES
  GROUP BY   DEPARTMENT_ID
  ORDER BY   DEPARTMENT_ID;
   
 -- 부서별 인원수가 5명이상인 부서번호
 SELECT        DEPARTMENT_ID        부서번호
             , COUNT(EMPLOYEE_ID)   부서별인원수
  FROM         EMPLOYEES
  WHERE        COUNT(EMPLOYEE_ID) >= 5    -- ORA-00934: 그룹 함수는 허가되지 않습니다
  GROUP BY     DEPARTMENT_ID 
  ORDER BY     DEPARTMENT_ID ; 
 
 SELECT        DEPARTMENT_ID        부서번호
             , COUNT(EMPLOYEE_ID)   부서별인원수
  FROM         EMPLOYEES
  -- WHERE        COUNT(EMPLOYEE_ID) >= 5    -- ORA-00934: 그룹 함수는 허가되지 않습니다
  GROUP BY     DEPARTMENT_ID 
   HAVING         COUNT(EMPLOYEE_ID) >= 5    -- 집계함수의 조건을 작성
  ORDER BY     DEPARTMENT_ID ; 
 
-- 부서별 월급총계가 20000 이상인 부서번호
SELECT     department_id      부서번호
         , SUM(SALARY)        월급총계
 FROM      EMPLOYEES 
 GROUP BY  department_id
   HAVING  SUM(SALARY)  >= 20000
 ORDER BY  부서번호 -- department_id


   -- SQL  명령순서
   --  FROM -> WHERE -> GROPU BY -> SELECT -> ORDER BY
   -- WHERE 문안에 집계함수 사용불가


-- JOB_ID 별 인원수 
SELECT       JOB_ID   
           , COUNT(EMPLOYEE_ID)   인원수
 FROM        EMPLOYEES 
 GROUP BY    JOB_ID
 ORDER BY    JOB_ID;
 
SELECT       JOB_ID   
           , COUNT(EMPLOYEE_ID)   인원수
 FROM        EMPLOYEES 
 GROUP BY    ROLLUP( JOB_ID )
 ORDER BY    JOB_ID;               -- 총계
 
SELECT       JOB_ID   
           , COUNT(EMPLOYEE_ID)   인원수
 FROM        EMPLOYEES 
 GROUP BY    CUBE(JOB_ID)
 ORDER BY    JOB_ID; 

--  입사일기준 월별 인원수, 2017년 기준
SELECT        TO_CHAR(HIRE_DATE, 'MM')    입사월
            , COUNT(EMPLOYEE_ID)          인원수
 FROM         EMPLOYEES
 WHERE        TO_CHAR(HIRE_DATE, 'YYYY') = '2017'
 GROUP BY     TO_CHAR(HIRE_DATE, 'MM')
 ORDER BY     TO_CHAR(HIRE_DATE, 'MM');


-- 부서별 최대월급이 14000 이상인 부서의 부서번호와 최대월급
SELECT        DEPARTMENT_ID     부서번호
            , MAX(SALARY)       최대월급   
 FROM         EMPLOYEES
 GROUP  BY    DEPARTMENT_ID
  HAVING      MAX(SALARY)  >= 14000
 ORDER  BY    DEPARTMENT_ID;


-- 부서별 모우고 같은부서는 직업별 인원수, 월급평균
SELECT        DEPARTMENT_ID           부서번호
            , JOB_ID                  직업ID
            , COUNT(JOB_ID)           직업별인원수
            , ROUND(AVG(SALARY), 3)   월급평균
 FROM         EMPLOYEES
 GROUP BY     ROLLUP(DEPARTMENT_ID, JOB_ID)
 ORDER BY     DEPARTMENT_ID, JOB_ID;

---------------------------------------------------------------
/*   SUBQUERY : QUERY 문안에 QUERY 가 들어간다    */
-- IT 부서의 직원정보를 출력하시오
1) IT 부서의 부서번호 :  DEPARTMENTS  -- 60
   SELECT   DEPARTMENT_ID
    FROM    DEPARTMENTS
    WHERE   DEPARTMENT_NAME = 'IT';  -- 60

2) 60 번 부서의 직원정보를 출력
   SELECT    EMPLOYEE_ID                     사번
            , FIRST_NAME || ' '|| LAST_NAME  이름
            , DEPARTMENT_ID                  부서번호
    FROM    EMPLOYEES
    WHERE    DEPARTMENT_ID   = 60;

1) + 2)

   SELECT    EMPLOYEE_ID                     사번
            , FIRST_NAME || ' '|| LAST_NAME  이름
            , DEPARTMENT_ID                  부서번호
    FROM    EMPLOYEES
    WHERE    DEPARTMENT_ID   = (
         SELECT   DEPARTMENT_ID
            FROM    DEPARTMENTS
          WHERE   DEPARTMENT_NAME = 'IT'
    );

-- 평균월급보다 않은 월급을 받는 사람의 명단
1)  SELECT  AVG(SALARY) FROM  EMPLOYEES;   -- 6461.831775700934579439252336448598130841
2)  SELECT  사번, 이름, 월급
     FROM   EMPLOYEES
     WHERE  SALARY >= (6461.831775700934579439252336448598130841);
     
1) + 2)     
    SELECT  EMPLOYEE_ID   사번, SALARY   월급
     FROM   EMPLOYEES
     WHERE  SALARY >= (
         SELECT  AVG(SALARY) FROM  EMPLOYEES
    );


-- 60번 부서의 평균월급보다 않은 월급을 받는 사람의 명단

--  SALES 부서의 평균월급보다 많은 월급을 받는 사람의 명단
1)   SALES 부서의 부서번호
  SELECT  DEPARTMENT_ID  
   FROM   DEPARTMENTS
   WHERE  UPPER(DEPARTMENT_NAME) = 'SALES';  -- 80
   
2)   80번 부서의 평균월급
  SELECT    AVG(SALARY)
   FROM     EMPLOYEES
   WHERE    DEPARTMENT_ID  = 80; -- 8955.882352941176470588235294117647058824

3)  평균월급(8955.882352941176470588235294117647058824)보다 많은 월급받는 사람의 명단

 SELECT     사번, 이름, 월급
  FROM      EMPLOYEES
  WHERE     SALARY  >= (8955.882352941176470588235294117647058824);


1) + 2)  + 3)

SELECT      EMPLOYEE_ID                     사번
          , FIRST_NAME || ' ' || LAST_NAME  이름
          , SALARY                          월급
  FROM      EMPLOYEES
  WHERE     SALARY  >= (
     SELECT    AVG(SALARY)
      FROM     EMPLOYEES
       WHERE    DEPARTMENT_ID  = (
           SELECT  DEPARTMENT_ID  
             FROM   DEPARTMENTS
             WHERE  UPPER(DEPARTMENT_NAME) = 'SALES'
       )
  );






