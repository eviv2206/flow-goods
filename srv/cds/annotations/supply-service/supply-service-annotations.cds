using SuppliesService from '../../services/supplies-service/supplies-service';

annotate SuppliesService.Supply with @odata.draft.enabled;

annotate SuppliesService.Supply with @(

    Capabilities         : {FilterRestrictions: {FilterExpressionRestrictions: [
        {
            Property          : dateSupply,
            AllowedExpressions: 'SingleValue',
        },
        {
            Property          : name,
            AllowedExpressions: 'SingleValue'
        },
    ], }, },

    UI                   : {
        DeleteHidden           : true,
        CreateHidden           : true,

        HeaderInfo             : {
            Title         : {
                $Type: 'UI.DataField',
                Value: name,
            },
            TypeName      : '{i18n>suppliesservice.supply.supply}',
            TypeNamePlural: '{i18n>suppliesservice.supply.supplies}',
            Description   : {
                $Type: 'UI.DataField',
                Value: description,
            },
        },

        HeaderFacets           : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'productsCount',
            Label : '{suppliesservice.supply.dateSupply}',
            Target: '@UI.DataPoint#dateSupply',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'totalPrice',
            Label : '{suppliesservice.supply.totalPrice}',
            Target: '@UI.DataPoint#totalPrice',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'quantity',
            Label : '{suppliesservice.supply.quantity}',
            Target: '@UI.DataPoint#quantity',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'pricePerItem',
            Label : '{suppliesservice.product.pricePerItem}',
            Target: '@UI.DataPoint#pricePerItem',
        }
        ],

        Facets                 : [
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>suppliesservice.supply.supplierInfo}',
                ID    : 'Supplier',
                Target: '@UI.FieldGroup#Supplier',
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>suppliesservice.supply.productInfo}',
                ID    : 'StorageInfo',
                Target: '@UI.FieldGroup#ProductInfo',
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>suppliesservice.supply.storageInfo}',
                ID    : 'ProductInfo',
                Target: '@UI.FieldGroup#StorageInfo',
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>suppliesservice.supply.adminInformation}',
                ID    : 'AdminInfo',
                Target: '@UI.FieldGroup#Admin',
            },
        ],

        FieldGroup #Supplier   : {Data: [
            {
                $Type: 'UI.DataField',
                Value: supplier.name,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: supplier.description,
            }
        ], },

        FieldGroup #ProductInfo: {Data: [
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.product.name,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.product.description,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.product.fullType.name,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.product.barcode,
                ![@Common.FieldControl]: #ReadOnly,
            }
        ]},

        FieldGroup #StorageInfo : {Data: [
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.storage.name,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.storage.description,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.storage.type.name,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.storage.city.name,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type: 'UI.DataField',
                Value: toProductStorage.storage.address,
                ![@Common.FieldControl]: #ReadOnly,
            }
        ]},

        FieldGroup #Admin    : {Data: [
            {
                $Type: 'UI.DataField',
                Value: createdBy
            },
            {
                $Type: 'UI.DataField',
                Value: modifiedBy
            },
            {
                $Type: 'UI.DataField',
                Value: createdAt
            },
            {
                $Type: 'UI.DataField',
                Value: modifiedAt
            }
        ]},

        DataPoint #dateSupply: {
            $Type: 'UI.DataPointType',
            Value: dateSupply,
            Title: '{i18n>suppliesservice.supply.dateSupply}',
        },

        DataPoint #totalPrice : {
            $Type : 'UI.DataPointType',
            Value : totalPrice,
            Title : '{i18n>suppliesservice.supply.totalPrice}',
        },

        DataPoint #quantity : {
            $Type : 'UI.DataPointType',
            Value : quantity,
            Title : '{i18n>suppliesservice.supply.quantity}',
        },

        DataPoint #pricePerItem : {
            $Type : 'UI.DataPointType',
            Value : pricePerItem,
            Title : '{i18n>suppliesservice.product.pricePerItem}',
        },

        SelectionFields      : [
            name,
            supplier_ID,
            dateSupply,
            toProductStorage.product_ID,
            toProductStorage.storage_ID,
        ],

        LineItem             : [
            {
                $Type                : 'UI.DataField',
                Value                : name,
                Label                : '{i18n>suppliesservice.supply.name}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : description,
                Label                : '{i18n>suppliesservice.supply.description}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : supplier.name,
                Label                : '{i18n>suppliesservice.supply.nameSupplier}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : dateSupply,
                Label                : '{i18n>suppliesservice.supply.dateSupply}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : toProductStorage.product.name,
                Label                : '{i18n>suppliesservice.supply.product}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : quantity,
                Label                : '{i18n>suppliesservice.supply.quantity}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : totalPrice,
                Label                : '{i18n>suppliesservice.supply.totalPrice}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : toProductStorage_ID,
                ![@UI.Hidden]      : true,
            },
            {
                $Type                : 'UI.DataField',
                Value                : ID,
                ![@UI.Hidden]      : true,
            },
                        {
                $Type                : 'UI.DataField',
                Value                : ID,
                ![@UI.Hidden]      : true,
                        },
                                    {
                $Type                : 'UI.DataField',
                Value                : supplier_ID,
                ![@UI.Hidden]      : true,
            }
        ],

        PresentationVariant  : {
            SortOrder     : [{
                Property  : modifiedAt,
                Descending: true,
            }],

            Visualizations: ['@UI.LineItem']
        },
    },
);

