trigger CampxSponsorTrigger on CAMPX__Sponsor__c (before insert, before update, after insert, after update) {
	CampxSponsorTriggerHandler handler = new CampxSponsorTriggerHandler();
    
    //Fires before insert or update methods
    if(trigger.isBefore) {
        if(trigger.isInsert) handler.beforeInsert(trigger.new);
        if(trigger.isUpdate) handler.beforeUpdate(trigger.new, trigger.old);
    }
    
    //Fires after insert or update methods
    if(trigger.isAfter) {
        if(trigger.isInsert) handler.afterInsert(trigger.new);
        if(trigger.isUpdate) handler.afterUpdate(trigger.new, trigger.old);
    }
}