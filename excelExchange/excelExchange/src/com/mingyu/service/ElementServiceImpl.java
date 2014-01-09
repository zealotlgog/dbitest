package com.mingyu.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.mingyu.dao.ElementDao;
import com.mingyu.domain.Element;

@Service
@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
public class ElementServiceImpl implements ElementService {

	@Autowired
	ElementDao elementDao;

	@Override
	public void addElement(Element element) {
		elementDao.saveElement(element);

	}

	@Override
	public List<Element> getElement() {
		return elementDao.getElement();

	}
}