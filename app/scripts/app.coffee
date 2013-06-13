'use strict'

angular.module('MouseTrackingApp', [])
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/heatmap',
        templateUrl: 'views/partials/heatmap.html'
        controller: 'HeatMapCtrl'
      .otherwise
        redirectTo: '/'
  ]
