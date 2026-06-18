-- 부서명, 직원이름
  SELECT    D.DEPARTMENT_NAME                     부서명, 
              E.FIRST_NAME || ' ' ||  E.LAST_NAME   직원이름,
              e.phone_number                        전화번호,
              e.email                               이메일          
     FROM     DEPARTMENTS D LEFT JOIN EMPLOYEES E 
           ON D.DEPARTMENT_ID = E.DEPARTMENT_ID
     WHERE    E.EMPLOYEE_ID = 110 ;
     
-- ORACLE 의 부프로그램 : 프로그램의 조각
----  1. PROCEDURE  SUBROUTINE 프로시저
        필요에 따라 0개 이상의 결과를 처리할수 있다
        RDB 에서는 STORED PROCEDURE 저장프로시저  
----  2. FUNCTION : 함수
        반드시 한개의 RETURN 값을 가져야한다

-----------------------------------------------
-- 107 번 직원의 이름과 월급 조회
 SELECT   FIRST_NAME || ' ' || LAST_NAME 직원이름, 
          SALARY                         월급 
  FROM    EMPLOYEES 
  WHERE   EMPLOYEE_ID  = 107;


-- ORACLE에 함수를 저장한다
CREATE PROCEDURE   GET_EMPSAL(  IN_EMPID IN NUMBER )
IS
  V_NAME    VARCHAR2(45);
  V_SAL     NUMBER(8, 2);
  BEGIN
     SELECT   FIRST_NAME || ' ' || LAST_NAME,  SALARY
      INTO    V_NAME,                          V_SAL
      FROM    EMPLOYEES 
      WHERE   EMPLOYEE_ID  = IN_EMPID;
     DBMS_OUTPUT.PUT_LINE( V_NAME ); 
     DBMS_OUTPUT.PUT_LINE( V_SAL  );     
  END; 
 /
 
 SET SERVEROUTPUT ON;
 CALL   GET_EMPSAL(120);
 
 -----------------------------------------------------
 -- 부서번호입력, 해당부서의 최고월급자의 이름, 월급 출력
 CREATE OR REPLACE  PROCEDURE   GET_NAME_MAXSAL( 
     IN_DEPTID  IN    NUMBER,
     O_NAME     OUT   VARCHAR2,
     O_SAL      OUT   VARCHAR2    )
 AS
   V_MAXSAL   NUMBER(8, 2);
   BEGIN
     SELECT   MAX(SALARY)
      INTO    V_MAXSAL
      FROM    EMPLOYEES  
      WHERE   DEPARTMENT_ID = IN_DEPTID;
       
     SELECT   FIRST_NAME || ' ' || LAST_NAME,   SALARY
      INTO    O_NAME,                           O_SAL
      FROM    EMPLOYEES 
      WHERE   SALARY         =  V_MAXSAL
      AND     DEPARTMENT_ID  =  IN_DEPTID;
    
    DBMS_OUTPUT.PUT_LINE( O_NAME );  
    DBMS_OUTPUT.PUT_LINE( O_SAL );  
      
   END;
/   

SET SERVEROUTPUT ON;
VAR     O_NAME   VARCHAR2;
VAR     O_SAL    NUMBER;  
CALL    GET_NAME_MAXSAL( 90, :O_NAME, :O_SAL );
PRINT   O_NAME;
PRINT   O_SAL;
 
 
 --   90 번 부서번호입력, 직원들 출력
 CREATE OR REPLACE  PROCEDURE  GETEMPLIST( IN_DEPTID NUMBER  ) 
 IS 
    VEID        NUMBER(8,2);
    VFNAME      VARCHAR2(4000); 
    VLNAME      VARCHAR2(4000);
    VPHONE      VARCHAR2(4000);
    BEGIN
       SELECT    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER
        INTO     VEID,        VFNAME,     VLNAME,    VPHONE
        FROM     EMPLOYEES  
        WHERE    DEPARTMENT_ID  =  IN_DEPTID;
        DBMS_OUTPUT.PUT_LINE( VEID );
    END;
/ 

EXEC   GETEMPLIST( 90 );
오류 발생 행: 1:
ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
ORA-06512: "HR.GETEMPLIST",  8행
ORA-06512:  1행

**** SELECT INTO 는 결과가 한줄일때만 사용가능

해결책) 커서(CURSOR) 사용
 --   90 번 부서번호입력, 직원들 출력
CREATE  OR  REPLACE  PROCEDURE   GET_EMPLIST (
     IN_DEPTID   IN      NUMBER,
     O_CUR       OUT     SYS_REFCURSOR )
AS
  BEGIN
     
     OPEN  O_CUR  FOR
       SELECT    EMPLOYEE_ID, FIRST_NAME, LAST_NAME, PHONE_NUMBER    
        FROM     EMPLOYEES  
        WHERE    DEPARTMENT_ID  =  IN_DEPTID;
     
  END;
/  

VARIABLE   O_CUR    REFCURSOR;
EXECUTE    GET_EMPLIST( 50, :O_CUR   );
PRINT      O_CUR;




 
 
 
 
 
 
 
 
 
 
 
 
 
 