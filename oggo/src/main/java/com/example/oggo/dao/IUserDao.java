
package com.example.oggo.dao;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.oggo.dto.LoginDTO;
import com.example.oggo.dto.MyReservationDTO;
import com.example.oggo.dto.PwDTO;
import com.example.oggo.dto.QnaDTO;
import com.example.oggo.dto.ReviewDTO;
import com.example.oggo.dto.UserDTO;
import com.example.oggo.dto.WishDTO;

@Mapper
public interface IUserDao {

	// 로그인 정보가 테이블에 있는지 확인
	int login(@Param("log")LoginDTO login);
	
	// 로그인 성공하면 라스트 로그인 업데이트
	void updateLastLogin(@Param("log")LoginDTO login);

	// 로그인한 사람의 정보
	UserDTO getUser(@Param("id")String id, @Param("pw")String pw);

	// 회원가입
	void regist(@Param("u")UserDTO user);

	// 아이디 중복검사 & 로그인할 때 사용
	int checkId(@Param("id")String id);

	// User의 salt와 PW값 반환
	PwDTO getSaltAndPassword(String user_id);

	// 회원 정보수정
	void update(@Param("u")UserDTO uesr);
	
	// 회원 탈퇴
	int delete(@Param("id")String user_id);

	// 내가 예약한 상품 리스트
	List<MyReservationDTO> getReservationList(@Param("user_id")String user_id);

	// 내가 찜한 상품 리스트
	List<WishDTO> getWishList(@Param("user_id")String user_id);

	// 내가 작성한 리뷰 리스트
	List<ReviewDTO> getReviewList(@Param("user_id")String user_id);

	// 내가 작성한 Q&A 리스트
	List<QnaDTO> getQnaList(@Param("user_id")String user_id);

	
	// 찜하기
	void addWish(@Param("product_id")String product_id, @Param("user_id")String user_id);

	// 찜 취소하기
	void delWish(@Param("wishlist_id")int wishlist_id);

	// 병합시 추가
	List<UserDTO> selectUserList();
	UserDTO serchUserInfo(@Param("user")UserDTO user);
	//추가
	UserDTO selectUserById(@Param("user")UserDTO user);
	int userInfoUpdate(@Param("user")UserDTO user);
}
