using com.yauheni.sapryn.flowgoods as flowgoods from '../../../../db';

@path: 'StoragesService'
service StoragesService {
    @cds.autoexpose
    entity Storage           as
        select from flowgoods.StorageEntity {
            key ID,
                name,
                description,
                city,
                address,
                type,
                longitude,
                latitude,
                products,
                createdAt,
                createdBy,
                modifiedAt,
                modifiedBy,
                (
                    select sum(quantityRemain) from flowgoods.ProductStorageMapEntity
                    where
                        ProductStorageMapEntity.storage.ID = StorageEntity.ID

                ) as productsCount : Integer,
        };

    entity StorageCity       as projection on flowgoods.StorageCityEntity;
    entity ProductStorageMap as select from flowgoods.ProductStorageMapEntity {
        key ID,
            product,
            storage,
            quantityRemain,
            price,
            quantityRemainStatus,
            createdAt,
            createdBy,
            modifiedAt,
            modifiedBy,
    }
    actions {
            action moveToAnotherStorage(productId: ProductStorageMap : product.ID,
                                        storageId: ProductStorageMap : storage.ID,
                                        quantity : ProductStorageMap : quantityRemain,
                                        ) returns ProductStorageMap;
        }
    ;
    entity Product           as projection on flowgoods.ProductEntity;
    entity ProductFullType   as projection on flowgoods.ProductFullTypeEntity;
    entity StorageType       as projection on flowgoods.StorageTypeEntity;
}
