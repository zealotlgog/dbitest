package com.mingyu.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "relationship")
public class RelationShip {

	@Id
	@GeneratedValue
	@Column(name = "id")
	private int id;

	@Column(name = "idhost")
	private int id_host;

	@Column(name = "idguest")
	private int id_guest;

	public int getId_host() {
		return id_host;
	}

	public void setId_host(int id_host) {
		this.id_host = id_host;
	}

	public int getId_guest() {
		return id_guest;
	}

	public void setId_guest(int id_guest) {
		this.id_guest = id_guest;
	}

}
