window.mouseTracking.controller 'MousePathCtrl', ['$scope', 'socket', 'kinetic', '$dialog', ($scope, socket, kinetic, dialog) ->
  $scope.data = {
    url: "http://localhost:9010/#/",
    targetWidth: 1024,
    type: false
  }
  $scope.visitors = [];

  $scope.availableUrls = {};
  socket.emit 'getAvailableUrls'

  $scope.openVisitorSelectionModal = () ->
    $scope.VisitorSelectionModal = true

  $scope.closeVisitorSelectionModal = () ->
    $scope.VisitorSelectionModal = false

  $scope.opts = {
    backdropFade: true,
    dialogFade:true
  };


  $scope.stage = new Kinetic.Stage {
    container: 'heatmap',
    width: 1024,
    height: 800
  };
  $scope.layer = new Kinetic.Layer()
  $scope.line = undefined


  $scope.generateMousePath = (data) ->
    socket.emit 'getMousePath', data;

  $scope.generatePathButtonClick = (pageId) ->
    $scope.generateMousePath { pageId: pageId ,url: $scope.urlIframe }

  $scope.changeUrl = (data) ->
    socket.emit 'getVisitorSessionsForUrl', {url : data.url}

  socket.on 'getAvailableUrls', (data) ->
    $scope.availableUrls = data
    if data.length > 0
      $scope.data.url = data[0]
      $scope.urlIframe = data[0];
      socket.emit 'getVisitorSessionsForUrl', {url : data[0]}

  socket.on 'getVisitorSessionsForUrl', (data) ->
    if data.length > 0
      $scope.visitors = data
      $scope.generateMousePath { pageId: data[0]._id,url: $scope.urlIframe }

  socket.on 'getMousePath', (data) ->
    if data.length > 0

      $scope.layer.destroyChildren()

      $scope.line = new Kinetic.Spline {
        points: data,
        stroke: 'red',
        strokeWidth: 2,
      }

      $scope.layer.add $scope.line
      $scope.stage.add $scope.layer
      $scope.closeVisitorSelectionModal()
]
