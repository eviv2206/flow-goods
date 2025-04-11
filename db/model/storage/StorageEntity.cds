namespace com.yauheni.sapryn.flowgoods;
using {
    cuid,
    managed
} from '@sap/cds/common';
using {
    com.yauheni.sapryn.flowgoods.StorageCityEntity,
    com.yauheni.sapryn.flowgoods.StorageTypeEntity
} from '..';

using {
    com.yauheni.sapryn.flowgoods.ProductStorageMapEntity
} from '../product/ProductStorageMapEntity';

entity StorageEntity : cuid, managed {
    name: String(255);
    description: String(255);
    city: Association to One StorageCityEntity;
    address: String(255);
    type: Association to One StorageTypeEntity;
    longitude: Decimal(18, 15);
    latitude: Decimal(17, 15);
    products: Association to Many ProductStorageMapEntity on products.storage = $self;
}