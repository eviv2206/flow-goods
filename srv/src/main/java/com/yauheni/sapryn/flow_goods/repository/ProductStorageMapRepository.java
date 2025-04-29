package com.yauheni.sapryn.flow_goods.repository;

import cds.gen.com.yauheni.sapryn.flowgoods.ProductStorageMapEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.ProductStorageMapEntity_;
import cds.gen.storagesservice.ProductStorageMap;


import com.sap.cds.ql.Insert;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.persistence.PersistenceService;
import lombok.RequiredArgsConstructor;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ProductStorageMapRepository {

    private final PersistenceService persistenceService;

    public Optional<ProductStorageMapEntity> findByIdOpt(String Id) {
        CqnSelect select = Select.from(ProductStorageMapEntity_.class)
                .where(productStorageMapEntity -> productStorageMapEntity.ID().eq(Id));
        return persistenceService.run(select).first(ProductStorageMapEntity.class);
    }

    public Optional<ProductStorageMapEntity> findByProductIdAndStorageId(String productId, String storageId) {
        CqnSelect select = Select.from(ProductStorageMapEntity_.class)
            .where(productStorageMap -> productStorageMap.product_ID().eq(productId)
                .and(productStorageMap.storage_ID().eq(storageId)));
    
        return persistenceService.run(select).first(ProductStorageMapEntity.class);
    }

    public ProductStorageMapEntity update(String productStorageID, Map<String, Object> data) {
        final var update = Update.entity(ProductStorageMapEntity_.class).data(data).where(c -> c.ID().eq(productStorageID));
        return persistenceService.run(update).single(ProductStorageMapEntity.class);
    }

    public ProductStorageMapEntity create(ProductStorageMapEntity productStorageMap) {
        return persistenceService.run(Insert.into(ProductStorageMapEntity_.class).entry(productStorageMap))
                .single(ProductStorageMapEntity.class);
    }

    public ProductStorageMapEntity save(ProductStorageMapEntity productStorageMap) {
        String id = productStorageMap.getId();

        Optional<ProductStorageMapEntity> existing = findByIdOpt(id);

        if (existing.isPresent()) {
            Map<String, Object> data = new HashMap<>();
            if (productStorageMap.getQuantityRemain() != null)
                data.put("quantityRemain", productStorageMap.getQuantityRemain());
            if (productStorageMap.getPrice() != null)
                data.put("price", productStorageMap.getPrice());
            if (productStorageMap.getProductId() != null)
                data.put("product_ID", productStorageMap.getProductId());
            if (productStorageMap.getStorageId() != null)
                data.put("storage_ID", productStorageMap.getStorageId());

            return update(id, data);
        } else {
            if (id == null || id.isBlank()) {
                productStorageMap.setId(UUID.randomUUID().toString());
            }
            return persistenceService.run(Insert.into(ProductStorageMapEntity_.class).entry(productStorageMap))
                    .single(ProductStorageMapEntity.class);
        }
    }
}
