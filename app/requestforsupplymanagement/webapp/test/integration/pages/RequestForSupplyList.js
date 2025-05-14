sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'com.yauheni.sapryn.requestforsupplymanagement',
            componentId: 'RequestForSupplyList',
            contextPath: '/RequestForSupply'
        },
        CustomPageDefinitions
    );
});