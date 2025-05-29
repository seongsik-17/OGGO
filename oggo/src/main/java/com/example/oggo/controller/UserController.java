package com.example.oggo.controller;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.oggo.dao.IUserDao;
import com.example.oggo.dto.LoginDTO;
import com.example.oggo.dto.MyReservationDTO;
import com.example.oggo.dto.PwDTO;
import com.example.oggo.dto.QnaDTO;
import com.example.oggo.dto.RegistDTO;
import com.example.oggo.dto.ReviewDTO;
import com.example.oggo.dto.UserDTO;
import com.example.oggo.dto.WishDTO;
import com.example.oggo.session.UserSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/user")
public class UserController {

	@Autowired
	private IUserDao userDao;
	
	@Autowired
	private UserSession userSession;
	
	/****************로그인/아웃*******************/
	// 로그인 폼으로 이동
	@GetMapping("/login")
	public String login() {
		return "/user/loginForm";
	}
	@GetMapping("/loginForm")
	public String loginForm() {
		return "/user/loginForm";
	}
	// 로그인
	@PostMapping("/login")
	public String login(LoginDTO login, HttpServletRequest request, RedirectAttributes rttr) {

		
		// 사용자는 id, pw만 입력한 상태
		// DB에 해당 아이디가 있으면 count(*) == 1 
		if(userDao.checkId(login.getUser_id())==1) {
			PwDTO saltAndPassword = userDao.getSaltAndPassword(login.getUser_id());
			// 해당 아이디가 가진 DB에 저장된 salt와 암호화된 비밀번호
			String salt = saltAndPassword.getSalt();
			String savePassword = saltAndPassword.getPassword();
			// 로그인할 때 입력했던 비밀번호화 salt를 해싱
			String loginPassword = myEncode.getEncodePw(login.getPassword(), salt);
			UserDTO user = new UserDTO();
			// 두 비밀번호를 비교해서 같으면 로그인 성공!
			if(savePassword.equals(loginPassword)) {
				// 로그인 성공하면 라스트 로그인 시간 업데이트
				userDao.updateLastLogin(login);
				// 유저정보 가져와서
				user = userDao.getUser(login.getUser_id(), loginPassword);
				// 유저세션에 저장
				userSession.login(user);
				// 세션에 저장 후 메인페이지로 이동
				HttpSession session = request.getSession();
				session.setAttribute("userSession", userSession);
				
				return "redirect:/";
//				return "/index";
			}
		}		// 로그인 실패 시 loginForm에서 정보확인 메시지 출력
		rttr.addFlashAttribute("msg", "로그인 정보를 다시 확인하세요.");
		return "redirect:/user/login";
		
		
	}
	// 로그아웃
	@GetMapping("/logout")
	public String logout(HttpServletRequest request, RedirectAttributes rttr) {
	    HttpSession session = request.getSession();
	    session.invalidate();
	    userSession.logout();
	    rttr.addFlashAttribute("msg", "로그아웃되었습니다.");
	    return "redirect:/user/login";
	}
	
	/****************회원가입*******************/
	// 회원가입
	@GetMapping("/registForm")
	public String registForm() {
		return "/user/registForm";
	}
	@PostMapping("/regist")
	public String regist(RegistDTO regist) {
		// 비밀번호 암호화
		// 1. salt 생성
		String salt = mySalt.getSalt();
		// 2. SHA-256 해싱(암호화)
		String encodePassword = myEncode.getEncodePw(regist.getPassword(), salt);
		UserDTO user = new UserDTO();
		// join_date랑 마지막 로그인 시간, role은 dao에서 입력해주기
		user.setUser_id(regist.getUser_id());
		user.setPassword(encodePassword);
		user.setSalt(salt);
		user.setName(regist.getName());
		user.setEmail(regist.getEmail());
		user.setPhone(regist.getPhone());
		user.setAddress(regist.getAddress());
		user.setBirth_date(regist.getBirth_date());
		user.setGender(regist.getGender());
		user.setMbti(regist.getMbti_ei()+regist.getMbti_sn()+regist.getMbti_tf()+regist.getMbti_jp());
		user.setPersonalities(String.join(",", regist.getPersonalities()));
		user.setDrinking_level(regist.getDrinking_level());
		
		// 회원가입 정보 저장
		userDao.regist(user);
		
		// 로그인 화면으로 이동
		return "/user/loginForm";
	}

