package com.yauheni.sapryn.flow_goods.service;

import cds.gen.com.yauheni.sapryn.flowgoods.ProductStorageMapEntity;
import lombok.RequiredArgsConstructor;

import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.yauheni.sapryn.flow_goods.repository.ProductStorageMapRepository;

import java.math.BigDecimal;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ProductService {
    
    private final ProductStorageMapRepository productStorageRepository;

    public ProductStorageMapEntity moveProducts(String productStorageID, String productId, String storageToMoveID, Integer quantityToMove) {
        Optional<ProductStorageMapEntity> currProductStorageOpt = productStorageRepository.findByIdOpt(productStorageID);

        if (currProductStorageOpt.isPresent()) {
            ProductStorageMapEntity currProductStorage = currProductStorageOpt.get();

            Integer newQuantityRemain = currProductStorage.getQuantityRemain() - quantityToMove;
            currProductStorage.setQuantityRemain(newQuantityRemain);
    
            productStorageRepository.save(currProductStorage);

            Optional<ProductStorageMapEntity> targetProductStorageOpt = productStorageRepository
                    .findByProductIdAndStorageId(currProductStorage.getProductId(), storageToMoveID);
    
            if (targetProductStorageOpt.isEmpty()) {
                ProductStorageMapEntity newProductStorage = ProductStorageMapEntity.create();
                newProductStorage.setProductId(currProductStorage.getProductId());
                newProductStorage.setStorageId(storageToMoveID);
                newProductStorage.setQuantityRemain(quantityToMove);
                newProductStorage.setPrice(currProductStorage.getPrice());
    
                var productStorage = productStorageRepository.save(newProductStorage);
                return productStorage;
            } else {
                var targetProductStorage = targetProductStorageOpt.get();
                Integer targetQuantityRemain = targetProductStorage.getQuantityRemain() + quantityToMove;
                targetProductStorage.setQuantityRemain(targetQuantityRemain);
                productStorageRepository.save(targetProductStorage);
                return targetProductStorage;    
            }
        } else {
            throw new ServiceException(ErrorStatuses.NOT_FOUND, "Product storage not found for ID: " + productStorageID);
        }
    }

    public ProductStorageMapEntity saveProductStorageMapEntity(String productID, String storageID, Integer quantity, BigDecimal price) {
        Optional<ProductStorageMapEntity> productStorageOpt = productStorageRepository
                .findByProductIdAndStorageId(productID, storageID);

        if (productStorageOpt.isPresent()) {
            ProductStorageMapEntity productStorage = productStorageOpt.get();
            productStorage.setQuantityRemain(quantity + productStorage.getQuantityRemain());
            productStorage.setPrice(productStorage.getPrice());
            return productStorageRepository.save(productStorage);
        } else {
            return createProductStorageMapEntity(productID, storageID, quantity, price);
        }
    }

    public ProductStorageMapEntity createProductStorageMapEntity(String productID, String storageID, Integer quantity, BigDecimal price) {
        ProductStorageMapEntity newProductStorageMap = ProductStorageMapEntity.create();
        newProductStorageMap.setProductId(productID);
        newProductStorageMap.setStorageId(storageID);
        newProductStorageMap.setQuantityRemain(quantity);
        newProductStorageMap.setPrice(price);
        return productStorageRepository.create(newProductStorageMap);
    }
}
