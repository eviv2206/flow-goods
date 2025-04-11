using com.yauheni.sapryn.flowgoods as flowgoods from '../../../../db';

@path: 'StoragesService'
service StoragesService {
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
                    select count(quantityRemain) from flowgoods.ProductStorageMapEntity
                    where
                        ProductStorageMapEntity.storage.ID = StorageEntity.ID

                ) as productsCount : Integer,
        };

    entity StorageCity       as projection on flowgoods.StorageCityEntity;
    entity ProductStorageMap as projection on flowgoods.ProductStorageMapEntity;
    entity StorageType      as projection on flowgoods.StorageTypeEntity;
}
