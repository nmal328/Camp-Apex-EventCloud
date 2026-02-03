public class CampxEventTriggerHandler {
	
    //Handles before insert operations 
    public static void beforeInsert(List<CAMPX__Event__c> newEvents) {
        //User Story 1 and 2 Inserts
        EventFieldUpdateLogic.StatusSetBefore(newEvents);
        EventFieldUpdateLogic.StatusChangeSetBefore(newEvents);
                        
        //User Story 7 inserts
        List<CAMPX__Event__c> eventRevenueSetList = new List<CAMPX__Event__c>();
        for(CAMPX__Event__c event : newEvents) {
            if(event.CAMPX__GrossRevenue__c != null || event.CAMPX__TotalExpenses__c != null) {
                eventRevenueSetList.add(event);
            }
        }
        if(!eventRevenueSetList.isEmpty()) {
            EventFieldUpdateLogic.EventRevenueSetBefore(eventRevenueSetList);
        }
    }
    
    //Handles before update operations
    public static void beforeUpdate(Map<Id, CAMPX__Event__c> newEventMap, Map<Id, CAMPX__Event__c> oldEventMap) {
        List<CAMPX__Event__c> eventStatusChangeList = new List<CAMPX__Event__c>();
        List<CAMPX__Event__c> eventRevenueSetList = new List<CAMPX__Event__c>();
        for (CAMPX__Event__c newEvent : newEventMap.values()) {
            CAMPX__Event__c oldEvent = oldEventMap.get(newEvent.Id);
            //User Story 2 updates
            if (newEvent.CAMPX__Status__c != oldEvent.CAMPX__Status__c) {
                eventStatusChangeList.add(newEvent);
            }
            //User Story 7 updates
            if (newEvent.CAMPX__GrossRevenue__c != null &&
                newEvent.CAMPX__TotalExpenses__c != null &&
                (newEvent.CAMPX__GrossRevenue__c != oldEvent.CAMPX__GrossRevenue__c ||
                newEvent.CAMPX__TotalExpenses__c != oldEvent.CAMPX__TotalExpenses__c)) {
                    eventRevenueSetList.add(newEvent);
                }
            else if((newEvent.CAMPX__GrossRevenue__c == null ||
                    newEvent.CAMPX__TotalExpenses__c == null) &&
                    (newEvent.CAMPX__GrossRevenue__c != oldEvent.CAMPX__GrossRevenue__c ||
                    newEvent.CAMPX__TotalExpenses__c != oldEvent.CAMPX__TotalExpenses__c)) {
                        eventRevenueSetList.add(newEvent);
                    }
        }
        if(!eventStatusChangeList.isEmpty()) {
            EventFieldUpdateLogic.StatusChangeSetBefore(eventStatusChangeList);
        }
        if(!eventRevenueSetList.isEmpty()) {
            EventFieldUpdateLogic.EventRevenueSetBefore(eventRevenueSetList);
        }
    }
}