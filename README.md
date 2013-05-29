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

    boss.config
    priv/src/websocket/draw_protocol.erl


i just add release to draw application,  
 follow this structure to be abble to do a release of your project.

update the reltool.config according to your application 

command:

>make rel


>make dist

	.
	├── apps            <----- boss app folder
	│   ├── cb_admin
	│   └── draw
	├── deps            <----- all yours deps
	│   ├── boss 
	│   └── .... 
	├── ebin
	├── Makefile
	├── rebar
	├── rebar.cmd
	├── rebar.config    <----- boss as deps and add yours
	└── rel
	    ├── files
	    ├── reltool.config
	    └── vars.config

