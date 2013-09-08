vows     = require 'vows'
assert   = require 'assert'
Ndoutils = require 'node-ndoutils'

settings = require '../settings.coffee'
ndoutils = new Ndoutils settings
ndoutils.connect()

exports.testMethods = vows.describe("Testing node-Ndotuils methods").addBatch
  'we can getServiceDetailsByHost':
    topic: ()->
      ndoutils.getServiceDetailsByHost this.callback
      return undefined

    'we get no err and valid data': (err, data)->
      assert.isNull err
      assert.isObject data

  'we can getHosts':
    topic: ()->
      ndoutils.getHosts this.callback
      return undefined

    'we get an array of hosts back': (data)->
      assert.isArray data

  'we can getServices':
    topic: ()->
      ndoutils.getServices this.callback
      return undefined

    'we get an array of services back': (err, rows, fields)->
      assert.isNull err
      assert.isArray rows
      assert.isArray fields

  'we can getServiceDetails':
    topic: ()->
      ndoutils.getServiceDetails this.callback
      return undefined

    'we get an array of service details back': (err, rows, fields)->
      assert.isNull err
      assert.isArray rows
      assert.isArray fields

exports.closeMySqlAfterTestSettings = vows.describe("Finished testing node-Ndoutils, closing ndoutils Connection").addBatch


  'we close it':
    topic: ()->
      return ndoutils.end()

    'get the mysql connection': (ndoutils)->
      assert.isObject ndoutils