	// 아이디 중복체크
	@PostMapping("/idChk")
	public @ResponseBody String idChk(@RequestParam("user_id") String id) {
		String result = userDao.checkId(id)==0? "사용가능" : "사용불가";
		return result;
	}
	
	/****************회원정보 수정*******************/
	@GetMapping("/beforeUpdateForm")
	public String beforeUpdateForm(RedirectAttributes rttr) {
		if(userSession.isLoggedIn())
			return "/user/beforeUpdateForm";
		else {
			rttr.addFlashAttribute("msg", "로그인 먼저 하세요.");
			return "redirect:/user/login";
		}
	}
	@PostMapping("/beforeUpdate")
	public String beforeUpdate(@RequestParam("password")String pw, RedirectAttributes rttr) throws ParseException {
		UserDTO user = userSession.getLoginUser();
		String password = user.getPassword();	// DB에 저장된 사용자 암호화pw
		String input_pw = myEncode.getEncodePw(pw, user.getSalt()); // 사용자가 입력한 pw 암호화하기
		if(password.equals(input_pw)) {
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			Date parsedDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(user.getBirth_date());
			user.setBirth_date(sdf.format(parsedDate)); // "yyyy-MM-dd" 문자열로 다시 설정
			
			return "redirect:/user/updateUserForm";
		}else {
			rttr.addFlashAttribute("msg", "비밀번호를 다시 확인하세요.");
			return "redirect:/user/beforeUpdate";
		}
	}
	@GetMapping("/updateUserForm")
	public String updateMemberForm(Model model, RedirectAttributes rttr) {
		if(userSession.isLoggedIn()) {
			UserDTO user = userSession.getLoginUser();
			model.addAttribute("user", user);
			return "/user/updateUserForm";
		}else {
			rttr.addFlashAttribute("msg", "로그인 먼저 하세요.");
			return "redirect:/user/login";
		}
	}
	@PostMapping("/update")
	public String updateMember(RegistDTO regist, HttpServletRequest request) {
		// 비밀번호 암호화
		// 1. salt 생성
		String salt = mySalt.getSalt();
		// 2. SHA-256 해싱(암호화)
		String encodePassword = myEncode.getEncodePw(regist.getPassword(), salt);
				
		UserDTO user = new UserDTO();
		// join_date랑 마지막 로그인 시간, role은 dao에서 입력해주기
		user.setUser_id(regist.getUser_id());
		user.setPassword(encodePassword);
		user.setSalt(salt);
		user.setName(regist.getName());
		user.setEmail(regist.getEmail());
		user.setPhone(regist.getPhone());
		user.setAddress(regist.getAddress());
		user.setBirth_date(regist.getBirth_date());
		user.setGender(regist.getGender());
		user.setMbti(regist.getMbti_ei()+regist.getMbti_sn()+regist.getMbti_tf()+regist.getMbti_jp());
		user.setPersonalities(String.join(",", regist.getPersonalities()));
		user.setDrinking_level(regist.getDrinking_level());
				
		// 회원가입 정보 저장
		userDao.update(user);
		userSession.login(user);
		// 세션에 저장 후 메인페이지로 이동
		HttpSession session = request.getSession();
		session.setAttribute("loginId", user.getUser_id());
		
		return "redirect:/user/myPage";
	}
	
	/****************회원 탈퇴*******************/
	@PostMapping("/delete")
	public String deleteUser(@RequestParam("user_id") String user_id, HttpSession session, RedirectAttributes rttr) {
	    int result = userDao.delete(user_id);
	    if (result > 0) {
	    	 // 세션 종료
	        session.invalidate();
	        userSession.logout();
	        
	        rttr.addFlashAttribute("msg", "회원 탈퇴가 완료되었습니다.");
	        return "redirect:/"; // 메인으로 이동
	    } else {
	        rttr.addFlashAttribute("msg", "탈퇴에 실패했습니다. 다시 시도해주세요.");
	        return "redirect:/user/updateUserForm";
	    }
	}
	
	
	/****************마이페이지*******************/
	@GetMapping("/myPage")
	public String mypage(RedirectAttributes rttr, Model model) {
		// 로그인 안하면 로그인하도록
		if(userSession == null || !userSession.isLoggedIn()) {
			rttr.addFlashAttribute("msg", "로그인 후 이용해주세요");
			return "redirect:/user/login";
		}
		model.addAttribute("user",userSession.getLoginUser());
		return "/user/myPage";
	}
	
