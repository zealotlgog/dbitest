package com.mingyu.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mingyu.service.FileService;

@Controller
public class HomeController {

	@Autowired
	private FileService fileService;

	@RequestMapping(value = "/exchange", method = RequestMethod.POST)
	public ModelAndView showFile(String input) {
		String[][] answer = fileService.exchangeFile(input);

		return new ModelAndView("showFile", "answer", answer);

	}

	@RequestMapping(value = "/showFile")
	public ModelAndView jumpInputFile() {
		return new ModelAndView("showFile");
	}

	@RequestMapping(value = "/input")
	public ModelAndView jumpInput() {
		return new ModelAndView("inputFile");
	}

	@RequestMapping(value = "/fileUpload", method = RequestMethod.POST)
	public ModelAndView fileUpload(
			@RequestParam("fileUpload") CommonsMultipartFile file) {
		System.out.println(file.getContentType());
		System.out.println(file.getSize());
		System.out.println(file.getOriginalFilename());
		
		String[][] answer = null;

		if (!file.isEmpty()) {
			String path = "/Users/mingyu_zhao/temp/" + file.getOriginalFilename();
			File localFile = new File(path);
			try {
				file.transferTo(localFile);
				answer = fileService.exchangeFile(path);
			} catch (IllegalStateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return new ModelAndView("showFile", "answer", answer);
	}
}
