// ***** Services *****
angular.module("ChoiceApp", [])
  // Filters a list of users based on the array of indices
  // passed to the function. Also inserts a "rank" attribute
  // which is the user's index in the array of choices, to
  // be used for ordering the list.
  .filter('choices', function() {
    return function(input, indices) {
      var out = [];
      if (!input) {
        return [];
      }
      var r = 0;
      for (var i = 0; i < input.length; i++) {
        if ((r = $.inArray(input[i].id, indices)) >= 0) {
          input[i].rank = r;
          out.push(input[i]);
        }
      }
      return out;
    };
  })
  // Adds a rank attribute to the list, based on order
  .filter('makeranks', function() {
    return function(input) {
      if (!input) {
        return [];
      }
      for (var i = 0; i < input.length; i++) {
        input[i].rank = i;
      }
      return input;
    };
  })
  // Returns an empty list if the filter is empty,
  // passes input through unchanged otherwise.
  .filter('iffilterempty', function() {
    return function(input, filter, override) {
      if (!override && (!filter || filter.length < 1)) {
        return [];
      }
      return input;
    };
  })
  // A simple conditional statement for use in
  // angular templates.
  // {{condition | iif : trueValue : falseValue}}
  .filter('iif', function () {
    return function(input, trueValue, falseValue) {
      return input ? trueValue : falseValue;
    };
  })
  .filter('searchwords', function($filter) {
    return function(input, filter) {
      var filterFn = $filter('filter');
      var filtersSplit = filter.split(' ');

      function filterWrapper(input, filters) {
        if (filters.length <= 0) {
          return input;
        }
        return filterFn(filterWrapper(input, filters.slice(1)), filters[0]);
      };

      return filterWrapper(input, filtersSplit);
    };
  });

// ***** Controllers *****
function ChoiceCtrl($scope, $http, $timeout) {
  // Search query
  $scope.search = "";

  // Variable for search results
  $scope.users = [];

  $http.get("/user/choices").success(function(data) {
    $scope.chosenUsers = data;
  });

  $scope.searchUsers = function() {
    console.log("Searching");
    $http.get("/user/all?query=" + $scope.search).success(function(data) {
      $scope.users = data;
    });
  };

  var promise = false;

  // Add listener to search input
  $scope.$watch('search', function() {
    if (promise) {
      $timeout.cancel(promise);
    }
    promise = $timeout($scope.searchUsers, 500);
  });

  $scope.addChoice = function(u) {
    for (var i = 0; i < $scope.chosenUsers.length; i++) {
      if ($scope.chosenUsers[i].id == u.id) {
        return;
      }
    }
    $scope.chosenUsers.push(u);
  };

  $scope.removeChoice = function(index) {
    $scope.chosenUsers.splice(index, 1);
  };

  $scope.reorderChoices = function(indices) {
    // Re-organize the back-end array
    var newArray = [];
    for (var i = 0; i < indices.length; i++) {
      newArray.push($scope.chosenUsers[indices[i]]);
    }
    $scope.chosenUsers = newArray;
    $scope.$apply();
  };

  $scope.saveChoices = function() {
    console.log("Saving Choices...");

    var choices = {
      choices: []
    };
    for (var i = 0; i < $scope.chosenUsers.length; i++) {
      choices.choices.push($scope.chosenUsers[i].id);
    }

    // Must include teh CSRF token for Rails to accept,
    // and for security
    $http.post("/user/update", choices, {
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    }).success(function(data) {
      top.location = "/saved";
    });
  };

  $scope.clearChoices = function() {
    $scope.chosenUsers = [];
  };

  $scope.cancel = function() {
    $http.get("/user/choices").success(function(data) {
      $scope.chosenUsers = data;
    });
  };

  // TODO: Do this sortable stuff cleaner (with Angular directive?)
  $(function() {
    $("#sortable").sortable({
      update: function(event, ui) {
        $scope.reorderChoices($.map($("#sortable").sortable("toArray"), function(string) {
          return parseInt(string);
        }));
      }
    });
    $("#sortable").disableSelection();
  });
};