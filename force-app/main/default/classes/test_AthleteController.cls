@IsTest
private class AthleteControllerTest {
    @IsTest
    static void testGetAthletes() {
        // Create test data
        Athlete__c athlete1 = new Athlete__c();
        athlete1.Name = 'Test Athlete 1';
        // Set other required fields

        Athlete__c athlete2 = new Athlete__c();
        athlete2.Name = 'Test Athlete 2';
        // Set other required fields

        List<Athlete__c> athletes = new List<Athlete__c>{athlete1, athlete2};
        insert athletes;

        // Call the method under test
        List<Athlete__c> result = AthleteController.getAthletes();

        // Verify the results
        System.assertEquals(2, result.size());
        // Verify other assertions
    }

    @IsTest
    static void testFetchAthleteStats() {
        // Create test data
        Athlete__c athlete1 = new Athlete__c();
        athlete1.Name = 'Test Athlete 1';
        // Set other required fields

        Athlete__c athlete2 = new Athlete__c();
        athlete2.Name = 'Test Athlete 2';
        // Set other required fields

        List<Athlete__c> athletes = new List<Athlete__c>{athlete1, athlete2};
        insert athletes;

        // Call the method under test
        Test.startTest();
        AthleteController.fetchAthleteStats(athletes);
        Test.stopTest();

        // Verify the results
        // Perform assertions to verify that the stats are updated correctly
    }

    @IsTest
    static void testInsertAthletes() {
        // Create test data
        Athlete__c athlete1 = new Athlete__c();
        athlete1.Name = 'Test Athlete 1';
        // Set other required fields

        Athlete__c athlete2 = new Athlete__c();
        athlete2.Name = 'Test Athlete 2';
        // Set other required fields

        List<Athlete__c> athletes = new List<Athlete__c>{athlete1, athlete2};

        // Call the method under test
        Test.startTest();
        AthleteController.insertAthletes(athletes);
        Test.stopTest();

        // Verify the results
        List<Athlete__c> insertedAthletes = [SELECT Id, Name FROM Athlete__c];
        System.assertEquals(2, insertedAthletes.size());
        // Verify other assertions
    }
}