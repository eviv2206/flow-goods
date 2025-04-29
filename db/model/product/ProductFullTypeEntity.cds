namespace com.yauheni.sapryn.flowgoods;

using {
    com.yauheni.sapryn.flowgoods.ProductSubpositionEntity,
} from '..';

entity ProductFullTypeEntity {
    key code: String(10);
    name: String(255);
    productSubposition: Association to One ProductSubpositionEntity;
};

