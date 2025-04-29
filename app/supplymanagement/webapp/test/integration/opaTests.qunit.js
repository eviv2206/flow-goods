sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/yauheni/sapryn/supplymanagement/test/integration/FirstJourney',
		'com/yauheni/sapryn/supplymanagement/test/integration/pages/SupplyList',
		'com/yauheni/sapryn/supplymanagement/test/integration/pages/SupplyObjectPage'
    ],
    function(JourneyRunner, opaJourney, SupplyList, SupplyObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/yauheni/sapryn/supplymanagement') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheSupplyList: SupplyList,
					onTheSupplyObjectPage: SupplyObjectPage
                }
            },
            opaJourney.run
        );
    }
);