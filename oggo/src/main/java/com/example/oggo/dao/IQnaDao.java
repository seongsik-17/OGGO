package com.example.oggo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.oggo.dto.ProductDTO;
import com.example.oggo.dto.QnaDTO;

@Mapper
public interface IQnaDao {
    List<QnaDTO> QnaList();
    QnaDTO QnaDetail(@Param("id") int qna_id);
    void increaseViews(@Param("id") int qna_id);
    void regQna(@Param("dto") QnaDTO dto);
    void deleteQna(@Param("id") int qna_id);
    void regAnswer(@Param("id") int qna_id, @Param("answer") String answer);
    List<QnaDTO> QnaSearch(@Param("keyword")String keyword);
    List<String> autocomplete(@Param("keyword")String keyword);
    List<QnaDTO> selectFaqList(); //조회수 100 이상만, 답변 있는 것만
    List<QnaDTO> selectQna();//답변하지 않은 QnA리스트 호
	List<QnaDTO> selectForbiddenWords();
	int updateQnA_Ans(@Param("qna")QnaDTO qna );
}