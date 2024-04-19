public class StravaAPIController implements Queueable {

    private String stravaAthleteId;

    public StravaAPIController(String stravaAthleteId) {
        this.stravaAthleteId = stravaAthleteId;
    }

    public void execute(QueueableContext context) {
        makeStravaAPICall(stravaAthleteId);
    }

    public void makeStravaAPICall(String stravaAthleteId) {
        Map<String, Object> data;
        try {


            // Get Custom Metadata containing refresh token parameters

            Strava_Refresh_Token__mdt stravaRefreshTokenConfig = Strava_Refresh_Token__mdt.getInstance('m00av000001MYVVAA4');

            // Get the access token

            String CLIENT_ID = stravaRefreshTokenConfig.client_id__c;
            String CLIENT_SECRET = stravaRefreshTokenConfig.client_secret__c;
            String GRANT_TYPE = stravaRefreshTokenConfig.grant_type__c;
            String REFRESH_TOKEN = stravaRefreshTokenConfig.refresh_token__c;

            String endpoint = 'https://www.strava.com/api/v3/oauth/token' + '?client_id=' + CLIENT_ID + '&client_secret=' + CLIENT_SECRET + '&grant_type=' + GRANT_TYPE + '&refresh_token=' + REFRESH_TOKEN;

            Http http = new Http();
            HttpRequest refreshReq = new HttpRequest();
            refreshReq.setEndpoint(endpoint);
            refreshReq.setMethod('POST');

            HttpResponse tokenRes = http.send(refreshReq);

            System.debug(tokenRes.getBody());

            Map<String, Object> tokenData = (Map<String, Object>) JSON.deserializeUntyped(tokenRes.getBody());

            String accessToken;
            if (tokenData.containsKey('access_token')) {
                accessToken = (String) tokenData.get('access_token');
            }

            System.debug('Access Token: ' + accessToken);


            for (Account acc : AccountFromSF) {
                
            }

            /* String accessToken = '1ad7ad8ef71688d737f96122192923dbb553a271'; */ 	
            String athleteEndpoint = 'https://www.strava.com/api/v3/athletes/' + stravaAthleteId + '/stats'; 
            HttpRequest athleteReq = new HttpRequest();
            athleteReq.setEndpoint(athleteEndpoint);
            athleteReq.setMethod('GET');
            athleteReq.setHeader('Authorization', 'Bearer ' + accessToken); // Include the access token in the request headers
    
            Http httpToken = new Http();
            HttpResponse res = httpToken.send(athleteReq);

            // Make the API call





            // HttpRequest req = new HttpRequest();
            // String endpoint = 'callout:Strava_Named_Credential/athletes/' + stravaAthleteId + '/stats';        
            // req.setEndpoint(endpoint);
            // req.setHeader('Authorization', 'Bearer ' + accessToken); // Include the access token in the request headers
            // req.setMethod('GET');
        
            // Http http = new Http();
            // HttpResponse res = http.send(req);
        
            if (res.getStatusCode() == 200) {
                String responseBody = res.getBody();
                System.debug('Response Body: ' + responseBody);
        
                // Parse the JSON response
                data = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            } else {
                System.debug('HTTP response status: ' + res.getStatusCode());
                System.debug('HTTP response body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception during callout: ' + e.getMessage());
        }

        if (data != null) {
            // Query the athlete record
            Id sfAthleteId = 'a00av000000w6jTAAQ'; // replace with your actual Salesforce athlete Id
            Athlete__c athlete = [SELECT Id, Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c FROM Athlete__c WHERE Id = :sfAthleteId LIMIT 1];
    
            // Debug the athlete record before updating
            System.debug('Athlete record before update: ' + athlete);

            // Assign the values to the custom fields
            Map<String, Object> recentRideTotals = (Map<String, Object>) data.get('recent_ride_totals');
            athlete.Recent_Ride_Count__c = (Decimal) recentRideTotals.get('count');
            athlete.Recent_Ride_Distance__c = (Decimal) recentRideTotals.get('distance');
            athlete.Recent_Ride_Moving_Time__c = (Decimal) recentRideTotals.get('moving_time');
            athlete.Recent_Ride_Elapsed_Time__c = (Decimal) recentRideTotals.get('elapsed_time');
            athlete.Recent_Ride_Elevation_Gain__c = (Decimal) recentRideTotals.get('elevation_gain');
            athlete.Recent_Ride_Achievement_Count__c = (Decimal) recentRideTotals.get('achievement_count');

            Map<String, Object> allRideTotals = (Map<String, Object>) data.get('all_ride_totals');
            athlete.All_Ride_Count__c = (Decimal) allRideTotals.get('count');
            athlete.All_Ride_Distance__c = (Decimal) allRideTotals.get('distance');
            athlete.All_Ride_Moving_Time__c = (Decimal) allRideTotals.get('moving_time');
            athlete.All_Ride_Elapsed_Time__c = (Decimal) allRideTotals.get('elapsed_time');
            athlete.All_Ride_Elevation_Gain__c = (Decimal) allRideTotals.get('elevation_gain');

            athlete.Biggest_Ride_Distance__c = (Decimal) data.get('biggest_ride_distance');
            athlete.Biggest_Climb_Elevation_Gain__c = (Decimal) data.get('biggest_climb_elevation_gain');

            // Update the record
            update athlete;

            // Query the athlete record after updating
            Athlete__c updatedAthlete = [SELECT Id, Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c FROM Athlete__c WHERE Id = :sfAthleteId LIMIT 1];

            // Debug the athlete record after updating
            System.debug('Athlete record after update: ' + updatedAthlete);
        } else {
            System.debug('Failed to make Strava API call.');
        }
    }
}