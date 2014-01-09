<%@page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Show File</title>
<link href="styles/kendo.common.min.css" rel="stylesheet"/>
<link href="styles/kendo.blueopal.min.css" rel="stylesheet"/>
<script type="text/javascript" src="extra/jquery.min.js"></script>
<script type="text/javascript" src="extra/kendo.web.min.js"></script>
<script type="text/javascript" src="extra/painter.js"></script>
<%
    String[][] jspArray = null;
    if (request.getAttribute("answer") != null)
        jspArray = (String[][]) request.getAttribute("answer");
%>
<script>
    var answerArray = new Array();
    <%if (jspArray != null) {%>
    <%for (int i = 0; i < jspArray.length; i++) {%>
    var tempArray = new Array();
    <%for (int j = 0; j < jspArray[i].length; j++) {%>
    tempArray[<%=j%>] = '<%=jspArray[i][j]%>';
    <%}%>
    answerArray[<%=i%>] = tempArray;
    <%}
}%>

</script>
<script type="text/javascript">
var context = null; // global context which is used to draw picture
var started = false; // if the mouse is moving
var isEdit = false; // if the user is select and saving factors.
var isShowGrid = true; // if the user select to show or not show the grid
var isResizeOpen = true; // if the user select to open the resize function
var editMode = 0; // the edit mode of the canvas

//actual width and height for the canvas
var actualWidth = 4000;
var actualHeight = 4000;

//basePoint for the canvas
var basePointX = 200;
var basePointY = 200;

// size for the grid lines
var lineGridX = 100;
var lineGridY = 30;

//position that the mouse click
var mouseDownX = 0;
var mouseDownY = 0;

var painter;
var canvas;

window.onload = function () {

    $("#saveButton").kendoButton();
    $("#gridShowButton").kendoButton();
    $("#factorSizeButton").kendoButton();
    $("#resizeButton").kendoButton();
    $("#viewMode").kendoDropDownList();
    $("#setFactorButton").kendoButton();
    $("#setPropButton").kendoButton();
    $("#setValueButton").kendoButton();

    // page loading function and also init the page
    // init the canvas and the context;
    canvas = document.getElementById("myCanvas");
    // if the brower do not support html 5 then just log it.
    if (!canvas.getContext) {
        alert("you browser do not support html5!");
        return;
    }

    // get 2D context of canvas and draw rectangel
    context = canvas.getContext("2d");
    context.lineWidth = 1;

    painter = new Painter(context, basePointX, basePointY, actualWidth, actualHeight,
            lineGridX, lineGridY);

    painter.transferFactors(answerArray);

    // mouse event
    canvas.addEventListener("mousedown", doMouseDown, false);
    canvas.addEventListener('mousemove', doMouseMove, false);
    canvas.addEventListener('mouseup', doMouseUp, false);

    if (canvas.addEventListener) {
        // IE9, Chrome, Safari, Opera
        canvas.addEventListener("mousewheel", scaleCanvas, false);
        // Firefox
        canvas.addEventListener("DOMMouseScroll", scaleCanvas, false);
    } else {
        // IE 6/7/8
        canvas.attachEvent("onmousewheel", scaleCanvas);
    }
    draw();
};

function scaleCanvas(event) {
    if (isResizeOpen && !isEdit) {
        event.preventDefault();
        var e = window.event || event; // old IE support
        var delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)));
        if (delta == 1) {
            painter.reSize(1.1, event.offsetX, event.offsetY);
        }
        else if (delta == -1) {
            painter.reSize(0.9, event.offsetX, event.offsetY);
        }
        cleanCanvas();
        draw();
    }
}

function doMouseDown(event) {
    mouseDownX = event.pageX;
    mouseDownY = event.pageY;
    if (editMode == 1 && isEdit)
        onMouseClickWithEditFactor(event);
    else if (editMode == 2 && isEdit)
        onMouseClickWithConfigureFactor(event);
    else if (editMode == 3 && isEdit)
        onMouseClickWithConfigureProp(event);
    started = true;
}

