public class StravaTokenRefresher {


    public String refreshTokenAndGetAthleteIds() {
        
     String CLIENT_ID = '120708';
     String CLIENT_SECRET = '525ede17509bf58c1df9147a90abe1a31cfa6c41';
     String REFRESH_TOKEN = 'bd412c1102d7ebb7ee46fece05c97f628b16d84e';
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:Strava_Named_Credential/oauth/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        String requestBody = '{"client_id": "' + CLIENT_ID + '", "client_secret": "' + CLIENT_SECRET + '", "grant_type": "refresh_token", "refresh_token": "' + REFRESH_TOKEN + '"}';
        req.setBody(requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> tokenData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) tokenData.get('access_token');
            if (String.isNotBlank(accessToken)) {
                List<Athlete__c> athletes = [SELECT Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c, Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Recent_Run_Count__c, Recent_Run_Distance__c, Recent_Run_Moving_Time__c, Recent_Run_Elapsed_Time__c, Recent_Run_Elevation_Gain__c FROM Athlete__c];
                List<Athlete__c> updatedAthletes = new List<Athlete__c>();

                for (Athlete__c athlete : athletes) {
                    // Make a callout to the Strava API using the provided access token
                    HttpRequest athleteReq = new HttpRequest();
                    athleteReq.setEndpoint('callout:Strava_Named_Credential/api/v3/athletes/' + CLIENT_ID + '/stats');
                    athleteReq.setMethod('GET');
                    athleteReq.setHeader('Authorization', 'Bearer ' + accessToken);

                    Http athleteHttp = new Http();
                    HttpResponse athleteRes = athleteHttp.send(athleteReq);

                    if (athleteRes.getStatusCode() == 200) {
                        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(athleteRes.getBody());
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
                    update updatedAthletes;
                }
            } else {
                System.debug('Failed to obtain access token from Strava.');
            }
            return accessToken;
        } else {
            System.debug('Failed to refresh access token. Status code: ' + res.getStatusCode());
            return null;
        }
    }
}