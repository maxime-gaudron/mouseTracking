express = require 'express'
http = require 'http'
io = require 'socket.io'

app = do express
server = http.createServer app
io.listen server

server.listen 9011
