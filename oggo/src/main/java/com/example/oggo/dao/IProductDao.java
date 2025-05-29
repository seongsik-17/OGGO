package com.example.oggo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.oggo.dto.ProductDTO;

@Mapper
public interface IProductDao {

	List<ProductDTO> getList();
	List<ProductDTO> getBest();
	List<ProductDTO> getRegion(@Param("region")String region);
	ProductDTO getOne(@Param("product_id")String product_id);
	List<ProductDTO> psearch(@Param("keyword")String keyword);
	void pwrite(@Param("p")ProductDTO product);
	void pdelete(@Param("product_id")String product_id);
	void pview(@Param("product_id")String product_id);
	void pupdate(@Param("product_id")String product_id,
				@Param("left_seats")int left_seats,
				@Param("status")String status);
	List<String> autocomplete(@Param("keyword")String keyword);
	List<String> pkeyword();
	List<String> phashtag();
}
