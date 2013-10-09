window.mouseTracking.factory 'socket', ($rootScope) ->
  socket = io.connect 'http://127.0.0.1:9012'
  return {
    on: (eventName, callback) ->
      socket.on eventName, () ->
        args = arguments
        $rootScope.$apply () ->
          callback.apply socket, args
    emit: (eventName, data, callback) ->
      socket.emit eventName, data, () ->
        args = arguments
        $rootScope.$apply () ->
          if callback
            callback.apply socket, args
  }