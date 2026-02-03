trigger CampxEventTrigger on CAMPX__Event__c (before insert, before update) {

    //Fires before insert or update methods
    if (Trigger.isInsert) CampxEventTriggerHandler.beforeInsert(Trigger.new);
    if (Trigger.isUpdate) CampxEventTriggerHandler.beforeUpdate((Map<Id, CAMPX__Event__c>) Trigger.newMap, (Map<Id, CAMPX__Event__c>) Trigger.oldMap);
}