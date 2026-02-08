@IsTest
private class SponsorErrorLogicTest {
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
}