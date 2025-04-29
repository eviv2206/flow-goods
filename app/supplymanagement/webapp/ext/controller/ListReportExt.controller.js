sap.ui.define([
	'sap/ui/core/mvc/ControllerExtension',
	"com/yauheni/sapryn/supplymanagement/custom/BaseController",
	"sap/ushell/Container",
], function (ControllerExtension, BaseController, Container) {
	'use strict';

	return ControllerExtension.extend('com.yauheni.sapryn.supplymanagement.ext.controller.ListReportExt', {
		...BaseController,

		override: {

			/**
			 * @description Initializes the ListReportExt controller.
			 */
			onInit: function () {
				this.oView = this.getView();
			},

			/**
			 * @description This method handles the before rendering event.
			 */
			onBeforeRendering: function () {
				this._oResourceBundle = this.getModel("i18n").getResourceBundle();
			}
		},

		async refreshModel() {
            this.getModel().refresh();
        },
	});
});