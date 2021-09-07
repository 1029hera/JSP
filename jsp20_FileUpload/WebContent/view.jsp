<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:choose>
	<c:when test="${empty list || fn:length(list) == 0 }">
		<script>
			alert("해당 정보가 삭제되거나 없습니다");
			history.back();
		</script>
	</c:when>
	
	<c:otherwise>
	
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>읽기-${list[0].subject }</title>
</head>
<script>

function chkDelete(uid){
	// 삭제 여부, 다시 확인 하고 진행하기
	var r = confirm("삭제하시겠습니까?");
	
	if(r){
		location.href = 'deleteOk.do?uid=' + uid;
	}
} // chkDelete

</script>
<body>	
	<h2>항목 보기</h2>
		<br>
		uid : ${list[0].uid }<br>
		작성자 : ${list[0].name }<br>
		제목: ${list[0].subject }<br>
		등록일: ${list[0].regDateTime }<br> <%-- getRegDateTime() 사용 --%>
		조회수: ${list[0].viewCnt }<br>
		내용: <br>
		<hr>
		<div>
		${list[0].content }
		</div>
		<hr>
		
		<%-- 첨부파일 및 다운로드 링크 --%>
		<c:if test="${fn:length(fileList) > 0 }">
		<div style="background-color: beige; padding: 2px 10px; margin-bottom: 5px; border: 1px solid black;">
			<h4>첨부파일</h4>
			<%-- 다운로드 링크 --%>
			<ul>
				<c:forEach var="fileDto" items="${fileList }">
					<li><a href="download.do?uid=${fileDto.uid }">${fileDto.source }</a></li>
				</c:forEach>
			</ul>
			
			<%-- 이미지인 경우 보여주기 --%>
			<c:forEach var="fileDto" items="${fileList }">
				<c:if test="${fileDto.image == true }">
					<div style="width:300px">
						<img style="width:100%; height:auto"
							src="upload/${fileDto.file }"/>
					</div><br>
				</c:if>
			</c:forEach>
		</div>
		</c:if>
		
		
		
		
		
		<br>
		<button onclick="location.href='update.do?uid=${list[0].uid }'">수정하기</button>
		<button onclick="location.href='list.do'">목록보기</button>
		<button onclick="chkDelete(${list[0].uid })">삭제하기</button>
		<button onclick="location.href='write.do'">신규등록</button>
</body>
</html>
				
	</c:otherwise>
</c:choose>









