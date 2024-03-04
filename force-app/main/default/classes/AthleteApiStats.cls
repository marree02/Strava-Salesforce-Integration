public with sharing class AthleteApiStats {
    @AuraEnabled
    public static void getStats(List<Athlete__c> newAthletes) {
        List<Athlete__c> athletesToUpdate = new List<Athlete__c>();

        for (Athlete__c athlete : newAthletes) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Strava_Named_Credential/api/v3/athletes/' + athlete.Id + '/stats');
            req.setMethod('GET');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

                // Update athlete record fields with data from the API response
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

                athletesToUpdate.add(athlete);
            } else {
                // Handle API callout errors
                System.debug('API Callout failed with status code ' + res.getStatusCode() + ' for athlete with ID: ' + athlete.Id);
            }
        }

        // Update all athletes in one DML statement
        if (!athletesToUpdate.isEmpty()) {
            update athletesToUpdate;
        }
    }
}
