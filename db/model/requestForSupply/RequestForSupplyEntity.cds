namespace com.yauheni.sapryn.flowgoods;
using {
    cuid,
    managed
} from '@sap/cds/common';

using {
    com.yauheni.sapryn.flowgoods.ProductRequestForSupplyMapEntity,
    com.yauheni.sapryn.flowgoods.RequestForSupplyStatusEntity,
} from '.';

entity RequestForSupplyEntity : cuid, managed {
    name: String(255);
    description: String(255);
    dueDate: Date;
    status: Association to One RequestForSupplyStatusEntity;
    products: Association to Many ProductRequestForSupplyMapEntity on products.requestForSupply = $self;
}