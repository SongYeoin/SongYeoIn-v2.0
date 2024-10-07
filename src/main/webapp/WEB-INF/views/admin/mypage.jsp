<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>송파여성인력센터</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<style>
/* CSS Reset */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

html, body {
	height: auto;
}

body {
	display: flex;
	flex-direction: column;
}

main {
	flex: 1;
	padding-top: 90px;
	overflow-y: auto;
	top: 120px;
	min-height: 100vh;
}

.mypage-wrapper {
	max-width: 700px; 
    margin: 100px auto;
    background-color: #fff;
    padding: 20px;
    border-radius: 15px;
    box-shadow: 0 0 15px rgba(0, 0, 0, 0.3);
}

.mypage-wrapper h2 {
    text-align: center;
    margin-bottom: 20px;
}

.mypage-wrapper table {
    width: 100%; 
    margin-top: 20px; 
    border-collapse: collapse; 
}

.mypage-wrapper input[type="text"],
.mypage-wrapper input[type="password"],
.mypage-wrapper input[type="email"],
.mypage-wrapper input[type="button"],
.mypage-wrapper input[type="submit"] {
    width: calc(100% - 20px);
	margin-top: 7px;
    margin-bottom: 7px;
    padding: 10px;
    font-size: 16px;
    border: 1px solid #ccc;
    border-radius: 5px;
    box-sizing: border-box;
}

.mypage-wrapper input[type="button"],
.mypage-wrapper input[type="submit"] {
    padding: 12px 0;
    cursor: pointer;
    border-radius: 5px;
    width: 100%;
    font-size: 16px;
    cursor: pointer; 
    transition: background-color 0.3s ease; 
}

#updateBtn,
#cancelBtn,
#deleteBtn {
    margin-top: 15px; 
	background-color: #000000; 
    color: #ffffff; 
    cursor: pointer; 
    transition: background-color 0.3s ease; 
}

#updateBtn:hover,
#cancelBtn:hover,
#deleteBtn:hover {
    background-color: #b3b3b3; 
}

input[type="button"]:hover, 
input[type="submit"]:hover {
    background-color: #b3b3b3; 
}

.mypage-wrapper .message {
    color: red;
    font-size: 14px;
    margin-top: 5px;
    min-height: 20px;
}

.message.valid {
    color: green; 
    font-size: 14px; 
    margin-top: 5px; 
}

.mypage-wrapper .button-row {
    display: flex;
    justify-content: space-between;
}

.mypage-wrapper .button-row input[type="button"] {
    width: 48%; 
    margin-bottom: 0; 
}

