trigger CampxSponsorTrigger on CAMPX__Sponsor__c (before insert, before update, after insert, after update) {
    
    //Fires before insert or update methods
    if(trigger.isBefore) {
        if(trigger.isInsert) CampxSponsorTriggerHandler.beforeInsert(trigger.new);
        if(trigger.isUpdate) CampxSponsorTriggerHandler.beforeUpdate(trigger.newMap, trigger.oldMap);
    }
    
    //Fires after insert or update methods
    if(trigger.isAfter) {
        if(trigger.isInsert) CampxSponsorTriggerHandler.afterInsert(trigger.new);
        if(trigger.isUpdate) CampxSponsorTriggerHandler.afterUpdate(trigger.new, trigger.old);
    }
}