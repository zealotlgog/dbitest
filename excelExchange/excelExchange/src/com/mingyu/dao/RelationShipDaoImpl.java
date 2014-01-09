package com.mingyu.dao;

import java.util.List;

import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.mingyu.domain.RelationShip;

@Repository("relationShipDao")
public class RelationShipDaoImpl implements RelationShipDao {

	@Autowired
	private SessionFactory sessionfactory;

	@Override
	@Transactional
	public void saveRelationShip(RelationShip relationShip) {
		sessionfactory.getCurrentSession().saveOrUpdate(relationShip);
	}

	@Override
	@Transactional
	public List<RelationShip> getRelationShip() {

		@SuppressWarnings("unchecked")
		List<RelationShip> userlist = sessionfactory.getCurrentSession()
				.createCriteria(RelationShip.class).list();
		return userlist;

	}

}
