package com.yauheni.sapryn.flow_goods.repository;

import java.util.Optional;

import org.springframework.stereotype.Component;

import com.sap.cds.ql.Insert;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.persistence.PersistenceService;

import cds.gen.com.yauheni.sapryn.flowgoods.SupplierEntity;
import cds.gen.com.yauheni.sapryn.flowgoods.SupplierEntity_;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class SupplierRepository {
    private final PersistenceService persistenceService;

    public Optional<SupplierEntity> findByNameOpt(String name) {
        CqnSelect select = Select.from(SupplierEntity_.class)
                .where(supplierEntity -> supplierEntity.ID().eq(name));
        return persistenceService.run(select).first(SupplierEntity.class);
    }

    public SupplierEntity create(SupplierEntity supplier) {
        return persistenceService.run(Insert.into(SupplierEntity_.class).entry(supplier))
                .single(SupplierEntity.class);
    }
}
