public with sharing class LogTriggerHandler {
  public static void afterInsert(List<Log__e> logs) {
    List<LogEvent__c> events = new List<LogEvent__c>();

    for (Log__e event : logs) {
      events.add(
        new LogEvent__c(
          Log_Data__c = event.Log_Message__c,
          Quiddity__c = event.Quiddity__c,
          Request_Id__c = event.Request_Id__c,
          Severity__c = event.Severity__c
        )
      );
    }

    List<Database.SaveResult> res = Database.insert(events, false);
    for (Database.SaveResult saveRes : res) {
      if (!saveRes.isSuccess()) {
        System.debug(
          LoggingLevel.ERROR,
          'Failed to save log message: ' + saveRes
        );
      }
    }
  }
}