annotate SuppliesService.ProductStorageMap with {
    @title : '{i18n>suppliesservice.storage.storage}'
    @mandatory
    storage @Common: {
        Text                    : storage.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'Storage',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: storage_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'type/name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'city/name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'address',
                },
            ]
        },
    };

    @title : '{i18n>suppliesservice.product.product}'
    @mandatory
    product @Common: {
        Text                    : product.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'Product',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: product_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'fullType/name',
                }
            ]
        },
    };
}

annotate SuppliesService.Product with {
    @title: '{i18n>suppliesservice.product.name}'
    @UI.HiddenFilter: true
    ID @Common: {
        Text           : name,
        TextArrangement: #TextOnly,
    };

    @title: '{i18n>suppliesservice.product.name}'
    name;

    @title: '{i18n>suppliesservice.product.description}'
    description;

    @title: '{i18n>suppliesservice.product.barcode}'
    barcode;

    @title: '{i18n>suppliesservice.product.group}'
    group       @Common: {
        Text                    : group.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'ProductGroup',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: group_code,
                    ValueListProperty: 'code',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ]
        }
    };

    @title: '{i18n>suppliesservice.product.position}'
    position    @Common: {
        Text                    : position.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'ProductPosition',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: group_code,
                    ValueListProperty: 'productGroup_code',
                },
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: position_code,
                    ValueListProperty: 'code',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
            ]
        }
    };

    @title: '{i18n>suppliesservice.product.subposition}'
    subposition @Common: {
        Text                    : subposition.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'ProductSubposition',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: position_code,
                    ValueListProperty: 'productPosition_code',
                },
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: group_code,
                    ValueListProperty: 'productPosition/productGroup_ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ]
        }
    };

    @title: '{i18n>suppliesservice.product.fullType}'
    fullType    @Common: {
        Text                    : fullType.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'ProductFullType',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: fullType_code,
                    ValueListProperty: 'code',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'productSubposition/name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'productSubposition/productPosition/name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'productSubposition/productPosition/productGroup/name',
                }
            ]
        },
    };
};

annotate SuppliesService.ProductFullType with {
    @title: '{i18n>suppliesservice.product.fullType.name}'
    name;
};


annotate SuppliesService.Storage with {
    @title: '{i18n>suppliesservice.storage.name}'
    ID @Common: {
        Text           : name,
        TextArrangement: #TextOnly,
    }
};

annotate SuppliesService.Supply with {
    @title: '{i18n>suppliesservice.supply.name}'
    name;

    @title: '{i18n>suppliesservice.supply.description}'
    description;

    @title: '{i18n>suppliesservice.supply.dateSupply}'
    dateSupply;

    @title : '{i18n>suppliesservice.product.pricePerItem}'
    pricePerItem;

    @title: '{i18n>suppliesservice.supply.supplier}'
    supplier @Common: {
        Text                    : supplier.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'Supplier',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: supplier_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'description',
                }
            ]
        },
    }
}

annotate SuppliesService.Supplier with {
    @title: '{i18n>suppliesservice.supplier.name}'
    @UI.HiddenFilter: true
    ID @Common: {
        Text           : name,
        TextArrangement: #TextOnly,
    };

    @title: '{i18n>suppliesservice.supplier.name}'
    @UI.HiddenFilter: true
    name;

    @title: '{i18n>suppliesservice.supplier.description}'
    @UI.HiddenFilter: true
    description;
};

annotate SuppliesService.StorageCity with {
    @title: '{i18n>suppliesservice.storageCity.name}'
    name;
};

annotate SuppliesService.StorageType with {
    @title: '{i18n>suppliesservice.storageType.name}'
    name;
};

annotate SuppliesService.Storage with {
    @title: '{i18n>suppliesservice.storage.name}'
    name;

    @title: '{i18n>suppliesservice.storage.description}'
    description;

    @title: '{i18n>suppliesservice.storage.storageAddress}'
    address;
};


