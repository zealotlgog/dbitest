<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Show File</title>
<link href="styles/kendo.common.min.css" rel="stylesheet" />
<link href="styles/kendo.black.min.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="jqueryslidemenu.css" />
<script src="js/jquery.min.js"></script>
<script src="js/kendo.web.min.js"></script>
<script type="text/javascript"
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"></script>
<script type="text/javascript" src="jqueryslidemenu.js"></script>
<script type="text/javascript" src="painter.js"></script>
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
<script>
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

	window.onload = function() {
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
		}else{  
		    // IE 6/7/8  
		    canvas.attachEvent("onmousewheel", scaleCanvas);  
		} 
		draw();
	};
	
	function scaleCanvas(event){  
		if(isResizeOpen){
	    	event.preventDefault();  
	    	var e = window.event || event; // old IE support  
	    	var delta = Math.max(-1, Math.min(1, (e.wheelDelta || -e.detail)));
	    	if(delta==1){
	    		painter.reSize(1.1, event.offsetX,event.offsetY);
	    	}
	    	else if(delta==-1){
	    		painter.reSize(0.9,event.offsetX, event.offsetY);
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
		if (started) {
			painter.switchBasePoint(x - mouseDownX, y- mouseDownY);
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
		if(isShowGrid)
		painter.drawGridLine();
		painter.drawFactorContext(answerArray);
	}
	
	function showGridButtonClick(event){
		if(document.getElementById("gridshow").checked == true)
			isShowGrid = true;
		else if(document.getElementById("griddisshow").checked == true){
			isShowGrid = false;
			cleanCanvas();
		}
		draw();	
	}
	
	function changeGridSize(){
		var inputWidthValue = parseInt(document.getElementById("inputGridWidth").value);
		var inputHeightValue = parseInt(document.getElementById("inputGridHeight").value);
		if(inputWidthValue > 0 && inputWidthValue < 200 && inputHeightValue >0 && inputHeightValue < 200){
			painter.factorWidth = inputWidthValue;
			painter.factorHeight = inputHeightValue;
			cleanCanvas();
			draw();
		}
		else {
			alert("toooooooo big or tooooo small");
			return;
		}
	}
	
	function resizeButtonClick(){
		if(document.getElementById("resizeOpen").checked == true)
			isResizeOpen = true;
		else if(document.getElementById("resizeClose").checked == true){
			isResizeOpen = false;
		}
	}
	
	function cleanCanvas(){
		canvas.width = canvas.width;
	}

</script>
</head>
<body>
	<div id="mother" class="k-content"
		style="border: 5px #000000 solid; width: 1250px; height: 900px; overflow: auto">
		<div id="title" class="k-content"
			style="border: 5px #000000 solid; height: 50px; overflow: auto">
			<button>open</button>
			<button>view</button>
			<button>edit</button>
			<button>save</button>
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
					<textarea rows="1" cols="1" style="width: 100px">Open/Close grid line</textarea>
					<form method="post" name="form1">
						<label> <input type="radio" name="radio" id="gridshow"
							value="open" onclick="showGridButtonClick()">open
						</label> <label> <input type="radio" id="griddisshow" name="radio"
							value="close" onclick="showGridButtonClick()">close
						</label>
					</form>
				</div>
				<div id="gridLineControl" class="k-content"
					style="border: 5px #000000 solid; height: 150px;">
					<textarea rows="1" cols="1" style="width: 100px">Size of the Grid</textarea>
					<input type='text' name='txt' id='inputGridWidth'>width <input
						type='text' name='txt' id='inputGridHeight'>height <input
						type="submit" name="adjust" value="adjust"
						onclick='changeGridSize()'></input>
				</div>
				<div id="autoResizeControl" class="k-content"
					style="border: 5px #000000 solid; height: 100px;">
					<textarea rows="1" cols="1" style="width: 100px">Open/Close resize</textarea>
					<form method="post" name="form1">
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
				<p />
				You want to set it as:
				<p />
				<textarea rows="1" cols="10">blank</textarea>
				<div id="myslidemenu" class="jqueryslidemenu">
					<ul>
						<li>Type
							<ul>
								<li>Factor</li>
								<li>Property</li>
								<li>Value</li>
							</ul>
						</li>
					</ul>
				</div>
				<div>This element will belongs to</div>
			</div>
		</div>
		<div id="button" class="k-content"
			style="border: 5px #000000 solid; height: 100px; overflow: auto">
		</div>
	</div>
</body>
</html>
