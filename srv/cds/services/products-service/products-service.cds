using com.yauheni.sapryn.flowgoods as flowgoods from '../../../../db';

@path: 'ProductsService'
service ProductsService {
    entity Product as projection on flowgoods.ProductEntity;
    entity ProductType as projection on flowgoods.ProductTypeEntity;
    entity ProductStorageMap as projection on flowgoods.ProductStorageMapEntity;
}