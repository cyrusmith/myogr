angular.module('OgrmonoApp').value('DummyData', {
    orders: [
        {
            id: 6333,
            org: "Орг 1",
            purchase: {
                id: 26523,
                title: "Старая закупка"
            }
        },
        {
            id: 8576,
            org: "Орг 2",
            purchase: {
                id: 44523,
                title: "Актуальная закупка"
            }
        }
    ]
});

angular.module('OgrmonoApp').controller('NewAppointmentController', ['$scope', 'DummyData', function ($scope, DummyData) {

    $scope.courier = {
        cities: ['Ебург', 'Нижний Тагил']
    }

    $scope.orders = DummyData.orders;

    $scope.sortOrders = function (fld) {

        if (fld != 'org' && fld != 'purchase') return;
        $scope.orders.sort(function (a, b) {
            console.log('sortOrders', fld, a,b);
            if (fld == 'org') {
                return a.org.localeCompare(b.org);
            }
            if (fld == 'purchase') {
                return a.purchase.title.localeCompare(b.purchase.title);
            }
            return 0;
        });
    }

    $scope.$watch('selectedType', function (type) {
        console.log(JSON.stringify(type));
    });

}]);