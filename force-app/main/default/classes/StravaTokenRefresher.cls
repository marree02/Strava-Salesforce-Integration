public class StravaTokenRefresher {
    
    private static final String CLIENT_ID = '120708';
    private static final String CLIENT_SECRET = '525ede17509bf58c1df9147a90abe1a31cfa6c41';
    private static final String REFRESH_TOKEN = 'bd412c1102d7ebb7ee46fece05c97f628b16d84e';
    
    public static void fetchAndUpdateAthleteIds() {
        // Get all Athlete__c records that don't have the Strava Athlete Id field populated
        List<Athlete__c> athletes = [SELECT Id FROM Athlete__c WHERE Strava_Athlete_Id__c = NULL];
        
        // List to store updated athletes
        List<Athlete__c> updatedAthletes = new List<Athlete__c>();
        
        // Get the access token
        String accessToken = getAccessToken();
        
        if (String.isNotBlank(accessToken)) {
            for (Athlete__c athlete : athletes) {
                // Make a callout to the Strava API to fetch the athlete's ID
                HttpRequest req = new HttpRequest();
                req.setEndpoint('callout:Strava_Named_Credential/api/v3/athlete');
                req.setMethod('GET');
                
                // Add the access token to the request headers
                req.setHeader('Authorization', 'Bearer ' + accessToken);
                
                Http http = new Http();
                HttpResponse res = http.send(req);
                
                if (res.getStatusCode() == 200) {
                    // Parse the response and get the athlete's ID
                    Map<String, Object> athleteData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                    String stravaAthleteId = String.valueOf(athleteData.get('id'));
                    
                    // Update the Strava Athlete Id field for the current record
                    athlete.Strava_Athlete_Id__c = stravaAthleteId;
                    updatedAthletes.add(athlete);
                } else {
                    // Handle API callout error
                    System.debug('API Callout failed with status code ' + res.getStatusCode() + ' for athlete with ID: ' + athlete.Id);
                }
            }
            
            // Update the records in Salesforce
            if (!updatedAthletes.isEmpty()) {
                update updatedAthletes;
            }
        } else {
            System.debug('Failed to obtain access token from Strava.');
        }
    }
    
    private static String getAccessToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://www.strava.com/oauth/token');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        String requestBody = '{"client_id": "' + CLIENT_ID + '", "client_secret": "' + CLIENT_SECRET + '", "grant_type": "refresh_token", "refresh_token": "' + REFRESH_TOKEN + '"}';
        req.setBody(requestBody);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> tokenData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) tokenData.get('access_token');
            return accessToken;
        } else {
            System.debug('Failed to refresh access token. Status code: ' + res.getStatusCode());
            return null;
        }
    }
}