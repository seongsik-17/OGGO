<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>OGGO-MyPage</title>
<link rel="stylesheet" href="/css/style.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
/* style.css 예시 */
.mypage-nav {
    display: flex;
    gap: 1rem;
    padding: 1rem;
    border-bottom: 2px solid #ff6f61;
    list-style: none;
}

.mypage-nav li {
    cursor: pointer;
    padding: 0.5rem 1rem;
    background: #ff6f61;
    border: 1px solid #ff6f61;
    border-radius: 8px;
    transition: background 0.3s;
    color: white;
}

.mypage-nav li:hover {
    background: #e4e4e4;
}

#result {
    padding: 1.5rem;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 1rem;
}

table th, table td {
    padding: 0.75rem;
    border: 1px solid #ccc;
    text-align: center;
}

table th {
    background-color: #ff6f61;
    color: white;
}

button {
    background-color: #ff6f61;
    color: white;
    border: none;
    padding: 6px 12px;
    border-radius: 5px;
    cursor: pointer;
}

button:disabled {
    background-color: #ff6f61;
    cursor: not-allowed;
}

</style>
</head>
<body>
<jsp:include page="../fragment/header.jsp"/>

<script>
	window.onload = function () {
		showUserInfo();
	}
</script>

<ul class="mypage-nav">
	<li onclick="showUserInfo()">회원정보</li>
	<li onclick="showReservation()">예약현황</li>
	<li onclick="showWish()">찜한여행</li>
	<li onclick="showReview()">작성한 후기</li>
	<li onclick="showQna()">작성한 Q&A</li>
</ul>


<div id="result">
	<table id="userTable">
        <tbody id="ubody"></tbody>
    </table>
</div>

${msg}

