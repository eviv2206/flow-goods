using com.yauheni.sapryn.flowgoods as flowgoods from '../../../../db';

@path: 'SuppliesService'
service SuppliesService {

    entity Supply as select from flowgoods.SupplyEntity {
        key ID,
            name,
            description,
            supplier,
            dateSupply,
            quantity,
            totalPrice,
            toProductStorage,
            modifiedAt,
            createdAt,
            modifiedBy,
            createdBy,
            ROUND( totalPrice / quantity, 2) as pricePerItem : Decimal(10, 2)
    };
    entity Supplier as projection on flowgoods.SupplierEntity;
    entity Product as projection on flowgoods.ProductEntity;
    entity ProductGroup as projection on flowgoods.ProductGroupEntity;
    entity ProductPosition as projection on flowgoods.ProductPositionEntity;
    entity ProductSubposition as projection on flowgoods.ProductSubpositionEntity;
    entity ProductFullType as projection on flowgoods.ProductFullTypeEntity;
    entity ProductStorageMap as projection on flowgoods.ProductStorageMapEntity;
    entity Storage as projection on flowgoods.StorageEntity;
    entity StorageCity as projection on flowgoods.StorageCityEntity;
    entity StorageType as projection on flowgoods.StorageTypeEntity;

    action createSupply (
            name: Supply : name,
            description: Supply : description,
            supplierName: Supply : supplier.name,
            dateSupply: Supply : dateSupply,
            product_ID: Supply : toProductStorage.product.ID,
            storage_ID: Supply : toProductStorage.storage.ID,
            quantity: Supply : quantity,
            totalPrice: Supply : totalPrice
        ) returns Supply;
}