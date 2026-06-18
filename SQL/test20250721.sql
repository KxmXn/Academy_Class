/*      TUSER  
회원관리
번호       숫자(6)    기본키  자동증가  
이름       문자(30)   필수입력
아이디     문자(15)   필수입력
암호       문자(15)   필수입력
이메일     문자(320)  
가입일     날짜       기본값  오늘
*/

DROP TABLE    TUSER;
CREATE  TABLE  TUSER (
    ID       NUMBER(6)      PRIMARY KEY
   ,NAME     VARCHAR2(30)   NOT NULL
   ,USERID   VARCHAR2(15)   NOT NULL   UNIQUE
   ,PASSWD   VARCHAR2(15)   NOT NULL 
   ,EMAIL    VARCHAR2(320)  
   ,REGDATE  DATE           DEFAULT  SYSDATE
);

SELECT  SEQID.CURRVAL  FROM DUAL;  -- NEXTVAL 실행후에만 값을 볼수 있다
DROP   SEQUENCE  SEQID;
CREATE SEQUENCE  SEQID;

SELECT  ID, NAME, USERID, PASSWD, EMAIL, REGDATE
 FROM   TUSER;
 
INSERT INTO  TUSER (  ID,            NAME,   USERID,    PASSWD, EMAIL )  
 VALUES            (  SEQID.NEXTVAL, '카리나', 'KARINA', '1234', 'KARINA@SM.COM' );
COMMIT;

INSERT INTO  TUSER ( ID, NAME, USERID, PASSWD, EMAIL ) 
  VALUES ( SEQID.NEXTVAL, '윈터',   'snow',   '1234',  'snow@sm.com' );
  
  
UPDATE    TUSER 
 SET      EMAIL = 'KARINA@YG.COM'
 WHERE    USERID = 'KARINA'
  AND     PASSWD = '1234';
COMMIT;

DELETE   FROM   TUSER
 WHERE    USERID = 'KARINA'
  AND     PASSWD = '1234';
COMMIT;








