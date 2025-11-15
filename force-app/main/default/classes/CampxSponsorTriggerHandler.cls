public class CampxSponsorTriggerHandler {
    
    //Handles before insert operations 
    public void beforeInsert(List<CAMPX__Sponsor__c> newSponsors) {
        
        for (CAMPX__Sponsor__c sponsor : newSponsors) {
            //User Story 3
            if(sponsor.CAMPX__Status__c == null) {
                sponsor.CAMPX__Status__c = 'Pending';
            }
            //User Story 4
            if(sponsor.CAMPX__Email__c == null) {
            	sponsor.addError('A sponsor can not be created without an email address');
            }
            //User Story 5 inserts
            if(sponsor.CAMPX__ContributionAmount__c == null) sponsor.CAMPX__Tier__c = null;
            else if(sponsor.CAMPX__ContributionAmount__c == 0) sponsor.CAMPX__Tier__c = null;
            else if(sponsor.CAMPX__ContributionAmount__c > 0 && sponsor.CAMPX__ContributionAmount__c < 1000) sponsor.CAMPX__Tier__c = 'Bronze';
            else if(sponsor.CAMPX__ContributionAmount__c >= 1000 && sponsor.CAMPX__ContributionAmount__c < 5000) sponsor.CAMPX__Tier__c = 'Silver';
            else if(sponsor.CAMPX__ContributionAmount__c >= 5000) sponsor.CAMPX__Tier__c = 'Gold';
  			
            //User Story 6 inserts
            if(sponsor.CAMPX__Event__c == null && sponsor.CAMPX__Status__c == 'Accepted') sponsor.addError('A Sponsor must be associated with an event before being Accepted.');
        }
    }
    
    //Handles before update operations
    public void beforeUpdate(List<CAMPX__Sponsor__c> newSponsors, List<CAMPX__Sponsor__c> oldSponsors) {
        for(Integer i = 0; i < newSponsors.size(); i++) {
            
            //User Story 5 updates
            if(newSponsors[i].CAMPX__Tier__c != oldSponsors[i].CAMPX__Tier__c) {
                if(newSponsors[i].CAMPX__ContributionAmount__c == null) newSponsors[i].CAMPX__Tier__c = null;
                else if(newSponsors[i].CAMPX__ContributionAmount__c == 0) newSponsors[i].CAMPX__Tier__c = null;
                else if(newSponsors[i].CAMPX__ContributionAmount__c > 0 && newSponsors[i].CAMPX__ContributionAmount__c < 1000) newSponsors[i].CAMPX__Tier__c = 'Bronze';
                else if(newSponsors[i].CAMPX__ContributionAmount__c >= 1000 && newSponsors[i].CAMPX__ContributionAmount__c < 5000) newSponsors[i].CAMPX__Tier__c = 'Silver';
                else if(newSponsors[i].CAMPX__ContributionAmount__c >= 5000) newSponsors[i].CAMPX__Tier__c = 'Gold';
            }
            
            //User Story 6 updates
            if(newSponsors[i].CAMPX__Status__c == 'Accepted' && oldSponsors[i].CAMPX__Status__c != 'Accepted' && newSponsors[i].CAMPX__Event__c == null) newSponsors[i].addError('A Sponsor must be associated with an event before being Accepted.');
        }
    }
    
    //Handles after insert operations
    public void afterInsert(List<CAMPX__Sponsor__c> newSponsors) {
        Map<Id, Decimal> eventRevenueAdjustments = new Map<Id, Decimal>();
        //User Story 7 inserts
        for(CAMPX__Sponsor__c sponsor : newSponsors) {
            if(sponsor.CAMPX__Status__c == 'Accepted') {
                Decimal contribution = sponsor.CAMPX__ContributionAmount__c;
                Id eventId = sponsor.CAMPX__Event__c;
                if(!eventRevenueAdjustments.containsKey(eventId)) {
                    eventRevenueAdjustments.put(eventId, 0);
                }
                eventRevenueAdjustments.put(eventId, eventRevenueAdjustments.get(eventId) + contribution);
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
    }
    
    //Handles after update operations
    public void afterUpdate(List<CAMPX__Sponsor__c> newSponsors, List<CAMPX__Sponsor__c> oldSponsors) {
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