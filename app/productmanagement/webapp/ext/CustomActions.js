'use strict'
sap.ui.define([
    "com/yauheni/sapryn/productmanagement/custom/moveToAnotherStorage/MoveToAnotherStorage"
], (MoveToAnotherStorage) => ({
    onMoveToAnotherStorage: function(oBindingContext, oSelectedBindingContexts) {
        if (!this.oMoveToAnotherStorage) {
            this.oMoveToAnotherStorage = new MoveToAnotherStorage(this.getEditFlow().getView());
        }

        this.oMoveToAnotherStorage.onMoveToAnotherStorage(oBindingContext, oSelectedBindingContexts);
    }

}));