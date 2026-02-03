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
}