public class SponsorErrorLogic {
    public static void nullEmailError(List<CAMPX__Sponsor__c> newSponsors) {
        for (CAMPX__Sponsor__c sponsor : newSponsors) {
        	sponsor.addError('A sponsor can not be created without an email address');
        }
    }
    public static void nullEventErrorBeforeInsert(List<CAMPX__Sponsor__c> newSponsors) {
        for (CAMPX__Sponsor__c sponsor : newSponsors) {
        	sponsor.addError('A Sponsor must be associated with an event before being Accepted.');
        }
    }
}