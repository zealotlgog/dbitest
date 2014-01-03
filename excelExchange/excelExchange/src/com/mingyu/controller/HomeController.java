package com.mingyu.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
	
	@RequestMapping(value = "/inputFile")
	public ModelAndView jumpInputFile() {
		return new ModelAndView("inputFile");
	}
	
	@RequestMapping(value = "/input")
	public ModelAndView jumpInput() {
		return new ModelAndView("inputFile");
	}
}
