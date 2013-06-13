console.log "starting tracking server"
cluster = require("cluster")
numCPUs = require("os").cpus().length
if cluster.isMaster
  i = 0
  cluster.on 'fork', (worker) ->
    console.log 'forked worker ' + worker.process.pid
  cluster.on "listening", (worker, address) ->
    console.log "worker " + worker.process.pid + " is now connected to " + address.address + ":" + address.port
  cluster.on "exit", (worker, code, signal) ->
    console.log "worker " + worker.process.pid + " died"
  while i < numCPUs
    cluster.fork()
    i++
else
  http = require 'http'
  next = require 'nextflow'
  socketio = require 'socket.io'
  io = socketio.listen 9011

  # Socket io configuration
  RedisStore = require 'socket.io/lib/stores/redis'
  redis = require 'socket.io/node_modules/redis'
  pub = redis.createClient
  sub = redis.createClient
  client = redis.createClient
  store = new RedisStore {redisPub : pub, redisSub : sub, redisClient : client}
  io.set 'store', store
  io.set 'log level', 2

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