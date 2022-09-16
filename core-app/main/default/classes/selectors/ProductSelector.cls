public inherited sharing class ProductSelector extends fflib_SObjectSelector {
    public Schema.SObjectField[] getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Product2.Id,
            Product2.Name,
            Product2.ProductCode,
            Product2.Family,
            Product2.IsActive,
            Product2.DisplayUrl,
            Product2.ExternalId
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Product2.sObjectType;
    }

    public Product2[] selectById(Set<Id> idSet) {
        return (Product2[]) selectSObjectsById(idSet);
    }

    public Product2[] selectAll(Integer limitCount, Boolean isActive) {
        return selectAll(limitCount, isActive, false, false);
    }

    public class QueryParams {
        public Schema.SObjectField[] fieldList;
        public Integer limitBy = 1;
        public String orderField = 'CreatedDate';
        public fflib_QueryFactory.SortOrder orderSort = fflib_QueryFactory.SortOrder.DESCENDING;
    }

    public Product2[] selectAll(
        Integer limitCount,
        Boolean isActive,
        Boolean includePricebookEntries,
        Boolean includeBalances
    ) {
        Map<String, QueryParams> params = new Map<String, QueryParams>();
        if (includePricebookEntries) {
            QueryParams p = new QueryParams();
            Map<String, Schema.SObjectField> fields = Schema.describeSObjects(
                    new List<String>{ 'PricebookEntry' },
                    SObjectDescribeOptions.DEFERRED
                )[0]
                .fields.getMap();
            p.fieldList = new List<Schema.SObjectField>{
                fields.get('UnitPrice')
            };
            p.limitBy = 2;
            params.put('PricebookEntrySelector', p);
        }
        if (includeBalances) {
            QueryParams p = new QueryParams();
            Map<String, Schema.SObjectField> fields = Schema.describeSObjects(
                    new List<String>{ 'Balance__c' },
                    SObjectDescribeOptions.DEFERRED
                )[0]
                .fields.getMap();
            p.fieldList = new List<Schema.SObjectField>{
                fields.get('Balance__c'),
                fields.get('Balance_AUD__c')
            };
            params.put('BalanceSelector', p);
        }

        return selectAll(limitCount, isActive, params);
    }

    public Product2[] selectAll(
        Integer limitCount,
        Boolean isActive,
        Map<String, QueryParams> childQueries
    ) {
        fflib_QueryFactory parent = newQueryFactory()
            .setLimit(limitCount)
            .setCondition('IsActive = :isActive');

        for (String childquery : childQueries.keySet()) {
            QueryParams params = childQueries.get(childQuery);

            fflib_SObjectSelector selector = (fflib_SObjectSelector) Type.forName(
                    childquery
                )
                .newInstance();
            fflib_QueryFactory child = selector.addQueryFactorySubselect(
                parent
            );

            selector.setFieldListBuilder(
                new fflib_StringBuilder.FieldListBuilder(params.fieldList)
            );
            child.setLimit(params.limitBy);
            child.setOrdering(params.OrderField, params.OrderSort);
        }
        return (Product2[]) Database.query(parent.toSOQL());
    }

    public Product2[] selectByFamily(Set<String> familyList) {
        return (Product2[]) Database.query(
            newQueryFactory().setCondition('Family IN :familyList').toSOQL()
        );
    }
}
