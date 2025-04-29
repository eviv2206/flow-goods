using com.yauheni.sapryn.flowgoods as flowgoods from '../../../../db';

@path: 'ProductsService'
service ProductsService {
    entity Product                       as
        select from flowgoods.ProductEntity {
            key ID,
                name,
                description,
                group,
                position,
                subposition,
                fullType,
                placement,
                barcode,
                createdAt,
                createdBy,
                modifiedAt,
                modifiedBy,
                (
                    select sum(quantityRemain) from flowgoods.ProductStorageMapEntity
                    where
                        ProductStorageMapEntity.product.ID = ProductEntity.ID
                ) as storagesCount : Integer,
        };

    entity ProductGroup                  as projection on flowgoods.ProductGroupEntity;
    entity ProductPosition               as projection on flowgoods.ProductPositionEntity;
    entity ProductSubposition            as projection on flowgoods.ProductSubpositionEntity;
    entity ProductFullType               as projection on flowgoods.ProductFullTypeEntity;
    entity ProductStorageMap             as projection on flowgoods.ProductStorageMapEntity
    actions {
            action moveToAnotherStorage(productId: ProductStorageMap : product.ID,
                                        storageId: ProductStorageMap : storage.ID,
                                        quantity : ProductStorageMap : quantityRemain,
                                        ) returns ProductStorageMap;
        }
    ;
    entity Storage                       as projection on flowgoods.StorageEntity;
    entity StorageType                   as projection on flowgoods.StorageTypeEntity;
    entity StorageCity                   as projection on flowgoods.StorageCityEntity;

}
