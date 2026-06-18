
SELECT  * FROM STUDENT;

성적처리 TABLE
 업무
 학생 : 학번, 이름, 전화, 입학일
 성적 : 학번, 국어, 영어, 수학, 총점, 평균, 석차 결과
 과목은 변경될 수 있다.
 
 TABLE 생성
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID          SUBJECT   SCORE   STID
 
 -- 제약조건(CONSTRAINTS) - 무결성  
  TABLE 에 저장될 데이터에 조건을 부여하여 잘못된 DATA 입려되는 방지
  1. 주식별자 설정 : 기본키
     PRIMARY KEY     : NOT NULL + UNIQUE 기본 적용
      CREATE TABLE 명령안에 한번만 사용가능
  2. NOT NULL / NULL : 필수입력, 컬럼단위 제약조건
  3. UNIQUE          : 중복방지
  4. CHECK           : 값의 범위지정 , DOMAIN 제약 조건 
  5. FOREIGN KEY     : 외래키 제약조건
  
  ---------------------------------------
  
 학생     : 학번(PK), 이름,   전화,   입학일
 STUDENT    STID      STNAME  PHONE   INDATE  
 
 CREATE  TABLE  STUDENT
 (
     STID      NUMBER(6)      PRIMARY KEY       -- 학번   숫자(6)   기본키, 
    , STNAME   VARCHAR2(30)   NOT NULL          -- 이름   문자(30)  필수입력,  
    , PHONE    VARCHAR2(20)   UNIQUE            -- 전화      문자(20)  중복방직,  
    , INDATE   DATE           DEFAULT  SYSDATE  -- 입학일    날짜      기본값(SYSDATE) 
 );
 
 INSERT INTO  STUDENT (  STID, STNAME, PHONE, INDATE   )
  VALUES              (   1,   '가나', '010', SYSDATE  );
 INSERT INTO  STUDENT 
  VALUES              (   2,   '나나', '011', SYSDATE  ); 
 INSERT INTO  STUDENT (  STID, STNAME, PHONE  )
  VALUES              (   3,   '가나', '012'  );
 INSERT INTO  STUDENT (  STID, STNAME, PHONE  )
  VALUES              (   4,   '라나', '013'  );  
 INSERT INTO  STUDENT (  STID, STNAME, PHONE  )
  VALUES              (   5,   '라나', '014'  );  
 INSERT INTO  STUDENT (  STID, STNAME, PHONE  )
  VALUES              (  NULL, '사나', '015'  );  -- ORA-01400: NULL을 ("SKY"."STUDENT"."STID") 안에 삽입할 수 없습니다
 INSERT INTO  STUDENT (  STID, STNAME, PHONE, INDATE   )
  VALUES              (   1,   '가나', '010', SYSDATE  );  -- ORA-00001: 무결성 제약 조건(SKY.SYS_C008371)에 위배됩니다
 INSERT INTO  STUDENT (  STID, STNAME, PHONE, INDATE   )
  VALUES              (   6,   NULL,   '016', SYSDATE  ); -- SQL 오류: ORA-01400: NULL을 ("SKY"."STUDENT"."STNAME") 안에 삽입할 수 없습니다
 INSERT INTO  STUDENT (  STID, STNAME, PHONE, INDATE   )
  VALUES              (   7,   '하나',  NULL, SYSDATE  ); -- 정상입력
 COMMIT; 
 
