package com.mingyu.dao;

import java.util.List;

import com.mingyu.domain.Element;

public interface ElementDao {
	public void saveElement(Element element);

	public List<Element> getElement();

}