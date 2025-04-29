
'use strict';
sap.ui.define([
    'sap/ui/core/mvc/ControllerExtension',
    "com/yauheni/sapryn/productmanagement/custom/BaseController",
    "sap/ushell/Container",
    "sap/m/MessageBox",
    "sap/m/MessageToast"
], function (ControllerExtension, BaseController, Container, MessageBox, MessageToast) {
    return ControllerExtension.extend('com.yauheni.sapryn.productmanagement.ext.controller.ObjectPageExt', {
        ...BaseController,

        override: {
            onBeforeRendering: function () {
                this.getView().byId("fe::table::placement::LineItem").attachRowPress((oEvent) => this._onProductRowPress(oEvent));
            },
        },

        onScanSuccess(oEvent) {
            if (oEvent.getParameter("cancelled")) {
                MessageToast.show(this.getView().getModel("i18n").getResourceBundle().getText("com.productmanagement.scanCancelled"), { duration:1000 });
            } else {
                if (oEvent.getParameter("text")) {
                    this.getView().getBindingContext().setProperty("barcode", oEvent.getParameter("text"));
                }
            }
        },

        onScanError: function(oEvent) {
            MessageToast.show(this.getView().getModel("i18n").getResourceBundle().getText("com.productmanagement.scanError"), { duration:1000 });
        },

        async refreshContextAndModel() {
            if (this.getView().getBindingContext().hasPendingChanges()) {
                await this.getView().getBindingContext().resetChanges();
            }
            await this.getView().getBindingContext().requestRefresh();
            this.getModel().refresh();
        },
        
        _onProductRowPress(oEvent) {
            MessageBox.confirm(
                this.getView().getModel("i18n").getResourceBundle().getText("com.productmanagement.confirmNavigation"),
                {
                    onClose: (oAction) => {
                        if (oAction === MessageBox.Action.OK) {
                            this._navigateToStorageManagement(oEvent);
                        }
                    },
                }
            )
            
        },

        async _navigateToStorageManagement(oEvent) {
            const Navigation = await Container.getServiceAsync("Navigation");
            const sStorageID = oEvent.getParameter("bindingContext").getObject().storage.ID;
            const sHash = await Navigation.getHref({
                target: {shellHash: "storage-management" + `&/Storage(ID=${sStorageID},IsActiveEntity=true)`},
            });
            let sURL = window.location.href.split("#")[0];
            sURL = sURL + sHash; //Navigate to second app in new tab
            sap.m.URLHelper.redirect(sURL, true);
        },
    });
})