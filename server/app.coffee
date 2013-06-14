reportingServer = require './reporting/app.js'
trackingServer = require './tracking/app.js'

reportingServer.start()
trackingServer.start()