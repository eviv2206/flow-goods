sap.ui.define([
	"sap/ui/model/json/JSONModel",
	"com/yauheni/sapryn/supplymanagement/ext/util/ValidateForm",
	"sap/ui/model/type/Date",
	"sap/ui/model/type/Float"
], (JSONModel, ValidateForm, TypeDate, TypeFloat) => 
    class CreateSupply {

        sSupplyCreateGroupId = "SupplyCreateGroupId";
		sCreateButtonId = "idCreateSupplyButton";

		aFormFields = [
            {
                id: "idNameCreateSupplyInput",
                fieldGroupId: "idNameFieldGroup",
            },
            {
                id: "idDescriptionCreateSupplyTextArea",
                fieldGroupId: "idDescriptionFieldGroup",
            },
			{
				id: "idNameSupplierCreateSupplyInput",
				fieldGroupId: "idNameSupplierFieldGroup",
			},
			{
				id: "idDateCreateSupplyInput",
				fieldGroupId: "idDateFieldGroup",
			},
			{
				id: "idProductCreateSupplyInput",
				fieldGroupId: "idProductFieldGroup",
			},
			{
				id: "idStorageCreateSupplyInput",
				fieldGroupId: "idStorageFieldGroup",
			},
			{
				id: "idQuantityCreateSupplyInput",
				fieldGroupId: "idQuantityFieldGroup",
			},
			{
				id: "idTotalPriceCreateSupplyInput",
				fieldGroupId: "idTotalPriceFieldGroup",
			}
        ];

		aInvalidFieldIds = [];

        constructor(oView) {
			this.oView = oView;
			this.getView = () => oView;
			this.getController = () => this.getView().getController();
			this.getBaseController = () => this.getController().getExtensionAPI().extension.com.yauheni.sapryn.supplymanagement.ext.controller.ListReportExt;
			this.getResourceBundle = () => this.getBaseController().getResourceBundle();

			// Requires for BusinessPartnerDialog
			this._oResourceBundle = this.getResourceBundle();

			// Requires for loadFragment. Handlers for fragment events
			this.onCloseCreateSupplyButtonPress = this.onCloseCreateSupplyButtonPress.bind(this);
			this.onValidateCreateSupplyFieldGroup = this.onValidateCreateSupplyFieldGroup.bind(this);
			this.validateMacrosField = this.validateMacrosField.bind(this);
			this.onCreateSupplyButtonPress = this.onCreateSupplyButtonPress.bind(this);
		};

        async openCreateSupplyDialog() {
			this.oView = this.getView();

			this.oModel = this.getBaseController().getModel();
			this.oResourceBundle = this.getResourceBundle();

			if (!this.oDialog) {
				this.oDialog = await this.getController().getExtensionAPI().loadFragment({
					id: this.getView().getId(),
					name: "com.yauheni.sapryn.supplymanagement.custom.createSupply.CreateSupplyDialog",
					controller: this,
				});

				this.getController().getExtensionAPI().addDependent(this.oDialog);

                this.oCustomUiJSONModel = new JSONModel({
                    isEditable: true
                });
                this.oDialog.setModel(this.oCustomUiJSONModel, "ui");

				this.oDialog.attachBeforeOpen(() => this._onBeforeOpenDialog());
				this.oDialog.attachAfterClose(() => this._onAfterCloseDialog());
			}

            this.mSupplyForCreation = new JSONModel({ 
                name: "",
                description: "",
                nameSupplier: "",
                dateSupply: null,
                product_ID: "",
                storage_ID: "",
                quantity: 0,
				totalPrice: 0,
            });
			this.oDialog.setModel(this.mSupplyForCreation, "formData");

			this.oDialog.open();
		};

		onValidateCreateSupplyFieldGroup(oEvent) {
			const oControl = oEvent.getSource();

			ValidateForm.validateField(oControl, this.getResourceBundle(), this.aFormFields, this.aInvalidFieldIds);

			this._changeEnabledSaveButtonState();
		};

		validateMacrosField(oEvent) {
            const oControl = oEvent.getSource();
            const sFieldGroupId = oControl.getFieldGroupIds()[0];
            this._triggerValidationForFieldGroup(sFieldGroupId);
        };

		onCloseCreateSupplyButtonPress() {
			this.oDialog.close();
		};

		async onCreateSupplyButtonPress() {
            if (!this._isAllFieldsValid()) {
                return;
            }

			this.getBaseController().showBusyIndicator(true, this.oDialog);
            const oAction = this.getBaseController().getModel().bindContext("/createSupply(...)");
            this._setParametersForCreateSupply(oAction, this.mSupplyForCreation.getData());

			try {
                await oAction.invoke();
                this.getBaseController().showMessage(this.getView().getModel("i18n").getResourceBundle().getText("com.supplymanagement.messageSupplyCreated"));
                await this.getBaseController().refreshModel();
                this.oDialog.close();
            } catch (oError) {
                this._onFailedSupplyCreation(oError);
            } finally {
                this.getBaseController().showBusyIndicator(false, this.oDialog);
            }
		};

		_isAllFieldsValid() {
			this.aFormFields.forEach((oFormField) => this._triggerValidationForFieldGroup(oFormField.fieldGroupId));

			return this.aInvalidFieldIds.length === 0;
		};

		_initializeInvalidFields() {
			this.aFormFields.forEach((oFormField) => {
				const aControls = this.getView().getControlsByFieldGroupId(oFormField.fieldGroupId);

				aControls.forEach((oControl) => {
					if (ValidateForm.isSupportedControlType(oControl)) {
						ValidateForm.validateField(oControl, this.getResourceBundle(), this.aFormFields, this.aInvalidFieldIds, false);
					}
				});
			});
		};

		_changeEnabledSaveButtonState(bEnabled = null) {
			if (bEnabled === null) {
				const bEnabled = this.aInvalidFieldIds.length === 0;
				this.getView().byId(this.sCreateButtonId).setEnabled(bEnabled);
			} else {
				this.getView().byId(this.sCreateButtonId).setEnabled(bEnabled);
			}
		};

		_triggerValidationForFieldGroup(sFieldGroupId) {
			const aControls = this.getView().getControlsByFieldGroupId(sFieldGroupId);

			aControls.forEach((oControl) => {
				if (ValidateForm.isSupportedControlType(oControl)) {
					oControl.fireValidateFieldGroup({ fieldGroupIds: [sFieldGroupId] });
				}
			});
		};

		_onBeforeOpenDialog() {
			this._setFieldGroupIds(this.aFormFields);

			this.aFormFields.forEach((oFormField) => {
				const aControls = this.getView().getControlsByFieldGroupId(oFormField.fieldGroupId);
				ValidateForm.resetFormFieldsErrors(aControls, this.aInvalidFieldIds);
			});

			this._initializeInvalidFields();
			this._changeEnabledSaveButtonState(false);
			
			this.getView().byId("idProductCreateSupplyInput::Field-edit").setDisplay("Description");
			this.getView().byId("idStorageCreateSupplyInput::Field-edit").setDisplay("Description");
		};

		async _onAfterCloseDialog() {
            this.oCustomUiJSONModel.setProperty("/isEditable", false);
            this.oDialog.destroy();
            this.oDialog = null;
        };

		_setFieldGroupIds(aObjects) {
            aObjects.forEach((oObject) => {
                const oControl = this.getView().byId(oObject.id);
                if (oControl) {
                    oControl.setFieldGroupIds(oObject.fieldGroupId);
                }
            });
        };

		_setParametersForCreateSupply(oAction, oData) {
			const oDate = new TypeDate({source: {pattern: "yyyy-MM-dd"}, style: "long"});
			const sDate = oDate.parseValue(oData.dateSupply, "string");
			oAction.setParameter('name', oData.name);
			oAction.setParameter('description', oData.description);
			oAction.setParameter('supplierName', oData.nameSupplier);
			oAction.setParameter('dateSupply', sDate);
			oAction.setParameter('product_ID', oData.product_ID);
			oAction.setParameter('storage_ID', oData.storage_ID);
			oAction.setParameter('quantity', oData.quantity);
			oAction.setParameter('totalPrice', `${oData.totalPrice}`);
		};

		_onFailedSupplyCreation(oError) {
			const sMessage = oError.message;
            if (sMessage) {
                this.getBaseController().showErrorMsg(sMessage);
            } else {
                this.getBaseController().showErrorMsg("OOOPS");
            }
		};

    }
)