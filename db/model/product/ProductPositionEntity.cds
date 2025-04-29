namespace com.yauheni.sapryn.flowgoods;

using { 
    com.yauheni.sapryn.flowgoods.ProductGroupEntity,
    com.yauheni.sapryn.flowgoods.ProductSubpositionEntity,
 } from '..';


entity ProductPositionEntity {
    key code: String(4);
    name: String(255);
    productGroup: Association to One ProductGroupEntity;
    productSubpositions: Association to Many ProductSubpositionEntity on productSubpositions.productPosition = $self;
};

