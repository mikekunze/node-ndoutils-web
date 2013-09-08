vows   = require 'vows'
assert = require 'assert'
request  = require 'request'

settings = require '../settings.coffee'
Web      = require '../lib/Web.coffee'
web = {}

url = "http://localhost:3000"

exports.testWebServer = vows.describe("Web Class").addBatch
  'Create an instance of Web class':
    topic: ()->
      web = new Web(settings)
      web.settings.scriptPath = __dirname + "/../"
      web.muteOutput = true

      return web

    'we get a web instance object back': (web)->
      assert.isObject web

    'it has inherited events': (web)->
      assert.isTrue web.hasEvents

    'it has inherited controller': (web)->
      assert.isTrue web.hasController

    'it has a controller object': (web)->
      assert.isObject web.controller

    'it has inherited security': (web)->
      assert.isTrue web.hasSecurity

    'it has a defined log function': (web)->
      assert.isFunction web.log

    'it has not been configured, yet': (web)->
      assert.isUndefined web.configured

    ', configure the web server and add mocked routes':
      topic: ()->
        web.configure()

        # Mock '/mock' route and return a JSON obj to test for
        # LENGTH - 2
        web.app.get '/mock', (req, res)->
          res.send { success: true }

        # Mock '/api/random/:random'
        # LENGTH - 1
        web.app.get '/api/random/:random', (req, res)->
          res.send { success: true, random: req.params.random }

        return web

      'we get a configured web server': (web)->
        assert.isTrue web.configured

      'it has a redis session store': (web)->
        assert.isObject web.sessionStore

      'it hasViewPort, and a viewPort object with core methods': (web)->
        assert.equal web.hasViewPort, true
        assert.isObject web.viewPort

        methods = web.viewPort.methods
        hasGetViewByName          = false
        hasGetCarouselForViewName = false
        hasGetGlobalNavigation    = false
        for id of methods
          switch methods[id].name
            when "getViewByName"
              hasGetViewByName = true
            when "getCarouselForViewName"
              hasGetCarouselForViewName = true
            when "getGlobalNavigation"
              hasGetGlobalNavigation = true

        assert.equal hasGetViewByName, true
        assert.equal hasGetCarouselForViewName, true
        assert.equal hasGetGlobalNavigation, true

        length = web.viewPort.methods.length > 1
        assert.equal length, true

      'it has an app fn reference': (web)->
        assert.isFunction web.app

      'it has our mocked /mock route, pushed to app': (web)->
        get = web.app.routes.get
        assert.equal get[get.length - 2].path, '/mock'

      'it has our mocked /api/random/:random, pushed to app': (web)->
        get = web.app.routes.get
        assert.equal get[get.length - 1].path, '/api/random/:random'

      'it has an ndoutils object with a connect fn': (web)->
        assert.isObject web.ndoutils
        assert.isFunction web.ndoutils.connect

      'its not listening, yet': (web)->
        assert.isUndefined web.listening

      ', listen on port ':
        topic: ()->
          web = web.createServer()
          return web

        'server is listening': (web)->
          assert.isTrue web.listening
          assert.isObject web.listener

        ', GET /':
          topic: ()->
            request "#{url}/", this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200

          'should be a full HTML index page': (e, res, body)->
            hasHtmlTagBegin = false
            hasHtmlTagEnd   = false

            if body.indexOf("<html><head><title>") >= 0
              hasHtmlTagBegin = true

            if body.indexOf("</html>") >= 0
              hasHtmlTagEnd = true

            assert.equal hasHtmlTagBegin, true
            assert.equal hasHtmlTagEnd,   true

        ', GET /mock':
          topic: ()->
            request url + '/mock', this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200

          'should have mocked data returned': (e, res, body)->
            assert.equal JSON.parse(res.body).success, true

        ', GET /api/view/geCarousel?name=index':
          topic: ()->
            request url + '/api/view/getCarousel?name=index', this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200

          'should have data returned': (e, res, body)->
            assert.equal JSON.parse(res.body).success, true
            assert.isString JSON.parse(res.body).html

        ', GET /api/view/getGlobalNavigation?name=index':
          topic: ()->
            request url + '/api/view/getGlobalNavigation?name=index', this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200

          'should have data returned': (e, res, body)->
            assert.equal JSON.parse(res.body).success, true
            assert.isString JSON.parse(res.body).html

        ', GET /api/view/getViewByName?name=index':
          topic: ()->
            request url + '/api/view/getViewByName?name=index', this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200

          'should have HTML returned': (e, res, body)->
            assert.equal    JSON.parse(res.body).success, true
            assert.isString JSON.parse(res.body).html

        ', GET /api/view/getServiceDetailsByHost?name=ndoutils':
          topic: ()->
            request url + '/api/view/getServiceDetailsByHost?name=ndoutils', this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200
            assert.equal    JSON.parse(res.body).success, true

          'should have HTML returned': (e, res, body)->
            assert.isString JSON.parse(res.body).html

          'should have a hosts object': (e, res, body)->
            assert.isObject JSON.parse(res.body).hosts

          'should run the controller\'s computeNdoutilStats against its hosts inline after rendered html': (e, res, body)->
            html = JSON.parse(res.body).html
            assert.equal html.indexOf("window.controller.computeNdoutilStats(window.controller.hosts)") >= 0, true

        ', GET /api/random/testing':
          topic: ()->
            request url + '/api/random/testing', this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200

          'should have random returned': (e, res, body)->
            assert.equal JSON.parse(res.body).success, true
            assert.equal JSON.parse(res.body).random, 'testing'

        ', GET /api/view/getViewByName?name=doesntExist':
          topic: ()->
            request url + '/api/view/getViewByName?name=doesntExist', this.callback
            undefined

          'should respond with a 200 OK': (e, res, body)->
            assert.equal res.statusCode, 200

          'should have an err object returned': (e, res, body)->
            assert.isObject JSON.parse(res.body).err


