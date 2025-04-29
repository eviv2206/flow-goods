package com.yauheni.sapryn.flow_goods.validation;

import cds.gen.storagesservice.Storage;
import cds.gen.storagesservice.Storage_;
import org.springframework.stereotype.Component;
import lombok.RequiredArgsConstructor;
import com.sap.cds.services.messages.Messages;


import static org.apache.logging.log4j.util.Strings.isBlank;
import static com.yauheni.sapryn.flow_goods.validation.ValidationMessageKeys.STORAGES_NAME_IS_EMPTY;
import static com.yauheni.sapryn.flow_goods.validation.ValidationMessageKeys.STORAGE_TYPE_IS_EMPTY;

@Component
@RequiredArgsConstructor
public class StoragesValidationService {
    private final Messages message;

    private void checkName(String storageName) {
        if (isBlank(storageName)) {
            message.error(STORAGES_NAME_IS_EMPTY)
                    .target(Storage_.class, Storage_::name);
        }
    }

    private void checkStorageType(Storage storage) {
        if (storage.getTypeId() == null) {
            message.error(STORAGE_TYPE_IS_EMPTY)
                    .target(Storage_.class, Storage_::type_ID);
        }
    }

    public void validate(Storage storage) {
        checkName(storage.getName());
        checkStorageType(storage);
        message.throwIfError();
    }
}
