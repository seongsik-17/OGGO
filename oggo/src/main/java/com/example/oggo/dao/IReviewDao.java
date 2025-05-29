package com.example.oggo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.oggo.dto.ReviewDTO;
import com.example.oggo.dto.ReviewListDTO;

@Mapper
public interface IReviewDao {

	//@Insert("INSERT INTO reviews (review_id, user_id, product_id, rating, title, content, created_at, updated_at, is_public) " +
	//       "VALUES (review_seq.NEXTVAL, #{r.user_id}, #{r.product_id}, #{r.rating}, #{r.title}, #{r.content}, SYSDATE, SYSDATE, #{r.is_public})")
	void insert(@Param("r") ReviewDTO review);

	//@Select("SELECT * FROM reviews WHERE review_id = #{review_id}")
	ReviewDTO detail(String review_id);
	
	//@Update("UPDATE reviews SET title = #{title}, content = #{content}, rating = #{rating}, updated_at = SYSDATE, is_public = #{is_public} WHERE review_id = #{review_id}")
	void update(ReviewDTO review);

	//@Delete("DELETE FROM reviews WHERE review_id = #{review_id}")
	void delete(String review_id);

	// 리뷰 리스트
	List<ReviewListDTO> getList();
}
