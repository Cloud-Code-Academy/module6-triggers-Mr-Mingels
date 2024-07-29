trigger OpportunityTrigger on Opportunity (before update, before delete) {

    if (Trigger.isBefore && Trigger.isUpdate) {
        OpportunityTriggerHandler.beforeUpdateHandler(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isDelete) {
        OpportunityTriggerHandler.beforeDeleteHandler(Trigger.old);
    }

}