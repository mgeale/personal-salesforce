public without sharing class LogEventService {
    public static void create(Log__e[] events) {
        LogEvent__c[] logEvents = new List<LogEvent__c>{};
        for (Log__e event : events) {
            logEvents.add(
                new LogEvent__c(
                    Log_Data__c = event.Log_Message__c,
                    Quiddity__c = event.Quiddity__c,
                    Request_Id__c = event.Request_Id__c,
                    Severity__c = event.Severity__c
                )
            );
        }

        for (Database.SaveResult sr : Database.insert(logEvents, false)) {
            if (!sr.isSuccess()) {
                System.debug(
                    LoggingLevel.ERROR,
                    'Failed to save log message: ' + sr
                );
            }
        }
    }

    public static void create(BatchApexErrorEvent[] events) {
        Set<Id> asyncApexJobIds = new Set<Id>();
        for (BatchApexErrorEvent evt : Trigger.new) {
            asyncApexJobIds.add(evt.events);
        }

        Map<Id, AsyncApexJob> jobs = new Map<Id, AsyncApexJob>(
            [
                SELECT id, ApexClass.Name
                FROM AsyncApexJob
                WHERE Id IN :asyncApexJobIds
            ]
        );

        LogEvent__c[] logEvents = new List<LogEvent__c>{};
        for (BatchApexErrorEvent event : events) {
            logEvents.add(
                new LogEvent__c(
                    Log_Data__c = event.Message,
                    Quiddity__c = System.Quiddity.BATCH_APEX.name(),
                    Request_Id__c = event.RequestId,
                    Severity__c = LogSeverity.Error.name()
                )
            );
        }

        for (Database.SaveResult sr : Database.insert(logEvents, false)) {
            if (!sr.isSuccess()) {
                System.debug(
                    LoggingLevel.ERROR,
                    'Failed to save log message: ' + sr
                );
            }
        }
    }
}