</style>
<body>
	<!-- 메뉴바 연결 -->
   <%@ include file="../common/header.jsp"%>
   
   
   <main>
   	<div class="mypage-wrapper">
		<h2>My Page</h2>
			<form action="${pageContext.servletContext.contextPath}/admin/mypage" method="post" id="mypage-form">
				<table>
					<tr>
						<td><label for="memberId">아이디</label></td>
						<td colspan="2"><input type="text" name="memberId" id="memberId" value="${sessionScope.loginMember.memberId}" readonly></td>
					</tr>
					<tr>
						<td width=20%><label for="currentPwd">현재 비밀번호</label></td>
						<td colspan="2"><input type="password" name="currentPwd" id="currentPwd" disabled></td>
						<td width=10%><input type="button" id="changePwdBtn" value="변경"></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><span id="currentPwdMsg" class="message"></span></td>
					</tr>
					<tr>
						<td><label for="memberPwd">새 비밀번호</label></td>
						<td colspan="2"><input type="password" name="memberPwd" id="memberPwd" disabled></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><span id="memberPwdType" class="message"></span></td>
					</tr>
					<tr>
						<td><label for="confirmPwd">새 비밀번호 확인</label></td>
						<td colspan="2"><input type="password" name="confirmPwd" id="confirmPwd" disabled></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><span id="memberPwdCheckType" class="message"></span></td>
					</tr>
					<tr>
						<td><label for="memberName">이름</label></td>
						<td colspan="2"><input type="text" name="memberName" id="memberName" value="${sessionScope.loginMember.memberName}" readonly></td>
					</tr>
					<tr>
						<td><label for="memberBirthday">생년월일</label></td>
						<td colspan="2"><input type="text" name="memberBirthday" id="memberBirthday" value="${sessionScope.loginMember.memberBirthday}" readonly></td>
					</tr>
					<tr>
						<td><label for="memberGender">성별</label></td>
						<td colspan="2"><input type="text" name="memberGender" id="memberGender" value="${sessionScope.loginMember.memberGender == 'M' ? '남자' : '여자'}" readonly></td>
					</tr>
					<tr>
						<td><label for="memberPhone">전화번호</label></td>
						<td colspan="2"><input type="text" name="memberPhone" id="memberPhone" value="${sessionScope.loginMember.memberPhone}" readonly></td>
						<td><input type="button" id="changePhoneBtn" value="변경"></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><span id="memberPhoneType" class="message"></span></td>
					</tr>
					<tr>
						<td><label for="memberEmail">이메일</label></td>
						<td colspan="2"><input type="email" name="memberEmail" id="memberEmail" value="${sessionScope.loginMember.memberEmail}" readonly></td>
						<td><input type="button" id="changeEmailBtn" value="변경"></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><span id="memberEmailType" class="message"></span></td>
					</tr>
					<tr>
						<td><label for="memberAddress">주소</label></td>
						<td colspan="2">
                            <input type="text" name="memberAddress" id="memberAddress" value="${sessionScope.loginMember.memberAddress}" readonly>
                        </td>
                        <td><input type="button" id="findAddress" value="주소 검색"></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><span id="memberAddressType" class="message"></span></td>
					</tr>
					<tr>
						<td><label for="memberStreetAddress">도로명주소</label></td>
						<td colspan="2"><input type="text" name="memberStreetAddress" id="memberStreetAddress" value="${sessionScope.loginMember.memberStreetAddress}" readonly></td>
					</tr>
					<tr>
						<td><label for="memberDetailAddress">상세주소</label></td>
						<td colspan="2"><input type="text" name="memberDetailAddress" id="memberDetailAddress" value="${sessionScope.loginMember.memberDetailAddress}"></td>
						<td><input type="button" id="changeAddressBtn" value="변경"></td>
					</tr>
					<tr>
						<td><label for="memberNickname">닉네임</label></td>
						<td colspan="2"><input type="text" name="memberNickname" id="memberNickname" value="${sessionScope.loginMember.memberNickname}" readonly></td>
						<td><input type="button" id="changeNicknameBtn" value="변경"></td>
					</tr>
					<tr>
						<td></td>
						<td colspan="3"><span id="memberNicknameType" class="message"></span></td>
					</tr>
					
					<tr>
						<td colspan="4" align="center"><input type="submit" id="updateBtn" value="수정"></td>
					</tr>
				</table>
			<div class="button-row">
				<input type="button" id="cancelBtn" value="취소">
				<input type="button" id="deleteBtn" value="탈퇴">
			</div>
		</form>
    </div>
	</main>
    
    <jsp:include page="../common/footer.jsp"/>

	<script
		src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	
    <script>
    
    $(document).ready(function() {
    	let updateResult = '${update_result}';
		let deleteResult = '${delete_result}';

		if (updateResult === 'success') {
			alert("정상적으로 수정되었습니다.");
		} else if(updateResult === 'fail') {
			alert("회원정보 수정에 실패하였습니다.");
		} 
		
		if(deleteResult === 'fail') {
			alert("회원 탈퇴에 실패하였습니다.");
		}
    	
        // 취소 버튼 클릭 시 이전페이지
        $("#cancelBtn").click(function() {
            window.location.href = '${pageContext.servletContext.contextPath}/admin/main';
        });

        // 회원탈퇴 버튼 클릭 시 알림창
        $("#deleteBtn").click(function() {
            if (confirm("회원탈퇴 하시겠습니까?")) {
                let form = document.getElementById("mypage-form");
                form.action = "${pageContext.servletContext.contextPath}/admin/delete";
                form.submit();
            }
        });

        // 수정 버튼 클릭 시 동작
        $("#updateBtn").click(function(e) {
            // 입력 필드가 검사 중인 경우 수정을 막음
            if ($('#changeNicknameBtn').val() === '검사' || $('#changeEmailBtn').val() === '검사' || $('#changePwdBtn').val() === '검사'
            		|| $('#changePhoneBtn').val() === '검사' || $('#changeAddressBtn').val() === '검사') {
                e.preventDefault(); // 기본 이벤트(폼 전송) 막기
                alert("검사 중인 항목이 있습니다. \n수정을 완료해주세요.");
            }
        });

        // 비밀번호 변경 버튼 클릭 시 동작
        $('#changePwdBtn').click(function(){
            if ($(this).val() === '변경') {   // 변경 버튼 클릭 시
                $('#currentPwd, #memberPwd, #confirmPwd').prop('disabled', false).prop('readonly', false);
                $('#currentPwd').focus();
                $(this).val('검사');
            } else {    // 검사 버튼 클릭 시
                validatememberPwd();   // 현재 비밀번호 유효성 검사
                if ($('#changePwdBtn').val() === '변경') {	// 모든 유효성 검사 통과되면 입력 필드를 readonly로 변경
                    $('#currentPwd, #memberPwd, #confirmPwd').prop('readonly', true);
                }
            }
        });

        // 현재 비밀번호 유효성 검사 함수
        function validatememberPwd() {
            let currentPwd = $("#currentPwd").val().trim();
            let memberPwd = $("#memberPwd").val().trim();
            let confirmPwd = $("#confirmPwd").val().trim();

            let memberPwdPattern = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*?_])[A-Za-z\d!@#$%^&*?_]{8,16}$/;
            let isValid = true; // 모든 유효성 검사가 통과했는지 확인하는 변수

            // 현재 비밀번호 유효성 검사
            if (currentPwd === "") {
                $("#currentPwdMsg").text("현재 비밀번호는 필수입니다.").removeClass('valid').addClass('invalid');
                isValid = false; // 유효성 검사 실패
            } else {
                let memberId = '${sessionScope.loginMember.memberId}';
                $.ajax({
                    url: "${pageContext.servletContext.contextPath}/admin/check-pwd",
                    type: "post",
                    data: {
                        memberId: memberId,
                        memberPwd: currentPwd
                    },
                    success: function(data) {
                        if (data.trim() === 'pass') {
                            $("#currentPwdMsg").text("현재 비밀번호가 일치합니다.").removeClass('invalid').addClass('valid');
                            validatememberPwdFormat(); // 현재 비밀번호가 일치할 때 새 비밀번호와 새 비밀번호 확인의 유효성 검사 실행
                        } else {
                            $("#currentPwdMsg").text("현재 비밀번호가 일치하지 않습니다.").removeClass('valid').addClass('invalid');
                            isValid = false; // 유효성 검사 실패
                        }
                    },
                    error: function(error) {
                        $("#currentPwdMsg").text("비밀번호 확인 중 오류가 발생하였습니다.").removeClass('valid').addClass('invalid');
                        isValid = false; // 유효성 검사 실패
                    }
                });
            }
            
         	// 새 비밀번호 유효성 검사 함수 호출
            validatememberPwdFormat();

            // 새 비밀번호 유효성 검사 함수
            function validatememberPwdFormat() {
                if (memberPwd === "") {
                    $("#memberPwdType").text("새 비밀번호는 필수입니다.").removeClass('valid').addClass('invalid');
                    isValid = false; // 유효성 검사 실패
                } else if (!memberPwdPattern.test(memberPwd)) {
                    $("#memberPwdType").text("비밀번호는 8~16자의 영문자, 숫자, 특수문자를 모두 포함해야합니다.").removeClass('valid').addClass('invalid');
                    isValid = false; // 유효성 검사 실패
                } else {
                    $("#memberPwdType").text("사용할 수 있는 비밀번호 형식입니다.").removeClass('invalid').addClass('valid');
                }

                // 새 비밀번호 확인 유효성 검사
                if (confirmPwd !== "" && memberPwd === confirmPwd) {
                    $("#memberPwdCheckType").text("비밀번호가 일치합니다.").removeClass('invalid').addClass('valid');
                } else if (confirmPwd !== "" && memberPwd !== confirmPwd) {
                    $("#memberPwdCheckType").text("비밀번호가 일치하지 않습니다.").removeClass('valid').addClass('invalid');
                    isValid = false; // 유효성 검사 실패
                } else {
                    $("#memberPwdCheckType").text("새 비밀번호 확인은 필수입니다.").removeClass('valid').addClass('invalid');
                    isValid = false; // 유효성 검사 실패
                }

                // 모든 유효성 검사가 통과하면 검사 버튼을 변경 버튼으로 체인지
                if (isValid) {
                    $('#changePwdBtn').val('변경');
                } else {
                    $('#changePwdBtn').val('검사'); // 유효성 검사 실패 시 검사 버튼 유지
                }
            }
        }
        
        // 전화번호 변경 버튼 클릭 시
        $('#changePhoneBtn').click(function() {
            if ($(this).val() === '변경') {
                $('#memberPhone').prop('readonly', false); // 입력 필드 활성화
                $('#memberPhone').focus();
                $(this).val('검사'); // 버튼 텍스트 변경
            } else {
                let newPhone = $('#memberPhone').val().trim();
                validatememberPhone(newPhone);	// 유효성 검사
            }
        });
        
     	// 전화번호 유효성 검사 함수
	    function validatememberPhone(memberPhone) {
	        let memberPhonePattern = /^[0-9]{2,3}-[0-9]{3,4}-[0-9]{4}/;
	        if (memberPhone === '') {
	            $("#memberPhoneType").text("전화번호를 입력해주세요.").removeClass('valid').addClass('invalid');
	        } else if (!memberPhonePattern.test(memberPhone)) {
	            $("#memberPhoneType").text("전화번호 형식으로 입력해주세요.").removeClass('valid').addClass('invalid');
	        } else {
	            $("#memberPhoneType").text("").removeClass('invalid').addClass('valid');
	            $('#changePhoneBtn').val('변경'); 
	        }
	    }

     	// 이메일 변경 버튼 클릭 시
        $('#changeEmailBtn').click(function() {
            if ($(this).val() === '변경') {
                $('#memberEmail').prop('readonly', false); // 입력 필드 활성화
                $('#memberEmail').focus();
                $(this).val('검사'); // 버튼 텍스트 변경
            } else {
                let newEmail = $('#memberEmail').val().trim();
                validatememberEmail(newEmail);	// 유효성 검사
            }
        });

        // 이메일 유효성 검사 함수
        function validatememberEmail(memberEmail) {
            let memberEmailPattern = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;

            if (memberEmail === "") {
                $("#memberEmailType").text("이메일은 필수입니다.").removeClass('valid').addClass('invalid');
            } else if (memberEmailPattern.test(memberEmail)) {
                dupCheckmemberEmail(memberEmail);
            } else {
                $("#memberEmailType").text("유효하지 않은 이메일 형식입니다.").removeClass('valid').addClass('invalid');
            }
        }

        // 이메일 중복 체크 함수
        function dupCheckmemberEmail(memberEmail) {
            $.ajax({
                url: "${pageContext.servletContext.contextPath}/admin/check-email",
                type: "post",
                data: {memberEmail: memberEmail},
                success: function(data) {
                    if (data.trim() === 'pass') {
                        $("#memberEmailType").text("사용 가능한 이메일입니다.").removeClass('invalid').addClass('valid');
                        $('#memberEmail').val(memberEmail); // 입력 필드에 값 설정
                        $('#memberEmail').prop('readonly', true); // 입력 필드 비활성화
                        $('#changeEmailBtn').val('변경'); // 버튼 텍스트 원래대로 변경
                    } else {
                        $("#memberEmailType").text("이미 사용 중인 이메일입니다.").removeClass('valid').addClass('invalid');
                    }
                },
                error: function(error) {
                    $("#memberEmailType").text("이메일 확인 중 오류가 발생하였습니다.").removeClass('valid').addClass('invalid');
                }
            });
        }
        
        // 주소 변경 버튼 클릭 시
        $('#changeAddressBtn').click(function() {
            if ($(this).val() === '변경') {
                $(this).val('검사'); // 버튼 텍스트 변경
             	// 주소 검색 버튼 클릭
                $("#findAddress").click(function() {
                	execution_daum_address();
                });
            } else {
                let newAddress = $('#memberAddress').val().trim();
                validatememberAddress(newAddress);	// 유효성 검사
            }
        });
        
    	// 다음 주소 연동
		function execution_daum_address() {
			new daum.Postcode(
					{
						oncomplete : function(data) {
							// 팝업에서 검색결과 항목을 클릭했을 때 실행할 코드

							// 각 주소의 노출 규칙에 따라 주소를 조합한다.
							// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
							let addr = ''; // 주소 변수
							let extraAddr = ''; // 참고항목 변수

							//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
							if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
								addr = data.roadAddress;
							} else { // 사용자가 지번 주소를 선택했을 경우(J)
								addr = data.jibunAddress;
							}

							// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
							if (data.userSelectedType === 'R') {
								// 법정동명이 있을 경우 추가한다. (법정리는 제외)
								// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
								if (data.bname !== ''
										&& /[동|로|가]$/g.test(data.bname)) {
									extraAddr += data.bname;
								}
								// 건물명이 있고, 공동주택일 경우 추가한다.
								if (data.buildingName !== ''
										&& data.apartment === 'Y') {
									extraAddr += (extraAddr !== '' ? ', '
											+ data.buildingName
											: data.buildingName);
								}
								// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
								if (extraAddr !== '') {
									extraAddr = ' (' + extraAddr + ')';
								}
								// 주소변수 문자열과 참고항목 문자열 합치기
								addr += extraAddr;

							} else {
								addr += ' ';
							}

							// 우편번호와 주소 정보를 해당 필드에 넣는다.
							// document.getElementById('sample6_postcode').value = data.zonecode;
							// document.getElementById("sample6_address").value = addr;

							$("#memberAddress").val(data.zonecode);
							$("#memberStreetAddress").val(addr);

							// 상세주소 입력란 disabled 속성 변경 및 커서를 상세주소 필드로 이동한다.
							// document.getElementById("sample6_detailAddress").focus();
							$("#memberDetailAddress").attr("readonly", false);
							$("#memberDetailAddress").focus();
						}
					}).open();
		}
        
     	// 주소 유효성 검사 함수
	 	function validatememberAddress(memberAddress) {
	 		if (memberAddress === '') {
	            $("#memberAddressCodeType").text("주소를 입력해주세요.").removeClass('valid').addClass('invalid');
	        } else {
	            $("#memberAddressCodeType").text("").removeClass('invalid').addClass('valid');
	            $('#changeAddressBtn').val('변경'); 
	        }
	 	}

        // 닉네임 변경 버튼 클릭 시
        $('#changeNicknameBtn').click(function() {
            if ($(this).val() === '변경') { // 변경 버튼 클릭 시
                $('#memberNickname').prop('readonly', false); // 입력 필드 활성화
                $('#memberNickname').focus();
                $(this).val('검사'); // 버튼 텍스트 변경
            } else { // 검사 버튼 클릭 시
                let newNickname = $('#memberNickname').val().trim();
                validatememberNickname(newNickname); // 유효성 검사
            }
        });
        
     	// 닉네임 유효성 검사 함수
	    function validatememberNickname(memberNickname) {
	        let memberNicknamePattern = /^[가-힣a-zA-Z0-9]{2,15}$/;

	        if (memberNickname === "") {
	            $("#memberNicknameType").text("닉네임을 입력해주세요.").removeClass('valid').addClass('invalid');
	        } else if (memberNicknamePattern.test(memberNickname)) {
	        	$("#memberNicknameType").text("").removeClass('invalid').addClass('valid');
                $('#changeNicknameBtn').val('변경'); // 버튼 텍스트 원래대로 변경
	        } else {
	            $("#memberNicknameType").text("닉네임은 2~15자의 한글, 영문자, 숫자만 사용 가능합니다.").removeClass('valid').addClass('invalid');
	        }
	    }
    });
    </script>
</body>
</html>
