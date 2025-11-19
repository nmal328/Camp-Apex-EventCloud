public class CampxEventTriggerHandler {
	
    //Handles before insert operations
    public void beforeInsert(List<CAMPX__Event__c> newEvents) {
        
        for (CAMPX__Event__c event : newEvents) {
            event.CAMPX__Status__c = 'Planning';
            event.CAMPX__StatusChangeDate__c = DateTime.now();
            if(event.CAMPX__GrossRevenue__c != null || event.CAMPX__TotalExpenses__c != null) event.CAMPX__NetRevenue__c = event.CAMPX__GrossRevenue__c - event.CAMPX__TotalExpenses__c;
            else event.CAMPX__NetRevenue__c = null;
        }
    }
    
    //Handles before update operations
    public void beforeUpdate(List<CAMPX__Event__c> newEvents, List<CAMPX__Event__c> oldEvents) {
        
        for (Integer i = 0; i < newEvents.size(); i++) {
            if (newEvents[i].CAMPX__Status__c != oldEvents[i].CAMPX__Status__c) {
                newEvents[i].CAMPX__StatusChangeDate__c = DateTime.now();
            }
            if (newEvents[i].CAMPX__GrossRevenue__c != null && newEvents[i].CAMPX__TotalExpenses__c != null && (newEvents[i].CAMPX__GrossRevenue__c != oldEvents[i].CAMPX__GrossRevenue__c || newEvents[i].CAMPX__TotalExpenses__c != oldEvents[i].CAMPX__TotalExpenses__c)) newEvents[i].CAMPX__NetRevenue__c = newEvents[i].CAMPX__GrossRevenue__c - newEvents[i].CAMPX__TotalExpenses__c;
            else if((newEvents[i].CAMPX__GrossRevenue__c == null || newEvents[i].CAMPX__TotalExpenses__c == null) && (newEvents[i].CAMPX__GrossRevenue__c != oldEvents[i].CAMPX__GrossRevenue__c || newEvents[i].CAMPX__TotalExpenses__c != oldEvents[i].CAMPX__TotalExpenses__c)) newEvents[i].CAMPX__NetRevenue__c = null;
        }
    }
    
    //Handles after insert operations
    public void afterInsert(List<CAMPX__Event__c> newEvents) {
        //logic here
    }
                             
    //Handles after update operations
    public void afterUpdate(List<CAMPX__Event__c> newEvents, List<CAMPX__Event__c> oldEvents) {
        //logic here
    }
}