public with sharing class StravaTokenRefresher {

    public void refreshTokenAndGetAthleteIds() {
        
        String CLIENT_ID = '130827242';
        String CLIENT_SECRET = '525ede17509bf58c1df9147a90abe1a31cfa6c41';
        String ACCESS_TOKEN = '5860cb46f28b228b0cdb574f8e3233076ebcc44b';
     
        List<Athlete__c> athletes = [SELECT Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c, Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Recent_Run_Count__c, Recent_Run_Distance__c, Recent_Run_Moving_Time__c, Recent_Run_Elapsed_Time__c, Recent_Run_Elevation_Gain__c FROM Athlete__c];
        List<Athlete__c> updatedAthletes = new List<Athlete__c>();

        for (Athlete__c athlete : athletes) {
            // Make a callout to the Strava API using the provided access token
            HttpRequest athleteReq = new HttpRequest();
            athleteReq.setEndpoint('https://www.strava.com/api/v3/athletes/' + CLIENT_ID + '/stats');
            athleteReq.setMethod('GET');
            athleteReq.setHeader('Authorization', 'Bearer ' + ACCESS_TOKEN);

            Http athleteHttp = new Http();
            HttpResponse athleteRes = athleteHttp.send(athleteReq);
            
            if (athleteRes.getStatusCode() == 200) {
                String responseBody = athleteRes.getBody();
                System.debug(responseBody);
                
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                athlete.Biggest_Ride_Distance__c = (Decimal) results.get('biggest_ride_distance');
                athlete.Biggest_Climb_Elevation_Gain__c = (Decimal) results.get('biggest_climb_elevation_gain');
                athlete.Recent_Ride_Count__c = (Integer) results.get('recent_ride_count');
                athlete.Recent_Ride_Distance__c = (Decimal) results.get('recent_ride_distance');
                athlete.Recent_Ride_Moving_Time__c = (Integer) results.get('recent_ride_moving_time');
                athlete.Recent_Ride_Elapsed_Time__c = (Integer) results.get('recent_ride_elapsed_time');
                athlete.Recent_Ride_Elevation_Gain__c = (Decimal) results.get('recent_ride_elevation_gain');
                athlete.Recent_Ride_Achievement_Count__c = (Integer) results.get('recent_ride_achievement_count');
                athlete.All_Ride_Count__c = (Integer) results.get('all_ride_count');
                athlete.All_Ride_Distance__c = (Decimal) results.get('all_ride_distance');
                athlete.All_Ride_Moving_Time__c = (Integer) results.get('all_ride_moving_time');
                athlete.All_Ride_Elapsed_Time__c = (Integer) results.get('all_ride_elapsed_time');
                athlete.All_Ride_Elevation_Gain__c = (Decimal) results.get('all_ride_elevation_gain');
                athlete.Recent_Run_Count__c = (Integer) results.get('recent_run_count');
                athlete.Recent_Run_Distance__c = (Decimal) results.get('recent_run_distance');
                athlete.Recent_Run_Moving_Time__c = (Integer) results.get('recent_run_moving_time');
                athlete.Recent_Run_Elapsed_Time__c = (Integer) results.get('recent_run_elapsed_time');
                athlete.Recent_Run_Elevation_Gain__c = (Decimal) results.get('recent_run_elevation_gain');
                updatedAthletes.add(athlete);
            } else {
                // Handle API callout error
                System.debug('API Callout failed with status code ' + athleteRes.getStatusCode());
            }
        }
        if (!updatedAthletes.isEmpty()) {
            upsert updatedAthletes;
        }
    } 
}
