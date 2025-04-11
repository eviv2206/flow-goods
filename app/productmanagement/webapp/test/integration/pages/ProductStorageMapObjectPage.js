sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'com.yauheni.sapryn.productmanagement',
            componentId: 'ProductStorageMapObjectPage',
            contextPath: '/Product/placement'
        },
        CustomPageDefinitions
    );
});