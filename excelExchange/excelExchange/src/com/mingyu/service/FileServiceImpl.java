package com.mingyu.service;

import java.io.File;

import com.mingyu.util.*;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
public class FileServiceImpl implements FileService {

	@Override
	public String[][] exchangeFile(String input) {
		// TODO Auto-generated method stub
		String[][] answer;
		answer = ExceltoArray.read(input);
		return answer;
	}
}
