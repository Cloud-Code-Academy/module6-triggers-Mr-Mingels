trigger AccountTrigger on Account (before insert, after insert) {

    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.beforeInsertHandler(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isInsert) {
        AccountTriggerHandler.afterInsertHandler(Trigger.new);
    }
    
}