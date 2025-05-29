package com.example.oggo.controller;

import java.util.List;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.oggo.dao.IReviewDao;
import com.example.oggo.dto.ReviewDTO;
import com.example.oggo.dto.ReviewListDTO;
import com.example.oggo.dto.UserDTO;
import com.example.oggo.dto.WriteReviewDTO;
import com.example.oggo.session.UserSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reviews")
public class ReviewsController {
	
	@Autowired
	private IReviewDao reviewDao;
	// 세션 및 인증관리(dy)
	@Autowired
	private UserSession userSession;
	
	@GetMapping("/writeReview")
	public String writeReview(@RequestParam(value = "product_id", required = false) String product_id,
			@RequestParam(value="title", required=false)String title, Model model,
			HttpServletRequest request) {
		// product_id가 없을 경우 index로 보내기(dy)
		if (product_id == null || product_id.trim().isEmpty() 
				|| title == null || title.trim().isEmpty()) {
		    return "redirect:/reviews/list";
		}else {
			
			HttpSession session = request.getSession();
			userSession = (UserSession) session.getAttribute("userSession");
			// 세션이 없거나 login을 안했으면 로그인 폼으로
			if (userSession == null || !userSession.isLoggedIn()) {
				return "redirect:/user/loginForm";
			}
			model.addAttribute("userSession", userSession);
			model.addAttribute("product_id",product_id);
			model.addAttribute("product_title",title);
			return "/reviews/reviewForm";
		}
	}
	@PostMapping("/writeReview")
	public String write(WriteReviewDTO insert, Model model) {
		ReviewDTO review = new ReviewDTO();
		review.setUser_id(insert.getUser_id());
		review.setProduct_id(insert.getProduct_id());
		review.setRating(insert.getRating());
		review.setTitle(insert.getTitle());
		review.setContent(insert.getContent());
		review.setIs_public(insert.getIs_public());
		// 작성한 review 저장
		reviewDao.insert(review);
		
		 // 랜덤 쿠폰 코드 생성
	    String couponCode = generateCouponCode();
	    model.addAttribute("couponCode", couponCode);

	    return "/reviews/couponModal"; // JSP에서 모달로 표시
		
		//return "redirect:/user/myPage";
	}
	
	 // 작성한 리뷰 상세 보기
	@GetMapping("/detail/{review_id}")
	public String detail(@PathVariable("review_id") String review_id, Model model, HttpServletRequest request) {
		
	    ReviewDTO review = reviewDao.detail(review_id);
	    
	    // 존재하지 않는 리뷰인 경우 리스트로 보내기
	    if (review == null) {
	        return "redirect:/reviews/list";
	    }
	    
	    // 공개여부 체크
	    if ("F".equals(review.getIs_public())) {
	    	HttpSession session = request.getSession();
	        UserSession userSession = (UserSession) session.getAttribute("userSession");
	        if (userSession == null || !userSession.isLoggedIn()) {
	            return "redirect:/user/loginForm";
	        }

	        UserDTO loginUser = userSession.getLoginUser();
	        if (!review.getUser_id().equals(loginUser.getUser_id())) {
	            return "redirect:/reviews/list"; // 다른 사용자는 접근 불가
	        }
	    }
	    
	    // 로그인한 사용자 세션활용(dy)
	    HttpSession session = request.getSession();
	    userSession = (UserSession) session.getAttribute("userSession");
	    // 세션이 없거나 login을 안했으면 guest
	    if (userSession == null || !userSession.isLoggedIn()) {
	    	model.addAttribute("loginId", "guest");
	    }else {	// login했으면 user_id를 저장
	        model.addAttribute("loginId", userSession.getLoginUser().getUser_id());
	    }
	    
	    
	    model.addAttribute("review", review);
	    return "/reviews/detail"; 
	}

    // 수정 폼으로 이동
    @GetMapping("/updateForm/{id}")
    public String updateForm(@PathVariable("id") String review_id, Model model, HttpServletRequest request) {
    	ReviewDTO review = reviewDao.detail(review_id);
    	
    	// 존재하지 않는 리뷰인 경우 리스트로 보내기
	    if (review == null) {
	        return "redirect:/reviews/list";
	    }
	    
	    // 공개여부 체크
	    if ("F".equals(review.getIs_public())) {
	    	HttpSession session = request.getSession();
	        UserSession userSession = (UserSession) session.getAttribute("userSession");
	        if (userSession == null || !userSession.isLoggedIn()) {
	            return "redirect:/user/loginForm";
	        }

	        UserDTO loginUser = userSession.getLoginUser();
	        if (!review.getUser_id().equals(loginUser.getUser_id())) {
	            return "redirect:/reviews/list"; // 다른 사용자는 접근 불가
	        }
	    }
    	
        model.addAttribute("review", review);
        return "/reviews/updateForm";
    }

    // 수정 처리
    @PostMapping("/update")
    public String update(@ModelAttribute ReviewDTO review) {
        reviewDao.update(review);
        return "redirect:/reviews/detail/" + review.getReview_id();
    }

    // 삭제 처리
    @PostMapping("/delete/{id}")
    public String delete(@PathVariable("id") String reviewId) {
        reviewDao.delete(reviewId);
        return "redirect:/user/myPage"; 
    }
   
    @GetMapping("/list")
    public String list(Model model){
    	List<ReviewListDTO> list = reviewDao.getList();
    	model.addAttribute("list",list);
    	return "/reviews/list";
    }
    
    // 쿠폰 발급(랜덤 수)
    private String generateCouponCode() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        StringBuilder sb = new StringBuilder();
        Random random = new Random();
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return "OGGO-" + sb.toString();
    }
    
}
