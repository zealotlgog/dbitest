<%@page language="java" contentType="text/html; charset=UTF-8"
        pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Show File</title>
    <link href="styles/kendo.common.min.css" rel="stylesheet"/>
    <link href="styles/kendo.black.min.css" rel="stylesheet"/>
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
            //painter.findByLocation(event.offsetX,event.offsetY);
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
            if (isShowGrid)
                painter.drawGridLine();
            painter.drawFactorContext(answerArray);
        }

        function showGridButtonClick(event) {
            if (document.getElementById("gridshow").checked == true)
                isShowGrid = true;
            else if (document.getElementById("griddisshow").checked == true) {
                isShowGrid = false;
                cleanCanvas();
            }
            draw();
        }

        function changeGridSize() {
            var inputWidthValue = parseInt(document.getElementById("inputGridWidth").value);
            var inputHeightValue = parseInt(document.getElementById("inputGridHeight").value);
            if (!isEdit) {
                if (inputWidthValue > 0 && inputWidthValue < 200 && inputHeightValue > 0 && inputHeightValue < 200) {
                    painter.factorWidth = inputWidthValue;
                    painter.factorHeight = inputHeightValue;
                    cleanCanvas();
                    draw();
                }
                else {
                    alert("toooooooo big or tooooo small");
                }
            }
        }

        function resizeButtonClick() {
            if (document.getElementById("resizeOpen").checked == true)
                isResizeOpen = true;
            else if (document.getElementById("resizeClose").checked == true) {
                isResizeOpen = false;
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


    </script>
</head>
<body>
<div id="mother" class="k-content"
     style="border: 5px #000000 solid; width: 1250px; height: 900px; overflow: auto">
    <div id="title" class="k-content"
         style="border: 5px #000000 solid; height: 100px; overflow: auto">
        <div id="openButtonDive" class="k-content"
             style="border: 5px #000000 solid; height: 100px; width: 180px; overflow: auto; float: left">
            Select the file to open<p></p>

            <form action="fileUpload.html" method="post" enctype="multipart/form-data">
                <input type="file" name="fileUpload"/>
                <input type="submit" value="upload"/>
            </form>
        </div>
        <div id="modeSelectDive" class="k-content"
             style="border: 5px #000000 solid; height: 100px; width: 180px; overflow: auto; float: left">
            select current view mode<p></p>
            <select id="viewMode" style="width:100px" onchange="changetoEdit()">
                <option type="1" value="1">View</option>
                <option type="2" value="2">Edit</option>
            </select>
        </div>
        <div id="gridShowButtonDive" class="k-content"
             style="border: 5px #000000 solid; height: 100px; width: 180px; overflow: auto; float: left">
            Open or close the grid line.<p></p>
            <button id="gridShowButton" style="width:100px">close</button>
        </div>
        <div id="factorSizeButtonDiv" class="k-content"
             style="border: 5px #000000 solid; height: 100px; width: 180px; overflow: auto; float: left">
            Size of the grid.<p></p>
            <button id="factorSizeButton" style="width:100px">apply</button>
        </div>
        <div id="resizeButtonDiv" class="k-content"
             style="border: 5px #000000 solid; height: 100px; width: 180px; overflow: auto; float: left">
            Open or close resize function.<p></p>
            <button id="resizeButton" style="width:100px">open resize</button>
        </div>
        <div id="saveButtonDiv" class="k-content"
             style="border: 5px #000000 solid; height: 100px; width: 180px; overflow: auto; float: left">
            Save current grid to database.<p></p>
            <button id="saveButton" style="width:100px">save</button>
        </div>
    </div>
    <div id="center" class="k-content"
         style="border: 5px #000000 solid; height: 800px; width: 1240px; overflow: auto">
        <div id="gridPanel" class="k-content"
             style="border: 5px #000000 solid; height: 800px; width: 800px; overflow: auto; float: left">
            <canvas width="800" height="800" id="myCanvas"></canvas>
        </div>
        <div id="controlPanel" class="k-content"
             style="border: 5px #000000 solid; height: 800px; width: 200px; overflow: auto; float: left">
            <div id="gridLineControl" class="k-content"
                 style="border: 5px #000000 solid; height: 100px;">
                <label>
                    <textarea rows="1" cols="1" style="width: 100px">Open/Close grid line</textarea>
                </label>

                <form method="post" name="form1" action="">
                    <label> <input type="radio" name="radio" id="gridshow"
                                   value="open" onclick="showGridButtonClick()">open
                    </label> <label> <input type="radio" id="griddisshow" name="radio"
                                            value="close" onclick="showGridButtonClick()">close
                </label>
                </form>
            </div>
            <div id="gridSizeControl" class="k-content"
                 style="border: 5px #000000 solid; height: 150px;">
                <label>
                    <textarea rows="1" cols="1" style="width: 100px">Size of the Grid</textarea>
                </label>
                <input type='text' name='txt' id='inputGridWidth'>width <input
                    type='text' name='txt' id='inputGridHeight'>height <input
                    type="submit" name="adjust" value="adjust"
                    onclick='changeGridSize()'>
            </div>
            <div id="autoResizeControl" class="k-content"
                 style="border: 5px #000000 solid; height: 100px;">
                <label>
                    <textarea rows="1" cols="1" style="width: 100px">Open/Close resize</textarea>
                </label>

                <form method="post" name="form1" action="">
                    <label> <input type="radio" name="radio" id="resizeOpen"
                                   value="open" onclick="resizeButtonClick()">open
                    </label> <label> <input type="radio" name="radio" id="resizeClose"
                                            value="close" onclick="resizeButtonClick()">close
                </label>
                </form>
            </div>
        </div>
        <div id="infoPanel" class="k-content"
             style="border: 5px #000000 solid; height: 800px; width: 195px; overflow: auto; float: left">
            Info of the factor:
            <p></p>
            You want to set it as:
            <p></p>
            <label>
                <textarea rows="1" cols="10">blank</textarea>
            </label>

            <div>This element will belongs to</div>
        </div>
    </div>
    <div id="button" class="k-content"
         style="border: 5px #000000 solid; height: 100px; overflow: auto">
    </div>
</div>
</body>
</html>
