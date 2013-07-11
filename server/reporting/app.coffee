exports.start = (port) ->
  process.chdir(__dirname)
  console.log "starting reporting server"

  #Init db
  mongoose = require 'mongoose'
  mongoose.connect 'mongodb://127.0.0.1/tracking'
  db = mongoose.connection
  db.on 'error', (err) -> console.error.bind(console, 'connection error:')

  #init models
  fs = require 'fs'
  models = fs.readdirSync('./models');
  for key in models
    require './models/' + models

  # init socket.io
  socketio = require 'socket.io'
  io = socketio.listen port
  io.set 'log level', 2
  io.set 'browser client', false

  io.sockets.on 'connection', (socket) ->
    socket.on 'generateHeatMapData', (data) ->
      console.log 'heatmap generation'

      mongoose.model('mouseTracking').generate data, (err, data) ->
        if !err
          socket.emit 'heatMapDataGenerated', data
          console.log 'heatmap generated'


    socket.on 'getAvailableUrls', (data) ->
      console.log 'get URLS'
      mongoose.model('mouseTracking').getAvailableUrls data, (err, data) ->
          if !err
              socket.emit 'getAvailableUrls'