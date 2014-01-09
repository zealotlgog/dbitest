package com.mingyu.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import com.mingyu.dao.RelationShipDao;
import com.mingyu.domain.RelationShip;

@Service
@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
public class RelationShipServiceImpl implements RelationShipService {

	@Autowired
	RelationShipDao relationShipDao;

	@Override
	public void addRelationShip(RelationShip relationShip) {
		relationShipDao.saveRelationShip(relationShip);

	}

	@Override
	public List<RelationShip> getRelationShip() {
		return relationShipDao.getRelationShip();

	}
}