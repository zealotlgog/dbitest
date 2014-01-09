package com.mingyu.service;

import java.util.List;
import com.mingyu.domain.Element;

public interface ElementService {
	public void addElement(Element element);

	public List<Element> getElement();

}