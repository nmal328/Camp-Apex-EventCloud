trigger CampxEventTrigger on CAMPX__Event__c (before insert, before update, after insert, after update) {

    //Fires before insert or update methods
    if (Trigger.isBefore) {
        if (Trigger.isInsert) CampxEventTriggerHandler.beforeInsert(Trigger.new);
        if (Trigger.isUpdate) CampxEventTriggerHandler.beforeUpdate((Map<Id, CAMPX__Event__c>) Trigger.newMap, (Map<Id, CAMPX__Event__c>) Trigger.oldMap);
    }
    
    //Fires after insert or update methods
    if (Trigger.isAfter) {
        if (Trigger.isInsert) CampxEventTriggerHandler.afterInsert(Trigger.new);
        if (Trigger.isUpdate) CampxEventTriggerHandler.afterUpdate(Trigger.new, Trigger.old);
    }
}