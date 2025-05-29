package com.example.oggo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.oggo.dao.IProductDao;
import com.example.oggo.dto.ProductDTO;
import com.example.oggo.session.UserSession;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/product")
public class ProductController {

	private IProductDao productDao;
	
	@Autowired
	private UserSession userSession;
	
	
	@Autowired
	public ProductController(IProductDao dao) {
		productDao = dao;
	}
	
	@GetMapping("/productlist")
	public String productlist(Model model,@RequestParam(value = "keyword", required = false) String keyword) {
		
		List<ProductDTO> list;
		List<ProductDTO> list2;
		List<String> list3;
		List<String> list4;
		
		if (keyword != null && !keyword.isEmpty()) {
			if(keyword.contains("#")) {
				System.out.println("#포함");
				keyword = keyword.replace("#", ""); // # 제거
			}
	        list = productDao.psearch(keyword);
	    } else {
	        list = productDao.getList(); // 전체 상품 조회
	        
	    }
		list2 = productDao.getBest();
		list3 = productDao.pkeyword();
		list4 = productDao.phashtag();
		model.addAttribute("list",list);
		model.addAttribute("list2",list2);
		model.addAttribute("list3",list3);
		model.addAttribute("list4",list4);
		return "/product/productlist";
	}
	
	@GetMapping("/productDetail")
	public String productDetail(@RequestParam("product_id")String product_id,Model model) {
		productDao.pview(product_id);
		ProductDTO product = productDao.getOne(product_id);
		model.addAttribute("product",product);
		return "/product/productDetail";
	}
	
	// 상품정보 입력하는 폼(관리자만 사용/dy)
	@GetMapping("/writeProductForm")
	public String writeProductForm(HttpServletRequest request) {
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
		
		
		return "/product/writeProductForm";
	}
	
	@PostMapping("/writeProduct")
	public String writeProduct(ProductDTO product) {
		productDao.pwrite(product);
		return "redirect:/product/product";
	}
	
	@PostMapping("/delete")
	public String deleteProduct(@RequestParam("product_id")String product_id) {
		productDao.pdelete(product_id);
		return "redirect:/product/productlist";
	}
	/*
	@GetMapping("/addWishList")
	public String addWishList() {
		//조장님 위시리스트 다오 추가
		return "redirect:/product/productDetail";
	}
	*/
	@GetMapping("/autocomplete")
	@ResponseBody
	public List<String> autocomplete(@RequestParam("keyword") String keyword) {
	    return productDao.autocomplete(keyword);  // title 또는 tag에서 LIKE 검색
	}
	
	@GetMapping("/region")
	@ResponseBody
	public List<ProductDTO> getRegion(@RequestParam(value = "region",required = false) String region) {
	    if (region == null || region.isBlank()) {
	        return productDao.getList();
	    } else {
	        return productDao.getRegion(region);
	    }
	}



}
