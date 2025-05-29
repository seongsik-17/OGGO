package com.example.oggo.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.oggo.dao.IQnaDao;
import com.example.oggo.dao.IReservationDao;
import com.example.oggo.dao.IStasticsDao;
import com.example.oggo.dao.IUserDao;
import com.example.oggo.dto.MonthlyStatisticsDTO;
import com.example.oggo.dto.QnaDTO;
import com.example.oggo.dto.ReservationDTO;
import com.example.oggo.dto.TotalSalseDTO;
import com.example.oggo.dto.UserDTO;
import com.example.oggo.session.UserSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {
	@Autowired
	private IQnaDao qnadao;
	@Autowired
	private IUserDao userdao;
	@Autowired
	private IReservationDao reservationdao;
	@Autowired
	private IStasticsDao istasticsdao;

	// 세션 및 인증관리(dy)
	@Autowired
	private UserSession userSession;

	@GetMapping("/management")
	public String mamgementPage(Model model, HttpServletRequest request) {
		// 로그인한 사용자 세션활용(dy)
		HttpSession session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			return "redirect:/";
		}
		
		List<QnaDTO> qnaList = qnadao.selectQna();
		// System.out.println(qnaList);
		model.addAttribute("qnaList", qnaList);
		// 통계 데이터 전송

		return "/admin/management";
	}

	@GetMapping("/getQnAList")
	public @ResponseBody List<QnaDTO> getQnaList(HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
		List<QnaDTO> list = qnadao.selectQna();
		System.out.println(list);
		return list;
		}
	}

	@GetMapping("/getUserList")
	public @ResponseBody List<UserDTO> userList(HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
			
		
		List<UserDTO> userList = userdao.selectUserList();
		// System.out.println(userList);
		return userList;
		}
	}

	@GetMapping("/getUser")
	public @ResponseBody UserDTO userByName(UserDTO user, HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
		System.out.println(user);
		UserDTO getUser = userdao.serchUserInfo(user);
		System.out.println(getUser);
		return getUser;
		}
	}

	@GetMapping("/getReservations")
	public @ResponseBody List<ReservationDTO> Reservations(HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
		List<ReservationDTO> reservationList = reservationdao.selectReservation();
		// System.out.println(reservationList);
		return reservationList;
		}
	}

	@GetMapping("/getSalse")
	public @ResponseBody List<TotalSalseDTO> getSalse(HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
		List<TotalSalseDTO> totalSalse = istasticsdao.totalSalse();
		// System.out.println(totalSalse);
		return totalSalse;
		}
	}

	@GetMapping("/getMonthlySalesDataset")
	@ResponseBody
	public List<List<Object>> getMonthlySalesDataset(HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
			
		List<MonthlyStatisticsDTO> stats = istasticsdao.selectMonthlyProductSales();
		// dto: title, month (1~12), total_sales

		// Map<상품명, Double[12]> 생성
		Map<String, Double[]> productMonthlyMap = new LinkedHashMap<>();
		for (MonthlyStatisticsDTO dto : stats) {
			String title = dto.getTitle();
			int monthIdx = Integer.parseInt(dto.getMonth()) - 1;

			productMonthlyMap.putIfAbsent(title, new Double[12]);
			productMonthlyMap.get(title)[monthIdx] = (double) dto.getTotal_sales();
		}

		// dataset.source 형태로 변환
		List<List<Object>> source = new ArrayList<>();
		source.add(Arrays.asList("product", "1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"));

		for (Map.Entry<String, Double[]> entry : productMonthlyMap.entrySet()) {
			List<Object> row = new ArrayList<>();
			row.add(entry.getKey());
			for (int i = 0; i < 12; i++) {
				row.add(entry.getValue()[i] != null ? entry.getValue()[i] : 0.0);
			}
			source.add(row);
		}

		return source;
		}
	}

	@GetMapping("/forbiddenWords")
	public @ResponseBody List<QnaDTO> forbiddenWords(HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
		List<QnaDTO> forbiddenWords = qnadao.selectForbiddenWords();
		System.out.println(forbiddenWords);
		return forbiddenWords;
		}
	}
	@GetMapping("/monthlyCount")
	public @ResponseBody List<MonthlyStatisticsDTO> monthlyCount(@RequestParam("month")String date) {
		String year = date.substring(0, 4);   // "2025"
	    String month = date.substring(5, 7);  // "05"
	    System.out.println(date);
	    List<MonthlyStatisticsDTO> list = istasticsdao.selectMonthlySalesByYearAndMonth(year, month);
	    return list;
		
	}

	@PostMapping("/updateResStatus")
	public @ResponseBody String updateResStatus(@RequestParam("res_id") int res_id, HttpServletResponse response) throws IOException {
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			response.sendRedirect("redirect:/user/login");
			return null;
		// 관리자가 아니면 메인으로
		}else if(!userSession.getLoginUser().getRole().equals("admin")) {
			response.sendRedirect("redirect:/");
			return null;
		}else {
		reservationdao.updateResStatus(res_id);
		return "예약 ID " + res_id + "의 결제 상태가 변경되었습니다.";
		}

	}
	@GetMapping("updateQnA_Ans")
	   public @ResponseBody String insertQnA_Ans(QnaDTO qna_ans){
	      int result = qnadao.updateQnA_Ans(qna_ans);
	      if(result == 1) {
	         return "답변 성공";
	      }return "등록 실패";
	   }

	@GetMapping("/getAllReservation")
	   public @ResponseBody List<ReservationDTO> allReservations(){
	      List<ReservationDTO> list = reservationdao.selectAllReservation();
	      return list;
	   }



}
