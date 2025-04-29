'use strict'
sap.ui.define([
    "com/yauheni/sapryn/supplymanagement/custom/createSupply/CreateSupply",
    "sap/ushell/Container",
    "sap/m/MessageBox",
], (CreateSupply, Container, MessageBox) => ({
    onCreateSupply: function (oBindingContext, oSelectedBindingContexts) {
        if (!this.oCreateSupply) {
            this.oCreateSupply = new CreateSupply(this.getEditFlow().getView());
        }

        this.oCreateSupply.openCreateSupplyDialog(oBindingContext, oSelectedBindingContexts);
    },

    async onPressNavigateToProductManagement(oEvent) {
        const Navigation = await Container.getServiceAsync("Navigation");
        const sID = oEvent.getBinding().getBoundContext().getObject().toProductStorage.product.ID;
        const sHash = await Navigation.getHref({
            target: { shellHash: "product-management" + `&/Product(ID=${sID},IsActiveEntity=true)` },
        });
        let sURL = window.location.href.split("#")[0];
        sURL = sURL + sHash; //Navigate to second app in new tab
        sap.m.URLHelper.redirect(sURL, true);
    },

    async onPressNavigateToStorageManagement(oEvent) {
        const Navigation = await Container.getServiceAsync("Navigation");
        const sID = oEvent.getBinding().getBoundContext().getObject().toProductStorage.storage.ID;
        const sHash = await Navigation.getHref({
            target: { shellHash: "storage-management" + `&/Storage(ID=${sID},IsActiveEntity=true)` },
        });
        let sURL = window.location.href.split("#")[0];
        sURL = sURL + sHash; //Navigate to second app in new tab
        sap.m.URLHelper.redirect(sURL, true);
    },
}));