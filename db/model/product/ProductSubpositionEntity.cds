namespace com.yauheni.sapryn.flowgoods;

using { 
    com.yauheni.sapryn.flowgoods.ProductFullTypeEntity,
    com.yauheni.sapryn.flowgoods.ProductPositionEntity,
 } from '..';


entity ProductSubpositionEntity {
    key code: String(6);
    name: String(255);
    productPosition: Association to One ProductPositionEntity;
    productFullTypes: Association to Many ProductFullTypeEntity on productFullTypes.productSubposition = $self;
};

