draw is a demo to illustrate websocket protocole
================================================

open whiteboard is a drawing websocket javascript application,
you can find more information on given link. 

    <https://developer.mozilla.org/fr/demosdetail/open-whiteboard>


Quickstart
----------

get ChicagoBoss first

    git clone http://github.com/mihawk/ChicagoBoss.git
    cd ChicagoBoss 
    make
    cd ..
    
    
Get draw 
    
    git clone http://github.com/mihawk/draw.git
    cd draw
    make
    make start

Open http://localhost:8001/draw in your browser, 
open a second webrowser on the same url, or more
on the first browser, start to draw. :) 

behind the scene you shoul look to:

    src/lib/draw_protocol.erl
    priv/init/draw_02_draw_protocol.erl



    


