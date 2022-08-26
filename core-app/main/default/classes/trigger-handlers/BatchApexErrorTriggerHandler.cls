public without sharing class BatchApexErrorTriggerHandler {
    public static void afterInsert(BatchApexErrorEvent[] errors) {
        LogEventService.create(errors);
    }
}
