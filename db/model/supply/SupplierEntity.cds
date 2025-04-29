namespace com.yauheni.sapryn.flowgoods;
using {
    cuid,
    managed
} from '@sap/cds/common';

entity SupplierEntity : cuid, managed {
    name: String(255);
    description: String(255);
}