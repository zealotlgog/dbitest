function Painter(context, basePointX, basePointY, actualWidth, actualHeight, lineGridX, lineGridY) {
    this.context = context; // context of canvas used to draw grid and factor
    this.baseX = basePointX; // base point of the canvas
    this.baseY = basePointY; // base point of the canvas
    this.canvasWidth = actualWidth;// width of the canvas
    this.canvasHeight = actualHeight;// height of the canvas
    this.factorWidth = lineGridX;// factor's width
    this.factorHeight = lineGridY;// factor's height
    this.gapX = (parseInt(actualWidth / lineGridX) + 1) * lineGridX;
    this.gapY = (parseInt(actualHeight / lineGridY) + 1) * lineGridY;
    this.factorArray = [];
    this.relationArray = [];
}

Painter.prototype.getFactorArray = function () {
    return this.factorArray;
}

Painter.prototype.getRelationArray = function () {
    return this.relationArray;
}

// use to transfer the input Array to our factor Array
Painter.prototype.transferFactors = function (inputArray) {
    var tempArray = []
    for (var i = 0; i < inputArray.length; i++) {
        tempArray = inputArray[i];
        for (var j = 0; j < tempArray.length; j++) {
            if (tempArray[j] != "") {
                var tempFactor = {};
                tempFactor.name = tempArray[j];
                tempFactor.type = 0;
                tempFactor.tempType = 0;
                tempFactor.startPointX = this.factorWidth * j;
                tempFactor.startPointY = this.factorHeight * i;
                this.factorArray.push(tempFactor);
            }
        }
    }
}

// use to judge whether something is in the array
Painter.prototype.isContains = function (array, value) {
    var i = array.length;
    while (i--) {
        if (array[i] == value) {
            return true;
        }
    }
    return false;
}

// use to resize the factor
Painter.prototype.reSetFactorSize = function (newWidth, newHeight) {
    for (var i = 0; i < this.factorArray.length; i++) {
        this.factorArray[i].startPointX = (this.factorArray[i].startPointX / this.factorWidth) * newWidth;
        this.factorArray[i].startPointY = (this.factorArray[i].startPointY / this.factorHeight) * newHeight;
    }
    this.factorWidth = newWidth;
    this.factorHeight = newHeight;
}

