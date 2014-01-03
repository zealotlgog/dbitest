//function to change the basePoint
function switchBasePoint(baseX, baseY, changeX, changeY) {

	baseX += changeX;
	if (baseX > 2000)
		baseX -= 2000;
	if (baseX < 0)
		baseX += 2000;

	baseY += changeY;
	if (baseY > 2000)
		baseY -= 2000;
	if (baseY < 0)
		baseY += 2000;

	return {
		x : baseX,
		y : baseY
	};
}

// function to draw the grid line
function drawGridLine(context, basePointX, basePointY, lineGridX, lineGridY,
		actualWidth, actualHeight) {
	// draw the right side of basePoint.
	for (var i = basePointX; i <= actualWidth; i += lineGridX) {
		context.moveTo(i, actualHeight);
		context.lineTo(i, 0);
		context.stroke();
	}
	// draw the left side of basePoint
	for (var i = basePointX; i >= 0; i -= lineGridX) {
		context.moveTo(i, actualHeight);
		context.lineTo(i, 0);
		context.stroke();
	}
	// draw the lower side of the basePoint
	for (var j = basePointY; j <= actualHeight; j += lineGridY) {
		context.moveTo(0, j);
		context.lineTo(actualWidth, j);
		context.stroke();
	}
	// draw the upper side of the basePoint
	for (var j = basePointY; j >= 0; j -= lineGridY) {
		context.moveTo(0, j);
		context.lineTo(actualWidth, j);
		context.stroke();
	}
}

// function to draw the factors
function dratTestRec(context, basePointX, basePointY, changeX, changeY, width,
		height, actualWidth, actualHeight) {
	context.fillStyle = "#FFFFFF";
	var recStartPointX = basePointX + changeX;
	if (recStartPointX > actualWidth)
		recStartPointX -= actualWidth;
	else if (recStartPointX + width > actualWidth) {
		width = recStartPointX + width - actualWidth;
		recStartPointX = 0;
	}
	var recStartPointY = basePointY + changeY;
	if (recStartPointY > actualHeight)
		recStartPointY -= actualHeight;
	else if (recStartPointY + height > actualHeight) {
		height = recStartPointY + height - actualHeight;
		recStartPointY = 0;
	}
	context.fillRect(recStartPointX, recStartPointY, width, height);
}

// function to draw the factor array
function drawFactorContext(context, basePointX, basePointY, width, height,
		actualWidth, actualHeight, factorArray) {
	for (var i = 0; i < factorArray.length; i++) {
		tempArray = factorArray[i];
		for (var j = 0; j < tempArray.length; j++) {
			if (tempArray[j] != "") {
				var changeX = width * i;
				var changeY = height * j;
				dratTestRec(context, basePointX, basePointY, changeX, changeY,
						width, height, actualWidth, actualHeight);
				context.fillStyle = "#FFFFFF";
				context.font = "15px Arial";
				context.fillText(tempArray[j], basePointX + changeX, basePointY
						+ changeY + height);
			}
		}
	}
}
