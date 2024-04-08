@isTest(SeeAllData=true)
private class StravaAPITest {
    @isTest
    static void testStravaApiCallout() {
        // Set the mock callout class
        Test.setMock(HttpCalloutMock.class, new StravaHttpCalloutMock());

        // Query for the real Athlete__c record
        Athlete__c athlete = [SELECT Id FROM Athlete__c WHERE Name = 'a00av000000w6jT' LIMIT 1];
        System.assertNotEquals(null, athlete, 'Athlete record not found');

        // Enqueue the job
        Test.startTest();
        System.enqueueJob(new StravaAPIController(athlete.Id));
        Test.stopTest();

        // Query the updated Athlete__c record
        Athlete__c updatedAthlete = [SELECT Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c FROM Athlete__c WHERE Id = :athlete.Id];

        // Assert that the fields were updated correctly
        System.assertEquals(1, updatedAthlete.Recent_Ride_Count__c);
        System.assertEquals(9147.0888671875, updatedAthlete.Recent_Ride_Distance__c);
        System.assertEquals(1597, updatedAthlete.Recent_Ride_Moving_Time__c);
        System.assertEquals(2045, updatedAthlete.Recent_Ride_Elapsed_Time__c);
        System.assertEquals(68.18839263916016, updatedAthlete.Recent_Ride_Elevation_Gain__c);
        System.assertEquals(3, updatedAthlete.Recent_Ride_Achievement_Count__c);
        System.assertEquals(3, updatedAthlete.All_Ride_Count__c);
        System.assertEquals(28713, updatedAthlete.All_Ride_Distance__c);
        System.assertEquals(5052, updatedAthlete.All_Ride_Moving_Time__c);
        System.assertEquals(6230, updatedAthlete.All_Ride_Elapsed_Time__c);
        System.assertEquals(214, updatedAthlete.All_Ride_Elevation_Gain__c);
        System.assertEquals(11388.2, updatedAthlete.Biggest_Ride_Distance__c);
        System.assertEquals(null, updatedAthlete.Biggest_Climb_Elevation_Gain__c);
    }
}