성적     : 일련번호(PK), 교과목,   점수,   학번(FK)
 SCORES     SCID         SUBJECT   SCORE   STID  
 
 DROP TABLE SCORES;
 
 CREATE    TABLE   SCORES (
       SCID        NUMBER(6)                                       -- 일련번호   숫자(6)   기본키  자동입력, 
     , SUBJECT     VARCHAR2(60)  NOT NULL                          -- 교과목     문자(60)  필수입력,   
     , SCORE       NUMBER(3)     CHECK (SCORE BETWEEN 0 AND 100)   -- 점수       숫자(3)   범위(0~100)
     , STID        NUMBER(6)                                       -- 학번       숫자(6)   STUDNETN TABLE 학번을 가져온다 FK
     , CONSTRAINT  SCID_PK
         PRIMARY KEY   (SCID, SUBJECT)
     , CONSTRAINT  STID_FK
         FOREIGN KEY ( STID )
         REFERENCES  STUDENT( STID )
  ); 
 
 INSERT INTO SCORES (SCID, SUBJECT, SCORE, STID)
  VALUES            (1,    '국어',  100,   1);
 INSERT INTO SCORES  VALUES (2, '영어',  100,  1);
 INSERT INTO SCORES  VALUES (3, '수학',  100,  1);
 INSERT INTO SCORES  VALUES (4, '국어',  100,  2);
 INSERT INTO SCORES  VALUES (5, '수학',   80,  2);
 INSERT INTO SCORES  VALUES (6, '국어',   70,  4);
 INSERT INTO SCORES  VALUES (7, '영어',   80,  4);
 INSERT INTO SCORES  VALUES (8, '수학',   85,  4);
 INSERT INTO SCORES  VALUES (9, '국어',  805,  5);  -- ORA-02290: 체크 제약조건(SKY.SYS_C008374)이 위배되었습니다
 INSERT INTO SCORES  VALUES (10, '영어', 100,  6);  -- ORA-02291: 무결성 제약조건(SKY.STID_FK)이 위배되었습니다- 부모 키가 없습니다 
 COMMIT;
 

 1. INSERT -- 줄(DATA) 추가 COMMIT 필수
  1) 1 줄 추가 
     INSERT INTO SCORES (SCID, SUBJECT, SCORE, STID)
        VALUES            (1,    '국어',  100,   1);
   
  2) 여러줄 추가 
     INSERT INTO EMP4
        SELECT * FROM HR.EMPLOYEES;
  
  3) INSERT 문 여러개를 한번에 실행 
    INSERT ALL -- 한번에 여러줄을 입려하는 방법
      INSERT ALL
        INTO ex7_3 VALUES (103, '강감찬')
        INTO ex7_3 VALUES (104, '연개소문')
      SELECT *
         FROM DUAL;
 
  2. DELETE  -- 줄(DATA) 을 삭제 한다 기본적으로 여러줄이 대상, COMMIT 필수
      DELETE   
      FROM   테이블명
      WHERE  조건; 
 
  3. UPDATE -- 줄에 변화없고 칸에 있는 정보만 수정, COMMIT
            -- HWERE 이 없으면 전체가 대상 
      UPDATE   MYMEMBER
        SET    TEL   = '010-1234-5678',
               EMAIL = 'SKY@GREEN.COM'
       WHERE   EMPID = 10;          
 
 
 ----------------------------------------
 DATA 제거
 1. DROP TABLE  SCORES;     -- 구조도 안남기고 삭제
 
 2. TRUNCATE TABLE SCORES; --ㅡ 구조만 남기고 삭제 :속도 빠름
 
 3. DELETE  FROM  SCORES;  -- 한줄씩 삭제수행
 
    SCORES DATA 삭제
     
   SELECT * FROM SCORES;
   DELETE FROM SCORES;
   ROLLBACK
 
   SELECT * FROM STUDENT;
   DELETE FROM STUDENT;   -- ORA-02292: 무결성 제약조건(SKY.STID_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
 
  INSERT INTO  STUDENT VALUES (11, '히나', '0111', SYSDATE );
  COMMIT
  
   DELETE  FROM  STUDENT
    WHERE  STID  = 1;   -- ORA-02292: 무결성 제약조건(SKY.STID_FK)이 위배되었습니다- 자식 레코드가 발견되었습니다
 
   DELETE  FROM  STUDENT
    WHERE  STID  = 11;  -- 1 행 이(가) 삭제되었습니다.
    
   외래키 관계에서는 자식테이블의 DATA를 지우고 부모테이블릐 DATA 를 삭제하면 된다
   
   DELETE  FROM  SCORES
    WHERE  STID  = 1;     -- 자식먼저 삭제
   DELETE  FROM  STUDENT
    WHERE  STID  = 1;     -- 부모키를 삭재
    
   
  -- 4번학생의 국어점수를 100점으로 수정
   UPDATE   SCORES
    SET     SCORE    = 100
    WHERE   SCID     =  6; 
 --   WHERE   STID     = 4
 --   AND     SUBJECT  = '국어'
  
 TRUNCATE TABLE SCORES 
 
 DROP TABLE SCORES; 

-- DELETE FROM STUDENT ; 
 DROP TABLE STUDENT ;
  
  ------------------------------------------------------
  -- 조회
  -- 학번, 이름, 점수(국어)
  SELECT   ST.STID       학번, 
           ST.STNAME     이름, 
           SC.SUBJECT    과목,
           SC.SCORE      점수
   FROM    STUDENT  ST,  SCORES  SC
   WHERE   ST.STID = SC.STID
    AND    SC.SUBJECT   =   '국어';
  
 --  학번, 이름, 총점, 평균
 SELECT      ST.STID                    학번, 
             ST.STNAME                  이름, 
             SUM(SC.SCORE)              총점, 
             ROUND(AVG(SC.SCORE), 3)    평균
  FROM       STUDENT  ST,  SCORES  SC
  WHERE      ST.STID = SC.STID
  GROUP BY   ST.STID,   ST.STNAME;
  
  
  -- 모든 학생의  학번, 이름, 총점, 평균
  ---- 점수가 NULL 인 학생은 '미응시'
 SELECT      ST.STID                                                 학번, 
             ST.STNAME                                               이름, 
             DECODE(SUM(SC.SCORE), NULL, '미응시', SUM(SC.SCORE))    총점, 
             CASE  
               WHEN   AVG(SC.SCORE) IS NULL  THEN   '미응시'
               ELSE                                  TO_CHAR(AVG(SC.SCORE), '990.999')
             END                                                     평균
  FROM       STUDENT  ST  LEFT JOIN  SCORES  SC  ON  ST.STID = SC.STID
  GROUP BY   ST.STID,   ST.STNAME;
  
  -- 모든 학생의  학번, 이름, 총점, 평균, 등급, 석차
  SELECT     ST.STID                                                 학번, 
             ST.STNAME                                               이름, 
             DECODE(SUM(SC.SCORE), NULL, '미응시', SUM(SC.SCORE))    총점, 
             CASE  
               WHEN   AVG(SC.SCORE) IS NULL  THEN   '미응시'
               ELSE                                  TO_CHAR(AVG(SC.SCORE), '990.999')
             END                                                     평균,
             CASE
               WHEN  ROUND(AVG(SCORE),3)  BETWEEN  90  AND 100     THEN  'A'   
               WHEN  ROUND(AVG(SCORE),3)  BETWEEN  80  AND 89.999  THEN  'B'
               WHEN  ROUND(AVG(SCORE),3)  BETWEEN  70  AND 79.999  THEN  'C'
               WHEN  ROUND(AVG(SCORE),3)  BETWEEN  60  AND 69.999  THEN  'D'
               WHEN  ROUND(AVG(SCORE),3)  BETWEEN   0  AND 59.999  THEN  'F'                              
               ELSE                                                      '미응시'
             END                                                      등급,
             RANK() OVER(ORDER BY SUM(SCORE) DESC NULLS LAST)         석차
  FROM       STUDENT  ST  LEFT JOIN  SCORES  SC  ON  ST.STID = SC.STID
  GROUP BY   ST.STID,   ST.STNAME;
  
  -- 비등가 조인 모든 학생의  학번, 이름, 총점, 평균, 등급, 석차
  
  -----------------------------------------------------------------
  ----  학번, 이름, 국어, 영어,수학,총점,평균, 등급, 석차
  
 --- 학번, 국어, 영어,수학,총점,평균 
 1. ORACLE 10G 방식
 1-1)  학번,국어, 영어, 수학
   SELECT   SC.STID                                  학번,
            DECODE( SC.SUBJECT, '국어', SC.SCORE)    국어, 
            DECODE( SC.SUBJECT, '영어', SC.SCORE)    영어, 
            DECODE( SC.SUBJECT, '수학', SC.SCORE)    수학 
    FROM    SCORES    SC ;
 
 1-2)  학번,국어, 영어, 수학
   SELECT     SC.STID                                         학번,
              SUM( DECODE( SC.SUBJECT, '국어', SC.SCORE) )    국어, 
              SUM( DECODE( SC.SUBJECT, '영어', SC.SCORE) )    영어, 
              SUM( DECODE( SC.SUBJECT, '수학', SC.SCORE) )    수학 
    FROM      SCORES    SC 
    GROUP BY  SC.STID;
 
 1-3) JOIN 학번, 이름, 국어, 영어, 수학
   SELECT     ST.STID                                         학번,
              ST.STNAME                                       이름,
              SUM( DECODE( SC.SUBJECT, '국어', SC.SCORE) )    국어, 
              SUM( DECODE( SC.SUBJECT, '영어', SC.SCORE) )    영어, 
              SUM( DECODE( SC.SUBJECT, '수학', SC.SCORE) )    수학 
    FROM      SCORES    SC, STUDENT   ST
    WHERE     SC.STID(+)    =     ST.STID
    GROUP BY  ST.STID, ST.STNAME;
 
 1-4) 학번, 이름, 국어, 영어, 수학, 총점, 평균
   SELECT     ST.STID                                         학번,
              ST.STNAME                                       이름,
              SUM( DECODE( SC.SUBJECT, '국어', SC.SCORE) )    국어, 
              SUM( DECODE( SC.SUBJECT, '영어', SC.SCORE) )    영어, 
              SUM( DECODE( SC.SUBJECT, '수학', SC.SCORE) )    수학,
              SUM (SC.SCORE)                                  총점,
              ROUND( AVG(SC.SCORE), 3)                        평균
    FROM      SCORES    SC, STUDENT   ST
    WHERE     SC.STID(+)    =     ST.STID
    GROUP BY  ST.STID, ST.STNAME;
 
 1-5)  학번, 이름, 국어, 영어,수학,총점,평균, 등급, 석차
    -- 미응시자는 '미응시' 로 출력
    -- 등급 : 비등가 조인으로 해결 
 
 CREATE TABLE  SCOREGRADE
 (
      GRADE      VARCHAR2(1)    PRIMARY KEY,
      LOSCORE    NUMBER(7, 3),
      HISCORE    NUMBER(7, 3)
 );
  
 INSERT INTO  SCOREGRADE VALUES('A', 90, 100); 
 INSERT INTO  SCOREGRADE VALUES('B', 80, 89.999); 
 INSERT INTO  SCOREGRADE VALUES('C', 70, 79.999); 
 INSERT INTO  SCOREGRADE VALUES('D', 60, 69.999); 
 INSERT INTO  SCOREGRADE VALUES('F',  0, 59.999); 
 COMMIT;

 SELECT   T.학번, T.이름, T.국어, T.영어, T.수학, T.총점, T.평균, 
          SG.GRADE      등급, 
          RANK() OVER(ORDER BY T.총점 DESC NULLS LAST ) 석차
  FROM  
   (
    SELECT    ST.STID                                         학번,
              ST.STNAME                                       이름,
              SUM( DECODE( SC.SUBJECT, '국어', SC.SCORE) )    국어, 
              SUM( DECODE( SC.SUBJECT, '영어', SC.SCORE) )    영어, 
              SUM( DECODE( SC.SUBJECT, '수학', SC.SCORE) )    수학,
              SUM (SC.SCORE)                                  총점,
              ROUND( AVG(SC.SCORE), 3)                        평균
    FROM      SCORES    SC, STUDENT   ST
    WHERE     SC.STID(+)    =     ST.STID
    GROUP BY  ST.STID, ST.STNAME   
   )  T LEFT JOIN SCOREGRADE  SG
      ON  T.평균 BETWEEN  SG.LOSCORE AND SG.HISCORE;

 ----------------------------------------------------------------- 
 2. ORACLE  11G PIVOT 문법사용   통계를 생성 - 일반적으로 집계함수와 같이 사용
 
 
 학번, 이름, 국어, 영어,수학,총점,평균, 등급
 
 1) 학번, 국어, 영어, 수학
 SELECT  * FROM (
    SELECT   STID, SUBJECT, SCORE
     FROM    SCORES
 )
 PIVOT
 (
    SUM(SCORE)
      FOR  SUBJECT
        IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학) 
 );
 
 -- 2)  학번, 이름, 국어, 영어, 수학, 총점, 평균, 학점, 석차
 SELECT   ST.STID  학번,  ST.STNAME  이름, T.국어, T.영어, T.수학, 
          ( NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0) )                   총점, 
          ROUND(( NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0) ) / 3, 3)     평균,
          SG.GRADE                                                            학점, 
          RANK() OVER (ORDER BY ( NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0) )  DESC NULLS LAST) 석차
  FROM    
  (
      SELECT  *  FROM (
            SELECT   STID, SUBJECT, SCORE
             FROM    SCORES
         )
         PIVOT
         (
            SUM(SCORE)
              FOR  SUBJECT
                IN('국어' AS 국어, '영어' AS 영어, '수학' AS 수학) 
         )          
  )  T  RIGHT JOIN   STUDENT     ST   ON  T.STID = ST.STID
        LEFT  JOIN   SCOREGRADE  SG   
          ON   (NVL(T.국어,0) + NVL(T.영어,0) + NVL(T.수학,0)) / 3 
               BETWEEN SG.LOSCORE  AND SG.HISCORE;
 
