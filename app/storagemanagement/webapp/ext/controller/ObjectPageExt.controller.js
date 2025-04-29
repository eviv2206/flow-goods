'use strict';
sap.ui.define([
    'sap/ui/core/mvc/ControllerExtension',
    "com/yauheni/sapryn/storagemanagement/custom/BaseController",
    "sap/ushell/Container",
    "sap/m/MessageBox",
], function (ControllerExtension, BaseController, Container, MessageBox) {
    return ControllerExtension.extend('com.yauheni.sapryn.storagemanagement.ext.controller.ObjectPageExt', {
        ...BaseController,

        override: {
            onBeforeRendering: async function () {
                const oMapConfig = {
                    "MapProvider": [{
                        "name": "OSM",
                        "type": "",
                        "description": "",
                        "tileX": "256",
                        "tileY": "256",
                        "maxLOD": "20",
                        "copyright": "Tiles Courtesy of OpenStreetMap",
                        "Source": [{
                            "id": "s1",
                            "url": "https://a.tile.openstreetmap.org/{LOD}/{X}/{Y}.png"
                        }]
                    }],
                    "MapLayerStacks": [{
                        "name": "DEFAULT",
                        "MapLayer": [{
                            "name": "OSMLayter",
                            "refMapProvider": "OSM",
                            "opacity": "1.0",
                            "colBkgnd": "RGB(255,255,255)"
                        }]
                    }]
                };
                const oGeoMap = this.getView().byId("fe::CustomSubSection::GeographyCustomSection--geoMap");
                oGeoMap.setMapConfiguration(oMapConfig);
                oGeoMap.setRefMapLayerStack("DEFAULT");

                this.getView().byId("fe::table::products::LineItem").attachRowPress((oEvent) => this._onProductRowPress(oEvent));
            },

            routing : {
                onAfterBinding: async function () {
                    const oBindingContext = this.getView().getBindingContext();
                    const longitude = await oBindingContext.requestProperty("longitude");
                    const latitude = await oBindingContext.requestProperty("latitude");

                    const oGeoMap = this.getView().byId("fe::CustomSubSection::GeographyCustomSection--geoMap");

                    if (longitude && latitude) {
                        oGeoMap.setCenterPosition(`${longitude};${latitude}`);
                        oGeoMap.setInitialPosition(`${longitude};${latitude};0`);
                        oGeoMap.setInitialZoom(14);
                    } else {
                        oGeoMap.setCenterPosition("27.555696;53.900605");
                        oGeoMap.setInitialPosition("27.555696;53.900605;0");
                        oGeoMap.setInitialZoom(6);
                    }
                }
            }
        },

        onMapClick(oEvent) {
            const pos = oEvent.getParameter("pos");
            const oBindingContext = this.getView().getBindingContext();
            if (!this.getView().getModel("ui").getProperty("/isEditable")) {
                return;
            }
            const [longitude, latitude] = pos.split(";");
            oBindingContext.setProperty("latitude", latitude);
            oBindingContext.setProperty("longitude", longitude);
        },

        onClickSpot(oEvent) {
            const oBindingContext = this.getView().getBindingContext();
            const sMsg = this.getView().getModel("i18n").getResourceBundle().getText("com.storagemanagement.spotWindow", [oBindingContext.getProperty("address"), oBindingContext.getProperty("city/name")]);
            oEvent.getSource().openDetailWindow(sMsg, "0", "0")
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
                this.getView().getModel("i18n").getResourceBundle().getText("com.storagemanagement.confirmNavigation"),
                {
                    onClose: (oAction) => {
                        if (oAction === MessageBox.Action.OK) {
                            this._navigateToProductManagement(oEvent);
                        }
                    },
                }
            )
            
        },

        async _navigateToProductManagement(oEvent) {
            const Navigation = await Container.getServiceAsync("Navigation");
            const sProductID = oEvent.getParameter("bindingContext").getObject().product.ID;
            const sHash = await Navigation.getHref({
                target: {shellHash: "product-management" + `&/Product(ID=${sProductID},IsActiveEntity=true)`},
            });
            let sURL = window.location.href.split("#")[0];
            sURL = sURL + sHash; //Navigate to second app in new tab
            sap.m.URLHelper.redirect(sURL, true);
        },
    });
})