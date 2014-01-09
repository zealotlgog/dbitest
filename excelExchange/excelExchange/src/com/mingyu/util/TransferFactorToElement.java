package com.mingyu.util;

import java.util.ArrayList;

import com.mingyu.domain.*;

public class TransferFactorToElement {

	public TransferFactorToElement() {

	}

	public static Element[] transfer(Factor[] input) {
		Element[] answer = new Element[input.length];
		for (int i = 0; i < input.length; i++) {
			Factor tempFactor = input[i];
			Element tempElement = new Element();
			tempElement.setName(tempFactor.getName());
			tempElement.setType(tempFactor.getType());
			answer[i] = tempElement;
		}
		return answer;
	}

	public static ArrayList<RelationShip> getRelationShip(Factor[] inputFactor,
			Element[] inputElement) {
		ArrayList<RelationShip> answer = new ArrayList<RelationShip>();

		return answer;
	}
}
