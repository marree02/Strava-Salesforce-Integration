public class AthletesApiExample {
    public void getStats() {
        for (Athlete__c athlete : Trigger.new) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Strava_Named_Credential/api/v3/athletes/' + athlete.Id + '/stats');
            req.setMethod('GET');
            req.setHeader('Authorization', 'Bearer 02fd966efc120b50bdb3b22ac59ea774840bb217');
    
            Http http = new Http();
            HttpResponse res = http.send(req);
    
            // Parse the JSON response
            if (res.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                // Fetch the values from the JSON response
                Decimal biggestRideDistance = (Decimal)results.get('biggest_ride_distance');
                Decimal biggestClimbElevationGain = (Decimal)results.get('biggest_climb_elevation_gain');
                Map<String, Object> recentRideTotals = (Map<String, Object>)results.get('recent_ride_totals');
    
                // Add the fetched values to the athlete
                athlete.Biggest_Ride_Distance__c = biggestRideDistance;
                athlete.Biggest_Climb_Elevation_Gain__c = biggestClimbElevationGain;
                athlete.Recent_Ride_Count__c = (Integer)recentRideTotals.get('count');
                athlete.Recent_Ride_Distance__c = (Decimal)recentRideTotals.get('distance');
                athlete.Recent_Ride_Moving_Time__c = (Integer)recentRideTotals.get('moving_time');
                athlete.Recent_Ride_Elapsed_Time__c = (Integer)recentRideTotals.get('elapsed_time');
                athlete.Recent_Ride_Elevation_Gain__c = (Decimal)recentRideTotals.get('elevation_gain');
                athlete.Recent_Ride_Achievement_Count__c = (Integer)recentRideTotals.get('achievement_count');
    
                // Update the athlete record
                update athlete;
                // TODO: Handle the results as needed
            } else {
                System.debug('Callout failed with status ' + res.getStatusCode() + ' ' + res.getStatus());
            }
        }
}