---------------------------------------------------------------
시퀀스 : 번호자동증가
--번호를 자동으로 입력

CREATE TABLE  TABLE3 (
    ID      NUMBER(6)    PRIMARY KEY,
    TITLE   VARCHAR2(400),
    MEMO    VARCHAR2(4000)
);

/*
INSERT INTO   TABLE3  VALUES( 1, 'A', 'AAAAA' );
INSERT INTO   TABLE3  VALUES( 2, 'B', 'ㅋㅋㅋㅋ' );
INSERT INTO   TABLE3  VALUES( 3, 'c', 'ㅇㅇ' );
*/

CREATE SEQUENCE   SEQ_ID;

INSERT INTO   TABLE3  VALUES( SEQ_ID.NEXTVAL, 'A', 'AAAAA' );
INSERT INTO   TABLE3  VALUES( SEQ_ID.NEXTVAL, 'B', 'ㅋㅋㅋㅋ' );
INSERT INTO   TABLE3  VALUES( SEQ_ID.NEXTVAL, 'c', 'ㅇㅇ' );

INSERT INTO   TABLE3  VALUES( (SELECT MAX(ID)+1 FROM TABLE3), 'D', 'ㅇㅇ' );
COMMIT;

DELETE  FROM  TABLE3
 WHERE  ID  IN ( 4, 5, 6 );
