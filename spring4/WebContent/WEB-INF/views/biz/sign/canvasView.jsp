<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

	<section>
		<div id="signaturePad" style="height: 100px; width: 200px;border: 1px solid;">
			
		</div>
		<div class="row">
			<button class="btn" id="signSubmitBtn">사인 전송</button>
		</div>
		<div>
			<canvas id="sig-canvas" width="620" height="160"></canvas>
		</div>
		<div class="row">
			<button class="btn" id="sig-submitBtn">Submit Signature</button>
			<button class="btn" id="sig-clearBtn">Clear Signature</button>
			<button class="btn" id="sig-ajaxBtn">jsonRequestBody</button>
			<button class="btn" id="sig-ajaxBtn2">jsonRequestParam</button>
			<button class="btn" id="sig-ajaxBtn3">jsonServletRequest</button>
		</div>

		<div class="col-md-12">
			<textarea id="sig-dataUrl" class="form-control" rows="5">Data URL for your signature will go here!</textarea>
		</div>
		
		<div class="col-md-12">
			<img id="sig-image" src="" alt="Your signature will go here!"/>
		</div>
		
	</section>
	
<style >
#sig-canvas {
  border: 2px dotted #CCCCCC;
  border-radius: 15px;
  cursor: crosshair;
}
</style>
<script type="text/javaScript" defer="defer">
	
	var clickX = new Array();
	var clickY = new Array();
	var clickDrag = new Array();
	
	var clickX2 = new Array();
	var clickY2 = new Array();
	var clickDrag2 = new Array();
	
	var paint;
	var canvas;
	var context;
	
	/** Clear Canvas **/
	function clearSig() {
		clickX = new Array();
		clickY = new Array();
		clickDrag = new Array();
		canvas.width = canvas.width;
		canvas.height = canvas.height;
	}
	
	/** Redraw the Canvas **/
	function redraw() {
		canvas.width = canvas.width; // Clears the canvas
	
		context.strokeStyle = "#000000";
		context.lineJoin = "miter";
		context.lineWidth = 2;
	
		for (var i = 0; i < clickX.length; i++) {
			context.beginPath();
			if (clickDrag[i] && i) {
				context.moveTo(clickX[i - 1], clickY[i - 1]);
			} else {
				context.moveTo(clickX[i] - 1, clickY[i]);
			}
			context.lineTo(clickX[i], clickY[i]);
			context.closePath();
			context.stroke();
		}
	}
	
	function addClick(x, y, dragging) {
		clickX.push(x);
		clickY.push(y);
		clickDrag.push(dragging);
	}
	
	$(function() {
	
		var canvasWidth = $("#signaturePad").width();
		var canvasHeight = $("#signaturePad").height();
		
		var canvasDiv = document.getElementById('signaturePad');
		canvas = document.createElement('canvas');
		canvas.setAttribute('width', canvasWidth);
		canvas.setAttribute('height', canvasHeight);
		canvas.setAttribute('id', 'signCanvas');
		canvasDiv.appendChild(canvas);
		context = canvas.getContext("2d");	
	
		$('#signaturePad').on("touchmove", function (e) {
			if (paint) {
				addClick(e.originalEvent.touches[0].pageX - this.offsetLeft, e.originalEvent.touches[0].pageY - this.offsetTop, true);
				redraw();
			}
		});	
		
		$('#signaturePad').on("touchend", function (e) {
			paint = false;
		});
		
		$('#signaturePad').on("touchstart", function (e) {
			paint = true;
			addClick(e.originalEvent.touches[0].pageX - this.offsetLeft, e.originalEvent.touches[0].pageY - this.offsetTop);
			redraw();
		});

		
	    $("#signSubmitBtn").on( "click", function() {
	    	
		    var dataUrl = document.getElementById("signCanvas").toDataURL();
		    
			$.ajax({
				url: "<c:url value='/sign/canvasInsert'/>"
				, type: "POST"
				, dataType: "json"
				, async: true
				, contentType: "application/json; charset=UTF-8;"
				, data: JSON.stringify({ "id":"1222541","dataUrl":dataUrl })
				, success: function(data){
					console.log(data);
					alert(data);
				}, error: function(){
					alert('error');
				}, complete: function(){
				}
			});		
	    });
	    $("#sig-ajaxBtn").on( "click", function() {
			$.ajax({
				url: "<c:url value='/sign/jsonRequestBody'/>"
				, type: "POST"
				, dataType: "json"
				, async: true
				, contentType: "application/json;charset=UTF-8;"
				, data: JSON.stringify({ "id":"test","dataUrl":"sssss" })
				, success: function(data){
					console.log(data);
					alert(data);
				}, error: function(){
					alert('error');
				}, complete: function(){
				}
			});    	
	    });
	
	    /**
	    	JSON.stringify 있고 없고의 차이는 key,value를 RequestParameter로 확인하면 됨
	    	contentType셋팅도 안해서 기본 application/x-www-form-urlencoded; charset=UTF-8로 전송되야 key,value가 확인됨 
	    */
	    $("#sig-ajaxBtn2").on( "click", function() {
			$.ajax({
				url: "<c:url value='/sign/jsonRequestParam'/>"
				, type: "POST"
				, dataType: "json"
				, async: true
	//			, contentType: "application/json;charset=UTF-8;"
	//			, data: JSON.stringify({ "id":"test","dataUrl":"sssss" })
				, data: { "id":"test","dataUrl":"sssss" }
				, success: function(data){
					console.log(data);
					alert(data);
				}, error: function(){
					alert('error');
				}, complete: function(){
				}
			});    	
	    });
	
	    $("#sig-ajaxBtn3").on( "click", function() {
			$.ajax({
				url: "<c:url value='/sign/jsonServletRequest'/>"
				, type: "POST"
				, dataType: "json"
				, async: true
	//			, contentType: "application/json;charset=UTF-8;"
	//			, data: JSON.stringify({ "id":"test","dataUrl":"sssss" })
				, data: { "id":"asdfasd","dataUrl":"sssss" }
				, success: function(data){
					console.log(data);
					alert(data);
				}, error: function(){
					alert('error');
				}, complete: function(){
				}
			});    	
	    });
	
	});
	
	(function() {
		  window.requestAnimFrame = (function(callback) {
		    return window.requestAnimationFrame ||
		      window.webkitRequestAnimationFrame ||
		      window.mozRequestAnimationFrame ||
		      window.oRequestAnimationFrame ||
		      window.msRequestAnimaitonFrame ||
		      function(callback) {
		        window.setTimeout(callback, 1000 / 60);
		      };
		  })();
	
		  var canvas = document.getElementById("sig-canvas");
		  var ctx = canvas.getContext("2d");
		  ctx.strokeStyle = "#222222";
		  ctx.lineWidth = 2;
	
		  var drawing = false;
		  var mousePos = {
		    x: 0,
		    y: 0
		  };
		  var lastPos = mousePos;
	
		  canvas.addEventListener("mousedown", function(e) {
		    drawing = true;
		    lastPos = getMousePos(canvas, e);
		  }, false);
	
		  canvas.addEventListener("mouseup", function(e) {
		    drawing = false;
		  }, false);
	
		  canvas.addEventListener("mousemove", function(e) {
		    mousePos = getMousePos(canvas, e);
		  }, false);
	
		  // Add touch event support for mobile
		  canvas.addEventListener("touchstart", function(e) {
	
		  }, false);
	
		  canvas.addEventListener("touchmove", function(e) {
		    var touch = e.touches[0];
		    var me = new MouseEvent("mousemove", {
		      clientX: touch.clientX,
		      clientY: touch.clientY
		    });
		    canvas.dispatchEvent(me);
		  }, false);
	
		  canvas.addEventListener("touchstart", function(e) {
		    mousePos = getTouchPos(canvas, e);
		    var touch = e.touches[0];
		    var me = new MouseEvent("mousedown", {
		      clientX: touch.clientX,
		      clientY: touch.clientY
		    });
		    canvas.dispatchEvent(me);
		  }, false);
	
		  canvas.addEventListener("touchend", function(e) {
		    var me = new MouseEvent("mouseup", {});
		    canvas.dispatchEvent(me);
		  }, false);
	
		  function getMousePos(canvasDom, mouseEvent) {
		    var rect = canvasDom.getBoundingClientRect();
		    return {
		      x: mouseEvent.clientX - rect.left,
		      y: mouseEvent.clientY - rect.top
		    }
		  }
	
		  function getTouchPos(canvasDom, touchEvent) {
		    var rect = canvasDom.getBoundingClientRect();
		    return {
		      x: touchEvent.touches[0].clientX - rect.left,
		      y: touchEvent.touches[0].clientY - rect.top
		    }
		  }
	
		  function renderCanvas() {
		    if (drawing) {
		      ctx.moveTo(lastPos.x, lastPos.y);
		      ctx.lineTo(mousePos.x, mousePos.y);
		      ctx.stroke();
		      lastPos = mousePos;
		    }
		  }
	
		  // Prevent scrolling when touching the canvas
		  document.body.addEventListener("touchstart", function(e) {
		    if (e.target == canvas) {
		      e.preventDefault();
		    }
		  }, false);
		  document.body.addEventListener("touchend", function(e) {
		    if (e.target == canvas) {
		      e.preventDefault();
		    }
		  }, false);
		  document.body.addEventListener("touchmove", function(e) {
		    if (e.target == canvas) {
		      e.preventDefault();
		    }
		  }, false);
	
		  (function drawLoop() {
		    requestAnimFrame(drawLoop);
		    renderCanvas();
		  })();
	
		  function clearCanvas() {
		    canvas.width = canvas.width;
		  }
	
		  // Set up the UI
		  var sigText = document.getElementById("sig-dataUrl");
		  var sigImage = document.getElementById("sig-image");
		  var clearBtn = document.getElementById("sig-clearBtn");
		  var submitBtn = document.getElementById("sig-submitBtn");
		  clearBtn.addEventListener("click", function(e) {
		    clearCanvas();
		    sigText.innerHTML = "Data URL for your signature will go here!";
		    sigImage.setAttribute("src", "");
		  }, false);
		  submitBtn.addEventListener("click", function(e) {
		    var dataUrl = canvas.toDataURL();
		    sigText.innerHTML = dataUrl;
		    sigImage.setAttribute("src", dataUrl);
	
		    var testData = {
		    	    id: "123",
		    	    name: "123",
		    	    testTags: [{id: "1111", tag: "2222"}]
		    	};
		    
			$.ajax({
				url: "<c:url value='/sign/canvasInsert'/>"
				, type: "POST"
				, dataType: "json"
				, async: true
				, contentType: "application/json; charset=UTF-8;"
				, data: JSON.stringify({ "id":"1222541","dataUrl":dataUrl })
				, success: function(data){
					console.log(data);
					alert(data);
				}, error: function(){
					alert('error');
				}, complete: function(){
				}
			});
		    
		  }, false);
	
		})();
</script>


