mongoose = require 'mongoose'

console.log 'mouseTracking model loaded'

mouseTracking = new mongoose.Schema {id: String, ms: Number, x: Number, y: Number, ip: String, url: String, type: String}, { collection: 'mouseTracking' }

mouseTracking.statics.generate = (data, callback) ->
  console.log data

  o = {}
  o.map = () ->
    x = Math.round(parseInt(this.x) / 10) * 10
    y = Math.round(parseInt(this.y) / 10) * 10
    if x > 0 and y > 0
      emit x + ':' + y, {x: x, y:y, weight: 1}

  o.reduce = (key, docs) ->
    coordinates = key.split(':')
    return {x: coordinates[0], y:coordinates[1], weight: docs.length}

  o.query = {url: data.url}

  this.mapReduce o, (err, results) ->
      if err
        console.log err

      callback err, results

mongoose.model 'mouseTracking', mouseTracking
