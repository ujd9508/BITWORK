<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <title>BitWork - Sign Write</title>
    <link rel="stylesheet" href="../css/normalize.css">
    <link rel="stylesheet" href="../css/style.css">
    <script src="/webjars/jquery/3.5.1/jquery.min.js"></script>
    <script src="/webjars/axios/0.21.1/dist/axios.min.js"></script>
    <script>
    function acceptDoc(form, isAccept) {
        let sign = document.createElement("input");
        sign.type = "hidden";
        sign.name = "sign";
        sign.value = isAccept;
        form.appendChild(sign);
        form.submit();
    }
    </script>
</head>

<style>
.form-write{
background-color: white;
	border-radius: 10px;
	padding: 60px 100px;
	border: 1px solid #e0e4e7;
	width: 100%;
	}
	
	#subject {
	padding: 0 10px;
	width: 100%;
	height: 30px;
	margin: 15px 0;
	border-radius: 5px;
	border: 1px solid #98a2af;
	}
	
	#content {
	padding: 10px;
	width: 100%;
	height: 300px;
	border: 1px solid #98a2af;
	border-radius: 5px;
	
	}
	
	#writer{
	padding: 0 10px;
	width: 100%;
	height: 30px;
	margin: 15px 0;
	border-radius: 5px;
	border: 1px solid #98a2af;
	
	}
	
	

</style>
<body> <!-- 작성모드와 detail 여부는 attribute vo가 있는지 여부로 판단-->
	<div class="white-bg">
		<div class="header">
			<p class="category">Board</p>
			<h2 class="title">작성게시판</h2>
		</div>
	</div>
  <!--   <h2>${empty requestScope.vo ? "작성 모드" : "보기 모드"}</h2> -->
    
    
    <div class = "wrap">
    <form class ="form-write" action="/sign/detail" method="post" enctype="multipart/form-data">
        <span><h3>결재 서류(상신)</h3></span>
        <span><h3>작성 일자 : ${requestScope.date}</h3></span>
            <div class="form-group">
                <label for="subject">제목</label>
                <input type="text" name="subject" id="subject"
                       value="${requestScope.vo.docTitle}" ${empty requestScope.vo ? "" : "readonly"}>
            </div>
            <div class="form-group">
                <label for="content">내용</label>
                <textarea type="text" name="content" id="content" ${empty requestScope.vo ? "" : "readonly"}>${requestScope.vo.docContent}</textarea>
            </div>
            <div class="form-group">
                <label for="writer">기안자</label>
                <input type="text" name="writer" id="writer" value="${empty requestScope.vo ? sessionScope.user.name : requestScope.vo.writerName}" readonly> <!-- 작성일때는 세션에서 유저이름, detail일때는 글의 writerName -->
            </div>
            <div class="form-group">
                <label for="file">첨부파일</label>
                <input type="file" name="file" id="file"> <!-- detail일때는 업로드 되있는 파일명이 보여야 함 -->
            </div>
            <div class="form-buttons">
                <!-- 디테일일때는 안보이거나, 디테일일때 사장이면 승인, 거절 버튼이 있어야된다 -->
            <c:if test="${empty requestScope.vo}">
                <button type="submit">상신</button>
            </c:if>
            <c:if test="${(not empty requestScope.vo) and sessionScope.user.grade == 4 and requestScope.vo.docStatus eq '대기'}">
                <input type="hidden" name="docNo" value="${requestScope.vo.docNo}">
                <button class = "blue" type="button" onclick="acceptDoc(this.form, true)">승인</button>
                <button class = "gray" type="button" onclick="acceptDoc(this.form, false)">반려</button>
            </c:if>
                <button type="button" onclick="history.back()">목록</button>
            </div>
        </form>
    </div>
</body>
</html>
