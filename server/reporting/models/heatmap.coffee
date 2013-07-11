mongoose = require 'mongoose'

mouseTracking = new mongoose.Schema {id: String, ms: Number, x: Number, y: Number, ip: String, url: String, type: String}, { collection: 'mouseTracking' }

mouseTracking.statics.generate = (data, callback) ->

  o = {}
  o.scope = {
    'targetWidth' : data.targetWidth
    'centered' : data.centeredDesign
  }
  o.map = () ->
    if centered
      offsetLeft = ( targetWidth - this.windowX ) / 2
    else
      offsetLeft = 0

    x = Math.round(parseInt(offsetLeft + this.x) / 10) * 10
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

mouseTracking.statics.getAvailableUrls = (data, callback) ->
  this.aggregate { $group: { _id: "$url"}}, (err, results) ->
    if err
      console.log err

      results.map

    callback err, results


mongoose.model 'mouseTracking', mouseTracking