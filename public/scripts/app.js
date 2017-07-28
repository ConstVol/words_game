var routerApp = angular.module('routerApp', ['ui.router', 'routerApp.mainController', 'routerApp.loginController', 'routerApp.historyController']);


routerApp.config(function($stateProvider, $urlRouterProvider) {

    $urlRouterProvider.otherwise('/');

    $stateProvider

        .state('phrases', {
            url: '/phrases',
            templateUrl: '/views/partial-home.html',
            controller: 'mainController'

        })

        .state('login', {
            url: '/login',
            templateUrl: '/views/login.html',
            controller: 'loginController'
        })

        .state('history', {
            url: '/phrase/history',
            templateUrl: '/views/history.html',
            controller: 'historyController'
        });


});

