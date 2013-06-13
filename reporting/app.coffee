console.log "starting reporting server"

express = require 'express'
http = require 'http'
socketio = require 'socket.io'
next = require 'nextflow'

app = do express
server = http.createServer app
io = socketio.listen server
io.set 'log level', 2

server.listen 9012

mongodb = require "mongodb"
server = new mongodb.Server "127.0.0.1", 27017
db = new mongodb.Db "tracking", server, {w: 1}

next flow =
  1: ->
    self = this
    db.open (err, database) ->
      self.next(database)

  2: (database) ->
    self = this
    database.collection 'mouseTracking', (err, collection) ->
      console.log "Unable to access database: #{err}" if err
      self.next(collection)

  3: (collection) ->
    io.sockets.on 'connection', (socket) ->
      socket.on 'generateHeatMapData', (data) ->
        console.log 'heatmap generation'

        map = () ->
          x = Math.round(parseInt(this.x) / 10) * 10
          y = Math.round(parseInt(this.y) / 10) * 10
          if x > 0 and y > 0
            emit x + ':' + y, {x: x, y:y, weight: 1}

        reduce = (key, docs) ->
          coordinates = key.split(':')
          return {x: coordinates[0], y:coordinates[1], weight: docs.length}

        collection.mapReduce map, reduce, {out : {inline: 1}, verbose:true}, (err, results, stats) ->
          if !err
            socket.emit 'heatMapDataGenerated', results
            console.log 'heatmap generated'