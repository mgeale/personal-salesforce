public without sharing class BatchApexErrorTriggerHandler extends TriggerHandler {
    BatchApexErrorEvent[] incomingRecords = new List<BatchApexErrorEvent>{};

    public BatchApexErrorTriggerHandler() {
        this.incomingRecords = (BatchApexErrorEvent[]) Trigger.new;
    }

    override public void afterInsert() {
        LogEventService.create(this.incomingRecords);
    }
}
