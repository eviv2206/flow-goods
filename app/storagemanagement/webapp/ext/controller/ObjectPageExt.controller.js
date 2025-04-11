'use strict';
sap.ui.define([
    'sap/ui/core/mvc/ControllerExtension',
 
], function (ControllerExtension) {
    return ControllerExtension.extend('com.yauheni.sapryn.storagemanagement.ext.controller.ObjectPageExt', {

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
            },

            routing : {
                onAfterBinding: async function () {
                    const oBindingContext = this.getView().getBindingContext();
                    const longitude = await oBindingContext.requestProperty("longitude");
                    const latitude = await oBindingContext.requestProperty("latitude");

                    const oGeoMap = this.getView().byId("fe::CustomSubSection::GeographyCustomSection--geoMap");

                    if (longitude && latitude) {
                        oGeoMap.setInitialPosition(`${longitude};${latitude};0`);
                        oGeoMap.setInitialZoom(14);
                    } else {
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
        }
    });
})