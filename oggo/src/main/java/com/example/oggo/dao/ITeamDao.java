package com.example.oggo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.oggo.dto.TeamDTO.TeamPostDTO;

@Mapper
public interface ITeamDao {

	List<TeamPostDTO> TeamList(); // 동행구하기 게시판 글 목록 조회

	void regPost(@Param("dto") TeamPostDTO postDTO); // 동행구하기 게시물 작성

	void updateStatus(@Param("post_id") int post_id, @Param("status") String status);
 // 모집 인원 다 차면 모집상태 [마감] 처리

	
	List<TeamPostDTO> ProductsList(); //여행상품 리스트 조회

	TeamPostDTO TeamDetail(int post_id); //동행구하기 게시글 상세 조회

	int updateTeamPost(TeamPostDTO postDTO); // 게시글 업데이트
	
	void deleteTeamPost(int post_id); // 게시글 삭제
	
	// 참여 여부 확인: 이미 참여했는지 체크
	int hasParticipated(@Param("post_id") int post_id, @Param("user_id") String user_id);

	// 참여 등록
	void addParticipation(@Param("post_id") int post_id, @Param("user_id") String user_id);

	// 현재 참여 인원 증가
	int increaseMembers(@Param("post_id") int post_id);

	//본인 게시물 참여 불가
	String getWriterByPostId(int post_id);

	//모집 상태 자동 마감
	int totalMembers(@Param("post_id")int post_id);

	//현재 참여 인원 조회
	int currentMembers(int post_id);



}
