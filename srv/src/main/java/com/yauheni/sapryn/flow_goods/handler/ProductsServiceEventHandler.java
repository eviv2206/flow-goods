package com.yauheni.sapryn.flow_goods.handler;

import org.springframework.stereotype.Component;

import com.sap.cds.Struct;
import com.sap.cds.ql.cqn.CqnAnalyzer;
import com.sap.cds.services.cds.CdsReadEventContext;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.yauheni.sapryn.flow_goods.service.ProductService;

import cds.gen.productsservice.ProductsService_;
import cds.gen.productsservice.ProductStorageMap;
import cds.gen.productsservice.ProductStorageMapMoveToAnotherStorageContext;
import cds.gen.productsservice.ProductStorageMap_;
import lombok.AllArgsConstructor;

import static com.sap.cds.services.cds.CqnService.EVENT_READ;

@Component
@AllArgsConstructor
@ServiceName(ProductsService_.CDS_NAME)
public class ProductsServiceEventHandler implements EventHandler {

    private final ProductService productService;


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
    };

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
