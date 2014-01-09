package com.mingyu.dao;

import java.util.List;

import com.mingyu.domain.RelationShip;

public interface RelationShipDao {
	public void saveRelationShip(RelationShip relationShip);

	public List<RelationShip> getRelationShip();

}