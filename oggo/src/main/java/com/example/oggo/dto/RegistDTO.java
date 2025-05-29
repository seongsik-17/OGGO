package com.example.oggo.dto;

import java.util.List;
import lombok.Data;

@Data
public class RegistDTO {

	// 필수 기본 정보
    private String user_id;
    private String password;
    private String name;
    private String email;
    private String phone;
    private String address;
    private String birth_date;
    private String gender;

    // MBTI (ei-sn-tf-jp 각각 라디오로 받음)
    private String mbti_ei;
    private String mbti_sn;
    private String mbti_tf;
    private String mbti_jp;

    // 성격 (체크박스: 여러 개 선택 가능)
	private List<String> personalities;

	// 주량
	private String drinking_level;

}
