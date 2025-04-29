package com.yauheni.sapryn.flow_goods.handler;

import org.springframework.stereotype.Component;
import cds.gen.storagesservice.StoragesService_;
import cds.gen.storagesservice.Storage_;
import cds.gen.storagesservice.Storage;
import cds.gen.com.yauheni.sapryn.flowgoods.StorageEntity;
import cds.gen.storagesservice.ProductStorageMap_;
import cds.gen.storagesservice.ProductStorageMap;
import cds.gen.storagesservice.ProductStorageMapMoveToAnotherStorageContext;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.yauheni.sapryn.flow_goods.service.ProductService;
import com.yauheni.sapryn.flow_goods.validation.StoragesValidationService;
import com.sap.cds.Struct;
import com.sap.cds.ql.cqn.CqnAnalyzer;
import com.sap.cds.services.cds.CdsCreateEventContext;
import com.sap.cds.services.cds.CdsReadEventContext;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.Before;
import com.sap.cds.services.handler.annotations.On;
import static com.sap.cds.services.cds.CqnService.EVENT_READ;

import lombok.AllArgsConstructor;

import static com.sap.cds.services.cds.CqnService.EVENT_CREATE;

@Component
@AllArgsConstructor
@ServiceName(StoragesService_.CDS_NAME)
public class StoragesServiceEventHandler implements EventHandler {

    private final StoragesValidationService storagesValidationService;
    private final ProductService productService;

    
    @Before(event = EVENT_CREATE, entity = Storage_.CDS_NAME)
    public void beforeCreateStorage(CdsCreateEventContext context, Storage storage) {
        StorageEntity newStorage = StorageEntity.create();

        newStorage.setId(storage.getId());
        newStorage.setName(storage.getName());

        storagesValidationService.validate(storage);
    };

    @After(event = EVENT_READ, entity = ProductStorageMap_.CDS_NAME)
    public void enrichProductStorageMap(CdsReadEventContext context) {
        final var productStorageMaps = context.getResult().listOf(ProductStorageMap.class);

        productStorageMaps.forEach(productStorageMap -> {
            if (productStorageMap.getQuantityRemain() != null) {
                Integer quantityRemain = productStorageMap.getQuantityRemain();
                if (quantityRemain < 20) {
                    productStorageMap.setQuantityRemainStatus(1);
                } else if (quantityRemain < 50) {
                    productStorageMap.setQuantityRemainStatus(2);
                } else {
                    productStorageMap.setQuantityRemainStatus(0);
                }
            }
        });
    }

    @On(event = ProductStorageMapMoveToAnotherStorageContext.CDS_NAME)
    public void moveToAnotherStorage(ProductStorageMapMoveToAnotherStorageContext context) {
        final var analysisResult = CqnAnalyzer.create(context.getModel())
                .analyze(context.getCqn());

        String productStorageID = (String) analysisResult.rootKeys().get(ProductStorageMap.ID);
        String productID = context.getProductId();
        String newStorageId = context.getStorageId();
        Integer quantityToMove = context.getQuantity();
        final var productStorageMap = productService.moveProducts(productStorageID, productID, newStorageId, quantityToMove);
        context.setResult(Struct.access(productStorageMap).as(ProductStorageMap.class));
        context.setCompleted();
    }
}
