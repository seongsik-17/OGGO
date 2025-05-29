package com.example.oggo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.oggo.dao.IQnaDao;
import com.example.oggo.dto.QnaDTO;
import com.example.oggo.session.UserSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/qna") // 모든 메서드의 기본 경로가 /qna로 시작한다는 의미
public class QnaController {

	@Autowired
	private IQnaDao qnaDao;
	
	// 세션 및 인증관리(dy)
	@Autowired
	private UserSession userSession;

	// QnA 검색 자동완성
	@GetMapping("/autocomplete")
	@ResponseBody
	public List<String> autocomplete(@RequestParam("keyword") String keyword) {
	    return qnaDao.autocomplete(keyword);  // title 또는 tag에서 LIKE 검색
	}
	
	// QnA 목록 조회
	@GetMapping("/list")
	public String list(Model model,@RequestParam(value = "keyword", required = false) String keyword) {
		List<QnaDTO> list;
		
		if (keyword != null && !keyword.isEmpty()) {
			list = qnaDao.QnaSearch(keyword);
		}else {
			list = qnaDao.QnaList();
		}
		model.addAttribute("qnaList", list);
		return "/qna/qnaBoard";
	}

	// QnA 상세 조회
	@GetMapping("/detail/{id}")
	public String detail(@PathVariable("id") int id, Model model) {
		qnaDao.increaseViews(id); //조회수 증가
		QnaDTO qnaDTO = qnaDao.QnaDetail(id);
		System.out.println(qnaDTO);
		model.addAttribute("qna", qnaDTO);
		return "/qna/detail";
	}
	
	   //FAQ 목록 조회
	   @GetMapping("/faqList")
	   public String faqList(Model model) {
	       List<QnaDTO> faqList = qnaDao.selectFaqList(); // 조회수 100 이상/답변 있는 것만
	       model.addAttribute("faqList", faqList);
	       return "/qna/faq";
	   }

	// QnA 게시글 작성 폼
	@GetMapping("/write")
	public String writeForm(HttpServletRequest request, Model model) {//HttpSession session) {
		// 로그인한 사용자 세션활용(dy)
		HttpSession session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}else {
		/*
		//유저 임시 데이터 세션에 저장
		session.setAttribute("user_id", "user1234");
		if(session.getAttribute("user_id") == null) {
			return "redirect:/index";
		}
		*/
		//String user_id = (String)session.getAttribute("user_id");
		//model.addAttribute("userId", user_id);
		model.addAttribute("user_id", userSession.getLoginUser().getUser_id());
		return "/qna/write";
		}
	}

	// QnA 등록 처리
	@PostMapping("/write")
	public String write(QnaDTO dto) {
		System.out.println(dto);
		qnaDao.regQna(dto);
		return "redirect:/qna/list";
	}
	
	// QnA 삭제 (작성자 본인만)
	@PostMapping("/delete/{id}")
	public String delete(@PathVariable("id") int id, HttpServletRequest request) { //HttpSession session) {
	    QnaDTO dto = qnaDao.QnaDetail(id);
//	    String loginUserId = (String) session.getAttribute("user_id");
//	    if (dto == null) {
//	        return "redirect:/qna/list";
//	    }
	    //로그인한 사용자 세션활용(dy)
	    HttpSession session = request.getSession();
	    userSession = (UserSession) session.getAttribute("userSession");
	    // 세션이 없거나 login을 안했으면 로그인 폼으로
	    if (userSession == null || !userSession.isLoggedIn()) {
	    	return "redirect:/user/loginForm";
	    }
	    // 로그인한 user와 게시글 작성자 id가 같을 경우에만 삭제
	    if(userSession.getLoginUser().getUser_id().equals(dto.getUser_id())) {
	    	// 본인만 삭제 가능
//		    if (loginUserId.equals(dto.getUser_id())) {
		        qnaDao.deleteQna(id);
//		    }
	    }
	    
	    return "redirect:/qna/list";

	    
	}
	
	

}