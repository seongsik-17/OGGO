package com.example.oggo.dto;

import java.sql.Date;

import lombok.Data;

public class TeamDTO {

	@Data
	public static class TeamParticipantDTO {
	    private int id;             // 참여 기록 고유 식별자
	    private int post_id;         // 동행 게시글 ID (foreign key)
	    private String user_id;      // 유저 ID
	    private Date joined_at;      // 참여 시간
	
	}

	@Data
	public static class TeamPostDTO {
	    private int post_id;                     // 게시글 고유 번호 - 자동 부여
	    private String user_id;             // 작성자 ID
	    private String title;              // 게시글 제목
	    private String content;            // 게시글 내용
	    private String product_id;          // 관련 상품 ID (여행 상품 등과 연동되는 경우)
	    private String product_title;       // 관련 상품 제목
	    private Date start_date;            // 동행 시작 날짜
	    private Date end_date;              // 동행 종료 날짜
	    private int total_members;          // 모집 인원 수
	    private int current_members;        // 현재 모집된 인원 수
	    private String status;    			// 모집 상태
	    private Date created_at;            // 게시글 작성 일시
	}
}
