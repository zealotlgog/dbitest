package com.mingyu.controller;

import java.io.File;
import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.mingyu.domain.Element;
import com.mingyu.domain.Factor;
import com.mingyu.domain.RelationShip;
import com.mingyu.service.ElementService;
import com.mingyu.service.FileService;
import com.mingyu.service.RelationShipService;
import com.mingyu.util.TransferFactorToElement;

@Controller
public class HomeController {

	@Autowired
	private FileService fileService;
	@Autowired
	private ElementService elementService;
	@Autowired
	private RelationShipService relationShipService;

	@RequestMapping(value = "/exchange", method = RequestMethod.POST)
	public ModelAndView showFile(String input) {
		String[][] answer = fileService.exchangeFile(input);

		return new ModelAndView("showFile", "answer", answer);

	}

	@RequestMapping(value = "/saveFactor", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView saveFactor(@RequestBody Factor[] factor) {

		Element[] elements = TransferFactorToElement.transfer(factor);
		for (int i = 0; i < elements.length; i++) {
			elementService.addElement(elements[i]);
		}
		return new ModelAndView("showFile");

	}
	
	@RequestMapping(value = "/saveRelationShip", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView saveFactor(@RequestBody RelationShip[] relationShips) {

		for (int i = 0; i < relationShips.length; i++) {
			relationShipService.addRelationShip(relationShips[i]);
		}
		return new ModelAndView("showFile");

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

		String[][] answer = null;

		if (!file.isEmpty()) {
			String path = "/Users/mingyu_zhao/temp/"
					+ file.getOriginalFilename();
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
