public class SponsorFieldUpdateLogic {
    public static void nullStatusBeforeInsert(List<CAMPX__Sponsor__c> newSponsors) {
        for(CAMPX__Sponsor__c sponsor : newSponsors) {
        	sponsor.CAMPX__Status__c = 'Pending';
        }
    }
    public static void contributionAmountBeforeInsert(List<CAMPX__Sponsor__c> newSponsors) {
        for(CAMPX__Sponsor__c sponsor : newSponsors) {
            sponsor.CAMPX__Tier__c = sponsor.CAMPX__ContributionAmount__c == null ? null :
            sponsor.CAMPX__ContributionAmount__c == 0 ? null :
            sponsor.CAMPX__ContributionAmount__c > 0 && sponsor.CAMPX__ContributionAmount__c < 1000 ? 'Bronze' :
            sponsor.CAMPX__ContributionAmount__c >= 1000 && sponsor.CAMPX__ContributionAmount__c < 5000 ? 'Silver' :
            'Gold';
        }
    }
    public static void eventRevenueUpdateAfterInsert(List<CAMPX__Sponsor__c> newSponsors) {
        Map<Id, Decimal> eventRevenueAdjustments = new Map<Id, Decimal>();
        
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

            if(!eventsToUpdate.isEmpty()) {
                update eventsToUpdate;
            }
        }
    }
    public static void eventRevenueUpdateAfterUpdate(Map<Id, CAMPX__Sponsor__c> newSponsorMap, Map<Id, CAMPX__Sponsor__c> oldSponsorMap) {
        Map<Id, Decimal> eventRevenueAdjustments = new Map<Id, Decimal>();
        for(CAMPX__Sponsor__c newSponsor : newSponsorMap) {
            CAMPX__Sponsor__c oldSponsor = oldSponsorMap.get(newSponsor.Id);
            //User Story 7 updates
            if(newSponsor.CAMPX__Status__c == 'Accepted' && oldSponsor.CAMPX__Status__c != 'Accepted') {
                Decimal contribution = newSponsor.CAMPX__ContributionAmount__c;
                Id eventId = newSponsor.CAMPX__Event__c;
                if(!eventRevenueAdjustments.containsKey(eventId)) {
                    eventRevenueAdjustments.put(eventId, 0);
                }
             	eventRevenueAdjustments.put(eventId, eventRevenueAdjustments.get(eventId) + contribution);
            }
            else if((newSponsor.CAMPX__Status__c != 'Accepted' && oldSponsor.CAMPX__Status__c == 'Accepted') || (newSponsor.CAMPX__Event__c == null && oldSponsor.CAMPX__Event__c != null)) {
                Decimal deduction = oldSponsor.CAMPX__ContributionAmount__c;
                Id eventId = oldSponsor.CAMPX__Event__c;
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
            if(!eventsToUpdate.isEmpty()) {
                update eventsToUpdate;
            }
        }
    }
}