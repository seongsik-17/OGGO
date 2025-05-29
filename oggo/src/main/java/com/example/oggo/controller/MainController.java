package com.example.oggo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.oggo.dao.IProductDao;
import com.example.oggo.dto.ProductDTO;

@Controller
public class MainController {

	private IProductDao productDao;
	
	@Autowired
	public MainController(IProductDao dao) {
		productDao = dao;
	}
	
	@GetMapping("/")
	public String root(Model model) {
		System.out.println("root..........");
		List<ProductDTO> list2;
		list2 = productDao.getBest();
		model.addAttribute("list2",list2);
		return "index";
	}

}
