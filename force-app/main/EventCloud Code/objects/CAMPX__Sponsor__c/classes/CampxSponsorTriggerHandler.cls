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
    public static void afterUpdate(Map<Id, CAMPX__Sponsor__c> newSponsorMap, Map<Id, CAMPX__Sponsor__c> oldSponsorMap) {
       
        //User Story 7 updates
        SponsorFieldUpdateLogic.eventRevenueUpdateAfterUpdate(newSponsorMap, oldSponsorMap);
    }
}