public class PricebookEntrySelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            PricebookEntry.Id,
            PricebookEntry.Product2Id,
            PricebookEntry.Pricebook2Id,
            PricebookEntry.UnitPrice
        };
    }

    public Schema.SObjectType getSObjectType() {
        return PricebookEntry.sObjectType;
    }

    public List<PricebookEntry> selectById(Set<Id> idSet) {
        return (List<PricebookEntry>) selectSObjectsById(idSet);
    }

    public List<PricebookEntry> selectByPricebookId(Set<Id> idSet) {
        return (List<PricebookEntry>) Database.query(
            newQueryFactory().setCondition('Pricebook2Id IN :idSet').toSOQL()
        );
    }
}
