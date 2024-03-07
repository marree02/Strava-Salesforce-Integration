@IsTest
private class StravaTokenRefresherTest {
    @IsTest
    static void testRefreshTokenAndGetAthleteIds() {
        // Create a mock HTTP response with a valid access token
        HttpResponse mockResponse = new HttpResponse();
        mockResponse.setStatusCode(200);
        mockResponse.setBody('{"access_token": "mockAccessToken"}');

        // Create a mock HTTP callout and associate it with the mock response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator(mockResponse));

        // Create test data
        Athlete__c athlete = new Athlete__c();
        athlete.Name = 'Test Athlete';
        // Set other required fields

        // Insert the test data
        insert athlete;

        // Call the method under test
        StravaTokenRefresher refresher = new StravaTokenRefresher();
        String accessToken = refresher.refreshTokenAndGetAthleteIds();

        // Verify the results
        System.assertEquals('mockAccessToken', accessToken);

        // Retrieve the updated athlete record
        Athlete__c updatedAthlete = [SELECT
            Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c, Recent_Ride_Count__c, Recent_Ride_Distance__c,
            Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c,
            Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c,
            All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Recent_Run_Count__c, Recent_Run_Distance__c,
            Recent_Run_Moving_Time__c, Recent_Run_Elapsed_Time__c, Recent_Run_Elevation_Gain__c
        FROM Athlete__c WHERE Id = :athlete.Id];

        // Verify the updated fields
        System.assertEquals(100.0, updatedAthlete.Biggest_Ride_Distance__c);
        System.assertEquals(200.0, updatedAthlete.Biggest_Climb_Elevation_Gain__c);
        // Verify other updated fields
    }

    // Helper class to generate mock HTTP responses
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        private HttpResponse response;

        public MockHttpResponseGenerator(HttpResponse response) {
            this.response = response;
        }

        public HttpResponse respond(HttpRequest request) {
            return response;
        }
    }
}