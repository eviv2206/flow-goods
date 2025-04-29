using ProductsService from '../../services/products-service/products-service';

annotate ProductsService.Product with @odata.draft.enabled;

annotate ProductsService.Product with @(
    Capabilities: {FilterRestrictions: {

    NonFilterableProperties: [
        'ID',
        'name',
        'description',
        'storagesCount'
    ], }, },

    UI          : {

        SelectionFields         : [
            group_code,
            position_code,
            subposition_code,
            fullType_code,
            barcode
        ],

        HeaderInfo              : {
            Title         : {
                $Type: 'UI.DataField',
                Value: name,
            },
            TypeName      : '{i18n>productservice.product.product}',
            TypeNamePlural: '{i18n>productservice.product.products}',
            Description   : {
                $Type: 'UI.DataField',
                Value: description,
            },
        },

        Facets                  : [
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>productservice.product.products}',
                ID    : 'Placements',
                Target: 'placement/@UI.PresentationVariant',
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>productservice.product.adminInfo}',
                ID    : 'AdminInfo',
                Target: '@UI.FieldGroup#Admin',
            },
        ],

        HeaderFacets            : [
            {
                $Type : 'UI.ReferenceFacet',
                ID    : 'barcode',
                Label : '{i18n>productservice.storage.productsCount}',
                Target: '@UI.DataPoint#barcode',
            },
            {
                $Type : 'UI.ReferenceFacet',
                ID    : 'storagesCount',
                Label : '{i18n>productservice.product.storagesCount}',
                Target: '@UI.DataPoint#storagesCount',
            }
        ],

        FieldGroup #Admin       : {Data: [
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

        LineItem                : [
            {
                $Type                : 'UI.DataField',
                Value                : name,
                Label                : '{i18n>productservice.product.name}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : description,
                Label                : '{i18n>productservice.product.description}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : fullType.name,
                Label                : '{i18n>productservice.product.fullType.name}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : storagesCount,
                Label                : '{i18n>productservice.product.storagesCount}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            }
        ],

        DataPoint #barcode      : {
            $Type: 'UI.DataPointType',
            Value: barcode,
            Title: '{i18n>productservice.product.barcode}',
        },

        DataPoint #storagesCount: {
            $Type: 'UI.DataPointType',
            Value: storagesCount,
            Title: '{i18n>productservice.product.storagesCount}',
        }
    }
);

annotate ProductsService.ProductStorageMap with @(UI: {
    DeleteHidden : true,
    LineItem           : {
        $value            : [
            {
                $Type                : 'UI.DataField',
                Value                : storage.name,
                Label                : '{i18n>productservice.storage.name}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type                : 'UI.DataField',
                Value                : storage.type.name,
                Label                : '{i18n>productservice.storage.type}',
                ![@HTML5.CssDefaults]: {width: '20%'},
                ![@UI.Importance]    : #High,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type                : 'UI.DataField',
                Value                : storage.address,
                Label                : '{i18n>productservice.storage.address}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High,
                ![@Common.FieldControl]: #ReadOnly,
            },
            {
                $Type                : 'UI.DataField',
                Value                : price,
                Label                : '{i18n>productservice.storage.price}',
                ![@HTML5.CssDefaults]: {width: '20%'},
                ![@UI.Importance]    : #High,
            },
            {
                $Type        : 'UI.DataField',
                Value        : quantityRemainStatus,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : quantityRemain,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : storage_ID,
                ![@UI.Hidden]: true,
            }
        ],
        ![@UI.Criticality]: quantityRemainStatus
    },

    PresentationVariant: {
        SortOrder     : [{
            Property  : modifiedAt,
            Descending: true,
        }],

        RequestAtLeast: [quantityRemainStatus, ],
        Visualizations: ['@UI.LineItem']

    },
});

annotate ProductsService.Product with {

    @title: '{i18n>productservice.product.name}'
    @mandatory
    name;

    @title: '{i18n>productservice.product.description}'
    description @(UI: {MultiLineText});

    @title: '{i18n>productservice.product.group}'
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


    @title: '{i18n>productservice.product.position}'
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
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: position_code,
                    ValueListProperty: 'code',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ]
        }
    };

    @title: '{i18n>productservice.product.subposition}'
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
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: position_code,
                    ValueListProperty: 'productPosition_code',
                },
                {
                    $Type            : 'Common.ValueListParameterIn',
                    LocalDataProperty: group_code,
                    ValueListProperty: 'productPosition/productGroup_code',
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: subposition_code,
                    ValueListProperty: 'code',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ]
        }
    };

    @title: '{i18n>productservice.product.placement}'
    placement;

    @title: '{i18n>productservice.product.barcode}'
    barcode;

    @title: '{i18n>productservice.product.fullType}'
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
                },
            ]
        },
    };
};

annotate ProductsService.ProductStorageMap with {
    @UI.Hidden: true
    ID;

    @title    : '{i18n>productservice.product.quantityRemain}'
    @mandatory
    quantityRemain;

    @title    : '{i18n>productservice.product.price}'
    price;

    @title    : '{i18n>productservice.storage.storage}'
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

    @UI.Hidden: true
    @readonly
    product;
};

annotate ProductsService.Storage with {
    ID @Common : { 
        Text           : name,
        TextArrangement: #TextOnly,
    };
    
    @title: '{i18n>productservice.storage.name}'
    @mandatory
    name;

    @title: '{i18n>productservice.storage.description}'
    description   @(UI: {MultiLineText});

    @title: '{i18n>productservice.storage.address}'
    address       @(UI: {MultiLineText});

    @title: '{i18n>productservice.storage.type}'
    @mandatory
    type          @Common: {
        Text                    : type.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: true,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'StorageType',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: type_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ]
        },
    };

    @title: '{i18n>productservice.storage.longitude}'
    longitude;

    @title: '{i18n>productservice.storage.latitude}'
    latitude;

    @title: '{i18n>productservice.storage.city}'
    city          @Common: {
        Text                    : city.name,
        TextArrangement         : #TextOnly,
        ValueListWithFixedValues: false,
        ValueList               : {
            $Type                  : 'Common.ValueListType',
            CollectionPath         : 'StorageCity',
            DistinctValuesSupported: true,
            SearchSupported        : true,
            Parameters             : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: city_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                }
            ]
        },
    };
};

annotate ProductsService.ProductGroup with {
    @title : '{i18n>productservice.product.group.code}'
    code;

    @title: '{i18n>productservice.product.group.name}'
    name;
};

annotate ProductsService.ProductPosition with {
    @title : '{i18n>productservice.product.position.code}'
    code;

    @title: '{i18n>productservice.product.position.name}'
    name;
};

annotate ProductsService.ProductSubposition with {
    @title : '{i18n>productservice.product.subposition.code}'
    code;

    @title: '{i18n>productservice.product.subposition.name}'
    name;
};

annotate ProductsService.ProductFullType with {
    @title : '{i18n>productservice.product.fullType.code}'
    code;

    @title: '{i18n>productservice.product.fullType.name}'
    name;
}
