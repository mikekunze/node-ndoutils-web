#### node-ndoutils-web
This is a report generator webApp which uses node-ndoutils server side and a combination
of neat looking client side icon sets from bootstrap3 and font-awesome.  If you have ndoutils configured with
your nagios install, you can use this project to generate neat looking reports.  These reports
are easily extended.

![dashboard](https://raw.github.com/mikekunze/node-ndoutils-web/master/assets/img/img1.png)

![host list](https://raw.github.com/mikekunze/node-ndoutils-web/master/assets/img/img2.png)

#### Clicking a host to show its details

![host details](https://raw.github.com/mikekunze/node-ndoutils-web/master/assets/img/img3.png)


    $ git clone https://github.com/PortalGNU/node-ndotuils-web.git
    $ cd node-ndotuils-web

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
    
#### settings.coffee
    
Before testing or starting the report web server, you need to modify settings.coffee so that it matches
your MySQL server login credentials.

````javascript
settings =
  assets:
    compress: false

  session:
    cookie: "123456789012345667878"
    secret: "123456789012345667878"

  mysql:
    user : 'node'
    pass : 'nodepass'
    host : 'localhost'
    db   : 'ndoutils'

module.exports = settings
````

#### Running tests

A good way to determine if your system is ready to run this report generator
is to run the tests. It will try to retrieve reports from MySQL through node-ndoutils and 
try and connect to MySQL and start the web server.

    $ npm test

#### Running

    // Single thread quick start
    $ npm start

    // Cluster
    $ node cluster.js

#### Accessing

    browse to http://localhost:3000
    
#### General Purpose Web Stack

  - [Extending the webstack](https://github.com/mikekunze/node-ndoutils-web/wiki/Extending-the-web-stack)
