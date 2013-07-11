'use strict'

window.mouseTracking = mouseTracking = angular.module('MouseTrackingApp')

mouseTracking.controller 'MainCtrl', ['$scope', ($scope) ->

  ]

mouseTracking.controller 'HeatMapCtrl', ['$scope', 'socket', ($scope, socket) ->
  $scope.data = {
    url: "http://localhost:9010/#/",
    targetWidth: 1024
  }

  $scope.availableUrls = {};
  socket.emit 'getAvailableUrls'

  $scope.heatmap = window.heatmapFactory.create {radius: 10, element: "heatmap"}

  socket.on 'getAvailableUrls', (data) ->
    console.log 'available URLS: ', data
    $scope.availableUrls = data
    if data.length > 0
      $scope.data.url = data[0]
      $scope.showHeatMap $scope.data

  socket.on 'heatMapDataGenerated', (data) ->
    maxValue = 0
    mapFunction = (element) ->
      if maxValue < element.value.weight
        maxValue = element.value.weight
      return {x: parseInt(element.value.x), y: parseInt(element.value.y), count: element.value.weight * 2}

    data = data.map(mapFunction)
    $scope.heatmap.store.setDataSet({max:maxValue, data: data});


  $scope.showHeatMap = (data) ->
    $scope.urlIframe = data.url;
    socket.emit 'generateHeatMapData', data
]
