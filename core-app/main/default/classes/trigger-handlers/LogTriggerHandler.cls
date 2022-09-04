public without sharing class LogTriggerHandler extends TriggerHandler {
    List<Log__e> incomingRecords = new List<Log__e>();

    public LogTriggerHandler() {
        this.incomingRecords = (List<Log__e>) Trigger.new;
    }

    override public void afterInsert() {
        LogEventService.create(this.incomingRecords);
    }
}
