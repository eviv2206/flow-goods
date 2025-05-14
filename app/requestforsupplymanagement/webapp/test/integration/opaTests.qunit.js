sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/yauheni/sapryn/requestforsupplymanagement/test/integration/FirstJourney',
		'com/yauheni/sapryn/requestforsupplymanagement/test/integration/pages/RequestForSupplyList',
		'com/yauheni/sapryn/requestforsupplymanagement/test/integration/pages/RequestForSupplyObjectPage'
    ],
    function(JourneyRunner, opaJourney, RequestForSupplyList, RequestForSupplyObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/yauheni/sapryn/requestforsupplymanagement') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheRequestForSupplyList: RequestForSupplyList,
					onTheRequestForSupplyObjectPage: RequestForSupplyObjectPage
                }
            },
            opaJourney.run
        );
    }
);