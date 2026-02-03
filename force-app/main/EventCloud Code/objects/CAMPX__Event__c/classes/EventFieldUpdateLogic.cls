public class EventFieldUpdateLogic {
    public static void StatusSetBefore(List<CAMPX__Event__c> newEvents) {

        for(CAMPX__Event__c event : newEvents) {
            //User Story 1
            event.CAMPX__Status__c = 'Planning';
        }
    }
    public static void StatusChangeSetBefore(List<CAMPX__Event__c> newEvents) {

        for(CAMPX__Event__c event : newEvents) {
            //User Story 2 Inerts
            event.CAMPX__StatusChangeDate__c = DateTime.now();
        }
    }
    public static void EventRevenueSetBefore(List<CAMPX__Event__c> newEvents) {

        for(CAMPX__Event__c event : newEvents) {
            //User Story 7 Inserts
            event.CAMPX__NetRevenue__c = event.CAMPX__GrossRevenue__c - event.CAMPX__TotalExpenses__c;
        }
    }
    //Keeping After methods in case the need arises
    /*public static void StatusSetAfter(List<CAMPX__Event__c> newEvents) {
        List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();
        for(CAMPX__Event__c event : newEvents) {
            //User Story 1
            event.CAMPX__Status__c = 'Planning';
            eventsToUpdate.add(event);
        }
        if(!eventsToUpdate.isEmpty()) {
            update eventsToUpdate;
        }
    }
    public static void StatusChangeSetAfter(List<CAMPX__Event__c> newEvents) {
        List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();
        for(CAMPX__Event__c event : newEvents) {
            //User Story 2 Inerts
            event.CAMPX__StatusChangeDate__c = DateTime.now();
            eventsToUpdate.add(event);
        }
        if(!eventsToUpdate.isEmpty()) {
            update eventsToUpdate;
        }
    }
    public static void EventRevenueSetAfter(List<CAMPX__Event__c> newEvents) {
        List<CAMPX__Event__c> eventsToUpdate = new List<CAMPX__Event__c>();
        for(CAMPX__Event__c event : newEvents) {
            //User Story 7 Inserts
            event.CAMPX__NetRevenue__c = event.CAMPX__GrossRevenue__c - event.CAMPX__TotalExpenses__c;
            eventsToUpdate.add(event);
        }
        if(!eventsToUpdate.isEmpty()) {
            update eventsToUpdate;
        }
    }*/
}