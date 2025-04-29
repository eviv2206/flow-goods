sap.ui.define([], function () {
    "use strict";
    return {
        formatLocation: function(sValue) {
            return sValue && sValue.replace(/,/g, '.');
        },

        formatProductRemainingQuantity: function(sQuantityRemainStatus) {
            if (sQuantityRemainStatus === "1") {
                return sap.ui.core.ValueState.Error;
            }
            if (sQuantityRemainStatus === "2") {
                return sap.ui.core.ValueState.Warning;
            }
            return sap.ui.core.ValueState.None;
        }
    }
});