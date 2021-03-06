package com.bitwork.board.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.bitwork.board.dto.BoardUpdateForm;
import com.bitwork.board.dto.BoardWriteForm;
import com.bitwork.board.vo.BoardVO;
import com.bitwork.board.vo.CommentsVO;
import com.bitwork.common.DBService;

public class BoardDAO {
	
	// 게시글 전체 건수 조회
	public static int getTotalCount(Map<String, Object> map) {
		try {
			SqlSession ss = DBService.getFactory().openSession();
			int totalCount = ss.selectOne("board.totalCount", map);
			ss.close();
			return totalCount;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	// 게시판 리스트 조회
	public static List<BoardVO> getList(Map<String, Object> map) {
		SqlSession ss = DBService.getFactory().openSession();
		try {
			List<BoardVO> list = ss.selectList("board.list", map);			
			ss.close();
			return list;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	// 게시글 번호에 해당하는 게시글 하나 조회
	public static BoardVO selectOne(String boardIdx) {
		SqlSession ss = DBService.getFactory().openSession();
		BoardVO vo = ss.selectOne("board.one", boardIdx);
		ss.close();
		return vo;
	}
	
	// 게시글 입력
	public static int insert(BoardWriteForm writeForm) {
		SqlSession ss = DBService.getFactory().openSession(true); // 오토커밋
		int result = ss.insert("board.insert", writeForm);
		if (result > 0) {
			result = ss.selectOne("board.currval");
		}
		ss.close();
		return result;
	}
	
	
	// 게시글 수정
	public static int update(BoardUpdateForm updateForm, int fileUpdate) {
		SqlSession ss = DBService.getFactory().openSession(true);
		// 파일 변동 X, 텍스트만 수정
		int result = ss.update("board.update_onlyText", updateForm);
		// 파일 변동 O
		if (fileUpdate == 1) {
			result = ss.update("board.update_file", updateForm);
		}
		System.out.println("updateForm : " + updateForm);
		System.out.println("result : " + result + ", fileUpdate : " + fileUpdate);
		
		ss.close();
		return result;
	}
	
	
	// 게시글 삭제
	public static int delete(String boardIdx) {
		SqlSession ss = DBService.getFactory().openSession(true);
		int result = ss.delete("board.delete", boardIdx);
		ss.close();
		
		return result;
	}
	
	
	
	// 조회수 증가 처리
	public static int updateHit(int boardIdx) {
		SqlSession ss = DBService.getFactory().openSession(true);
		int result = ss.update("board.hit", boardIdx);
		ss.close();
		
		return result;
	}

	public static List<BoardVO> lastNormal() {
		try (SqlSession ss = DBService.getFactory().openSession()) {
			return ss.selectList("board.lastNormal");
		}
	}
	
	// =============== 댓글관련 ===============

	
	// 댓글 목록 조회
	public static List<CommentsVO> getCmtList(String boardIdx) {
		SqlSession ss = DBService.getFactory().openSession();
		List<CommentsVO> cmt_list = ss.selectList("board.cmtList", boardIdx);
		ss.close();
		
		return cmt_list;
	}
	
	// 댓글 입력
	public static int insertCmt(CommentsVO cvo) {
		SqlSession ss = DBService.getFactory().openSession(true);
		int result = ss.insert("board.cmtInsert", cvo);
		ss.close();
		
		return result;
	}
	
	// 댓글 삭제
	public static int cmtDelete(String cmtIdx) {
		SqlSession ss = DBService.getFactory().openSession(true);
		int result = ss.delete("board.cmtDelete", cmtIdx);
		ss.close();
		
		return result;
	}

}
