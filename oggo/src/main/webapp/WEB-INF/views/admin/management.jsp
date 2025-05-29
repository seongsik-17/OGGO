<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>ManageMentPage</title>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.6.0/dist/echarts.min.js"></script>
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            margin: 0;
            display: flex;
            height: 100vh;
        }

        header {
            width: 220px;
            background-color: #2c3e50;
            color: white;
            padding: 20px 0;
        }

        nav ul {
            list-style: none;
            padding: 0;
        }

        nav ul li {
            padding: 15px 20px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        nav ul li:hover {
            background-color: #34495e;
        }

        nav li.no-hover:hover {
            background-color: inherit;
            cursor: default;
            font-weight: bold;
        }

        nav ul li div {
            color: white;
            text-decoration: none;
        }

        #main {
            flex: 1;
            padding: 20px;
            overflow-y: auto;
            background-color: #f4f6f9;
        }

        h1 {
            background-color: #1abc9c;
            color: white;
            padding: 20px;
            margin: 0;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
            background: white;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        th,
        td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }

        th {
            background-color: #ecf0f1;
            font-weight: bold;
        }

        input[type="text"],
        input[type="date"],
        input[type="submit"] {
            padding: 6px 10px;
            margin: 5px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        input[type="submit"] {
            background-color: #3498db;
            color: white;
            cursor: pointer;
        }

        input[type="submit"]:hover {
            background-color: #2980b9;
        }

        #salesChart {
            background-color: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        input[type="submit"] {
            background-color: #27ae60;
            color: white;
            border: none;
            padding: 9px 18px;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        input[type="submit"]:hover {
            background-color: #1e8449;
        }

        #main2 {
            position: absolute;
            top: 200px;
            /* main 내부의 h2 아래에 배치되도록 조정 */
            left: 250px;
            /* sidebar 너비보다 살짝 오른쪽 */
            z-index: 10;
        }
    </style>
</head>

<body>
    <header>
        <nav>
            <ul>
                <li class="no-hover">OGGO</li>
                <li>
                    <div onclick="getQnAList()">❌미응답QnAList</div>
                </li>
                <li>
                    <div onclick="forbiddenWords()">👮🏼‍♂️필터링된 QnAList</div>
                </li>
                <li>
                    <div onclick="getUserList()">👥 회원 현황</div>
                </li>
                <li>
                    <div onclick="getUser()">🔍 개별 회원 조회</div>
                </li>
                <li>
                    <div onclick="getAllReservation()">📝 예약 전체 조회</div>
                </li>
                <li>
                    <div onclick="getReservationList()">📝 결제확인</div>
                </li>
                <li>
                    <div onclick="productStatistics()">📊 총 매출 보고</div>
                </li>
                <li>
                    <div onclick="monthlySalse()">📈 월별 매출 추세</div>
                </li>
                <li>
                    <div onclick="loadMonthlySalesTable()">🧾 월간 보고서 생성</div>
                </li>
                <li>
                    <div onclick="exitManagement()">🛠 관리자 페이지 나가기</div>
                </li>
            </ul>
        </nav>
    </header>
    <div id="main">
        <h2>관리자용 페이지</h2>
        <p>Version 1.0</p>
        <p>All Copyrights from OGGO</p>
    </div>
    <div id="main2"></div>
    <div id="main3"></div>
    <script>
        function exitManagement() { location.href = '/' }//컨트롤러와 연결 필요!!
        function getQnAList() {
            const main = document.getElementById("main");
            document.getElementById("main2").innerHTML = '<div id="main2"></div>';

            fetch('/getQnAList')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('응답 없음');
                    }
                    return response.json();
                })
                .then(data => {
                    let html = `
                   <h3>QnA 목록</h3>
                   <table border="1">
                       <thead>
                           <tr>
                               <th>식별번호</th>
                               <th>유저 ID</th>
                               <th>제목</th>
                               <th>내용</th>
                               <th>조회수</th>
                               <th>작성일자</th>
                               <th>답변 잔여시간</th>
                               <th>답변달기</th>
                           </tr>
                       </thead>
                       <tbody>
               `;

                    data.forEach((qna, index) => {
                        html += `
                       <tr>
                           <td>\${qna.qna_id}</td>
                           <td>\${qna.user_id}</td>
                           <td>\${qna.title}</td>
                           <td>\${qna.content}</td>
                           <td>\${qna.views}</td>
                           <td>\${qna.created_at}</td>
                           <td id="timer-\${index}">계산 중...</td>
                           <td><input type="text" name="answer" id="answer"><button onclick="replyToQna(\${qna.qna_id})">답변</button></td>
                       </tr>
                   `;
                    });

                    html += `
                       </tbody>
                   </table>
               `;

                    main.innerHTML = html;

                    // 타이머 업데이트
                    data.forEach((qna, index) => {
                        const createdAt = new Date(qna.created_at);
                        const endTime = new Date(createdAt.getTime() + 24 * 60 * 60 * 1000);

                        function updateTimer() {
                            const now = new Date();
                            const diff = endTime - now;
                            const timerEl = document.getElementById(`timer-\${index}`);

                            if (!timerEl) return;

                            if (diff <= 0) {
                                timerEl.innerText = "시간 초과";
                                timerEl.style.color = "red";
                                clearInterval(interval);
                                return;
                            }

                            const hours = Math.floor(diff / (1000 * 60 * 60));
                            const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
                            const seconds = Math.floor((diff % (1000 * 60)) / 1000);

                            timerEl.innerText = `\${hours.toString().padStart(2, '0')}시간 ` +
                                `\${minutes.toString().padStart(2, '0')}분 ` +
                                `\${seconds.toString().padStart(2, '0')}초`;
                        }

                        const interval = setInterval(updateTimer, 1000);
                        updateTimer();
                    });
                })
                .catch(error => {
                    console.error("QnA 데이터를 불러오는 데 실패했습니다:", error);
                    main.innerHTML = "<p>QnA 데이터를 불러오지 못했습니다.</p>";
                });
        }
        //QnA답변
        function replyToQna(qna_id) {
            let answer = document.querySelector("input[name=answer]").value;
            console.log(answer);
            fetch('updateQnA_Ans?qna_id=' + qna_id + '&answer=' + answer)
                .then(response => response.text())
                .then(data => {
                    alert(data)
                    getQnAList();
                })
                .catch(err => {
                    alert(err);
                });

        }


        function getUserList() {
            document.getElementById("main2").innerHTML = '<div id="main2"></div>';
            fetch('/getUserList')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('응답 없음');
                    }
                    return response.json();
                })
                .then(userList => {
                    const main = document.getElementById('main');

                    let html = `
          <table border="1">
            <thead>
              <tr>
                <th>UserID</th><th>비밀번호</th><th>이름</th><th>이메일</th>
                <th>전화번호</th><th>생일</th><th>성별</th><th>주소</th>
                <th>가입일</th><th>역할</th><th>최근로그인</th><th>MBTI</th><th>성향</th><th>주량</th>
                <th>회원정보수정</th>
              </tr>
            </thead>
            <tbody>
        `;

                    userList.forEach(user => {
                        html += `
            <tr>
              <td>\${user.user_id}</td>
              <td>\${user.password}</td>
              <td>\${user.name}</td>
              <td>\${user.email}</td>
              <td>\${user.phone}</td>
              <td>\${user.birth_date}</td>
              <td>\${user.gender}</td>
              <td>\${user.address}</td>
              <td>\${user.join_date}</td>
              <td>\${user.role}</td>
              <td>\${user.lastLogin}</td>
              <td>\${user.mbti}</td>
              <td>\${user.personalities}</td>
              <td>\${user.drinking_level}</td>
              <td><div style="width=100px height=100px" onclick="userInfoUpdate('\${user.user_id}')">회원정보수정</div></td>
            </tr>
          `;
                    });

                    html += `
            </tbody>
          </table>
        `;

                    main.innerHTML = html;
                })
                .catch(error => {
                    const main = document.getElementById('main');
                    alert("데이터 로딩에 실패하였습니다!");
                    return;
                });
        }
        //예약내역 전체 조회
        function getAllReservation(){
           const main = document.getElementById("main");
           fetch('/getAllReservation')
            .then(response => {
                if (!response.ok) {
                    throw new Error('응답없음')
                }return response.json();
            })
            .then(reservationList => {
                console.log(reservationList)
                let html = `
       <table border="1">
         <thead>
           <tr>
             <th>예약번호</th>
             <th>유저ID</th>
             <th>상품ID</th>
             <th>예약일</th>
             <th>예약인원</th>
             <th>total_price</th>
             <th>상태</th>
           </tr>
         </thead>
         <tbody>
     `;

                reservationList.forEach(reservation => {
                    html += `
         <tr>
           <td>\${reservation.reservation_id}</td>
           <td>\${reservation.user_id}</td>
           <td>\${reservation.product_id}</td>
           <td>\${reservation.reservation_date}</td>
           <td>\${reservation.num_people}</td>
           <td>\${reservation.total_price.toLocaleString()}원</td>
           <td>\${reservation.status}</td>
         </tr>
       `;
                });

                html += `
         </tbody>
       </table>
     `;

                document.getElementById('main').innerHTML = html;
            })
            .catch(error => {
                alert("데이터 로딩에 실패하였습니다!");
                return;
            });
        }

        function getReservationList() {
            document.getElementById("main2").innerHTML = '<div id="main2"></div>';
            fetch('/getReservations')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('응답없음')
                    }
                    return response.json();
                })
                .then(reservationList => {
                    console.log(reservationList)
                    let html = `
          <table border="1">
            <thead>
              <tr>
                <th>예약번호</th>
                <th>유저ID</th>
                <th>상품ID</th>
                <th>예약일</th>
                <th>예약인원</th>
                <th>total_price</th>
                <th>상태</th>
                <th>결제확인</th>
              </tr>
            </thead>
            <tbody>
        `;

                    reservationList.forEach(reservation => {
                        html += `
            <tr>
              <td>\${reservation.reservation_id}</td>
              <td>\${reservation.user_id}</td>
              <td>\${reservation.product_id}</td>
              <td>\${reservation.reservation_date}</td>
              <td>\${reservation.num_people}</td>
              <td>\${reservation.total_price.toLocaleString()}원</td>
              <td>\${reservation.status}</td>
              <td><button onclick="checkPayment(\${reservation.reservation_id})">예약확정</button>
            </tr>
          `;
                    });

                    html += `
            </tbody>
          </table>
        `;

                    document.getElementById('main').innerHTML = html;
                })
                .catch(error => {
                    alert("데이터 로딩에 실패하였습니다!");
                    return;
                });
        }

        function getUser() {
            const main = document.getElementById("main");
            document.getElementById("main2").innerHTML = '<div id="main2"></div>';
            main.innerHTML = `
       <form id="userForm">
         <input type="text" name="name" placeholder="성명" required>
         생년월일&nbsp;<input type="date" name="birth_date" >&nbsp;
         <input type="submit" value="찾기">
       </form>
       <div id="result"></div>
     `;

            const form = document.getElementById("userForm");

            form.addEventListener("submit", function (event) {
                event.preventDefault(); // 폼의 기본 제출 방지

                const formData = new FormData(form);
                const queryString = new URLSearchParams(formData).toString();

                fetch("getUser?" + queryString, {
                    method: "GET",
                })
                    .then(response => response.json()) // 서버가 HTML이나 텍스트를 반환할 경우
                    .then(data => {
                        console.log(data);
                        document.getElementById("result").innerHTML = `
         <table>
            <thead>
              <tr>
                <th>UserID</th><th>비밀번호</th><th>이름</th><th>이메일</th>
                <th>전화번호</th><th>생일</th><th>성별</th><th>주소</th>
                <th>가입일</th><th>역할</th><th>최근로그인</th><th>MBTI</th><th>성향</th><th>주량</th>
              </tr>
            </thead>
            <tbody>
               <td>\${data.user_id}</td>
               <td>\${data.password}</td>
               <td>\${data.name}</td>
               <td>\${data.email}</td>
               <td>\${data.phone}</td>
               <td>\${data.birth_date}</td>
               <td>\${data.gender}</td>
               <td>\${data.address}</td>
                 <td>\${data.regDate}</td>
               <td>\${data.role}</td>
               <td>\${data.lastLogin}</td>
               <td>\${data.mbti}</td>
               <td>\${data.personalities}</td>
               <td>\${data.drinking_level}</td>
            </tbody>
         </table>
         `;
                    })
                    .catch(error => {
                        document.getElementById("result").innerHTML = "입력하신 사용자가 존재하지 않습니다!";
                    });
            });
        }

        //통계 차트
        function productStatistics() {
            const main = document.getElementById('main');
            document.getElementById("main2").innerHTML = '<div id="main2"></div>';
            main.innerHTML = `<div id="salesChart" style="width: 1000px; height: 800px;"></div>`; // 차트 전용 div

            var chartDom = document.getElementById('salesChart');
            var myChart = echarts.init(chartDom);

            fetch('/getSalse')
                .then(response => response.json())
                .then(rawData => {
                    const formattedData = rawData.map(item => ({
                        name: item.title,
                        value: item.total_sale
                    }));

                    var option = {
                        title: {
                            text: '상품별 매출 비중',
                            subtext: '매출액 대비 비율',
                            left: 'center'
                        },
                        tooltip: {
                            trigger: 'item'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left'
                        },
                        series: [
                            {
                                name: 'Access From',
                                type: 'pie',
                                radius: '50%',
                                data: formattedData,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                }
                            }
                        ]
                    };
                    myChart.setOption(option);
                })
                .catch(err => {
                    console.error('매출 데이터 로딩 실패:', err);
                    main.innerHTML = '<p>매출 데이터를 불러오는 데 실패했습니다.</p>';
                });

        }
        function monthlySalse() {
            const main = document.getElementById('main');
            document.getElementById("main2").innerHTML = '<div id="main2"></div>';
            main.innerHTML = `<div id="salesChart" style="width: 1200px; height: 1000px;"></div>`;
            var chartDom = document.getElementById('salesChart');
            var myChart = echarts.init(chartDom);

            fetch('/getMonthlySalesDataset')
                .then(response => response.json())
                .then(sourceData => {
                    let option = {
                        legend: {},
                        tooltip: {
                            trigger: 'axis',
                            showContent: false
                        },
                        dataset: {
                            source: sourceData
                        },
                        xAxis: { type: 'category' },
                        yAxis: { gridIndex: 0 },
                        grid: { top: '55%' },
                        series: [], // 아래에서 채움
                    };

                    // 상품 개수만큼 라인 시리즈 추가
                    for (let i = 1; i < sourceData.length; i++) {
                        option.series.push({
                            type: 'line',
                            smooth: true,
                            seriesLayoutBy: 'row',
                            emphasis: { focus: 'series' }
                        });
                    }

                    // pie 차트 추가 (기본은 첫 번째 월인 '1월')
                    option.series.push({
                        type: 'pie',
                        id: 'pie',
                        radius: '30%',
                        center: ['50%', '25%'],
                        emphasis: {
                            focus: 'self'
                        },
                        label: {
                            formatter: '{b}: {@[1]} ({d}%)'
                        },
                        encode: {
                            itemName: 'product',
                            value: 1,
                            tooltip: 1
                        }
                    });

                    // pie 갱신
                    myChart.on('updateAxisPointer', function (event) {
                        const xAxisInfo = event.axesInfo[0];
                        if (xAxisInfo) {
                            const dimension = xAxisInfo.value + 1;
                            myChart.setOption({
                                series: {
                                    id: 'pie',
                                    label: {
                                        formatter: `{b}: {@[${dimension}]} ({d}%)`
                                    },
                                    encode: {
                                        value: dimension,
                                        tooltip: dimension
                                    }
                                }
                            });
                        }
                    });

                    myChart.setOption(option);
                })
                .catch(err => {
                    console.error("월별 매출 데이터 로딩 실패:", err);
                    main.innerHTML = "<p>데이터를 불러오지 못했습니다.</p>";
                });
        }
        function forbiddenWords() {
            const main = document.getElementById("main");
            document.getElementById("main2").innerHTML = '<div id="main2"></div>';
            fetch("/forbiddenWords") // 컨트롤러 또는 JSP 매핑 경로
                .then(response => {
                    if (!response.ok) throw new Error("응답 실패");
                    return response.json();
                })
                .then(data => {
                    console.log(data);
                    let html = `
           <h3>필터링된 QnA리스트</h3>
           <table border="1">
             <thead>
               <tr>
                 <th>식별번호</th>
                 <th>유저 ID</th>
                 <th>제목</th>
                 <th>내용</th>
                 <th>조회수</th>
                 <th>작성일자</th>
                 <th>처리</th>
               </tr>
             </thead>
             <tbody>
         `;

                    data.forEach(qna => {
                        html += `
             <tr>
               <td>\${qna.qna_id}</td>
               <td>\${qna.user_id}</td>
               <td>\${qna.title}</td>
               <td>\${qna.content}</td>
               <td>\${qna.views}</td>
               <td>\${qna.created_at}</td>
               <td><button onclick="deleteForbiddenWord(\${qna.qna_id})">삭제하기</button></td>
             </tr>
           `;
                    });

                    html += `
             </tbody>
           </table>
         `;

                    main.innerHTML = html;
                })
                .catch(err => {
                    console.error("비속어 목록 로딩 실패:", err);
                    main.innerHTML = "<p>비속어 데이터를 불러오지 못했습니다.</p>";
                });
        }
        //비속어가 포함된걸로 감지되어 
        function deleteForbiddenWord(qna_id) {
            alert("qna 삭제 기능에 포함 예정");
        }
        //결제를 확인하면 상태를 변경
        function checkPayment(res_id) {
            const main = document.getElementById("main");
            console.log(res_id);
            fetch("/updateResStatus", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: "res_id=" + encodeURIComponent(res_id)
            })
                .then(result => {
                    console.log("처리 결과:", result);
                    alert("결제 상태가 성공적으로 변경되었습니다.");
                    //결제정보 다시 호출
                    getReservationList();
                })
                .catch(err => {
                    console.error("에러:", err);
                    main.innerHTML = '<p>처리 실패</p>';
                });
        }

        function loadMonthlySalesTable() {
            const main = document.getElementById("main");
            const main2 = document.getElementById("main2");
            const main3 = document.getElementById("main3");
            main.innerHTML = `
      <h2>기간별 실적 조회</h2>
      <hr>
      <label for="monthInput">조회할 월:</label>
      <input type="month" id="monthInput" name="month">
      <button onclick="monthlyCount()">조회</button>
      `;
            main.after(main2);
            main2.after(main3);

        }
        function monthlyCount() {
            const selectedMonth = document.getElementById("monthInput").value;
            if (!selectedMonth) {
                alert("월을 선택하세요.");
                return;
            }

            const chartDom = document.getElementById('main2');
            chartDom.innerHTML = `<div id="monthlyChart" style="width: 1200px; height: 800px;"></div>`;
            const myChart = echarts.init(document.getElementById('monthlyChart'));

            fetch(`/monthlyCount?month=\${selectedMonth}`)
                .then(response => response.json())
                .then(data => {
                    if (!data || data.length === 0) {
                        alert("해당 달에는 데이터가 없습니다!")
                        return;
                    }
                    const titles = data.map(item => item.title);         // 상품명
                    const sales = data.map(item => item.total_sales);    // 매출 값

                    const option = {
                            title: {
                                text: `${selectedMonth} 상품별 매출`,
                                left: 'center',
                                textStyle: {
                                    fontSize: 24,         // 제목 글자 크기
                                    fontWeight: 'bold'
                                }
                            },
                            grid:{
                                bottom: 250, // x축 글자 확보
                            },
                            tooltip: {
                                trigger: 'axis',
                                formatter: '{b}<br/>매출: {c}원',
                                textStyle: {
                                    fontSize: 16          // 툴팁 글자 크기
                                }
                            },
                            xAxis: {
                                type: 'category',
                                data: titles,
                                axisLabel: {
                                    fontSize: 18,// X축 글자 크기
                                    rotate: 30,
                                    color: '#333'
                                }
                            },
                            yAxis: {
                                type: 'value',
                                axisLabel: {
                                    formatter: function (value) {
                                        return value.toLocaleString(); // 1,000 단위 구분
                                    },
                                    fontSize: 20,         // Y축 글자 크기
                                    color: '#333'
                                }
                            },
                            series: [
                                {
                                    name: '매출',
                                    data: sales,
                                    type: 'bar',
                                    itemStyle: {
                                        color: '#3498db'
                                    },
                                    label: {
                                        show: true,
                                        position: 'top',
                                        fontSize: 20       // 막대 위의 데이터 라벨 글자 크기
                                    }
                                }
                            ]
                        };


                    myChart.setOption(option);
                })
                .catch(error => {
                    console.error("월별 매출 데이터 로딩 실패:", error);
                    chartDom.innerHTML = "<p>데이터를 불러오는 데 실패했습니다.</p>";
                });
        }

        //회원정보 수정
        function userInfoUpdate(userId) {
            const main = document.getElementById("main");
            fetch('getUserById?user_id=' + userId)
                .then(response => response.json())
                .then(data => {
                    main.innerHTML = `
            <form id="userUpdateForm">
               <input type="text" name="user_id" id="user_id" value="\${data.user_id}" readonly>
               <input type="text" name="password" id="password" value="\${data.password}">
               <input type="text" name="name" id="name" value="\${data.name}">
               <input type="text" name="email" id="email" value="\${data.email}">
               <input type="text" name="phone" id="phone" value="\${data.phone}">
               <input type="submit" value="변경하기">
            </form>   
               `;
                    document.getElementById("userUpdateForm").addEventListener("submit", function (event) {
                        event.preventDefault(); // 새로고침 방지

                        const formData = new FormData(this);

                        fetch("/userInfoUpdate", {
                            method: "POST",
                            body: formData
                        })
                            .then(res => res.text())
                            .then(msg => {
                                alert(msg);
                                getUserList();

                            })
                            .catch(err => {
                                alert("오류발생:" + err);
                                console.error(err);
                            });
                    });

                })
                .catch(err => {
                    alert("오류!");
                })

        }
    </script>
</body>

</html>