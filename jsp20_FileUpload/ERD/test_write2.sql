
/* Drop Tables */

DROP TABLE test_file CASCADE CONSTRAINTS;
DROP TABLE test_write CASCADE CONSTRAINTS;




/* Create Tables */

CREATE TABLE test_file
(
	bf_uid number NOT NULL,
	bf_source varchar2(100) NOT NULL,
	bf_file varchar2(100) NOT NULL,
	wr_uid number NOT NULL,
	PRIMARY KEY (bf_uid)
);


CREATE TABLE test_write
(
	wr_uid number NOT NULL,
	wr_subject varchar2(200) NOT NULL,
	wr_content clob,
	wr_name varchar2(40) NOT NULL,
	wr_viewcnt number DEFAULT 0,
	wr_regdate date DEFAULT SYSDATE,
	PRIMARY KEY (wr_uid)
);



/* Create Foreign Keys */

ALTER TABLE test_file
	ADD FOREIGN KEY (wr_uid)
	REFERENCES test_write (wr_uid)
	ON DELETE CASCADE  -- 참조하는 부모가 삭제되면 같이 삭제
;

CREATE SEQUENCE test_file_seq;


SELECT * FROM test_file ORDER BY bf_uid DESC;


SELECT w.wr_uid, w.wr_subject, f.bf_uid, f.bf_file, f.bf_source
FROM test_write w, test_file f
WHERE w.wr_uid = f.wr_uid ORDER BY w.wr_uid DESC
;




