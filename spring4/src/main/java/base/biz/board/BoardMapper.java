package base.biz.board;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Param;

/**
 * 간단 게시판
 * @author naru
 *
 */
public interface BoardMapper {

	public List<HashMap<String, String>> selectBoardList(HashMap<String, String> map) throws Exception;
	
	public List<HashMap<String, String>>  selectBoardSearch(@Param("bKey") String bKey, @Param("title") String title) throws Exception;
}
