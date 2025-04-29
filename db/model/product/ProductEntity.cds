namespace com.yauheni.sapryn.flowgoods;
using {
    cuid,
    managed
} from '@sap/cds/common';
using {
    com.yauheni.sapryn.flowgoods.ProductGroupEntity,
    com.yauheni.sapryn.flowgoods.ProductPositionEntity,
    com.yauheni.sapryn.flowgoods.ProductSubpositionEntity,
    com.yauheni.sapryn.flowgoods.ProductFullTypeEntity,
    com.yauheni.sapryn.flowgoods.ProductStorageMapEntity
} from '..';

entity ProductEntity : cuid, managed {
    name: String(255);
    description: String(255);
    group: Association to One ProductGroupEntity;
    position: Association to One ProductPositionEntity;
    subposition: Association to One ProductSubpositionEntity;
    fullType: Association to One ProductFullTypeEntity;
    placement: Association to many ProductStorageMapEntity on placement.product = $self;
    barcode: String(255);
}