reportingServer = require './reporting/app.js'
trackingServer = require './tracking/app.js'

reportingServer.start(9012)
trackingServer.start(9011)