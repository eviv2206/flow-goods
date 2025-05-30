namespace com.yauheni.sapryn.flowgoods;
using {
    cuid,
    managed
} from '@sap/cds/common';
using com.yauheni.sapryn.flowgoods.ProductEntity from './ProductEntity';
using com.yauheni.sapryn.flowgoods.StorageEntity from '../storage/StorageEntity';

entity ProductStorageMapEntity : cuid, managed {
    product: Association to One ProductEntity;
    storage: Association to One StorageEntity;
    quantityRemain: Integer;
    quantityRemainStatus : Integer @Core.Computed;
    price: Decimal(10, 2);
}