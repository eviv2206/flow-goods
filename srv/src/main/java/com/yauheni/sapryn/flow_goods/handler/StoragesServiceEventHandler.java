package com.yauheni.sapryn.flow_goods.handler;

import org.springframework.stereotype.Component;
import cds.gen.storagesservice.StoragesService_;
import cds.gen.storagesservice.Storage_;
import cds.gen.storagesservice.Storage;
import cds.gen.com.yauheni.sapryn.flowgoods.StorageEntity;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.yauheni.sapryn.flow_goods.validation.StoragesValidationService;
import com.sap.cds.services.cds.CdsCreateEventContext;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.Before;
import lombok.AllArgsConstructor;

import static com.sap.cds.services.cds.CqnService.EVENT_CREATE;

@Component
@AllArgsConstructor
@ServiceName(StoragesService_.CDS_NAME)
public class StoragesServiceEventHandler implements EventHandler {

    private final StoragesValidationService storagesValidationService;
    
    @Before(event = EVENT_CREATE, entity = Storage_.CDS_NAME)
    public void beforeCreateStorage(CdsCreateEventContext context, Storage storage) {
        StorageEntity newStorage = StorageEntity.create();

        newStorage.setId(storage.getId());
        newStorage.setName(storage.getName());

        storagesValidationService.validate(storage);

    }
}
