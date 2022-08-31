@isTest
public class LogEventService_Test {
    @isTest
    static void shouldCreateWithLogPlatformEvent() {
        Log__e[] events = new List<Log__e>{
            new Log__e(
                Log_Message__c = 'event 1',
                Quiddity__c = 'QUEUEABLE',
                Request_Id__c = 'fake_id',
                Severity__c = 'DEBUG'
            ),
            new Log__e(
                Log_Message__c = 'event 2',
                Quiddity__c = 'SCHEDULED',
                Request_Id__c = 'fake_id',
                Severity__c = 'INFO'
            ),
            new Log__e(
                Log_Message__c = 'event 3',
                Quiddity__c = 'BATCH_APEX',
                Request_Id__c = 'fake_id',
                Severity__c = 'WARN'
            )
        };

        LogEventService.create(events);

        LogEvent__c[] results = [
            SELECT id, Log_Data__c, Quiddity__c, Request_Id__c, Severity__c
            FROM LogEvent__c
        ];
        System.assertEquals(3, results.size());
    }

    @isTest
    static void shouldCreateWithBatchApexError() {
        BatchApexErrorEvent[] events = new List<BatchApexErrorEvent>{
            new BatchApexErrorEvent(Message = 'event 1', RequestId = 'fake_id'),
            new BatchApexErrorEvent(Message = 'event 2', RequestId = 'fake_id'),
            new BatchApexErrorEvent(Message = 'event 3', RequestId = 'fake_id')
        };

        LogEventService.create(events);

        LogEvent__c[] results = [
            SELECT id, Log_Data__c, Quiddity__c, Request_Id__c, Severity__c
            FROM LogEvent__c
        ];
        System.assertEquals(3, results.size());
        System.assertEquals('BATCH_APEX', results[0].Quiddity__c);
        System.assertEquals('ERROR', results[0].Severity__c);
    }
}
