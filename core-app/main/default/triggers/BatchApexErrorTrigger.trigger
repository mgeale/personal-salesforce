trigger BatchApexErrorTrigger on BatchApexErrorEvent(after insert) {
    new BatchApexErrorTriggerHandler().run();
}
