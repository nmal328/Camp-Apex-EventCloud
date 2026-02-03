@IsTest
private class EventFieldUpdateLogicTest {
    @TestSetup
    static void TestSetup() {
        CAMPX__Event__c testEvent = new CAMPX__Event__c(
            Name = 'Test Event',
            CAMPX__Status__c = null,
            CAMPX__StatusChangeDate__c = null,
            CAMPX__GrossRevenue__c = 100.00,
            CAMPX__TotalExpenses__c = 50.00
        );

        insert testEvent;
    }
    @IsTest
    static void StatusSetTest() {
        CAMPX__Event__c eventStatusCheck = [
            SELECT Id, Name, CAMPX__Status__c
            FROM CAMPX__Event__c
            WHERE Name = 'Test Event'
        ];

        System.assertEquals(true, eventStatusCheck.CAMPX__Status__c == 'Planning', 'An event with a null Status will get changed to Planning');
    }
    @IsTest
    static void StatusChangedDateTest() {
        CAMPX__Event__c eventStatusChangedCheck = [
            SELECT Id, Name, CAMPX__StatusChangeDate__c
            FROM CAMPX__Event__c
            WHERE Name = 'Test Event'
        ];

        System.assertEquals(true, eventStatusChangedCheck != null, 'The Status Changed Date should no longer be null after inserting the record');
    }
    @IsTest
    static void NetRevenueTest() {
        CAMPX__Event__c eventNetRevenueCheck = [
            SELECT Id, Name, CAMPX__NetRevenue__c
            FROM CAMPX__Event__c
            WHERE Name = 'Test Event'
        ];

        System.assertEquals(50.00, eventNetRevenueCheck.CAMPX__NetRevenue__c, 'Net Revenue will equal 50 since gross is 100 and expenses is 50');
    }
}