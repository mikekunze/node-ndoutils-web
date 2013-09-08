#### node-web-skel
This is a skel project with the intended goal of adding MVC by commit, and used in a blog series.  
If you would like to try it, clone it.

    $ git clone https://github.com/PortalGNU/node-web-skel.git
    $ cd node-web-skel

#### Dependencies
  - bower 1.2.6
  - Node 0.10.18
  - Redis

#### Global Dependencies

    $ sudo npm install -g coffee-script

#### Configuration
The templates in this stack point their script tags to public/components.  By default,
bower stores installed components in bower_components at the root
of the project folder.  You can either move it as public/components
or ***set this as your ~/.bowerrc***:

````javascript
{
  "directory"  : "public/components",
  "json"       : "bower.json",
  "endpoint"   : "https://bower.herokuapp.com",
  "searchpath" : ["https://bower.herokuapp.com"]
}
````

#### Installation

    $ npm install
    $ bower install

#### Running

    // Single thread quick start
    $ npm start

    // testing
    $ npm test

    // Cluster
    $ node cluster.js

#### Accessing

    browse to http://localhost:3000

#### Running tests
A good way to determine if your system is ready to run this webstack,
run the tests. It will tell you if stack dependencies such as
modules and settings are met.  As this stack progresses, tests will
allow a test driven style of development.

    $ npm test

#### Creating Views

    $ mkdir ./views/aNewView
    $ echo "<div class=\"well\">HELLO</div>" > ./views/aNewView/body.jade

#### Switching Views

Navigate to http://localhost:3000/ in your browser,
Open up the dev console:

````javascript
    window.controller.view = 'aNewView';
    window.controller.displayView();
````

#### Doing fun interactive stuff!
If you want to interact with the web server, simply start the server up
inside the coffee console.  You will have access to web, which is running
a listening web server.  Go ahead and tab complete the object
to see what it contains.

    $ cd node-web-skel
    $ coffee

    coffee> settings = require './settings.coffee'

    coffee> Web = require './lib/Web.coffee'
    coffee> web = new Web settings

    coffee> web.settings.scriptPath = process.cwd()

    coffee> web.configure()
    coffee> web.createServer()


At this point, you have a web object, with the app reference.
You can browse our defined index route at http://localhost:3000/ , and more
interestingly, can create new routes which apply immediately.
Go ahead and create a new route, just for fun.  Call it 'justForFun'

    coffee> web.app.get '/justForFun', (req, res)-> res.send { success: true }

Now hit up http://localhost:3000/justForFun

Neat.

#### Running cluster
If you decide you dont want to directly interact with the web server, you can
also use coffee cli to run the cluster ware.  Make sure to end your previously
listening server (ctrl + c a few times).

    $ coffee

    coffee> cluster = require 'cluster'
    coffee> cluster.setupMaster { exec: 'app.js' }

    coffee> workers = []
    coffee> workers.push(cluster.fork())
    1
    coffee> worker 1: Express server listening on port 3000


So now, we have an array of workers containing the information of forked process(es).
We can make as many as we need, or even kill off a few.

    coffee> workers.push(cluster.fork())
    2
    coffee> worker 2: Express server listening on port 3000

    coffee> workers[0].kill()

At this point, our first server listening on the port has hung up because
we killed it, but our second server is still listening, so you can still get to
http://localhost:3000

If we kill off our second process, then we can no longer get through to http://localhost:3000,
until we spawn a new one

    coffee> workers[1].kill()

    coffee> workers.push(cluster.fork())
    3
    coffee> worker 3: Express server listening on port 3000
    coffee> workers

````javascript
[
  {
    domain: null,
    _events: {},
    _maxListeners: 10,
    id: 1,
    uniqueID: 1,
    workerID: 1,
    state: 'dead',
    suicide: true
  },

  {
    domain: null,
    _events: {},
    _maxListeners: 10,
    id: 2,
    uniqueID: 2,
    workerID: 2,
    state: 'dead',
    suicide: true
  },

  {
    domain: null,
    _events: {},
    _maxListeners: 10,
    id: 3,
    uniqueID: 3,
    workerID: 3,
    state: 'listening'
  }
]
````
