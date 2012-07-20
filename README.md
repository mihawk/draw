Draw is a demo of the websocket protocol in ChicagoBoss
=======================================================

Background
----------

`open whiteboard` is a drawing websocket javascript application,
you can find more information on the given link. 

    https://developer.mozilla.org/fr/demosdetail/open-whiteboard


Quickstart
----------

Get ChicagoBoss

    git clone http://github.com/mihawk/ChicagoBoss.git
    cd ChicagoBoss 
    make
    cd ..
    
    
Get draw 
    
    git clone http://github.com/mihawk/draw.git
    cd draw
    make
    make start

Open `http://localhost:8001/draw` in your browser, 
open a second web browser on the same url, or a tab
in the first browser then start to draw. :) 

Digging in
----------

Behind the scenes, you should look at:

    src/lib/draw_protocol.erl
    priv/init/draw_02_draw_protocol.erl



    


