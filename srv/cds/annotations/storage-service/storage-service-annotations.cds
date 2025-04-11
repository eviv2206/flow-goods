using StoragesService from '../../services/storages-service/storages-service';

annotate StoragesService.Storage with @odata.draft.enabled;

annotate StoragesService.Storage with @(
    Capabilities: {FilterRestrictions: {
        FilterExpressionRestrictions: [{
            Property          : city_ID,
            AllowedExpressions: 'MultiValue',
        }],

        NonFilterableProperties     : [
            'longitude',
            'latitude',
            'ID',
            'name',
            'description',
        ],
    }, },

    UI          : {

        SelectionPresentationVariant #All      : {
            Text : '{i18n>all}',
            SelectionVariant: {
                Text         : '{i18n>all}',
            },
            PresentationVariant : ![@UI.PresentationVariant],
        },

        SelectionPresentationVariant #SalePoint: {
            Text         : '{i18n>storage.type.salePoint}',
            SelectionVariant: {
                Text         : '{i18n>storage.type.salePoint}',
                SelectOptions: [{
                    PropertyName: type_ID,
                    Ranges      : [{
                        $Type : 'UI.SelectionRangeType',
                        Option: #EQ,
                        Sign  : #I,
                        Low   : '0',
                    }]
                }],
            },
            PresentationVariant : ![@UI.PresentationVariant]
        },

        SelectionPresentationVariant #Warehouse: {
            Text: '{i18n>storage.type.warehouse}',
            SelectionVariant: {
                Text        : '{i18n>storage.type.warehouse}',
                SelectOptions: [{
                    PropertyName: type_ID,
                    Ranges      : [{
                        $Type : 'UI.SelectionRangeType',
                        Option: #EQ,
                        Sign  : #I,
                        Low   : '1'
                    }]
                }]
            },
            PresentationVariant         : ![@UI.PresentationVariant]
        },

        PresentationVariant  : {
            SortOrder: [{
                Property: modifiedAt,
                Descending: true,
            }]
            
        },

        LineItem                   : [
            {
                $Type                : 'UI.DataField',
                Value                : type.name,
                Label                : '{i18n>storage.type}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : city.name,
                Label                : '{i18n>storage.city}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type                : 'UI.DataField',
                Value                : address,
                Label                : '{i18n>storage.address}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
                        {
                $Type                : 'UI.DataField',
                Value                : modifiedAt,
                Label                : '{i18n>modifiedAt}',
                ![@HTML5.CssDefaults]: {width: '35%'},
                ![@UI.Importance]    : #High
            },
            {
                $Type        : 'UI.DataField',
                Value        : longitude,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : latitude,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : ID,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : city_ID,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : name,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : description,
                ![@UI.Hidden]: true,
            },
            {
                $Type        : 'UI.DataField',
                Value        : type_ID,
                ![@UI.Hidden]: true,
            }

        ],

        SelectionFields            : [
            type_ID,
            city_ID,
            address,
        ],

        HeaderInfo                 : {
            Title         : {
                $Type: 'UI.DataField',
                Value: name,
            },
            TypeName      : '{i18n>storage.storage}',
            TypeNamePlural: '{i18n>storage.storages}',
            Description   : {
                $Type: 'UI.DataField',
                Value: description,
            },
        },

        HeaderFacets               : [{
            $Type : 'UI.ReferenceFacet',
            ID    : 'productsCount',
            Label : '{i18n>storage.productsCount}',
            Target: '@UI.DataPoint#productsCount',
        }],

        Facets                     : [
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>adminInformation}',
                ID    : 'AdminInfo',
                Target: '@UI.FieldGroup#Admin',
            },
            {
                $Type : 'UI.ReferenceFacet',
                Label : '{i18n>storage.products}',
                ID    : 'Products',
                Target: 'products/@UI.LineItem#Products',
            }
        ],

        FieldGroup #Admin          : {Data: [
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

        DataPoint #productsCount   : {
            $Type: 'UI.DataPointType',
            Value: productsCount,
            Title: '{i18n>storage.totalProductsCount}',
        }
    },
);

annotate StoragesService.ProductStorageMap with @(UI: {LineItem #Products: [
    {
        $Type                : 'UI.DataField',
        Value                : product.name,
        Label                : '{i18n>product.name}',
        ![@HTML5.CssDefaults]: {width: '35%'},
        ![@UI.Importance]    : #High
    },
    {
        $Type                : 'UI.DataField',
        Value                : quantityBase,
        Label                : '{i18n>product.quantityBase}',
        ![@HTML5.CssDefaults]: {width: '35%'},
        ![@UI.Importance]    : #High
    },
    {
        $Type                : 'UI.DataField',
        Value                : quantityRemain,
        Label                : '{i18n>product.quantityRemain}',
        ![@HTML5.CssDefaults]: {width: '35%'},
        ![@UI.Importance]    : #High
    },
    {
        $Type                : 'UI.DataField',
        Value                : price,
        Label                : '{i18n>product.price}',
        ![@HTML5.CssDefaults]: {width: '35%'},
        ![@UI.Importance]    : #High
    },
], });

annotate StoragesService.StorageCity with {
    @title: '{i18n>storage.city.name}'
    ID @Common: {
        Text           : name,
        TextArrangement: #TextOnly,
    };

    @title: '{i18n>storage.city.name}'
    name;
};

annotate StoragesService.StorageType with {
    @title: '{i18n>storage.type.name}'
    ID @Common: {
        Text           : name,
        TextArrangement: #TextOnly,
    };

    @title: '{i18n>storage.type.name}'
    name;
};

annotate StoragesService.ProductStorageMap with {
    @title: '{i18n>product.quantityBase}'
    quantityBase;

    @title: '{i18n>product.quantityRemain}'
    quantityRemain;

    @title: '{i18n>product.price}'
    price;
};

annotate StoragesService.Storage with {
    @title: '{i18n>storage.name}'
    @mandatory
    name;

    @title: '{i18n>storage.description}'
    description   @(UI: {MultiLineText});

    @title: '{i18n>storage.address}'
    address       @(UI: {MultiLineText});

    @title: '{i18n>storage.type}'
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

    @title: '{i18n>storage.longitude}'
    longitude;

    @title: '{i18n>storage.latitude}'
    latitude;

    @title: '{i18n>storage.productsCount}'
    productsCount @readonly;

    @title: '{i18n>storage.city}'
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
