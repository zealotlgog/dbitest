package com.mingyu.dao;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.mingyu.domain.Element;

@Repository("elementDao")
public class ElementDaoImpl implements ElementDao {

	@Autowired
	private SessionFactory sessionfactory;

	@Override
	@Transactional
	public void saveElement(Element element) {
		sessionfactory.getCurrentSession().saveOrUpdate(element);
	}

	@Override
	@Transactional
	public List<Element> getElement() {

		@SuppressWarnings("unchecked")
		List<Element> userlist = sessionfactory.getCurrentSession()
				.createCriteria(Element.class).list();
		return userlist;

	}

}
