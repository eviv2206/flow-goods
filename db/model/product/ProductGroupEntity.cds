namespace com.yauheni.sapryn.flowgoods;

using {
    com.yauheni.sapryn.flowgoods.ProductPositionEntity
} from '..';

entity ProductGroupEntity {
    key code: String(2);
    name: String(255);
    positions: Association to Many ProductPositionEntity on positions.productGroup = $self;
}