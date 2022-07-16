public without sharing class PriceBookTriggerHandler {
    public static void afterInsert(List<Pricebook2> newList) {
        for (Pricebook2 book : newList) {
            System.enqueueJob(new CoinGeckoPricesQueueable(book.id));
        }
    }
}
