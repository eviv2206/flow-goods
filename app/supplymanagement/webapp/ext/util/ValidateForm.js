sap.ui.define([
    "sap/ui/core/library",
], function (library) {

    const { ValueState } = library;

    const INVALID_CHARACTERS_MESSAGE = "One or more invalid characters";

    return {

        /**
         * @description Validates a control and updates the list of invalid field IDs based on the validation result.
         * @param {object} oControl - The control to validate.
         * @param {sap.base.i18n.ResourceBundle} oResourceBundle - Resource bundle for retrieving localized messages.
         * @param {object[]} aFormFields - Array of form field definitions with control IDs.
         * @param {object[]} aInvalidFieldIds - Array to be updated with invalid field IDs.
         * @param {boolean} [bSetValueState=true] - Whether to update the control's error state.
         * @since 2502
         * @author C5388035
         */
        validateField(oControl, oResourceBundle, aFormFields, aInvalidFieldIds, bSetValueState = true) {
            let oMatchingField = aFormFields.find(oFormField => oControl.getId().includes(oFormField.id));

            if (!oMatchingField) {
                const oParentControl = oControl.getParent();
                oMatchingField = aFormFields.find(oFormField => oParentControl.getId().includes(oFormField.id));
            }

            if (oMatchingField) {
                const sInputContext = oMatchingField?.sInputContext || "";
                const bValidField = this.isValidField({ oControl, oResourceBundle, bSetValueState, sInputContext });
                this.setInvalidFields(bValidField, oMatchingField, aInvalidFieldIds);
            }
        },

        /**
         * @description Resets the error state of all controls by setting their `ValueState` to "None".
         * @param {object[]} aControls - Array of controls to reset.\
         * @since 2441
         * @author C5388035
         */
        resetFieldsError: function (aControls) {
            aControls.forEach((oControl) => {
                oControl.setValueState && oControl.setValueState(ValueState.None);
            });
        },

        /**
         * @description Validates all provided controls and determines if the form is valid.
         * @param {object[]} aControls - Array of controls to validate.
         * @param {sap.base.i18n.ResourceBundle} oResourceBundle - Resource model for retrieving localized messages.
         * @returns {boolean} - `true` if all controls are valid, otherwise `false`.
         * @since 2441
         * @author C5388035
         */
        isValidForm: function (aControls, oResourceBundle) {
            let bValidationError = false;
            aControls.forEach((oControl) => {
                bValidationError = !this.isValidField({ oControl, oResourceBundle }) || bValidationError;
            });

            return !bValidationError;
        },

        /**
         * @description Validates a specific control based on its type and updates its error state.
         * @param {object} options - The options object.
         * @param {object} options.oControl - The control to validate.
         * @param {sap.base.i18n.ResourceBundle} options.oResourceBundle - Resource bundle for retrieving localized messages.
         * @param {boolean} [options.bSetValueState=true] - Whether to update the control's error state.
         * @param {string} [options.sInputContext=""] - The input context for the control.
         * @returns {boolean} - `true` if the control is valid, otherwise `false`.
         * @since 2441
         * @author C5388035
         */
        isValidField: function ({ oControl, oResourceBundle, bSetValueState = true, sInputContext = "" }) {
            let sValueState = ValueState.None;
            let bValidationError = false;
            let sMessage = "";

            if (this._checkIsRequired(oControl)) {
                bValidationError = true;
            }

            if (!bValidationError) {
                ({ sValueState, bValidationError, sMessage } = this._validateControlByType(oControl, oResourceBundle, sInputContext));
            }

            bSetValueState && this.setErrorState(oControl, sValueState, sMessage);

            return !bValidationError;
        },

        /**
         * @description Validates a `sap.m.DatePicker` control.
         * @param {sap.m.DatePicker} oDatePicker - The DatePicker control to validate.
         * @throws {Error} - If the date value is invalid or not set.
         * @since 2441
         * @author C5388035
         */
        validateDatePicker: function (oDatePicker) {
            const oDateValue = oDatePicker.getDateValue();

            if (!oDateValue || !oDatePicker.isValidValue()) {
                throw new Error(oDatePicker.getValueStateText());
            }

        },

        /**
         * @description Validates a `sap.ui.mdc.Field` control.
         * @param {sap.ui.mdc.Field} oMdcField - The Field control to validate.
         * @throws {Error} - If the field value is invalid.
         * @since 2441
         * @author C5388035
         */
        validateMdcField: function (oMdcField) {
            const bIsInvalid = oMdcField.isInvalidInput();

            if (bIsInvalid) {
                throw new Error(oMdcField.getValueStateText());
            }
        },

        /**
         * @description Validates a `sap.m.MultiInput` control with ValueHelp and Token.
         * @param {sap.m.MultiInput} oMultiInput - The MultiInput control to validate.
         * @param {sap.base.i18n.ResourceBundle} oResourceBundle - Resource bundle for retrieving localized messages.
         * @throws {Error} - If the value exists.
         * @since 2441
         * @author C5388035
         */
        validateMultiInput: function (oMultiInput, oResourceBundle) {
            const sValue = oMultiInput.getValue();
            const aTokens = oMultiInput.getTokens();

            if (aTokens.some((oToken) => oToken.getKey() === sValue)) {
                const sMsg = oResourceBundle.getText("apm.caseManagement.valueExists.text", [sValue]);
                throw new Error(sMsg);
            }

            if (sValue) {
                const sMsg = oResourceBundle.getText("apm.caseManagement.valueNotExists.text", [sValue]);
                throw new Error(sMsg);
            }

        },

        /**
         * @description Sets the error state of a control with the provided value state and message.
         * @param {object} oControl - The control to update.
         * @param {sap.ui.core.ValueState} sValueState - The value state ("None", "Error", etc.).
         * @param {string} sMessage - The error message to display.
         * @since 2441
         * @author C5388035
         */
        setErrorState: function (oControl, sValueState, sMessage) {
            oControl.setValueState(sValueState);
            oControl.setValueStateText && oControl.setValueStateText(sMessage);
        },

        /**
         * @description Updates the list of invalid field IDs based on the validation result of a control.
         * @param {boolean} bValid - Whether the control is valid.
         * @param {object} oControl - The control that was validated.
         * @param {object[]} aInvalidFieldIds - Array to be updated with invalid field IDs.
         * @author C5388035
         */
        setInvalidFields(bValid, oControl, aInvalidFieldIds) {
            if (bValid) {
                if (aInvalidFieldIds.includes(oControl)) {
                    aInvalidFieldIds.splice(aInvalidFieldIds.indexOf(oControl), 1);
                }
            } else {
                if (!aInvalidFieldIds.includes(oControl)) {
                    aInvalidFieldIds.push(oControl);
                }
            }
        },

        /**
         * @description Resets errors for supported controls and clears the list of invalid field IDs.
         * @param {object[]} aControls - Array of controls to be checked and reset.
         * @param {object[]} aInvalidFieldIds - Array to be cleared of invalid field IDs.
         * @author C5388035
         */
        resetFormFieldsErrors(aControls, aInvalidFieldIds) {
            const aValidControls = aControls.filter((oControl) => this.isSupportedControlType(oControl));

            if (aValidControls.length > 0) {
                this.resetFieldsError(aValidControls);
                aInvalidFieldIds.length = 0;
            }
        },

        /**
         * @description Checks whether a control is of a supported type.
         * @param {object} oControl - The control to check.
         * @returns {boolean} - Whether the control is of a supported type.
         * @author C5388035
         */
        isSupportedControlType(oControl) {
            return oControl.isA(["sap.m.MaskInput", "sap.m.MultiInput", "sap.m.Input", "sap.m.TextArea", "sap.m.DatePicker", "sap.ui.mdc.MultiValueField", "sap.ui.mdc.Field"]);
        },

        /**
         * @description Validates a control based on its type.
         * @private
         * @param {object} oControl - The control to validate.
         * @param {sap.base.i18n.ResourceBundle} oResourceBundle - Resource bundle for retrieving localized messages.
         * @param {string} sInputContext - The input context for the control.
         * @returns {object} - Object containing validation result.
         * @since 2441
         * @author C5388035
         */
        _validateControlByType: function (oControl, oResourceBundle, sInputContext) {
            let sValueState = ValueState.None;
            let bValidationError = false;
            let sMessage = "";

            try {
                const sControlType = oControl.getMetadata().getName();
                const fnValidate = this._getValidationFunction(sControlType);

                if (fnValidate) {
                    fnValidate.call(this, oControl, oResourceBundle, sInputContext);
                }
            } catch (oException) {
                sValueState = ValueState.Error;
                sMessage = oException?.message || "Invalid value";
                bValidationError = true;
            }

            return {
                sValueState,
                bValidationError,
                sMessage
            };
        },

        /**
         * @description Returns a validation function for the given control type.
         * @private
         * @param {string} sControlType - The metadata name of the control.
         * @returns {Function|null} - The validation function or `null` if none is found.
         * @since 2441
         * @author C5388035
         */
        _getValidationFunction: function (sControlType) {
            const validationMap = {
                "sap.m.DatePicker": this.validateDatePicker,
                "sap.m.MultiInput": this.validateMultiInput,
                "sap.ui.mdc.Field": this.validateMdcField,
            };

            return validationMap[sControlType] || this._validateByType;
        },

        /**
         * @description Validates a control based on its type if no other validation function is provided.
         * @private
         * @param {object} oControl - The control to validate.
         * @throws {Error} - If the value is invalid.
         * @since 2441
         * @author C5388035
         */
        _validateByType: function (oControl) {
            const oBinding = oControl.getBinding("value");

            if (oBinding) {
                const oValue = oControl.getValue();
                if (!oValue) {
                    return;
                }

                oBinding.getType().validateValue(oValue);
            }
        },

        /**
         * @description Checks if a control is required and whether its value is valid.
         * @private
         * @param {object} oControl - The control to check. 
         * @returns {boolean} - `true` if the control is required and its value is empty, otherwise `false`.
         * @since 2441
         * @author C5388035
         */
        _checkIsRequired: function (oControl) {
            if (oControl.isA("sap.m.MultiInput")) {
                return oControl.getRequired() && !oControl.getTokens().length;
            }
            if (oControl.isA("sap.m.InputBase")) {
                return oControl.getRequired() && (!oControl.getValue() || oControl.getValue().trim() === "");
            }
            if (oControl.isA("sap.ui.mdc.Field")) {
                return oControl.getRequired() && !oControl.getValue() && !oControl.isInvalidInput();
            }
            return false;
        },
    }
})