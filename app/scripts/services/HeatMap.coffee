'use strict'

window.mouseTracking.factory 'heatmap', ['socket', (socket) ->

  globalCallback = null

  updateData = (data, callback) ->
    socket.emit 'generateHeatMapData', data
    globalCallback = callback

  socket.on heatMapDataGenerated, () ->
    args = arguments
    $rootScope.$apply () ->
      callback.apply socket, args

  return {
    generate: (data, callback) ->
      updateData data (data) ->

  }
]