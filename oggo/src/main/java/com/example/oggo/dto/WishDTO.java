package com.example.oggo.dto;

import lombok.Data;

@Data
public class WishDTO {
	
	private int wishlist_id;
	private String user_id;
	private String product_id;
	private String added_at;
}
