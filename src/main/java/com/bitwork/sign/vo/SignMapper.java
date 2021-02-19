package com.bitwork.sign.vo;

import java.util.List;
import java.util.Map;

public interface SignMapper {

    int totalRow(Map<String, Object> map);

    List<SignVO> findByMap(Map<String, Object> map);

    int insertDocument(SignWriteForm formData);

    SignVO findByDocNo(int docNo);

    int updateSign(Map<String, Object> map);
}
