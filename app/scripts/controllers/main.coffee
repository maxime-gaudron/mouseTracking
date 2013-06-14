'use strict'

window.mouseTracking = mouseTracking = angular.module('MouseTrackingApp')

mouseTracking.controller 'MainCtrl', ['$scope', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate',
      'AngularJS'
    ]
  ]

mouseTracking.controller 'HeatMapCtrl', ['$scope', 'socket', ($scope, socket) ->
  $scope.data = {url: "http://localhost:9010/#/"}
  $scope.heatmap = window.heatmapFactory.create {radius: 10, element: "heatmap",legend: {position: 'br',title: 'Example Distribution'}}

  console.log 'init controller'

  socket.on 'heatMapDataGenerated', (data) ->
    console.log 'generated heatmap data'

    maxValue = 0
    mapFunction = (element) ->
      if maxValue < element.value.weight
        maxValue = element.value.weight
      return {x: parseInt(element.value.x), y: parseInt(element.value.y), count: element.value.weight * 2}

    data = data.map(mapFunction)
    $scope.heatmap.store.setDataSet({max:maxValue, data: data});


  $scope.showHeatMap = (data) ->
    console.log 'generate heatmap'
    socket.emit 'generateHeatMapData', data
]
