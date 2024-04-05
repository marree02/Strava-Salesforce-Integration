public class StravaAPIController implements Queueable {

    public void execute(QueueableContext context) {
        makeStravaAPICall();
    }

    @future(callout=true)
    public static void makeStravaAPICall() {
        String CLIENT_ID = '130827242';
        String accessToken = '1ad7ad8ef71688d737f96122192923dbb553a271'; 	
        String endpoint = 'https://www.strava.com/api/v3/athletes/' + CLIENT_ID + '/stats'; 
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + accessToken); // Include the access token in the request headers

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            String responseBody = res.getBody();
            System.debug('Response Body: ' + responseBody);

            // Parse the JSON response
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(responseBody);

            // Create a new Athlete__c record
           Athlete__c athlete = [SELECT Id, Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c FROM Athlete__c WHERE Id = :targetId LIMIT 1];


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

            // Insert the new record
            update athlete;

            // Print the JSON response in the Apex log
            System.debug(JSON.serializePretty(JSON.deserializeUntyped(responseBody)));
        } else {
            System.debug('Failed to make Strava API call. Status code: ' + res.getStatusCode());
            System.debug('Response: ' + res.getBody());
        }
    }
}