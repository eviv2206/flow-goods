"use strict";
sap.ui.define([
    'sap/m/MessageBox',
    'sap/m/MessageToast',
], (MessageBox, MessageToast) => ({
    /**
     * @description Retrieves the model with the given name from the view
     * @param {string} sName the model name
     * @returns {sap.ui.model.Model} the requested model
     * @author C5388035
     */
    getModel(sName) {
        return this.getView().getModel(sName);
    },

    /**
     * @description Sets a model with the given name on the view
     * @param {sap.ui.model.Model} oModel the model to be set
     * @param {string} sName the name of the model
     * @returns {sap.ui.model.Model} the set model
     * @author C5388035
     */
    setModel(oModel, sName) {
        return this.getView().setModel(oModel, sName);
    },

    /**
     * @description Shows/hides the busy indicator for the given control
     * @param {boolean} bIsBusy true to show the busy indicator, false to hide it
     * @param {sap.ui.core.Control} [oControl=null] the control to which the busy indicator belongs, defaults to the view
     * @author C5388035
     */
    showBusyIndicator(bIsBusy, oControl = null) {
        const oControlToSetBusy = oControl || this.getView();
        oControlToSetBusy.setBusyIndicatorDelay(0);
        oControlToSetBusy.setBusy(bIsBusy);
    },

    /**
     * @description Shows a message box with the given message or a default message
     * @param {string} [sMessage=null] the message to be shown
     * @author C5388035
     */
    showErrorMsg(sMessage = null) {
        MessageBox.error(sMessage || this.getResourceBundle().getText('REQUEST_ERROR_MESSAGE'));
    },

    /**
     * @description Shows a message toast with the given message
     * @param {string} sMessage the message to be shown
     * @author C5388035
     */
    showMessage(sMessage) {
        MessageToast.show(sMessage);
    },

    /**
     * @description Displays the most recent error message associated with the given context or a default message if no context-specific messages exist.
     * @param {sap.ui.model.odata.v4.Context} oContext The context from which to retrieve error messages.
     * @param {string} [sDefaultMessage=""] The default message to display if no context-specific error messages are found.
     * @author C5388035
     */
    showModelErrorMsg(oContext, sDefaultMessage = "") {
        let oMessage;
        const aContextMessages = oContext.getModel().getMessages(oContext);
        const aDefaultMessages = oContext.getModel().mMessages[""] ?? [];

        const oLastContextMessage = aContextMessages.length > 0 ? aContextMessages[aContextMessages.length - 1] : null;
        const oLastDefaultMessage = aDefaultMessages.length > 0 ? aDefaultMessages[aDefaultMessages.length - 1] : null;

        if (oLastContextMessage && oLastDefaultMessage) {
            oMessage = oLastContextMessage.getDate() > oLastDefaultMessage.getDate() ? oLastContextMessage : oLastDefaultMessage;
        } else {
            oMessage = oLastContextMessage || oLastDefaultMessage;
        }

        this.showErrorMsg(oMessage ? oMessage.getMessage() : sDefaultMessage);
    },

    /**
     * @description Retrieves the resource bundle
     * @returns {object} The resource bundle object
     * @author C5388035
     */
    getResourceBundle() {
        return this._oResourceBundle;
    },
}))