package com.yauheni.sapryn.flow_goods.service;

import java.util.Optional;

import org.springframework.stereotype.Service;

import com.yauheni.sapryn.flow_goods.repository.SupplierRepository;

import cds.gen.com.yauheni.sapryn.flowgoods.SupplierEntity;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class SuppliesService {

    private final SupplierRepository supplierRepository;
    
    public SupplierEntity saveSupplierByName(String name) {
        Optional<SupplierEntity> supplierOpt = supplierRepository.findByNameOpt(name);
        if (supplierOpt.isPresent()) {
            return supplierOpt.get();
        } else {
            SupplierEntity supplier = SupplierEntity.create();
            supplier.setName(name);
            return supplierRepository.create(supplier);
        }
    }
    
}
