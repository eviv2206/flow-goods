package com.yauheni.sapryn.flow_goods.handler;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Component;

import com.sap.cds.Struct;
import com.sap.cds.ql.Insert;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.ql.cqn.CqnAnalyzer;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;

import cds.gen.requestsforsupplyservice.RequestsForSupplyService_;
import cds.gen.requestsforsupplyservice.CreateRequestForSupplyContext;
import cds.gen.requestsforsupplyservice.RequestForSupply;
import cds.gen.requestsforsupplyservice.RequestForSupplyChangeStatusContext;
import cds.gen.requestsforsupplyservice.ProductRequestForSupplyMap;
import cds.gen.requestsforsupplyservice.ProductRequestForSupplyMap_;
import cds.gen.requestsforsupplyservice.RequestForSupply_;
import cds.gen.com.yauheni.sapryn.flowgoods.ProductStorageMapEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.ProductRequestForSupplyMapEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.RequestForSupplyEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.RequestForSupplyEntity_;
import cds.gen.com.yauheni.sapryn.flowgoods.RequestForSupplyStatusEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.RequestForSupplyStatusEntity_;
import cds.gen.com.yauheni.sapryn.flowgoods.ProductRequestForSupplyMapEntity_;
import cds.gen.com.yauheni.sapryn.flowgoods.SupplierEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.SupplyEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.SupplyEntity_;
import cds.gen.productsservice.ProductStorageMap;
import cds.gen.suppliesservice.CreateSupplyContext;
import cds.gen.suppliesservice.Supply;
import lombok.AllArgsConstructor;

@Component
@AllArgsConstructor
@ServiceName(RequestsForSupplyService_.CDS_NAME)
public class RequestsForSupplyEventHandler implements EventHandler {

    private final PersistenceService persistenceService;

    @On(event = CreateRequestForSupplyContext.CDS_NAME)
    public void onCreateRequestForSupply(CreateRequestForSupplyContext context) {
        String name = context.getName();
        String description = context.getDescription();
        LocalDate dueDate = context.getDueDate();
        Collection<String> productIDs = context.getProductIDs();

        RequestForSupply newRequest = RequestForSupply.create();
        newRequest.setName(name);
        newRequest.setDescription(description);
        newRequest.setDueDate(dueDate);

        RequestForSupplyStatusEntity defaultStatus = persistenceService
            .run(Select.from(RequestForSupplyStatusEntity_.class).orderBy(s -> s.ID().asc()))
            .first(RequestForSupplyStatusEntity.class)
            .orElse(null);
        
        newRequest.setStatusId(defaultStatus.getId());

        RequestForSupplyEntity savedRequestForSupply = persistenceService.run(Insert.into(RequestForSupplyEntity_.class).entry(newRequest))
                .single(RequestForSupplyEntity.class);

        String requestId = savedRequestForSupply.getId();

        List<ProductRequestForSupplyMapEntity> savedProducts = new ArrayList<>();

        for (String productId : productIDs) {
            ProductRequestForSupplyMapEntity mapping = ProductRequestForSupplyMapEntity.create();
            mapping.setRequestForSupplyId(requestId);
            mapping.setProductId(productId);

            ProductRequestForSupplyMapEntity savedMapping = persistenceService
                    .run(Insert.into(ProductRequestForSupplyMapEntity_.class).entry(mapping))
                    .single(ProductRequestForSupplyMapEntity.class);

            savedProducts.add(savedMapping);
        }

        savedRequestForSupply.setProducts(savedProducts);
        context.setResult(Struct.access(savedRequestForSupply).as(RequestForSupply.class));
        context.setCompleted();
        context.setResult(newRequest);
    }

    @On(event = RequestForSupplyChangeStatusContext.CDS_NAME)
    public void onChangeStatus(RequestForSupplyChangeStatusContext context) {
        final var analysisResult = CqnAnalyzer.create(context.getModel())
                .analyze(context.getCqn());
        
        String requestID = (String) analysisResult.rootKeys().get(RequestForSupply.ID);

        String newStatusId = (String) context.getStatusID();

        RequestForSupplyStatusEntity newStatus = persistenceService
                .run(Select.from(RequestForSupplyStatusEntity_.class).where(s -> s.ID().eq(newStatusId)))
                .single(RequestForSupplyStatusEntity.class);

        if (newStatus == null) {
            throw new ServiceException(ErrorStatuses.NOT_FOUND, "Статус с ID '" + newStatusId + "' не найден.");
        }

        persistenceService.run(Update.entity(RequestForSupplyEntity_.class)
                .data(RequestForSupplyEntity_.ID, newStatusId)
                .where(r -> r.ID().eq(requestID)));

        RequestForSupplyEntity updatedRequest = persistenceService
                .run(Select.from(RequestForSupplyEntity_.class).where(r -> r.ID().eq(requestID)))
                .single(RequestForSupplyEntity.class);

        context.setResult(Struct.access(updatedRequest).as(RequestForSupply.class));
        context.setCompleted();
    }

}
