<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
    <title>BitWork - Manage</title>
    <link rel="stylesheet" href="/css/normalize.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/components/search.css">
    <link rel="stylesheet" href="/fontawesome/css/fontawesome.css">
    <link rel="stylesheet" href="/css/components/table.css">
    <script src="/webjars/jquery/3.5.1/jquery.min.js"></script>
    <script src="/webjars/axios/0.21.1/dist/axios.js"></script>
    <style>
        .wrap {
            display: flex;
            width: 1000px;
            height: 80%;
            margin-top: 10px;
        }

        .invite-section {
            background-color: #CCCCCC;
            border-radius: 10px;
            padding: 20px;
            margin-right: 10px;
            flex-basis: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    </style>
    <script>
        function invite(id, button) {
            let params = {
                command: "invite",
                id: id
            };
            const payload = new URLSearchParams(params);

            axios.post("../member/api", payload)
                .then((response) => {
                    if (response.data.result) {
                        button.innerText = "초대완료";
                        button.className = "transparent invited";
                        button.removeEventListener();
                    } else {
                        alert("초대에 실패했습니다.");
                    }
                });
        }

        function makeTableRow(tbody, data) {
            tbody.innerHTML = "";
            if (data.length === 0) {
                alert("검색된 결과가 없습니다");
            }
            data.forEach(function (el) {
                const tr = document.createElement("tr");
                const button = document.createElement("button");
                button.type = "button";
                if (el.grade === 0) {
                    button.className = "transparent invite";
                    button.innerText = "초대";
                    button.addEventListener("click", () => invite(el.id, button));
                } else if (el.grade === 1) {
                    button.className = "transparent invited";
                    button.innerText = "초대완료";
                }
                tr.insertCell(-1);
                tr.insertCell(-1);
                tr.insertCell(-1);
                tr.cells[0].textContent = el.id;
                tr.cells[1].textContent = el.name;
                tr.cells[2].appendChild(button);
                tbody.appendChild(tr);
            });
        }

        function gradeHandler(isApply, ...memberIdList) {
            let payload = {
                isApply: isApply,
                memberIdList: memberIdList
            }
            axios.post("../member/updateGrade", payload).then(function (res) {
                payload.memberIdList.forEach(function (memberId) {
                    document.querySelector("#memberId_" + memberId).remove();
                })
                alert(res.data + "건 처리되었습니다");
            });
        }

        function loadApplyList() {
            axios.get("../member/api?command=findApplyList").then(function (res) {
                const tbody = document.createElement("tbody");
                tbody.id = "applyTbody";
                if (res.data.result) {
                    const list = res.data.list;
                    list.forEach(function (member, idx) {
                        const tr = tbody.insertRow(-1);
                        tr.id = "memberId_" + member.id;
                        const tdNo = tr.insertCell(-1);
                        const tdId = tr.insertCell(-1);
                        const tdName = tr.insertCell(-1);
                        const tdPosition = tr.insertCell(-1);
                        const tdApply = tr.insertCell(-1);
                        const applyBtn = document.createElement("button");
                        const refuseBtn = document.createElement("button");
                        tdNo.innerText = idx + 1;
                        tdId.innerText = member.id;
                        tdName.innerText = member.name;
                        tdPosition.innerText = member.position;
                        applyBtn.innerText = "승인";
                        applyBtn.type = "button";
                        applyBtn.addEventListener("click", () => gradeHandler(true, member.id));
                        refuseBtn.innerText = "거절";
                        refuseBtn.type = "button";
                        refuseBtn.addEventListener("click", () => gradeHandler(false, member.id));
                        tdApply.appendChild(applyBtn);
                        tdApply.appendChild(refuseBtn);
                    });
                    document.querySelector("#inviteTable thead").insertAdjacentElement("afterend", tbody);
                } else {
                    alert("에러가 발생했습니다. 서버관리자에게 문의해주세요");
                }
            });
        }

        document.addEventListener("DOMContentLoaded", function () {
            loadApplyList();

            document.querySelector("#searchUserBtn").addEventListener("click", function () {
                const tbody = document.getElementById("userTbody");
                const id = document.querySelector("#userId").value;
                axios.get("../member/api", {
                    params: {
                        command: "findInvitable",
                        id: id
                    }
                }).then(function (res) {
                    const data = res.data;
                    makeTableRow(tbody, data);
                });
            });
        });
    </script>
</head>
<body>
    <header class="header">
        <div class="category">Company</div>
        <div class="title">사용자 관리</div>
    </header>
    <div class="wrap">
        <section class="invite-section">
            <div class="search-form">
                <label for="userId"></label>
                <input type="text" placeholder="아이디로 검색" name="userId" id="userId" class="search-bar">
                <button type="button" id="searchUserBtn" class="search-button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
            <table class="table">
                <thead class="thead">
                    <tr>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>초대</th>
                    </tr>
                </thead>
                <tbody id="userTbody">
                    <tr>
                        <td>테스트1 아이디</td>
                        <td>테스트1 이름</td>
                        <td>
                            <button class="transparent invite">초대</button>
                        </td>
                    </tr>
                    <tr>
                        <td>테스트2 아이디</td>
                        <td>테스트2 이름</td>
                        <td>
                            <button class="transparent invite">초대</button>
                        </td>
                    </tr>
                </tbody>
            </table>
        </section>
        <section class="invite-section" id="inviteList">
            <table id="inviteTable">
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>아이디</th>
                        <th>이름</th>
                        <th>직급</th>
                        <th>승인</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <td colspan="5">
                            <button type="button" id="applyAll">모두 승인</button>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </section>
    </div>
</body>
</html>
