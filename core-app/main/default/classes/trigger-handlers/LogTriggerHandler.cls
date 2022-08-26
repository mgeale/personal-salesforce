public without sharing class LogTriggerHandler {
    public static void afterInsert(Log__e[] logs) {
        LogEventService.create(logs);
    }
}
