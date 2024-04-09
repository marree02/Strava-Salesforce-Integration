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
        System.assertEquals(2.00, updatedAthlete.Recent_Ride_Count__c);
        System.assertEquals(19566.3291015625, updatedAthlete.Recent_Ride_Distance__c);
        System.assertEquals(3455.00, updatedAthlete.Recent_Ride_Moving_Time__c);
        System.assertEquals(4185, updatedAthlete.Recent_Ride_Elapsed_Time__c);
        System.assertEquals(145.70810317993164, updatedAthlete.Recent_Ride_Elevation_Gain__c);
        System.assertEquals(0, updatedAthlete.Recent_Ride_Achievement_Count__c);
        System.assertEquals(2.00, updatedAthlete.All_Ride_Count__c);
        System.assertEquals(19566.00, updatedAthlete.All_Ride_Distance__c);
        System.assertEquals(3455, updatedAthlete.All_Ride_Moving_Time__c);
        System.assertEquals(4185, updatedAthlete.All_Ride_Elapsed_Time__c);
        System.assertEquals(146, updatedAthlete.All_Ride_Elevation_Gain__c);
        System.assertEquals(11388.2, updatedAthlete.Biggest_Ride_Distance__c);
        System.assertEquals(null, updatedAthlete.Biggest_Climb_Elevation_Gain__c);
    }
}