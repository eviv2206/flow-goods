namespace com.yauheni.sapryn.flowgoods;
using {
    cuid,
    managed
} from '@sap/cds/common';
using {
    com.yauheni.sapryn.flowgoods.ProductTypeEntity,
    com.yauheni.sapryn.flowgoods.ProductStorageMapEntity
} from '..';

entity ProductEntity : cuid, managed {
    name: String(255);
    description: String(255);
    type: Association to One ProductTypeEntity;
    placement: Association to many ProductStorageMapEntity on placement.product = $self;
    barcode: String(255);
}