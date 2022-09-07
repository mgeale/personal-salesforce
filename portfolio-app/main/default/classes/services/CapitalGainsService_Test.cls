@isTest
public class CapitalGainsService_Test {
    @TestSetup
    static void makeData() {
        TriggerHandler.bypass('CapitalGainsTriggerHandler');

        Account acc = (Account) TestDataFactory.createSObject('Account');
        Product2 product = (Product2) TestDataFactory.createSObject('Product2');

        Asset[] purchaseAssets = (Asset[]) TestDataFactory.createSObjectList(
            'Asset',
            new Map<String, Object>{
                'Status' => 'Purchase',
                'AccountId' => acc.id,
                'Product2Id' => product.id,
                'Price__c' => 1.5,
                'Quantity__c' => 200
            },
            5
        );

        Asset[] soldAssets = (Asset[]) TestDataFactory.createSObjectList(
            'Asset',
            new Map<String, Object>{
                'Status' => 'Sold',
                'AccountId' => acc.id,
                'Product2Id' => product.id,
                'Price__c' => 1.99,
                'Quantity__c' => 65
            },
            3
        );

        TestDataFactory.createSObject(
            'Capital_Gains__c',
            new Map<String, Object>{
                'Amount__c' => 55,
                'Purchase__c' => purchaseAssets[0].id,
                'Sold__c' => soldAssets[0].id
            }
        );

        // required because trigger bypassed
        update new Asset(id = purchaseAssets[0].id, Amount_Taxed__c = 55);
        update new Asset(id = soldAssets[0].id, Amount_Taxed__c = 55);
    }

    @isTest
    static void shouldAllocateToAssetList() {
        Asset[] purchaseAssets = [
            SELECT id, Amount_Taxed__c
            FROM Asset
            WHERE Status = 'Purchase' AND Amount_Taxed__c = NULL
        ];
        System.assert(!purchaseAssets.isEmpty());

        Asset[] soldAssets = [
            SELECT id, Amount_Taxed__c
            FROM Asset
            WHERE Status = 'Sold' AND Amount_Taxed__c = NULL
        ];
        System.assert(!soldAssets.isEmpty());

        Capital_Gains__c[] results = CapitalGainsService.allocateToAsset(
            new List<Capital_Gains__c>{
                (Capital_Gains__c) TestDataFactory.createSObject(
                    'Capital_Gains__c',
                    new Map<String, Object>{
                        'Amount__c' => 35,
                        'Purchase__c' => purchaseAssets[0].id,
                        'Sold__c' => soldAssets[0].id
                    },
                    false
                ),
                (Capital_Gains__c) TestDataFactory.createSObject(
                    'Capital_Gains__c',
                    new Map<String, Object>{
                        'Amount__c' => 55,
                        'Purchase__c' => purchaseAssets[1].id,
                        'Sold__c' => soldAssets[1].id
                    },
                    false
                )
            }
        );

        Map<Id, Asset> assetResultsMap = new Map<Id, Asset>(
            [
                SELECT id, Status, Amount_Taxed__c, Outstanding_Tax__c
                FROM Asset
                WHERE
                    id IN (
                        :purchaseAssets[0].id,
                        :soldAssets[0].id,
                        :purchaseAssets[1].id,
                        :soldAssets[1].id
                    )
            ]
        );
        System.assertEquals(
            35,
            assetResultsMap.get(purchaseAssets[0].id).Amount_Taxed__c
        );
        System.assertEquals(
            35,
            assetResultsMap.get(soldAssets[0].id).Amount_Taxed__c
        );
        System.assertEquals(
            55,
            assetResultsMap.get(purchaseAssets[1].id).Amount_Taxed__c
        );
        System.assertEquals(
            55,
            assetResultsMap.get(soldAssets[1].id).Amount_Taxed__c
        );
    }

    @isTest
    static void shouldAllocateToAssetSingle() {
        Asset[] purchaseAssets = [
            SELECT id, Amount_Taxed__c
            FROM Asset
            WHERE Status = 'Purchase' AND Amount_Taxed__c > 0
        ];
        System.assert(!purchaseAssets.isEmpty());

        Asset[] soldAssets = [
            SELECT id, Amount_Taxed__c
            FROM Asset
            WHERE Status = 'Sold' AND Amount_Taxed__c > 0
        ];
        System.assert(!soldAssets.isEmpty());

        Capital_Gains__c[] results = CapitalGainsService.allocateToAsset(
            new List<Capital_Gains__c>{
                (Capital_Gains__c) TestDataFactory.createSObject(
                    'Capital_Gains__c',
                    new Map<String, Object>{
                        'Amount__c' => 5,
                        'Purchase__c' => purchaseAssets[0].id,
                        'Sold__c' => soldAssets[0].id
                    },
                    false
                )
            }
        );

        Map<Id, Asset> assetResultsMap = new Map<Id, Asset>(
            [
                SELECT id, Status, Amount_Taxed__c, Outstanding_Tax__c
                FROM Asset
                WHERE id IN (:purchaseAssets[0].id, :soldAssets[0].id)
            ]
        );
        System.assertEquals(
            60,
            assetResultsMap.get(purchaseAssets[0].id).Amount_Taxed__c
        );
        System.assertEquals(
            60,
            assetResultsMap.get(soldAssets[0].id).Amount_Taxed__c
        );
    }

    @isTest
    static void shouldFailAllocateToAsset() {
        Asset[] purchaseAssets = [
            SELECT id, Amount_Taxed__c
            FROM Asset
            WHERE Status = 'Purchase' AND Amount_Taxed__c > 0
        ];
        System.assert(!purchaseAssets.isEmpty());

        Asset[] soldAssets = [
            SELECT id, Amount_Taxed__c
            FROM Asset
            WHERE Status = 'Sold' AND Amount_Taxed__c > 0
        ];
        System.assert(!soldAssets.isEmpty());

        try {
            Capital_Gains__c[] results = CapitalGainsService.allocateToAsset(
                new List<Capital_Gains__c>{
                    (Capital_Gains__c) TestDataFactory.createSObject(
                        'Capital_Gains__c',
                        new Map<String, Object>{
                            'Amount__c' => 12,
                            'Purchase__c' => purchaseAssets[0].id,
                            'Sold__c' => soldAssets[0].id
                        },
                        false
                    )
                }
            );
            System.assert(false, 'Should not reach this assert.');
        } catch (Exception e) {
            System.assert(e instanceof DmlException);
            System.assert(
                e.getMessage()
                    .contains(
                        '67.000000000 total is greater than maximum of 65.000000000'
                    )
            );
        }

        Map<Id, Asset> assetResultsMap = new Map<Id, Asset>(
            [
                SELECT id, Status, Amount_Taxed__c, Outstanding_Tax__c
                FROM Asset
                WHERE id IN (:purchaseAssets[0].id, :soldAssets[0].id)
            ]
        );
        System.assertEquals(
            55,
            assetResultsMap.get(purchaseAssets[0].id).Amount_Taxed__c
        );
        System.assertEquals(
            55,
            assetResultsMap.get(soldAssets[0].id).Amount_Taxed__c
        );
    }
}
