namespace com.yauheni.sapryn.flowgoods;
using {
    cuid,
    managed
} from '@sap/cds/common';
using com.yauheni.sapryn.flowgoods.ProductEntity from '../product/ProductEntity';
using com.yauheni.sapryn.flowgoods.ProductStorageMapEntity from '../product/ProductStorageMapEntity';
using com.yauheni.sapryn.flowgoods.SupplierEntity from './SupplierEntity';

entity SupplyEntity : cuid, managed {
    name: String(255);
    description: String(255);
    supplier: Association to One SupplierEntity;
    dateSupply: Date;
    quantity: Integer;
    totalPrice: Decimal(10, 2);
    toProductStorage: Association to One ProductStorageMapEntity;
}