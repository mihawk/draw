$(document).ready(function() {


    var canvas = document.getElementById("canvas"), 
        ctx = canvas.getContext("2d"),
        remotecanvas = document.getElementById("remotecanvas"),
        remotectx = remotecanvas.getContext("2d"),
        $cvs = $("#canvas"),
        top = $cvs.offset().top,
        left = $cvs.offset().left,
        wsc = new WebSocket("ws://localhost:8001/draw/websocket/draw_protocol", "draw_protocol"),
        mySocketId = -1;


    var resizeCvs = function() {
        ctx.canvas.width = remotectx.canvas.width = $(window).width();
        ctx.canvas.height = remotectx.canvas.height = $(window).height();
        };
    
    var initializeCvs = function () {
        ctx.lineCap = remotectx.lineCap = "round";
        resizeCvs();
        ctx.save();
        remotectx.save();
        ctx.clearRect(0, 0, ctx.canvas.width, ctx.canvas.height);
        remotectx.clearRect(0,0, remotectx.canvas.width, remotectx.canvas.height);
        ctx.restore();
        remotectx.restore();
    };

    var draw = {
        isDrawing: false,
        mousedown: function(coordinates) {
            ctx.beginPath();
            ctx.moveTo(coordinates.x, coordinates.y);
            this.isDrawing = true;
        },
        mousemove: function(coordinates) {
            if (this.isDrawing) {
                ctx.lineTo(coordinates.x, coordinates.y);
                ctx.stroke();
            }
        },
        mouseup: function(coordinates) {
            this.isDrawing = false;
            ctx.lineTo(coordinates.x, coordinates.y);
            ctx.stroke();
            ctx.closePath();
        },
        touchstart: function(coordinates){
            ctx.beginPath();
            ctx.moveTo(coordinates.x, coordinates.y);
            this.isDrawing = true;
        },
        touchmove: function(coordinates){
            if (this.isDrawing) {
                ctx.lineTo(coordinates.x, coordinates.y);
                ctx.stroke();
            }
        },
        touchend: function(coordinates){
            if (this.isDrawing) {
                this.touchmove(coordinates);
                this.isDrawing = false;
            }
        }
    };
    var remotedraw = {
        isDrawing: false,
        mousedown: function(coordinates) {
            remotectx.beginPath();
            remotectx.moveTo(coordinates.x, coordinates.y);
            this.isDrawing = true;
        },
        mousemove: function(coordinates) {
            if (this.isDrawing) {
                remotectx.lineTo(coordinates.x, coordinates.y);
                remotectx.stroke();
            }
        },
        mouseup: function(coordinates) {
            this.isDrawing = false;
            remotectx.lineTo(coordinates.x, coordinates.y);
            remotectx.stroke();
            remotectx.closePath();
        },
        touchstart: function(coordinates){
            remotectx.beginPath();
            remotectx.moveTo(coordinates.x, coordinates.y);
            this.isDrawing = true;
        },
        touchmove: function(coordinates){
            if (this.isDrawing) {
                remotectx.lineTo(coordinates.x, coordinates.y);
                remotectx.stroke();
            }
        },
        touchend: function(coordinates){
            if (this.isDrawing) {
                this.touchmove(coordinates);
                this.isDrawing = false;
            }
        }
    };
    // create a function to pass touch events and coordinates to drawer
    function setupDraw(event, isRemote){

        var coordinates = {};
        var evt = {};
        evt.type = event.type;
        evt.socketid = mySocketId;
        evt.lineWidth = ctx.lineWidth;
        evt.strokeStyle = ctx.strokeStyle;
        if (event.type.indexOf("touch") != -1 ){
            evt.targetTouches = [{ pageX: 0, pageY: 0 }];
            evt.targetTouches[0].pageX = event.targetTouches[0].pageX || 0;
            evt.targetTouches[0].pageY = event.targetTouches[0].pageY || 0;
            coordinates.x = event.targetTouches[0].pageX - left;
            coordinates.y = event.targetTouches[0].pageY - top;
        } else {
            evt.pageX = event.pageX;
            evt.pageY = event.pageY;
            coordinates.x = event.pageX - left;
            coordinates.y = event.pageY - top;
        }
        if (event.strokeStyle) {
            remotectx.strokeStyle = event.strokeStyle;
            remotectx.lineWidth = event.lineWidth;
        }


        if (!isRemote) {
            wsc.send(JSON.stringify(evt));
            draw[event.type](coordinates);
        } else {
            remotedraw[event.type](coordinates);
        }
    };

    window.addEventListener("mousedown", setupDraw, false);
    window.addEventListener("mousemove", setupDraw, false);
    window.addEventListener("mouseup", setupDraw, false);
    canvas.addEventListener('touchstart',setupDraw, false);
    canvas.addEventListener('touchmove',setupDraw, false);
    canvas.addEventListener('touchend',setupDraw, false); 

    document.body.addEventListener('touchmove',function(event){
      event.preventDefault();
    },false);

    $('#clear').click(function (e) {
        initializeCvs(true);
        $("#sizer").val("");
    });
    
    $("#draw").click(function (e) {
        e.preventDefault();
        $("label[for='sizer']").text("Line Size:");
    });
    
  
    $("#colors li").click(function (e) { 
        e.preventDefault();
        $("label[for='sizer']").text("Line Size:");
        ctx.strokeStyle = $(this).css("background-color");
    });
    
 
    $("#sizer").change(function (e) {
        ctx.lineWidth = parseInt($(this).val(), 10);
    });

    initializeCvs();
    
    
    window.onresize = function() {
        resizeCvs();
    };


    wsc.onmessage = function(event) {
        if (event.data.indexOf("socketid_") !== -1) {
            mySocketId = event.data.split("_")[1];
        } else {
            var dt = JSON.parse(event.data);
            setupDraw(dt, true);
        }
        
    }
});
