package com.example.oggo.dto;

import lombok.Data;

@Data
public class MonthlyStatisticsDTO {
	private String month;
	private String title;
	private int total_sales;//매출 총액
}