// use to switch the base point when it goes out of boundary.
Painter.prototype.switchBasePoint = function (changeX, changeY) {
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

// use to find if the given Point is in the factoryArray;
Painter.prototype.isInFactorArray = function (PointX, PointY) {
    for (var i = 0; i < this.factorArray.length; i++) {
        var tempFactor = this.factorArray[i];
        if (PointX > tempFactor.startPointX && PointX < tempFactor.startPointX + this.factorWidth) {
            if (PointY > tempFactor.startPointY && PointY < tempFactor.startPointY + this.factorHeight) {
                return i;
            }
        }
    }
    return -1;
};

// use to resize the panel
Painter.prototype.reSize = function (times, changeBaseX, changeBaseY) {
    if (this.canvasWidth < 600 && times == 0.9) {
        return;
    }
    this.baseX = changeBaseX + (this.baseX - changeBaseX) * times;
    this.baseY = changeBaseY + (this.baseY - changeBaseY) * times;
    this.canvasWidth *= times;
    this.canvasHeight *= times;
    this.factorWidth *= times;
    this.factorHeight *= times;
    for (var i = 0; i < this.factorArray.length; i++) {
        this.factorArray[i].startPointX *= times;
        this.factorArray[i].startPointY *= times;
    }
    this.gapX = (parseInt(this.canvasWidth / this.factorWidth) + 1)
        * this.factorWidth;
    this.gapY = (parseInt(this.canvasHeight / this.factorHeight) + 1)
        * this.factorHeight;
};


// use to draw factor recs
Painter.prototype.drawRec = function (changeX, changeY) {
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

// use to draw text of the factor
Painter.prototype.drawText = function (text, fontPointX, fontPointY) {
    fontPointX += this.baseX;
    fontPointY += this.baseY;

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
};

// use to draw factors
Painter.prototype.drawFactorContext = function () {
    for (var i = 0; i < this.factorArray.length; i++) {
        var tempFactor = this.factorArray[i];
        if (tempFactor.tempType == 0)
            this.context.fillStyle = "#CAEDFF";
        else if (tempFactor.tempType == 1)
            this.context.fillStyle = "#FF0000";
        else if (tempFactor.tempType == 2)
            this.context.fillStyle = "#00FF00";
        else if (tempFactor.tempType == 3)
            this.context.fillStyle = "#0000FF";
        else if (tempFactor.tempType == 4)
            this.context.fillStyle = "555555";

        this.drawRec(tempFactor.startPointX, tempFactor.startPointY);
        this.context.fillStyle = "#000000";
        this.context.font = "15px Arial";
        this.drawText(tempFactor.name, tempFactor.startPointX, tempFactor.startPointY + this.factorHeight);
    }
};

// use to draw the grid line
Painter.prototype.drawGridLine = function () {
    // draw the right side of basePoint.

    for (var i = this.baseX; i <= this.canvasWidth; i += this.factorWidth) {
        this.context.moveTo(i, this.canvasHeight);
        this.context.lineTo(i, 0);
        this.context.strokeStyle = "#DBFFFF";
        this.context.stroke();
    }
    // draw the left side of basePoint
    for (var m = this.baseX; m >= 0; m -= this.factorWidth) {
        this.context.moveTo(m, this.canvasHeight);
        this.context.lineTo(m, 0);
        this.context.strokeStyle = "#DBFFFF";
        this.context.stroke();
    }
    // draw the lower side of the basePoint
    // noinspection JSDuplicatedDeclaration
    for (var j = this.baseY; j <= this.canvasHeight; j += this.factorHeight) {
        this.context.moveTo(0, j);
        this.context.lineTo(this.canvasWidth, j);
        this.context.strokeStyle = "#DBFFFF";
        this.context.stroke();
    }
    // draw the upper side of the basePoint
    for (var n = this.baseY; n >= 0; n -= this.factorHeight) {
        this.context.moveTo(0, n);
        this.context.lineTo(this.canvasWidth, n);
        this.context.strokeStyle = "#DBFFFF";
        this.context.stroke();
    }
};

// use to setDifferent colour for the factor space
Painter.prototype.setFactors = function (eventPointX, eventPointY) {
    var index = this.isInFactorArray(eventPointX - this.baseX, eventPointY - this.baseY);
    if (index == -1)
        return;
    if (this.factorArray[index].tempType == 1 && this.factorArray[index].type == 0)
        this.factorArray[index].tempType = 0;
    else
        this.factorArray[index].tempType = 1;// set as factor

};

// function to update the factors
Painter.prototype.confirmFactor = function () {
    for (var i = 0; i < this.factorArray.length; i++) {
        if (this.factorArray[i].tempType == 1 && this.factorArray[i].type == 0) {
            this.factorArray[i].type = 1;
        }
    }
}

Painter.prototype.setProps = function (eventPointX, eventPointY) {
    // if the point is not a element.
    var index = this.isInFactorArray(eventPointX - this.baseX, eventPointY - this.baseY);
    if (index == -1)
        return;

    var element = this.factorArray[index];

    // if the point is a factor
    if (element.type == 1) {
        if (element.tempType == 1)
            element.tempType = 4;
        else element.tempType = 1;
    }

    // if the point is not set or is a props
    if (element.type == 0) {
        if (element.tempType == 0)
            element.tempType = 2;
        else if (element.tempType == 2)
            element.tempType = 0;
    }
};

Painter.prototype.confirmProps = function () {
    for (var i = 0; i < this.factorArray.length; i++) {
        var tempFactor = this.factorArray[i];
        if (tempFactor.tempType == 1 && tempFactor.type == 1) {
            for (var j = 0; j < this.factorArray.length; j++) {
                var tempFactorTwo = this.factorArray[j];
                if (tempFactorTwo.tempType == 2 && tempFactorTwo.type == 0) {
                    var relationShip = {};
                    relationShip.hostId = i;
                    relationShip.guestId = j;
                    if (!this.isContains(this.relationArray, relationShip))
                        this.relationArray.push(relationShip);
                }
            }
        }
    }
    for (var i = 0; i < this.factorArray.length; i++) {
        var tempFactor = this.factorArray[i];
        if (tempFactor.tempType == 2 && tempFactor.type == 0) {
            tempFactor.type = 2;
        }
    }
}

Painter.prototype.setValues = function (eventPointX, eventPointY) {
    // if the point is not a element.
    var index = this.isInFactorArray(eventPointX - this.baseX, eventPointY - this.baseY);
    if (index == -1)
        return;

    var element = this.factorArray[index];

    // if the point is a factor
    if (element.type == 1) {
        if (element.tempType == 1)
            element.tempType = 4;
        else element.tempType = 1;
    }

    // if the point is a factor
    if (element.type == 2) {
        if (element.tempType == 2)
            element.tempType = 4;
        else element.tempType = 2;
    }

    // if the point is not set or is a props
    if (element.type == 0) {
        if (element.tempType == 0)
            element.tempType = 3;
        else if (element.tempType == 3)
            element.tempType = 0;
    }
}

Painter.prototype.confirmValues = function () {
    for (var i = 0; i < this.factorArray.length; i++) {
        var tempFactor = this.factorArray[i];
        if (tempFactor.tempType == 1 && tempFactor.type == 1) {
            for (var j = 0; j < this.factorArray.length; j++) {
                var tempFactorTwo = this.factorArray[j];
                if (tempFactorTwo.tempType == 3 && tempFactorTwo.type == 0) {
                    var relationShip = {};
                    relationShip.hostId = i;
                    relationShip.guestId = j;
                    if (!this.isContains(this.relationArray, relationShip))
                        this.relationArray.push(relationShip);
                }
            }
        }
        else if (tempFactor.tempType == 2 && tempFactor.type == 2) {
            for (var j = 0; j < this.factorArray.length; j++) {
                var tempFactorTwo = this.factorArray[j];
                if (tempFactorTwo.tempType == 3 && tempFactorTwo.type == 0) {
                    var relationShip = {};
                    relationShip.hostId = i;
                    relationShip.guestId = j;
                    if (!this.isContains(this.relationArray, relationShip))
                        this.relationArray.push(relationShip);
                }
            }
        }
    }
    for (var i = 0; i < this.factorArray.length; i++) {
        var tempFactor = this.factorArray[i];
        if (tempFactor.tempType == 3 && tempFactor.type == 0) {
            tempFactor.type = 3;
        }
    }
    return;
}

Painter.prototype.setAllFactorToGrey = function () {
    for (var i = 0; i < this.factorArray.length; i++) {
        element = this.factorArray[i];
        if (element.type == 1)
            element.tempType = 4;
    }
}

Painter.prototype.drawRelationShipLine = function () {
    for (var i = 0; i < this.relationArray.length; i++) {
        var hostId = this.relationArray[i].hostId;
        var guestId = this.relationArray[i].guestId;

        var hostFactor = this.factorArray[hostId];
        var guestFactor = this.factorArray[guestId];

        var startPointX = hostFactor.startPointX + this.baseX + this.factorWidth / 2;
        var startPointY = hostFactor.startPointY + this.baseY + this.factorHeight / 2;

        var finishPointX = guestFactor.startPointX + this.baseX + this.factorWidth / 2;
        var finishPointY = guestFactor.startPointY + this.baseY + this.factorHeight / 2;


        if (guestFactor.type == 2) {
            this.context.fillStyle = "#00FF00";
        }
        this.context.beginPath();
        this.context.moveTo(startPointX, startPointY);
        this.context.lineTo(finishPointX, finishPointY);
        this.context.closePath();
        this.context.stroke();
        this.context.strokeStyle = "DBFFFF";
    }
}


