using com.yauheni.sapryn.flowgoods as flowgoods from '../../../../db';

@path: 'RequestsForSupplyService'
service RequestsForSupplyService {

    entity RequestForSupply as select from flowgoods.RequestForSupplyEntity {
        key ID,
            name,
            description,
            dueDate,
            status,
            products
    }
    actions {
        action changeStatus(
            statusID: RequestForSupply : status.ID
        ) returns RequestForSupply;
    };
    entity RequestForSupplyStatus as projection on flowgoods.RequestForSupplyStatusEntity;
    entity Product as projection on flowgoods.ProductEntity;
    entity ProductRequestForSupplyMap as projection on flowgoods.ProductRequestForSupplyMapEntity;

    action createRequestForSupply (
            name: RequestForSupply : name,
            description: RequestForSupply : description,
            dueDate: RequestForSupply : dueDate,
            statusName: RequestForSupply : status.name,
            product_IDs: array of Product : ID,
        ) returns RequestForSupply;
}