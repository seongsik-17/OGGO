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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.oggo.dao.ITeamDao;
import com.example.oggo.dto.TeamDTO.TeamPostDTO;
import com.example.oggo.session.UserSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/team")
public class TeamController {
	@Autowired
	private ITeamDao teamDao;
	
	// 세션 및 인증관리(dy)
	@Autowired
	private UserSession userSession;

	// 동행구하기 목록 조회
	@GetMapping("/list")
	public String list(Model model) {
		List<TeamPostDTO> list = teamDao.TeamList();

		// 모집상태 (모집인원이 다 차면 상태 변화)
		for (TeamPostDTO post : list) {
		    if (post.getCurrent_members() >= post.getTotal_members() && !"마감".equals(post.getStatus())) {
		        post.setStatus("마감");
		        teamDao.updateStatus(post.getPost_id(), "마감"); 
		    }
		}
		model.addAttribute("teamList", list);
		return "/team/teamBoard";
	}

	// 동행구하기 게시글 작성 폼
	@GetMapping("/write")
	public String writeForm(HttpSession session, Model model, HttpServletRequest request) {
		
		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}
			
		// 유저 임시 데이터 세션에 저장
		session.setAttribute("user_id", userSession.getLoginUser().getUser_id());
		if (session.getAttribute("user_id") == null) {
			return "redirect:/team/list";
		}
		

