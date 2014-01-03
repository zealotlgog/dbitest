function Painter(context, basePointX, basePointY, actualWidth, actualHeight,
		lineGridX, lineGridY) {
	this.context = context; // context of canvas used to draw grid and factor
	this.baseX = basePointX; // base point of the canvas
	this.baseY = basePointY; // base point of the canvas
	this.canvasWidth = actualWidth;// width of the canvas
	this.canvasHeight = actualHeight;// height of the canvas
	this.factorWidth = lineGridX;// factor's width
	this.factorHeight = lineGridY;// factor's height
	this.gapX = (parseInt(actualWidth / lineGridX) + 1) * lineGridX;
	this.gapY = (parseInt(actualHeight / lineGridY) + 1) * lineGridY;
	this.factorSelectArray = [];
}
// use to draw factor recs
Painter.prototype.drawRec = function(changeX, changeY) {
	var width = this.factorWidth;
	var height = this.factorHeight;
	var recStartPointX = this.baseX + changeX;
	if (recStartPointX > this.canvasWidth)
		recStartPointX -= this.gapX;
	else if (recStartPointX + this.factorWidth > this.canvasWidth) {
		width = recStartPointX + this.factorWidth - this.gapX;
		recStartPointX = 0;
	}
	var recStartPointY = this.baseY + changeY;
	if (recStartPointY > this.canvasHeight)
		recStartPointY -= this.gapY;
	else if (recStartPointY + this.factorHeight > this.canvasHeight) {
		height = recStartPointY + this.factorHeight - this.gapY;
		recStartPointY = 0;
	}
	this.context.fillRect(recStartPointX, recStartPointY, width, height);
};

Painter.prototype.drawText = function(text, fontPointX, fontPointY) {
	if (fontPointX > this.canvasWidth)
		fontPointX -= this.gapX;
	else if (fontPointX <= 0)
		fontPointX += this.gapX;

	if (fontPointY > this.canvasHeight)
		fontPointY -= this.gapY;
	else if (fontPointY <= 0)
		fontPointY += this.gapY;

	this.context.fillText(text, fontPointX, fontPointY);
	var factorLocation = {};
	factorLocation.startPointX = fontPointX;
	factorLocation.startPointY = fontPointY;
	factorLocation.context = text;
	this.factorSelectArray.push(factorLocation);
};

// use to draw factors
Painter.prototype.drawFactorContext = function(factorArray) {
	this.factorSelectArray = [];
	var tempArray;
	for ( var i = 0; i < factorArray.length; i++) {
		tempArray = factorArray[i];
		for ( var j = 0; j < tempArray.length; j++) {
			if (tempArray[j] != "") {
				var changeX = this.factorWidth * i;
				var changeY = this.factorHeight * j;
				this.context.fillStyle = "#FFFFFF";
				this.drawRec(changeX, changeY);
				this.context.fillStyle = "#000000";
				this.context.font = "15px Arial";
				this.drawText(tempArray[j], this.baseX + changeX, this.baseY
						+ changeY + this.factorHeight)
			}
		}
	}
};

// use to draw the grid line
Painter.prototype.drawGridLine = function() {
	// draw the right side of basePoint.
	for ( var i = this.baseX; i <= this.canvasWidth; i += this.factorWidth) {
		this.context.moveTo(i, this.canvasHeight);
		this.context.lineTo(i, 0);
		this.context.stroke();
	}
	// draw the left side of basePoint
	for ( var m = this.baseX; m >= 0; m -= this.factorWidth) {
		this.context.moveTo(m, this.canvasHeight);
		this.context.lineTo(m, 0);
		this.context.stroke();
	}
	// draw the lower side of the basePoint
	// noinspection JSDuplicatedDeclaration
	for ( var j = this.baseY; j <= this.canvasHeight; j += this.factorHeight) {
		this.context.moveTo(0, j);
		this.context.lineTo(this.canvasWidth, j);
		this.context.stroke();
	}
	// draw the upper side of the basePoint
	for ( var n = this.baseY; n >= 0; n -= this.factorHeight) {
		this.context.moveTo(0, n);
		this.context.lineTo(this.canvasWidth, n);
		this.context.stroke();
	}
};

// use to switch the base point when it goes out of boundary.
Painter.prototype.switchBasePoint = function(changeX, changeY) {
	this.baseX += changeX;
	if (this.baseX > this.canvasWidth)
		this.baseX -= this.gapX;
	if (this.baseX < 0)
		this.baseX += this.gapX;

	this.baseY += changeY;
	if (this.baseY > this.canvasHeight)
		this.baseY -= this.gapY;
	if (this.baseY < 0)
		this.baseY += this.gapY;
};

Painter.prototype.reSize = function(times, changeBaseX, changeBaseY) {
	this.baseX = changeBaseX + (this.baseX - changeBaseX) * times;
	this.baseY = changeBaseY + (this.baseY - changeBaseY) * times;
	this.canvasWidth *= times;
	this.canvasHeight *= times;
	this.factorWidth *= times;
	this.factorHeight *= times;
	this.gapX = (parseInt(this.canvasWidth / this.factorWidth) + 1)
			* this.factorWidth;
	this.gapY = (parseInt(this.canvasHeight / this.factorHeight) + 1)
			* this.factorHeight;
};