COMMIT; 

--------------------------------------------------------------------------
인덱스 : 검색 속도를 빠르게 만드는 객체
  인덱스가 생성된 칼럼을 WHERE 움네 사용해야 효과있다
    CREATE INDEX IDX_NAME
     ON   EMP1( FIRST_NAME  );
    CREATE INDEX IDX_NAME
     ON   EMP1( FIRST_NAME || ' ' || LAST_NAME  );
 
------------------------------------------------ 

트리거 :  TRIGGER  방아쇠
   회원정보가 추가되면 로그에 기록을 남기는 작업을 해야할때
   
   상황 
  1)  INSERT 회원정보
  2)  INSERT 로그기록
   두번실행
  
   자동화 
  1)  INSERT 회원정보 -> 트리거가  INSERT 로그기록 호출해서 실행
  
   단점 : 로직추적이 쉽지 않다 
          트리거를 남발하지 맣라.
          
 https://docs.oracle.com/database/121/TDDDG/tdddg_triggers.htm#BABDAGJJ  


---------------------------------------------------------------- 
트랜잭션 ( TRANSACTION )
송금
  1) 내걔좌 금액   -
  2) 상대계좌 금액 +
 
  
  1) UPDATE  TABLE1 
    SET   내계좌   = 내계좌 - 100;
    
  2) UPDATE  TABLE1 
    SET   샹대계좌 = 상대계좌 + 100;  
 
 두 동작을 하나의 트랜잭션으로 묶어주면 
  COMMIT을 만나기 전에는 DB에 저장되지 않으므로 
  송금실패시 DATA 가 잘목되는일이 없다
    
  BEGIN TRANS
  1) UPDATE  TABLE1 
      SET   내계좌   = 내계좌 - 100;
    
  2) UPDATE  TABLE1 
      SET   샹대계좌 = 상대계좌 + 100;  
    
    COMMIT; -- ROLLBACK;
  END
  

------------------------------
LOCK; 
  INSERT INTO TABLE2 (EMPID, ENAME, TEL, EMAIL)
   VALUES            (100, '김일', '010', 'KIM1');
  SELECT * FROM TABLE2;  

WIN+R : cmd
c:> sqlplus sky/1234
 
SQL>   INSERT INTO TABLE2 (EMPID, ENAME, TEL, EMAIL)
  2     VALUES            (100, '김일', '010', 'KIM1');
컴퓨터가 멈춘다

SQLDEVELOPER 에서 
 COMMIT 하면 -> DB LOCK 이 풀리고 TABLE2 에 저장된다

SQLPLUS 화면에서는
SQL>   INSERT INTO TABLE2 (EMPID, ENAME, TEL, EMAIL)
  2     VALUES            (100, '김일', '010', 'KIM1');
  INSERT INTO TABLE2 (EMPID, ENAME, TEL, EMAIL)
*
1행에 오류:
ORA-00001: 무결성 제약 조건(SKY.SYS_C008369)에 위배됩니다
중복오류발생한다

 100 번이 입력되어 기본키위반이 발생하며 저장되지 않는다
  








 
  
    
    
 