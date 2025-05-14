package com.yauheni.sapryn.flow_goods.handler;

import java.math.BigDecimal;
import java.time.LocalDate;

import org.springframework.stereotype.Component;
import cds.gen.suppliesservice.SuppliesService_;
import cds.gen.suppliesservice.Supply;

import com.sap.cds.Struct;
import com.sap.cds.ql.Insert;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import com.yauheni.sapryn.flow_goods.service.ProductService;
import com.yauheni.sapryn.flow_goods.service.SuppliesService;

import cds.gen.com.yauheni.sapryn.flowgoods.ProductStorageMapEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.SupplierEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.SupplyEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.SupplyEntity_;
import cds.gen.suppliesservice.CreateSupplyContext;

import lombok.AllArgsConstructor;

@Component
@AllArgsConstructor
@ServiceName(SuppliesService_.CDS_NAME)
public class SuppliesServiceEventHandler implements EventHandler {

    private final ProductService productService;
    private final SuppliesService suppliesService;
    private final PersistenceService persistenceService;

    @On(event = CreateSupplyContext.CDS_NAME)
    public void onCreateSupply(CreateSupplyContext context) {
        String name = context.getName();
        String description = context.getDescription();
        String supplierName = context.getSupplierName();
        LocalDate dateSupply = context.getDateSupply();
        String productID = context.getProductId();
        String storageID = context.getStorageId();
        Integer quantity = context.getQuantity();
        BigDecimal totalPrice = context.getTotalPrice();
        
        ProductStorageMapEntity createdProductStorageMapEntity = productService.saveProductStorageMapEntity(productID, storageID, quantity, null);
        SupplierEntity savedSupplier = suppliesService.saveSupplierByName(supplierName);

        SupplyEntity newSupply = SupplyEntity.create();
        newSupply.setName(name);
        newSupply.setDescription(description);
        newSupply.setSupplierId(savedSupplier.getId());
        newSupply.setDateSupply(dateSupply);
        newSupply.setQuantity(quantity);
        newSupply.setTotalPrice(totalPrice);
        newSupply.setToProductStorageId(createdProductStorageMapEntity.getId());
    
        SupplyEntity savedSupply = persistenceService.run(Insert.into(SupplyEntity_.class).entry(newSupply))
                .single(SupplyEntity.class);
        context.setResult(Struct.access(savedSupply).as(Supply.class));
        context.setCompleted();
    }
}
