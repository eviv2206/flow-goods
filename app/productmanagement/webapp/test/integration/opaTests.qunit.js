sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/yauheni/sapryn/productmanagement/test/integration/FirstJourney',
		'com/yauheni/sapryn/productmanagement/test/integration/pages/ProductList',
		'com/yauheni/sapryn/productmanagement/test/integration/pages/ProductObjectPage',
		'com/yauheni/sapryn/productmanagement/test/integration/pages/ProductStorageMapObjectPage'
    ],
    function(JourneyRunner, opaJourney, ProductList, ProductObjectPage, ProductStorageMapObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/yauheni/sapryn/productmanagement') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheProductList: ProductList,
					onTheProductObjectPage: ProductObjectPage,
					onTheProductStorageMapObjectPage: ProductStorageMapObjectPage
                }
            },
            opaJourney.run
        );
    }
);