		// 여행 상품 리스트 불러오기
		List<TeamPostDTO> productList = teamDao.ProductsList();
		model.addAttribute("productList", productList);
		return "/team/write";
	}

	// 동행 구하기 게시글 등록
	@PostMapping("/write")
	public String writePost(TeamPostDTO postDTO, HttpSession session, Model model, HttpServletRequest request) {

		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}
		
		// 작성자 자동 세팅
		String user_id = (String) session.getAttribute("user_id");
		
		
		postDTO.setUser_id(user_id);

		teamDao.regPost(postDTO);

		return "redirect:/team/list";
	}

	@GetMapping("/detail/{post_id}")
	public String detail(@PathVariable("post_id") int post_id, HttpSession session, Model model, HttpServletRequest request) {
		
		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}
		
	    TeamPostDTO dto = teamDao.TeamDetail(post_id);

	    // 세션에서 현재 로그인한 사용자 아이디 가져오기
	    //String currentUser = (String) session.getAttribute("user_id");
	    // 세션에 저장한 로그인 수정(dy)
	    String currentUser = userSession.getLoginUser().getUser_id();
	    
	    model.addAttribute("team", dto);

	    // 작성자인지 여부 체크 (dto.getUser_id()로 수정)
	    boolean isOwner = currentUser != null && currentUser.equals(dto.getUser_id());
	    model.addAttribute("isOwner", isOwner);

	    // 참여 여부 체크 (0 or 1)
	    int hasParticipated = 0;
	    if (currentUser != null) {
	    	hasParticipated = teamDao.hasParticipated(post_id, currentUser);
	    }
	    model.addAttribute("hasParticipated", hasParticipated == 1);

	    return "/team/detail";
	}
	

	// 기존 글 수정 폼
	@GetMapping("/write/{post_id}")
	public String editForm(@PathVariable("post_id") int postId, Model model, HttpSession session, HttpServletRequest request) {
		
		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}
		
	    TeamPostDTO dto = teamDao.TeamDetail(postId);
	    model.addAttribute("team", dto); 
	    //String loginUserId = (String) session.getAttribute("user_id");
	    // 세션에 저장한 로그인 수정(dy)
	    String loginUserId = userSession.getLoginUser().getUser_id();

		// 여행 상품 리스트 불러오기
		List<TeamPostDTO> productList = teamDao.ProductsList();
		model.addAttribute("productList", productList);
		
		//게시글이 존재하지 않거나, 로그인 정보가 없을 경우 목록으로 이동
	    if (dto == null || loginUserId == null) {
	        return "redirect:/team/list";
	    }
	    
	    // 본인 글이 아닐 경우 목록으로 이동
	    if (!loginUserId.equals(dto.getUser_id())) {
	        return "redirect:/team/list";
	    }
	    
	    
	    return "/team/write";
	}
	
	// 수정하기
	@PostMapping("/update/{post_id}")
	public String updatePost(@PathVariable("post_id") int post_id,
	                         TeamPostDTO dto,
	                         HttpSession session,
	                         HttpServletRequest request) {
		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}
		
		
	    // 현재 참여 인원 조회
	    int current_members = teamDao.currentMembers(post_id);

	    // 총 모집 인원 변경 반영
	    int total_members = dto.getTotal_members();

	    System.out.println("현재 참여 인원: " + current_members + ", 총 인원: " + total_members);
	    
	    // 모집 상태 판단
	    if (current_members >= total_members) {
	    	dto.setStatus("마감");
	    } else {
	    	dto.setStatus("모집 중");
	    }
	    

		// 게시글 수정 처리
		dto.setPost_id(post_id);
	    teamDao.updateTeamPost(dto);
	    return "redirect:/team/detail/" + post_id;
	}

	//게시글 삭제
	@PostMapping("/delete/{id}")
	public String delete(@PathVariable("id") int id, HttpSession session, HttpServletRequest request) {
		
		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}
		
		TeamPostDTO dto = teamDao.TeamDetail(id);

		//게시글이 존재하지 않거나, 로그인 정보가 없을 경우 목록으로 이동
	    //String loginUserId = (String) session.getAttribute("user_id");
		// 세션에 저장한 로그인 수정(dy)
		String loginUserId = userSession.getLoginUser().getUser_id();
	    
	    
	    if (dto == null || loginUserId == null) {
	        return "redirect:/team/list";
	    }

	    // 본인만 삭제 가능
	    if (loginUserId.equals(dto.getUser_id())) {
		teamDao.deleteTeamPost(id);
	    }

	    return "redirect:/team/list";
	}
	    	    

	// 참여 신청 처리
	@PostMapping("/participate")
	public String participate(@RequestParam("post_id") int post_id, HttpSession session, RedirectAttributes rttr, HttpServletRequest request) {
		
		// 로그인한 사용자 세션활용(dy)
		session = request.getSession();
		userSession = (UserSession) session.getAttribute("userSession");
		// 세션이 없거나 login을 안했으면 로그인 폼으로
		if (userSession == null || !userSession.isLoggedIn()) {
			return "redirect:/user/loginForm";
		}
		
		//session.setAttribute("user_id", "user123");
		// 세션에 저장한 정보로 변경(dy)
		session.setAttribute("user_id", userSession.getLoginUser().getUser_id());
		//String user_id = (String) session.getAttribute("user_id");
		String user_id = userSession.getLoginUser().getUser_id();
	    
		
		if (user_id == null) {
	        rttr.addFlashAttribute("error", "로그인이 필요합니다.");
	        return "redirect:/team/detail/" + post_id;
	    }

	    // 게시글 작성자 조회
	    String writer = teamDao.getWriterByPostId(post_id);
	    if (user_id.equals(writer)) {
	        rttr.addFlashAttribute("msg", "본인이 작성한 게시글에는 참여하실 수 없습니다.");
	        return "redirect:/team/detail/" + post_id;
	    }

	    //참여 여부 확인
	    int hasParticipated = teamDao.hasParticipated(post_id, user_id);
	    if (hasParticipated == 1) {
	        rttr.addFlashAttribute("msg", "이미 참여하셨습니다.");
	        return "redirect:/team/detail/" + post_id;
	    }

	    // 참여 기록 추가
	    teamDao.addParticipation(post_id, user_id);
	    // 현재 참여 인원 증가
	    teamDao.increaseMembers(post_id);

	    
	 // 현재 인원 조회 후 상태 변경
	    int currentMembers = teamDao.currentMembers(post_id);
	    int totalMembers = teamDao.totalMembers(post_id);
	    String newStatus = (currentMembers >= totalMembers) ? "마감" : "모집 중";
	    teamDao.updateStatus(post_id, newStatus);
	    
	    rttr.addFlashAttribute("success", "참여가 완료되었습니다!");

	    return "redirect:/team/list";
	}

}
