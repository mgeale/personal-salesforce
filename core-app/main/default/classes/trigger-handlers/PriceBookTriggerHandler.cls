public without sharing class PriceBookTriggerHandler {
    public static void afterInsert(List<Pricebook2> newList) {
        for (Pricebook2 book : newList) {
            Database.executeBatch(new PricebookEntryCreatorAsync(book.id));
        }
    }
}
