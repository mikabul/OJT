package com.ojt.util;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
@PropertySource("/WEB-INF/properties/setting.properties")
public class DevMultiPartFile {
	
	@Value("${resourcesPath}")
	private String resourcesPath;	// resources 절대 경로, properties에서 정의
	
	private File folder;			// 폴더 생성 혹은 확인을 위한 객체
	private File uploadFile;		// 파일 저장을 위한 객체
	private String originFileName;	// 업로드된 파일의 이름
	private String fileType;		// 파일의 타입을 저장하기위한 변수
	private String fileName;		// 개발자가 지정한 파일의 이름을 저장하기 위한 변수
	Map<String, Object> map;		// 결과를 저장하기위한 Map
	
	/*
	 * 파일 저장을 위한 메서드
	 * 결과를 Map으로 반환
	 * 파라미터( 파일, 저장 경로(ex="/images/member/"), 파일 저장을 위한 이름(멤버기준 멤버의 번호)
	 */
	public Map<String, Object> saveFile(MultipartFile file, String path, String name) {
		
		map = new HashMap<String, Object>(); // 결과 반환을 위한 HashMap
		
		System.out.println("resourcesPath : " + resourcesPath);
		
		String savePath = resourcesPath + path; // 저장 경로
		System.out.println("savePath : " + savePath);
		
		// 폴더가 없을시 생성
		folder = new File(savePath);
		if(folder.isDirectory() == false) {
			folder.mkdir();
		}
		
		// 파일의 이름을 받아옴
		originFileName = file.getOriginalFilename();
		
		// 파일의 이름이 비어있을경우 기본 사진을 이용
		if(originFileName.isEmpty()) {
			map.put("success", true);
			map.put("fileName", "default.jpg");
			return map;
		}
		
		/*
		 * 파일의 확장자를 분리
		 * 실패시 success = false
		 * 		code = 400, 부적절한 파일(확장자가 없음)
		 */
		try {
			fileType = originFileName.substring(originFileName.lastIndexOf("."));
			System.out.println("fileType : " + fileType);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			System.out.println("파일 확장자 분리 실패 - " + originFileName);
			map.put("success", "false");
			map.put("code", "401");
		}
		
		/*
		 * 파일을 저장
		 * 실패시 success = false
		 * 		code = 515(파일 저장 실패)
		 */
		try {
			// 실제로 저장될 파일의 이름
			fileName = System.currentTimeMillis() + name + fileType;
			System.out.println(fileName);
			
			// 저장을 위해 경로와 파일이름을 가진 객체 객성
			uploadFile = new File(savePath + fileName);
			System.out.println("저장 경로 : " + savePath + fileName);
			
			// 파일 저장
			file.transferTo(uploadFile);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			System.out.println("저장 실패");
			map.put("success", "false");
			map.put("code", "515");
			return map;
		}
		
		// 파일 저장에 성공할 경우 저장된 파일의 이름을 반환
		map.put("success", true);
		map.put("fileName", fileName);
		
		return map;
	}
}
