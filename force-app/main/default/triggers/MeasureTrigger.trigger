trigger MeasureTrigger on Measure__c (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        MeasureTriggerHandler.beforeInsert(Trigger.new);
    }
}
