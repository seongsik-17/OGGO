package com.example.oggo.dto;

import lombok.Data;

@Data
public class PwDTO {
	private String salt;
	private String password;
}
