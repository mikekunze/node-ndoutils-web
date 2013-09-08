vows   = require 'vows'
assert = require 'assert'

settings = require '../settings.coffee'
connection = {}

exports.testSettings = vows.describe("Testing settings file").addBatch
  'Testing the contents of settings.coffee':
    topic: ()->
      return settings

    'we have session keys': (settings)->
      assert.isString settings.session.cookie
      assert.isString settings.session.secret

    'we have mysql keys': (settings)->
      assert.isObject settings.mysql
      assert.isString settings.mysql.user
      assert.isString settings.mysql.pass
      assert.isString settings.mysql.host
      assert.isString settings.mysql.db

    ', we can connect to mysql':
      topic: ()->
        mysql = require 'mysql'
        connection = mysql.createConnection
          host     : settings.mysql.host
          user     : settings.mysql.user
          password : settings.mysql.pass
          database : settings.mysql.db

        vowzer = @
        connection.connect (err)->
          if err
            vowzer.callback(err)

          else
            vowzer.callback(null, connection)

      'we get no error in the callback': (err, connection)->
        assert.isNull err

      'we get a connection': (err, connection)->
        assert.isObject connection
        assert.isFunction connection.query


