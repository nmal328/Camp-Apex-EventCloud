public class CampxSponsorTriggerHandler {
    
    //Handles before insert operations 
    public static void beforeInsert(List<CAMPX__Sponsor__c> newSponsors) {
    	List<CAMPX__Sponsor__c> nullStatusList = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Sponsor__c> emailErrorList = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Sponsor__c> eventErrorList = new List<CAMPX__Sponsor__c>();
        for(CAMPX__Sponsor__c sponsor : newSponsors) {
            if(sponsor.CAMPX__Status__c == null) nullStatusList.add(sponsor);
            if(sponsor.CAMPX__Email__c == null) emailErrorList.add(sponsor);
            if(sponsor.CAMPX__Event__c == null && sponsor.CAMPX__Status__c == 'Accepted') eventErrorList.add(sponsor);
        }
    	//User Story 3
        SponsorFieldUpdateLogic.nullStatusBeforeInsert(nullStatusList);
        //User Story 4
        SponsorErrorLogic.nullEmailError(emailErrorList);
        //User Story 5 inserts
        SponsorFieldUpdateLogic.contributionAmountBeforeInsert(newSponsors);
        //User Story 6 inserts
        SponsorErrorLogic.nullEventErrorBeforeInsert(eventErrorList);
    }
    
    //Handles before update operations
    public static void beforeUpdate(Map<Id, CAMPX__Sponsor__c> newSponsorMap, Map<Id, CAMPX__Sponsor__c> oldSponsorMap) {
        List<CAMPX__Sponsor__c> contributionChangeSponsors = new List<CAMPX__Sponsor__c>();
        List<CAMPX__Sponsor__c> throwErrorSponsors = new List<CAMPX__Sponsor__c>();
        for(CAMPX__Sponsor__c newSponsor : newSponsorMap.values()) {
            CAMPX__Sponsor__c oldSponsor = oldSponsorMap.get(newSponsor.Id);
            
            //User Story 5 updates
            //
            if(newSponsor.CAMPX__ContributionAmount__c != oldSponsor.CAMPX__ContributionAmount__c) contributionChangeSponsors.add(newSponsor);
            
            //User Story 6 updates
            if(newSponsor.CAMPX__Status__c == 'Accepted' && oldSponsor.CAMPX__Status__c != 'Accepted' &&
               newSponsor.CAMPX__Event__c == null) throwErrorSponsors.add(newSponsor);
        }
        
        if(!contributionChangeSponsors.isEmpty()) SponsorFieldUpdateLogic.contributionAmountBeforeInsert(contributionChangeSponsors);
        if(!throwErrorSponsors.isEmpty()) SponsorErrorLogic.nullEventErrorBeforeInsert(throwErrorSponsors);
    }
    
    //Handles after insert operations
    public void afterInsert(List<CAMPX__Sponsor__c> newSponsors) {
        
        //User Story 7 inserts
        SponsorFieldUpdateLogic.eventRevenueUpdateAfterInsert(newSponsors);
    }
    
    //Handles after update operations
    public static void afterUpdate(List<CAMPX__Sponsor__c> newSponsors, List<CAMPX__Sponsor__c> oldSponsors) {
        Map<Id, Decimal> eventRevenueAdjustments = new Map<Id, Decimal>();
        for(Integer i = 0; i < newSponsors.size(); i++) {
            //User Story 7 updates
            if(newSponsors[i].CAMPX__Status__c == 'Accepted' && oldSponsors[i].CAMPX__Status__c != 'Accepted') {
                Decimal contribution = newSponsors[i].CAMPX__ContributionAmount__c;
                Id eventId = newSponsors[i].CAMPX__Event__c;
                if(!eventRevenueAdjustments.containsKey(eventId)) {
                    eventRevenueAdjustments.put(eventId, 0);
                }
             	eventRevenueAdjustments.put(eventId, eventRevenueAdjustments.get(eventId) + contribution);
            }
            else if((newSponsors[i].CAMPX__Status__c != 'Accepted' && oldSponsors[i].CAMPX__Status__c == 'Accepted') || (newSponsors[i].CAMPX__Event__c == null && oldSponsors[i].CAMPX__Event__c != null)) {
                Decimal deduction = oldSponsors[i].CAMPX__ContributionAmount__c;
                Id eventId = oldSponsors[i].CAMPX__Event__c;
                if(!eventRevenueAdjustments.containsKey(eventId)) {
                    eventRevenueAdjustments.put(eventId, 0);
                }
                eventRevenueAdjustments.put(eventId, eventRevenueAdjustments.get(eventId) - deduction);
            }
        }
        if(!eventRevenueAdjustments.isEmpty()) {
            List<CAMPX__Event__c> eventsToUpdate = [
                SELECT Id, CAMPX__GrossRevenue__c
                FROM CAMPX__Event__c
                WHERE Id in :eventRevenueAdjustments.keySet()
            ];
            for(CAMPX__Event__c event : eventsToUpdate) {
                Decimal adjustment = eventRevenueAdjustments.get(event.Id);
                if(event.CAMPX__GrossRevenue__c == null) event.CAMPX__GrossRevenue__c = 0;
                event.CAMPX__GrossRevenue__c += adjustment;
            }
            update eventsToUpdate;
        }
        //User Story 8 updates
        
    }
}