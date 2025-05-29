package com.example.oggo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.oggo.dto.ReservationDTO;

@Mapper
public interface IReservationDao {

	List<ReservationDTO> getList();
	List<ReservationDTO> getMyList(@Param("user_id")String user_id);
	List<ReservationDTO>selectAllReservation();
	ReservationDTO getOne(@Param("reservation_id")String reservation_id);
	void rwrite(@Param("r")ReservationDTO reservation);
	void rdelete(@Param("reservation_id")String reservation_id);
	
	List<ReservationDTO>selectReservation();
	void updateResStatus(@Param("res_id")int res_id);
}