<script>
	// 내정보(회원정보) 보기	
	function showUserInfo() {
	    const result = document.getElementById('result');
	    result.innerHTML = `
	        <table id="userTable" border="1">
	            <tbody id="ubody"></tbody>
	        </table>
	    `;

	    const ubody = document.getElementById('ubody');
	    ubody.innerHTML = "";

	    fetch('/user/userInfo')
	        .then(res => res.json())
	        .then(user => {
	            const labels = {
	                user_id: 'ID',
	                name: '이름',
	                email: '이메일',
	                phone: '전화번호',
	                address: '주소',
	                birth_date: '생년월일',
	                mbti: 'MBTI',
	                personalities: '성격',
	                drinking_level: '주량'
	            };

	            for (const key in labels) {
	                const tr = document.createElement('tr');
	                const th = document.createElement('th');
	                const td = document.createElement('td');

	                th.innerText = labels[key];

	                if (key === 'user_id') {
	                    td.innerText = user[key] ?? '-';

	                    const editBtn = document.createElement('button');
	                    editBtn.innerText = '수정하기';
	                    editBtn.style.marginLeft = '10px';
	                    editBtn.onclick = updateInfo;

	                    td.appendChild(editBtn);
	                } else {
	                    td.innerText = user[key] ?? '-';
	                }

	                tr.appendChild(th);
	                tr.appendChild(td);
	                ubody.appendChild(tr);
	            }
	        })
	        .catch(err => {
	            console.error('오류:', err);
	            ubody.innerHTML = '<tr><td colspan="2">회원 정보를 불러올 수 없습니다.</td></tr>';
	        });
	}


	// 회원정보 수정
	function updateInfo(){
		location.href = '/user/beforeUpdateForm';
		//location.href = '/user/updateUserForm';
	}

	
	// 예약현황 보기
	function showReservation() {
    const result = document.getElementById('result');
    result.innerHTML = ""; // 기존 내용 비우기

    fetch('/user/reservationList')
        .then(res => res.json())
        .then(reservations => {
            if (reservations.length === 0) {
                result.innerHTML = "<p>예약된 여행이 없습니다.</p>";
                return;
            }

            const table = document.createElement('table');
            table.border = "1";

            const thead = document.createElement('thead');
            const labels = {
            		//p.product_id, p.title, p.region, p.start_date, r.status
                product_id: '상품번호',
                title: '상품명',
                region: '지역',
                start_date: '시작일',
                end_date: '종료일',
                status: '상태'
            };

            // thead 작성
            const trHead = document.createElement('tr');
            for (const key in labels) {
                const th = document.createElement('th');
                th.innerText = labels[key];
                trHead.appendChild(th);
            }
            thead.appendChild(trHead);
            table.appendChild(thead);

            const tbody = document.createElement('tbody');

            reservations.forEach(res => {
                const tr = document.createElement('tr');

                for (const key in labels) {
                    const td = document.createElement('td');

                    if (key === 'start_date' && res[key]) {
                        td.innerText = new Date(res[key]).toLocaleDateString();
                    } else if (key === 'end_date' && res[key]) {
                        td.innerText = new Date(res[key]).toLocaleDateString();
                    } else if (key === 'title') {
                        const a = document.createElement('a');
                        a.href = `/product/productDetail?product_id=\${res.product_id}`;
                        a.innerText = res[key];
                        td.appendChild(a);
                    } else {
                        td.innerText = res[key] ?? '-';
                    }

                    tr.appendChild(td);
                }

                // 후기쓰기 버튼 칸 추가
                const tdButton = document.createElement('td');

                const today = new Date();
                const endDate = new Date(res.end_date);

                // 종료일이 있고, 종료일이 오늘보다 이전이면 후기쓰기 버튼 생성
                /*
                if (res.end_date && endDate < today) {
                    const btn = document.createElement('button');
                    btn.innerText = "후기쓰기";
                    // 후기쓰기 페이지 이동 예시 (product_id를 쿼리나 경로로 전달)
                    btn.onclick = () => {
                    	location.href = '/reviews/writeReview?product_id=' + encodeURIComponent(res.product_id) + '&title=' + encodeURIComponent(res.title);
                    };
                    tdButton.appendChild(btn);
                */
                if (res.end_date && endDate < today) {
                    const btn = document.createElement('button');
                    btn.innerText = "후기쓰기";
                    btn.disabled = res.review_written; // 이미 작성했으면 비활성화

                    if (!res.review_written) {
                        btn.onclick = () => {
                            location.href = '/reviews/writeReview?product_id=' + encodeURIComponent(res.product_id) + '&title=' + encodeURIComponent(res.title);
                        };
                    } else {
                        btn.title = "이미 작성한 후기입니다";
                    }

                    tdButton.appendChild(btn);
                    
                    
                    
                } else {
                    tdButton.innerText = '-'; // 버튼이 없으면 빈칸 표시
                }

                tr.appendChild(tdButton);

                tbody.appendChild(tr);
            });

            table.appendChild(tbody);
            result.appendChild(table);
        })
        .catch(err => {
            console.error('예약현황 오류:', err);
            result.innerHTML = '<p>예약현황을 불러올 수 없습니다.</p>';
        });
	}

	// 찜한 여행 보기
	function showWish() {
    const result = document.getElementById('result');
    result.innerHTML = ""; // 기존 내용 비우기

    fetch('/user/wishList')
        .then(res => res.json())
        .then(reservations => {
            if (reservations.length === 0) {
                result.innerHTML = "<p>찜한 여행이 없습니다.</p>";
                return;
            }

            const table = document.createElement('table');
            table.border = "1";

            const thead = document.createElement('thead');
            const labels = {
                wishlist_id: '예약번호',
                user_id: '사용자 아이디',
                product_id: '상품 아이디',
                added_at: '찜한 일자',
                delete: '삭제' // 삭제 열 추가
            };

            const trHead = document.createElement('tr');
            for (const key in labels) {
                const th = document.createElement('th');
                th.innerText = labels[key];
                trHead.appendChild(th);
            }
            thead.appendChild(trHead);
            table.appendChild(thead);

            const tbody = document.createElement('tbody');

            reservations.forEach(res => {
                const tr = document.createElement('tr');

                for (const key in labels) {
                    const td = document.createElement('td');

                    if (key === 'added_at' && res[key]) {
                        td.innerText = new Date(res[key]).toLocaleDateString();
                    } else if (key === 'product_id') {
                        const a = document.createElement('a');
                        a.href = `/product/productDetail?product_id=\${res[key]}`;
                        //a.href = "/product/detail/"+{res[key]};
                        a.innerText = res[key];
                        td.appendChild(a);
                    } else if (key === 'delete') {
                        const a = document.createElement('a');
                        a.href = "/user/delWishList/"+res.wishlist_id;
                        a.innerText = "삭제";
                        td.appendChild(a);
                    } else {
                        td.innerText = res[key];
                    }

                    tr.appendChild(td);
                }
                tbody.appendChild(tr);
            });

            table.appendChild(tbody);
            result.appendChild(table);
        })
        .catch(err => {
            console.error('찜한 목록 현황 오류:', err);
            result.innerHTML = '<p>찜한 현황을 불러올 수 없습니다.</p>';
        });
	}


	
	
	// 작성한 후기 보기
	function showReview() {
    const result = document.getElementById('result');
    result.innerHTML = ""; // 기존 내용 비우기

    fetch('/user/reviewList')
        .then(res => res.json())
        .then(reservations => {
            if (reservations.length === 0) {
                result.innerHTML = "<p>남긴 후기가 없습니다.</p>";
                return;
            }

            const table = document.createElement('table');
            table.border = "1";

            const thead = document.createElement('thead');
            const labels = {
                title: '제목',
                rating: '점수',
                created_at: '작성 일자',
                is_public: '공개여부'
            };

            // thead 작성
            const trHead = document.createElement('tr');
            for (const key in labels) {
                const th = document.createElement('th');
                th.innerText = labels[key];
                trHead.appendChild(th);
            }
            thead.appendChild(trHead);
            table.appendChild(thead);

            const tbody = document.createElement('tbody');

            reservations.forEach(res => {
                const tr = document.createElement('tr');

                for (const key in labels) {
                    const td = document.createElement('td');

                    if (key === 'created_at' && res[key]) {
                        td.innerText = new Date(res[key]).toLocaleDateString();
                    } else if (key === 'title') {
                        const a = document.createElement('a');
                        let review_id = res.review_id;
                        console.log(review_id);
                        a.href = "/reviews/detail/" + review_id;
                        a.innerText = res[key];
                        td.appendChild(a);
                    } else {
                        td.innerText = res[key];
                    }

                    tr.appendChild(td);
                }

                tbody.appendChild(tr);
            });

            table.appendChild(tbody);
            result.appendChild(table);
        })
        .catch(err => {
            console.error('후기 목록 오류:', err);
            result.innerHTML = '<p>후기 목록을 불러올 수 없습니다.</p>';
        });
}

	
	
	// 작성한 Q&A 보기
	function showQna() {
    const result = document.getElementById('result');
    result.innerHTML = ""; // 기존 내용 비우기

    fetch('/user/qnaList')
        .then(res => res.json())
        .then(reservations => {
            if (reservations.length === 0) {
                result.innerHTML = "<p>남긴 Q&A가 없습니다.</p>";
                return;
            }

            const table = document.createElement('table');
            table.border = "1";

            const thead = document.createElement('thead');
            const labels = {
            	qna_id: 'Q&A 번호',
                user_id: '사용자 아이디',
                title: '제목',
                created_at: '작성 일자',
                is_answered: '답변여부'
            };

            // thead 작성
            const trHead = document.createElement('tr');
            for (const key in labels) {
                const th = document.createElement('th');
                th.innerText = labels[key];
                trHead.appendChild(th);
            }
            thead.appendChild(trHead);
            table.appendChild(thead);

            
            
            const tbody = document.createElement('tbody');

            reservations.forEach(res => {
                const tr = document.createElement('tr');

                for (const key in labels) {
                    const td = document.createElement('td');

                    if (key === 'created_at' && res[key]) {
                        td.innerText = new Date(res[key]).toLocaleDateString();
                    }else if (key === 'title') {
                    	const a = document.createElement('a');
                        let qna_id = res.qna_id;
                        a.href = "/reviews/detail/" + qna_id;
                    	a.innerText = res[key];
                        td.appendChild(a);
                    }else{
                    	td.innerText = res[key];
                    }

                    tr.appendChild(td);
                }
                tbody.appendChild(tr);
            });

            table.appendChild(tbody);
            result.appendChild(table);
        })
        .catch(err => {
            console.error('Q&A 목록 현황 오류:', err);
            result.innerHTML = '<p>Q&A 현황을 불러올 수 없습니다.</p>';
        });
	}
	
	

</script>


<jsp:include page="../fragment/footer.jsp"/>
</body>
</html>
