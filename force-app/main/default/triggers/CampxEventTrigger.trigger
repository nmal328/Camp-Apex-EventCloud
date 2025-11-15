trigger CampxEventTrigger on CAMPX__Event__c (before insert, before update, after insert, after update) {
	CampxEventTriggerHandler handler = new CampxEventTriggerHandler();

    //Fires before insert or update methods
    if (Trigger.isBefore) {
        if (Trigger.isInsert) handler.beforeInsert(Trigger.new);
        if (Trigger.isUpdate) handler.beforeUpdate(Trigger.new, Trigger.old);
    }
    
    //Fires after insert or update methods
    if (Trigger.isAfter) {
        if (Trigger.isInsert) handler.afterInsert(Trigger.new);
        if (Trigger.isUpdate) handler.afterUpdate(Trigger.new, Trigger.old);
    }
}