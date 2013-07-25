Draw is a demo of the websocket protocol in ChicagoBoss
=======================================================

Background
----------

`open whiteboard` is a drawing websocket javascript application,
you can find more information on the given link. 

    https://developer.mozilla.org/fr/demosdetail/open-whiteboard


draw come as an otp application

Quickstart
----------

Get draw

    $>git clone http://github.com/mihawk/draw.git
    $>cd draw
    $>make rel
    
Start Draw
```bash
    
    $>cd draw
    $>rel/draw/bin/draw start

```
    or get a console to see log :)

```bash

    $>rel/draw/bin/draw console     

```
    

Open `http://localhost:8001/draw` in your browser, 
open a second web browser on the same url, or a tab
in the first browser then start to draw. :) 

Digging in
----------

Behind the scenes, you should look at:

    
    draw/apps/draw/src/websocket/draw_draw_protocol_websocket.erl


Application directory canva
---------------------------


```sh

    .
    ├── apps                   <----- boss app folder
    │   ├── cb_admin
    │   └── draw
    ├── deps
    │   ├── boss               <----- all yours deps boss ... and yours
    │   └── ...
    ├── dist
    │   └── draw-<tag>.tar.gz  <----- your tarball
    ├── Makefile
    ├── rebar
    ├── rebar.config
    └── rel
        ├── files  
        │   ├── draw
        │   ├── draw.cmd
        │   ├── erl
        │   ├── install_upgrade.escript
        │   ├── nodetool
        │   ├── start_erl.cmd
        │   ├── sys.config
        │   └── vm.args
        ├── reltool.config
        └── vars.config

```
