@IsTest
private class SponsorLogicTest {
    @TestSetup
    static void setup() {
        CAMPX__Sponsor__c testSponsor = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor Update Error',
            CAMPX__Email__c = 'Test@Test.com',
            CAMPX__Status__c = 'Pending',
            CAMPX__Event__c = null
        );
        insert testSponsor;
    }
    @IsTest
    static void nullStatusTest(){
        CAMPX__Sponsor__c testSponsor = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor',
            CAMPX__Status__c = null,
            CAMPX__Email__c = 'test@test.com'
        );
        
        Test.startTest();
        insert testSponsor;
        Test.stopTest();
        
        CAMPX__Sponsor__c insertedSponsor = [
            SELECT Id, Name, CAMPX__Status__c
            FROM CAMPX__Sponsor__c
            WHERE Id = :testSponsor.Id
        ];
        
        System.assertEquals('Pending', insertedSponsor.CAMPX__Status__c, 'When a Sponsor is inserted with a null status, it get\'s changed to Pending');
    }
    @IsTest
    //This should really be in its own test class
    static void nullEmailTest() {
        CAMPX__Sponsor__c testSponsor = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor',
            CAMPX__Status__c = 'Pending'
        );
        
        Test.startTest();
        Try {
            insert testSponsor;
        } catch (Exception e) {
            system.assertEquals(true, e.getMessage().contains('A sponsor can not be created without an email address'), 'Error is successfully thrown');
        }
    }
    @IsTest
    static void contributionAmountTest() {
        CAMPX__Sponsor__c nullTier = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor',
            CAMPX__Status__c = 'Pending',
            CAMPX__Email__c = 'test@test.com',
            CAMPX__ContributionAmount__c = null
        );
        
        CAMPX__Sponsor__c bronzeTier = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor',
            CAMPX__Status__c = 'Pending',
            CAMPX__Email__c = 'test@test.com',
            CAMPX__ContributionAmount__c = 750
        );
        
        CAMPX__Sponsor__c silverTier = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor',
            CAMPX__Status__c = 'Pending',
            CAMPX__Email__c = 'test@test.com',
            CAMPX__ContributionAmount__c = 2500
        );
        
        CAMPX__Sponsor__c goldTier = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor',
            CAMPX__Status__c = 'Pending',
            CAMPX__Email__c = 'test@test.com',
            CAMPX__ContributionAmount__c = 5500
        );
        
        Test.startTest();
        insert new List<CAMPX__Sponsor__c>{nullTier, bronzeTier, silverTier, goldTier};
        Test.stopTest();
        
        CAMPX__Sponsor__c nullTierUpdated = [
            SELECT Id, CAMPX__Tier__c
            FROM CAMPX__Sponsor__c
            WHERE Id = :nullTier.Id
        ];
        CAMPX__Sponsor__c bronzeTierUpdated = [
            SELECT Id, CAMPX__Tier__c
            FROM CAMPX__Sponsor__c
            WHERE Id = :bronzeTier.Id
        ];
        CAMPX__Sponsor__c silverTierUpdated = [
            SELECT Id, CAMPX__Tier__c
            FROM CAMPX__Sponsor__c
            WHERE Id = :silverTier.Id
        ];
        CAMPX__Sponsor__c goldTierUpdated = [
            SELECT Id, CAMPX__Tier__c
            FROM CAMPX__Sponsor__c
            WHERE Id = :goldTier.Id
        ];
        
        System.assertEquals(null, nullTierUpdated.CAMPX__Tier__c, 'Null contribution amount means a null tier');
        System.assertEquals('Bronze', bronzeTierUpdated.CAMPX__Tier__c, 'A 750 contribution amount will mean a Bronze tier');
		System.assertEquals('Silver', silverTierUpdated.CAMPX__Tier__c, 'A 2500 contribution amount will mean a Silver tier');        
        System.assertEquals('Gold', goldTierUpdated.CAMPX__Tier__c, 'A 5500 contribution amount will mean a Gold tier');
    }
    @IsTest
    //This should really be in its own test class
    static void nullEventTest() {
        CAMPX__Sponsor__c nullEvent = new CAMPX__Sponsor__c(
        	Name = 'Test Sponsor',
            CAMPX__Status__c = 'Accepted',
            CAMPX__Email__c = 'test@test.com',
            CAMPX__Event__c = null
        );
        
        Test.startTest();
        Try {
            insert nullEvent;
        } Catch(Exception e) {
            System.debug(e.getMessage());
            System.assertEquals(true, e.getMessage().contains('A Sponsor must be associated with an event before being Accepted.'), 'Error is successfully thrown');
        }
        Test.stopTest();
    }
    @IsTest
    //This should really be in its own test class
    static void sponsorStatusUpdateErrorTest() {
        CAMPX__Sponsor__c testSponsor = [
            SELECT Id, CAMPX__Status__c, Name
            FROM CAMPX__Sponsor__c
            WHERE Name = 'Test Sponsor Update Error'
        ];
        
        Test.startTest();
        testSponsor.CAMPX__Status__c = 'Accepted';
        try {
            update testSponsor;
        } catch(Exception e) {
            System.assertEquals(true, e.getMessage().contains('A Sponsor must be associated with an event before being Accepted.'), 'Error is successfully thrown');
        }
        Test.stopTest();
    }
    @IsTest
    static void sponsorContributionAmountUpdateTest() {
        CAMPX__Sponsor__c testSponsor = [
            SELECT Id, CAMPX__Status__c, Name, CAMPX__Tier__c
            FROM CAMPX__Sponsor__c
            WHERE Name = 'Test Sponsor Update Error'
        ]; 
        
        testSponsor.CAMPX__ContributionAmount__c = 5001;
        
        Test.startTest();
        update testSponsor;
        Test.stopTest();
        
        CAMPX__Sponsor__c tierSponsorUpdate = [
            SELECT Id, CAMPX__Status__c, CAMPX__Tier__c
            FROM CAMPX__Sponsor__c
            WHERE Id = :testSponsor.Id
        ];
        
        System.assertEquals(true, tierSponsorUpdate.CAMPX__Tier__c == 'Gold', 'A Contribution Amount change to 5001 results in a Tier change to Gold');
    }
}