	// 회원정보 보기(수정, 탈퇴)
	@GetMapping("/userInfo")
	public @ResponseBody UserDTO userInfo() {
		UserDTO user = userSession.getLoginUser();
		return user;
	}
	
	
	// 내가 예약한 현황
	@GetMapping("/reservationList")
	public @ResponseBody List<MyReservationDTO> reservationList(HttpServletResponse response) throws IOException{
		// 로그인 안하고 페이지 접속 시도 시 반응 없게	
		if (userSession == null || !userSession.isLoggedIn()) {
			return null;
		}
		// 로그인한 유저 정보 가져오기
		UserDTO user = userSession.getLoginUser();
		String user_id = user.getUser_id().trim();
		List<MyReservationDTO> list = userDao.getReservationList(user_id);
		return list;
	}
	
	
	// 찜한 여행목록 현황
	@GetMapping("/wishList")
	public @ResponseBody List<WishDTO> wishList(HttpServletResponse response) throws IOException{
		// 로그인 안하고 페이지 접속 시도 시 반응 없게	
		if (userSession == null || !userSession.isLoggedIn()) {
			return null;
		}
		
		// 로그인한 유저 정보 가져오기
		UserDTO user = userSession.getLoginUser();
		String user_id = user.getUser_id().trim();
		List<WishDTO> list = userDao.getWishList(user_id);
		return list;
	}
	
	// 작성한 후기 리스트
	@GetMapping("/reviewList")
	public @ResponseBody List<ReviewDTO> reviewList(HttpServletResponse response) throws IOException{
		// 로그인 안하고 페이지 접속 시도 시 반응 없게	
		if (userSession == null || !userSession.isLoggedIn()) {
			return null;
		}
		// 로그인한 유저 정보 가져오기
		UserDTO user = userSession.getLoginUser();
		String user_id = user.getUser_id().trim();
		List<ReviewDTO> list = userDao.getReviewList(user_id);
		return list;
	}
	
	// 작성한 QnA 리스트
	@GetMapping("/qnaList")
	public @ResponseBody List<QnaDTO> qnaList() {
		// 로그인 안하고 페이지 접속 시도 시 반응 없게	
		if (userSession == null || !userSession.isLoggedIn()) {
			return null;
		}
		// 로그인한 유저 정보 가져오기
		UserDTO user = userSession.getLoginUser();
		String user_id = user.getUser_id().trim();
		List<QnaDTO> list = userDao.getQnaList(user_id);
		return list;
	}

	/**************찜하기***************/
	@GetMapping("/addWishList/{product_id}")
	public String addWishList(@PathVariable("product_id") String product_id, Model model) {
		// 로그인 안했으면 로그인(dy)
		if (userSession == null || !userSession.isLoggedIn()) {
		    return "redirect:/user/loginForm";
		}else {
			String user_id = userSession.getLoginUser().getUser_id().trim();
			userDao.addWish(product_id, user_id);
		    //return "/product/detail/"; 
		    //return "/product/productDetail?product_id="+product_id;
			return "redirect:/product/productDetail?product_id=tp007";
		}
	}
	
	@GetMapping("/delWishList/{wishlist_id}")
	public String delWishList(@PathVariable("wishlist_id") int wishlist_id) {
		userDao.delWish(wishlist_id);
		return "redirect:/user/myPage";
	}
	
	
	/***************비밀번호 암호화***************/
	@GetMapping("/makeSalt")
	public @ResponseBody String makeSalt() {
		String salt = mySalt.getSalt();
		String password = "1q2w3e4r!";
		return "salt: "+salt+"| encode: "+myEncode.getEncodePw(password, salt);
	}
	
	
	// 솔트값 생성(랜덤)
	
	public class mySalt{
		public static String getSalt() {
			Random random = new Random();
			String salt = "";
			for(int i=0; i<16; i++) {
				int ascii = random.nextInt(94) + 33;           // ascii 코드에서 랜덤값 (공백 등 제외)
				salt += (char)ascii;
			}			
			return salt;
		}
	}
	
	// 입력한 pw + salt를 암호화하기
	
	
	public class myEncode{
		public static String getEncodePw(String password, String salt) {
			
			// 사용자가 입력한 pw랑 랜덤 salt값을 합친 문장
			String input = password + salt;
			int hash = 0;
			// 문자열마다 가중치 연산해서 더하기
	        for (int i = 0; i < input.length(); i++) {
	            char c = input.charAt(i);
	            hash += (c * (i + 1));  // 가중치 곱해서 더함
	        }
	        // 16진수 문자열로 반환
	        return Integer.toHexString(hash);
		}
	}
	
}
