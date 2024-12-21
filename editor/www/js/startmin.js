$(function() {

    $('#side-menu').metisMenu();     
});


function setup_websocket() {

    var websocket = new WebSocket("ws://127.0.0.1:8080", "cmds");
    websocket.binaryType = "arraybuffer";

    websocket.onmessage = function(event) {
        var message = CBOR.decode(event.data);
        console.log(message);
    };

    websocket.onopen = function(event) {
    // Handle connection open
    };

    websocket.onclose = function(event) {
    // Handle connection close
    };

    function sendMessage(message) {
        websocket.send(message);
    }   

    return websocket;
}

function Utf8ArrayToStr(str) {
    const encoder = new TextEncoder(); // Uses 'utf-8' encoding by default
    return encoder.encode(str).buffer;
}

(() => {
    console.log("Starting websocket...");
    const ws = new WebSocket("ws://127.0.0.1:8080", "cmds")
    ws.binaryType = "arraybuffer";

    ws.onopen = () => {
      console.log('ws opened on browser')
    }
  
    ws.onmessage = (event) => {
        console.log(event);
        if (event.data instanceof ArrayBuffer) {
            const array = new Uint8Array(event.data);
            console.log('Received binary data: ', array);
        } 
        else {
            const jobj = JSON.parse(event.data);
            console.log(jobj);

            console.log('Received text data: ', event.data);
        }
    }

    window.addEventListener('beforeunload', function(event) {
        event.returnValue = ''; // Some browsers require this line
        console.log("Closing websocket...");
        ws.close();
        return ''; // Some browsers require this line too
    });

    console.log("Ready websocket."); 

    setTimeout( function() {
        let json = { Hello: "World" };
        ws.send(JSON.stringify(json));  
    }, 1000);

})();

//Loads the correct sidebar on window load,
//collapses the sidebar on window resize.
// Sets the min-height of #page-wrapper to window size
$(function() {
    $(window).bind("load resize", function() {
        topOffset = 50;
        width = (this.window.innerWidth > 0) ? this.window.innerWidth : this.screen.width;
        if (width < 768) {
            $('div.navbar-collapse').addClass('collapse');
            topOffset = 100; // 2-row-menu
        } else {
            $('div.navbar-collapse').removeClass('collapse');
        }

        height = ((this.window.innerHeight > 0) ? this.window.innerHeight : this.screen.height) - 1;
        height = height - topOffset;
        if (height < 1) height = 1;
        if (height > topOffset) {
            $("#page-wrapper").css("min-height", (height) + "px");
        }
    });

    var url = window.location;
    var element = $('ul.nav a').filter(function() {
        return this.href == url || url.href.indexOf(this.href) == 0;
    }).addClass('active').parent().parent().addClass('in').parent();
    if (element.is('li')) {
        element.addClass('active');
    }

});