function doMouseMove(event) {
    var x = event.pageX;
    var y = event.pageY;
    if (started && !isEdit) {
        painter.switchBasePoint(x - mouseDownX, y - mouseDownY);
        cleanCanvas();
        draw();
        mouseDownX = x;
        mouseDownY = y;
        context.stroke();
    }
}

function doMouseUp(event) {
    console.log("mouse up now");
    if (started) {
        doMouseMove(event);
        started = false;
    }
}

function draw() {
    if (isShowGrid) {
        painter.drawGridLine();
    }
    painter.drawFactorContext();
    painter.drawRelationShipLine();
}

function showGridButtonClick(event) {
    if (isShowGrid) {
        isShowGrid = false;
        document.getElementById("gridShowButton").textContent = "Open";
    }
    else {
        isShowGrid = true;
        document.getElementById("gridShowButton").textContent = "Close";
    }
    cleanCanvas();
    draw();
}

function changeGridSize() {
    var inputWidthValue = parseInt(document.getElementById("inputGridWidth").value);
    var inputHeightValue = parseInt(document.getElementById("inputGridHeight").value);
    if (!isEdit) {
        if (inputWidthValue > 0 && inputWidthValue < 200 && inputHeightValue > 0 && inputHeightValue < 200) {
            painter.reSetFactorSize(inputWidthValue, inputHeightValue);
            cleanCanvas();
            draw();
        }
        else {
            alert("toooooooo big or tooooo small");
        }
    }
}

function resizeButtonClick() {
    if (isResizeOpen) {
        isResizeOpen = false;
        document.getElementById("resizeButton").textContent = "Open";
    }
    else {
        isResizeOpen = true;
        document.getElementById("resizeButton").textContent = "Close";
    }
}

function cleanCanvas() {
    canvas.width = canvas.width;
}

function changetoEdit() {
    var objS = document.getElementById("viewMode");
    var optionText = objS.options[objS.selectedIndex].text;
    if (optionText == "View")
        isEdit = false;
    else if (optionText == "Edit")
        isEdit = true;
}

function saveToDatabase() {
    var jsonParameter = kendo.stringify(painter.getFactorArray());

    $.ajax(
            {
                url: "saveFactor.html",
                type: "POST",
                data: jsonParameter,
                success: function (data) {
                    alert("Save successful!");
                },
                dataType: "json",
                contentType: "application/json"
            });
}

function onMouseClickWithEditFactor(event) {
    painter.setFactors(event.offsetX, event.offsetY);
    cleanCanvas();
    draw();
}

function onMouseClickWithConfigureFactor(event) {
    painter.setProps(event.offsetX, event.offsetY);
    cleanCanvas();
    draw();
}

function onMouseClickWithConfigureProp(event) {
    painter.setValues(event.offsetX, event.offsetY);
    cleanCanvas();
    draw();
}

function setFactor() {
    // if we are not able to edit, then return.
    if (!isEdit)
        return;
    // if we are not under a editMode, then enter the factor add mode.
    if (editMode == 0) {
        editMode = 1;
        document.getElementById("setFactorButton").textContent = "Apply";
    }
    // if we are under the add factor mode.
    else if (editMode == 1) {
        editMode = 0;
        document.getElementById("setFactorButton").textContent = "Begin to Set Factor";
        painter.confirmFactor();
    }
}

function setProp() {
    // if we are not able to edit, then return
    if (!isEdit)
        return;

    // if we are not under a editMode, then enter the factor add mode.
    if (editMode == 0) {
        editMode = 2;
        document.getElementById("setPropButton").textContent = "Apply";
    }
    // if we are under the add factor mode.
    else if (editMode == 2) {
        editMode = 0;
        document.getElementById("setPropButton").textContent = "Begin to Set Prop";
        painter.confirmProps();
    }
}

function setValue() {
    // if we are not able to edit, then return
    if (!isEdit)
        return;

    // if we are not under a editMode, then enter the factor add mode.
    if (editMode == 0) {
        editMode = 3;
        document.getElementById("setValueButton").textContent = "Apply";
    }
    // if we are under the add factor mode.
    else if (editMode == 3) {
        editMode = 0;
        document.getElementById("setValueButton").textContent = "Begin to Set Value";
        painter.confirmValues();
    }
}


