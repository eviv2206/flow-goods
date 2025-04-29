"use strict";
sap.ui.define([
    "sap/ui/model/json/JSONModel",
    "com/yauheni/sapryn/storagemanagement/ext/util/ValidateForm",
    "sap/ui/core/message/MessageType"
], (JSONModel, ValidateForm, MessageType) =>
    class {
        sStorageToMoveFieldId = "idStorageToMoveField";
        sQuantityToMoveFieldId = "idQuantityToMoveField";
        sNewPriceFieldId = "idNewPriceField";

        sMoveBtnId = "idMoveButton";

        sUpdateGroupId = "moveStorageGroupId";

        aFormFields = [
            {
                id: "idStorageToMoveField",
                fieldGroupId: "idStorageToMoveFieldGroup",
                context: "StorageToMove",
            },
            {
                id: "idQuantityToMoveField",
                fieldGroupId: "idQuantityToMoveFieldGroup",
                context: "QuantityToMove",
            }
        ];

        aInvalidFieldIds = [];

        /**
         * @description Initializes a new instance of the class.
         * @param {sap.ui.core.mvc.View} oView - The view instance.
         * @author C5388035
         */
        constructor(oView) {
            this.oView = oView;
            this.getView = () => oView;
            this.getController = () => this.getView().getController();
            this.getBaseController = () => this.getController().getExtensionAPI().extension.com.yauheni.sapryn.storagemanagement.ext.controller.ObjectPageExt;
            this.getResourceBundle = () => this.getBaseController().getResourceBundle();

            this.onValidateEditCaseFieldGroup = this.onValidateEditCaseFieldGroup.bind(this);
            this.validateMacrosField = this.validateMacrosField.bind(this);
            this.onCancelButtonPress = this.onCancelButtonPress.bind(this);
            this.onMoveButtonPress = this.onMoveButtonPress.bind(this);
        };

        async onMoveToAnotherStorage(oBindingContext, aSelectedBindingContexts) {

            if (!this.oDialog) {
				this.oDialog = await this.getController().getExtensionAPI().loadFragment({
					id: this.getView().getId(),
					name: "com.yauheni.sapryn.storagemanagement.custom.moveToAnotherStorage.MoveToAnotherStorageDialog",
					controller: this,
				});

                this.oDialog.attachBeforeOpen(() => this._onBeforeOpenDialog());
                this.oDialog.attachAfterClose(() => this._onAfterCloseDialog());

                this.getView().addDependent(this.oDialog);

                this.oCustomUiJSONModel = new JSONModel({
                    isEditable: true,
                });
                this.oDialog.setModel(this.oCustomUiJSONModel, "ui");
			}

            this.oCustomDataJSONModel = new JSONModel({
                storage: ""
            });
            this.oDialog.setModel(this.oCustomDataJSONModel, "appData");
        
            this.oContextBinding = this.getBaseController().getModel().bindContext("", aSelectedBindingContexts[0], { $$updateGroupId: this.sUpdateGroupId, $select: "storage,product,quantityRemain,price" });
            this.oContextBinding.attachEvent("dataReceived", (oEvent) => this._onContextDataReceived(oEvent));
            this.oDialog.setBindingContext(this.oContextBinding.getBoundContext());
            this.oDialog.open();
        };

        onValidateEditCaseFieldGroup(oEvent) {
            const oControl = oEvent.getSource();
            const oMatchingField = this.aFormFields.find(oFormField => oControl.getId().includes(oFormField.id));

            if (oMatchingField?.context === "StorageToMove") {
                this._validateStorageField(oControl);
            }

            if (oMatchingField?.context === "QuantityToMove") {
                this._validateQuantityField(oControl);
            }

            const bValid = !ValidateForm._checkIsRequired(oControl) && oControl.getValueState() !== sap.ui.core.ValueState.Error;
            if (bValid) {
                if (this.aInvalidFieldIds.includes(oControl)) {
                    this.aInvalidFieldIds.splice(this.aInvalidFieldIds.indexOf(oControl), 1);
                }
            } else {
                if (!this.aInvalidFieldIds.includes(oControl)) {
                    this.aInvalidFieldIds.push(oControl);
                }
            }

            this._changeEnabledSaveButtonState();
        };

        validateMacrosField(oEvent) {
            const oControl = oEvent.getSource();
            const sFieldGroupId = oControl.getFieldGroupIds()[0];
            this._triggerValidationForFieldGroup(sFieldGroupId);
        };

        onCancelButtonPress() {
            this.oDialog.close();
        };

        async onMoveButtonPress() {
            if (!this._isAllFieldsValid(this.aFormFields, this.aInvalidFieldIds)) {
                return;
            }

            this.getBaseController().showBusyIndicator(true, this.oDialog);
            const oAction = this.getBaseController().getModel().bindContext("/ProductStorageMap(" + this.oData.ID + ")/StoragesService.moveToAnotherStorage(...)");
            this._setParametersForMoveStorage(oAction);

            try {
                await oAction.invoke();
                this.getBaseController().showMessage(this.getView().getModel("i18n").getResourceBundle().getText("com.storagemanagement.messageStorageMoved"));
                await this.getBaseController().refreshContextAndModel();
                this.oDialog.close();
            } catch (oError) {
                this._onFailedMoveStorage(oError);
            } finally {
                this.getBaseController().showBusyIndicator(false, this.oDialog);
            }
        };

        async _onAfterCloseDialog() {
            this.oCustomUiJSONModel.setProperty("/isEditable", false);
            const oContext = this.oDialog.getBindingContext();

            if (oContext.hasPendingChanges()) {
                await oContext.resetChanges();
            }

            this.oDialog.destroy();
            this.oDialog = null;
        };

        _onBeforeOpenDialog() {
            this._setFieldGroupIds(this.aFormFields);
            this._changeEnabledSaveButtonState(false);

            this.getView().byId("idStorageToMoveField::Field-edit").setDisplay("Description");

            this.aFormFields.forEach((oFormField) => {
                const aControls = this.getView().getControlsByFieldGroupId(oFormField.fieldGroupId);
                ValidateForm.resetFormFieldsErrors(aControls, this.aInvalidFieldIds);
            });

            this.oCustomUiJSONModel.setProperty("/isEditable", true);
        };

        _setFieldGroupIds(aObjects) {
            aObjects.forEach((oObject) => {
                const oControl = this.getView().byId(oObject.id);
                if (oControl) {
                    oControl.setFieldGroupIds(oObject.fieldGroupId);
                }
            });
        };

        _isAllFieldsValid(aFormFields, aInvalidFieldIds) {
            aFormFields.forEach((oFormField) => this._triggerValidationForFieldGroup(oFormField.fieldGroupId));

            return aInvalidFieldIds.length === 0;
        };

        _changeEnabledSaveButtonState(bEnabled = null) {
            if (bEnabled === null) {
                const bEnabled = this.aInvalidFieldIds.length === 0;
                this.getView().byId(this.sMoveBtnId).setEnabled(bEnabled);
            } else {
                this.getView().byId(this.sMoveBtnId).setEnabled(bEnabled);
            }
        };

        _triggerValidationForFieldGroup(sFieldGroupId) {
            const aControls = this.getView().getControlsByFieldGroupId(sFieldGroupId);

            aControls.forEach((oControl) => {
                if (ValidateForm.isSupportedControlType(oControl)) {
                    oControl.fireValidateFieldGroup({ fieldGroupIds: [sFieldGroupId] });
                }
            })
        };

        _onContextDataReceived(oEvent) {
            this.oData = this.oContextBinding.getBoundContext().getObject();
        };

        _setParametersForMoveStorage(oAction) {
            const oData = this.oContextBinding.getBoundContext().getObject();
            oAction.setParameter('productId', oData.product.ID);
            oAction.setParameter('storageId', this.oCustomDataJSONModel.getProperty("/storage"));
            oAction.setParameter('quantity', oData.quantityRemain);
        };

        _onFailedMoveStorage(oError) {
            const sMessage = oError.message;
            if (sMessage) {
                this.getBaseController().showErrorMsg(sMessage);
            } else {
                this.getBaseController().showErrorMsg("OOOPS");
            }
        };

        _validateQuantityField(oControl) {
            if (this.oData.quantityRemain < parseInt(oControl.getValue().replace(/,/g, ""), 10)) {
                oControl.setValueState(sap.ui.core.ValueState.Error);
                oControl.setValueStateText("Quantity to move is greater than available quantity");
            } else {
                oControl.setValueState(sap.ui.core.ValueState.None);
            }
        };

        _validateStorageField(oControl) {
            if (this.oData.storage.ID === oControl.getValue()) {
                oControl.setValueState(sap.ui.core.ValueState.Error);
                oControl.setValueStateText("Storage to move is the same as current storage");
            } else {
                oControl.setValueState(sap.ui.core.ValueState.None);
            }
        };
    }
);