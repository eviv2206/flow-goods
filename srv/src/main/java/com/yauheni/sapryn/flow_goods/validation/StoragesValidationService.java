package com.yauheni.sapryn.flow_goods.validation;

import cds.gen.storagesservice.Storage_;
import org.springframework.stereotype.Component;
import lombok.RequiredArgsConstructor;
import com.sap.cds.services.messages.Messages;


import static org.apache.logging.log4j.util.Strings.isBlank;
import static com.yauheni.sapryn.flow_goods.validation.ValidationMessageKeys.STORAGES_NAME_IS_EMPTY;

@Component
@RequiredArgsConstructor
public class StoragesValidationService {
    private final Messages message;

    public void checkName(String storageName) {
        if (isBlank(storageName)) {
            message.error(STORAGES_NAME_IS_EMPTY)
                    .target(Storage_.class, Storage_::name);
            return;
        }
    }
}
