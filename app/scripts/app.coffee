'use strict'

window.mouseTracking = angular.module('MouseTrackingApp', ['ui.bootstrap'])
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/heatmap',
        templateUrl: 'views/partials/heatmap.html'
        controller: 'HeatMapCtrl'
      .when '/mousePath',
        templateUrl: 'views/partials/mousePath.html'
        controller: 'MousePathCtrl'
      .otherwise
        redirectTo: '/'
  ]
