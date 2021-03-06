$(function () {
    $("#uploadPicture").click(function () {
        $("#user_picture")[0].click();
    });

    let validTargets = document.querySelectorAll("input[pattern]");
    for (let target of validTargets) {
        target.validationMessage = target.title;
        target.addEventListener("change", function () {
            let valid = this.checkValidity();
            if (valid) {
                this.classList.remove("red-important");
            } else {
                this.classList.add("red-important");
                this.reportValidity();
            }
        });
    }

    $("#join").click(function () {
        for (let obj of validTargets) {
            let valid = obj.checkValidity();
            if (valid) {
                obj.classList.remove("red-important");
            } else {
                obj.reportValidity();
                obj.focus();
                obj.classList.add("red-important");
                return;
            }
        }
        let fileForm = document.querySelector("#file_form");
        let formData = new FormData(fileForm);
        $.ajax("join", {
            processData: false,
            contentType: false,
            method: "post",
            data: formData,
            dataType: "json",
            success: function (result) {
                if (result.success === "fail") {
                    alert("가입에 실패했습니다.");
                } else {
                    alert("가입되었습니다.");
                    location.href = "../member/login";
                }
            }
        });
    });

    $("#update").click(function () {
        for (let obj of validTargets) {
            let valid = obj.checkValidity();
            if (valid) {
                obj.classList.remove("red-important");
            } else {
                obj.reportValidity();
                obj.focus();
                obj.classList.add("red-important");
                return;
            }
        }
        let fileForm = $("#file_form")[0];
        let formData = new FormData(fileForm);
        $.ajax("update", {
            processData: false,
            contentType: false,
            method: "post",
            data: formData,
            dataType: "json",
            success: function (result) {
                if (result.success === "fail") {
                    alert("정보 수정에 실패했습니다.");
                } else {
                    alert("회원정보가 수정되었습니다.");
                    location.href = "/main";
                }
            }
        });
    });

    document.querySelector("#user_image").addEventListener("error", function () {
        console.log(this);
        this.src = "/profile-picture/default.png";
    })

    $("#user_picture").change(function (event) {
        let reader = new FileReader();
        reader.addEventListener("load", function (event) {
            document.querySelector("#user_image").setAttribute("src", event.target.result);
        });
        reader.readAsDataURL(event.target.files[0]);
    });

    $("#user_id").change(function () {
        $("#join").prop("disabled", true);
        $("#checkDuplicate").prop("disabled", false);
    });

    $("#checkDuplicate").click(function () {
        let $userId = $("#user_id");
        let $join = $("#join");
        let id = $userId.val().trim();
        $userId.val(id);
        let data = {
            id: id
        };
        if (id) {
            $.ajax("api?command=findById", {
                method: "post",
                data: data,
                dataType: "json",
                success: function (data) {
                    if (data) {
                        $join.prop("disabled", true);
                        $userId.focus();
                        alert("중복된 아이디가 존재합니다");
                    } else {
                        $join.prop("disabled", false);
                        $("#checkDuplicate").attr("disabled", true);
                    }
                },
                error: function () {
                    alert("통신 실패입니다");
                }
            });
        } else {
            $userId.val("").focus();
            alert("아이디를 입력하세요");
        }
    });

    document.querySelector("#cancel").addEventListener("click", function () {
        history.back();
    });
})