package com.mingyu.service;

import java.util.List;
import com.mingyu.domain.RelationShip;

public interface RelationShipService {
	public void addRelationShip(RelationShip relationShip);

	public List<RelationShip> getRelationShip();

}