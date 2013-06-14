exports.start = (port) ->
  console.log "starting tracking server"

  next = require 'nextflow'
  socketio = require 'socket.io'
  io = socketio.listen port
  io.set 'log level', 2
  io.set 'browser client', false

  mongodb = require "mongodb"
  server = new mongodb.Server "127.0.0.1", 27017
  db = new mongodb.Db "tracking", server, {w: 1}

  next flow =
    1: ->
      self = this
      db.open (err, database) ->
        self.next(database)

    2: (database)->
      self = this
      database.collection 'mouseTracking', (err, collection) ->
        console.log "Unable to access database: #{err}" if err
        self.next(collection)

    3: (collection) ->
      io.sockets.on 'connection', (socket) ->
        socket.on 'mouseMovement', (data) ->
          if data
              data.ip = socket.handshake.address.address
              console.log "data !" + data.ms
              collection.save data, (err, doc) ->
                  console.log "Unable to save record: #{err}" if err

        socket.on 'getId', (data) ->
          socket.emit 'newId', socket.id