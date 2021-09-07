
/* Drop Tables */

DROP TABLE test_write CASCADE CONSTRAINTS;




/* Create Tables */

CREATE TABLE test_write
(
	wr_uid number NOT NULL,   -- 글 고유 아이디
	wr_subject varchar2(200) NOT NULL, -- 글제목
	wr_content clob,  -- 글내용
	wr_name varchar2(40) NOT NULL, --글 작성자
	wr_viewcnt number DEFAULT 0,  -- 글 조회수
	wr_regdate date DEFAULT SYSDATE,  -- 글 작성일
	PRIMARY KEY (wr_uid)
);

-- 시퀀스
CREATE SEQUENCE test_write_seq;

-- 기본데이터
-- 기본데이터 작성
INSERT INTO TEST_WRITE VALUES
(TEST_WRITE_SEQ.nextval, '첫째글:방가요', '안녕하세요', '김희철', 0, '2017-03-02');
INSERT INTO TEST_WRITE VALUES
(TEST_WRITE_SEQ.nextval, '둘째글:헤헤헤','1111', '김수길', 0, '2017-03-02');
INSERT INTO TEST_WRITE VALUES
(TEST_WRITE_SEQ.nextval, '세째글:힘내세요', '7394', '최진덕' , 0, '2017-08-12');
INSERT INTO TEST_WRITE VALUES
(TEST_WRITE_SEQ.nextval, '네째글: ... ', '9090', '이혜원', 0, '2018-02-09');
INSERT INTO TEST_WRITE VALUES
(TEST_WRITE_SEQ.nextval, '다섯째글: 게시판', '7531', '박수찬', 0, sysdate);


SELECT * FROM test_write ORDER BY wr_uid DESC;

-- 실제 쿼리할때는 * 보다는 별명을 주자 (혹은 VIEW 를 만들어서 활용)
SELECT 
	wr_uid "uid", wr_subject subject, wr_content content,
	wr_name name, wr_viewcnt viewcnt, wr_regdate regdate
FROM test_write ORDER BY wr_uid DESC;

-- 기본의 테이블 x2 배 늘리기
INSERT INTO test_write(wr_uid, wr_subject, wr_content, wr_name, wr_viewcnt)
SELECT test_write_seq.nextval, wr_subject, wr_content, wr_name, WR_VIEWCNT
FROM test_write;


-- 페이징

SELECT * FROM (
	SELECT ROWNUM AS RNUM, T.*
	FROM (SELECT wr_uid "uid", wr_subject subject, wr_content content,
			wr_name name, wr_viewcnt viewcnt, wr_regdate regdate
			FROM test_write ORDER BY wr_uid DESC) T )
WHERE RNUM >= 17 AND RNUM < 17 + 8
;


DELETE FROM test_write WHERE wr_uid > 10;


