</script>
</head>
<body>
<div id="mother" class="k-content"
     style="border: 5px #D1FFFF solid; width: 1200px; height: 900px;">
    <div id="title" class="k-content"
         style="border: 5px #D1FFFF solid; height: 160px; overflow: auto">

        <div id="openButtonDive" class="k-content"
             style="border: 5px #D1FFFF solid; height: 150px; width: 190px; float: left">
            Select the file to open<p></p>

            <form action="fileUpload.html" method="post" enctype="multipart/form-data">
                <input type="file" name="fileUpload"/>
                <input type="submit" value="upload"/>
            </form>
        </div>

        <div id="modeSelectDive" class="k-content"
             style="border: 5px #D1FFFF solid; height: 150px; width: 190px; overflow: auto; float: left">
            select current view mode<p></p>
            <select id="viewMode" style="width:100px" onchange="changetoEdit()">
                <option type="1" value="1">View</option>
                <option type="2" value="2">Edit</option>
            </select>
        </div>

        <div id="gridShowButtonDive" class="k-content"
             style="border: 5px #D1FFFF solid; height: 150px; width: 190px; overflow: auto; float: left">
            Open or close the grid line.<p></p>
            <button id="gridShowButton" style="width:100px" onclick="showGridButtonClick()">Close</button>
        </div>

        <div id="factorSizeButtonDiv" class="k-content"
             style="border: 5px #D1FFFF solid; height: 150px; width: 190px; overflow: auto; float: left">
            Size of the grid.<p></p>
            <input type='text' name='txt' id='inputGridWidth'><label for="inputGridWidth">width </label><input
                type='text' name='txt' id='inputGridHeight'><label for="inputGridHeight">height</label>
            <button id="factorSizeButton" style="width:100px" onclick='changeGridSize()'>apply</button>
        </div>

        <div id="resizeButtonDiv" class="k-content"
             style="border: 5px #D1FFFF solid; height: 150px; width: 190px; overflow: auto; float: left">
            Open or close resize function.<p></p>
            <button id="resizeButton" style="width:100px" onclick="resizeButtonClick()">Close</button>
        </div>

        <div id="saveButtonDiv" class="k-content"
             style="border: 5px #D1FFFF solid; height: 150px; width: 180px; overflow: auto; float: left">
            Save current grid to database.<p></p>
            <button id="saveButton" style="width:100px" onclick="saveToDatabase()">save</button>
        </div>
    </div>
    <div id="center" class="k-content"
         style="border: 5px #D1FFFF solid; height: 810px; overflow: auto">
        <div id="gridPanel" class="k-content"
             style="border: 5px #D1FFFF solid; height: 800px; width: 900px; overflow: auto; float: left">
            <canvas width="900" height="800" id="myCanvas"></canvas>
        </div>
        <div id="controlPanel" class="k-content"
             style="border: 5px #D1FFFF solid; height: 800px; width: 270px; overflow: auto; float: left">
            Set the type of the elements
            <div id="setFactorButtonDiv" class="k-content"
                 style="border: 5px #D1FFFF solid; height: 100px; width: 260px; overflow: auto; float: left">
                <button id="setFactorButton" style="width:100px" onclick="setFactor()">Begin to Set Factor</button>
            </div>
            <div id="setPropButtonDiv" class="k-content"
                 style="border: 5px #D1FFFF solid; height: 100px; width: 260px; overflow: auto; float: left">
                <button id="setPropButton" style="width:100px" onclick="setProp()">Begin to Set Prop</button>
            </div>
            <div id="setValueButtonDiv" class="k-content"
                 style="border: 5px #D1FFFF solid; height: 100px; width: 260px; overflow: auto; float: left">
                <button id="setValueButton" style="width:100px" onclick="setValue()">Begin to Set Value</button>
            </div>
        </div>
    </div>
    <div id="button" class="k-content"
         style="border: 5px #D1FFFF solid; height: 100px; overflow: auto">
    </div>
</div>
</body>
</html>
