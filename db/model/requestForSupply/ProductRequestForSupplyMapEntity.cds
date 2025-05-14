namespace com.yauheni.sapryn.flowgoods;

using {
    cuid,
    managed
} from '@sap/cds/common';

using com.yauheni.sapryn.flowgoods.ProductEntity from '../product/ProductEntity';
using com.yauheni.sapryn.flowgoods.RequestForSupplyEntity from './RequestForSupplyEntity';

entity ProductRequestForSupplyMapEntity : cuid, managed {
    product: Association to One ProductEntity;
    requestForSupply: Association to One RequestForSupplyEntity;
}