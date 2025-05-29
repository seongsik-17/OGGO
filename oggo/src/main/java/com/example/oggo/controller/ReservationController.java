package com.example.oggo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.oggo.dao.IProductDao;
import com.example.oggo.dao.IReservationDao;
import com.example.oggo.dto.ProductDTO;
import com.example.oggo.dto.ReservationDTO;
import com.example.oggo.session.UserSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reservation")
public class ReservationController {

	private IReservationDao reservationDao;
	private IProductDao productDao;

	// 세션 및 인증관리(dy)
	@Autowired
	private UserSession userSession;

	@Autowired
	public ReservationController(IReservationDao dao, IProductDao dao2) {
		reservationDao = dao;
		productDao = dao2;
	}

	@GetMapping("/reservateForm")
	public String reservateForm(Model model, HttpSession session,
			@RequestParam(value = "product_id", required = false) String product_id, HttpServletRequest request,
			RedirectAttributes redirectAttributes) {

		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			redirectAttributes.addFlashAttribute("message", "로그인 후 이용해주세요");
			return "redirect:/user/loginForm";
		}

		// product_id가 없을 경우 index로 보내기(dy)
		if (product_id == null || product_id.trim().isEmpty()) {
			return "redirect:/";
		} else {
			ProductDTO product = productDao.getOne(product_id);
			System.out.println(product);
			model.addAttribute("product", product);
			return "/reservation/writeReservationForm";
		}
	}

	@PostMapping("/reservate")
	public String reservate(ReservationDTO reservation, RedirectAttributes redirectAttributes) {
//		System.out.println(reservation);
		int left_seats = reservation.getNum_people();
//		System.out.println(left_seats);
		String product_id = reservation.getProduct_id();
		String status;
		ProductDTO product = productDao.getOne(product_id);
		if (product.getLeft_seats() == 0) {
			redirectAttributes.addFlashAttribute("message", "죄송합니다. 품절되었습니다.");
			return "redirect:/product/productlist";
		}
		if (left_seats == product.getLeft_seats()) {
			status = "DISABLED";
		} else {
			status = "AVAILABLE";
		}
		reservationDao.rwrite(reservation);
		productDao.pupdate(product_id, left_seats, status);
		redirectAttributes.addFlashAttribute("message", "예약이 완료되었습니다!");
		return "redirect:/product/productlist";
	}

	/*
	 * MyPage에서 구현(dy)
	 * 
	 * @GetMapping("/reservationDetail") public String
	 * reservationDetail(@RequestParam("reservation_id")String reservation_id,Model
	 * model) { ReservationDTO reservation = reservationDao.getOne(reservation_id);
	 * model.addAttribute("reservation",reservation); return
	 * "/reservation/reservationDetail"; }
	 * 
	 * 
	 * @GetMapping("/myReservation") public String myReservation(Model
	 * model,HttpSession session) { session.setAttribute("user_id", "OGGO");//현재는
	 * 세션이 없어서 임의로 넣은 값(지워야 함) String user_id =
	 * (String)session.getAttribute("user_id"); List<ReservationDTO> list =
	 * reservationDao.getMyList(user_id); model.addAttribute("list",list); return
	 * "/reservation/myReservation"; }
	 */

	@GetMapping("/getlist")
	public String getlist(Model model, HttpServletRequest request) {
		// 로그인한 사용자 세션활용(dy)
		HttpSession session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
			// 관리자가 아니면 메인으로
		} else if (!userSession.getLoginUser().getRole().equals("admin")) {
			return "redirect:/";
		}
		List<ReservationDTO> list = reservationDao.getList();
		model.addAttribute("list", list);
		return "/reservation/myReservation";
	}

	@PostMapping("/rdelete")
	public String deleteReservation(@RequestParam("reservation_id") String reservation_id) {
		reservationDao.rdelete(reservation_id);
		return "redirect:/reservation/reservationlist";
	}

}
