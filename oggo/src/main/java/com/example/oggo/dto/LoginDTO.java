package com.example.oggo.dto;

import lombok.Data;

@Data
public class LoginDTO {
	private String user_id;
	private String password;
	private String lastLogin; // 마지막 로그인 시간 저장용
}
