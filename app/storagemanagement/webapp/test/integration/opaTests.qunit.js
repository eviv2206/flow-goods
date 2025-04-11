sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'com/yauheni/sapryn/storagemanagement/test/integration/FirstJourney',
		'com/yauheni/sapryn/storagemanagement/test/integration/pages/StorageList',
		'com/yauheni/sapryn/storagemanagement/test/integration/pages/StorageObjectPage'
    ],
    function(JourneyRunner, opaJourney, StorageList, StorageObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('com/yauheni/sapryn/storagemanagement') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheStorageList: StorageList,
					onTheStorageObjectPage: StorageObjectPage
                }
            },
            opaJourney.run
        );
    }
);