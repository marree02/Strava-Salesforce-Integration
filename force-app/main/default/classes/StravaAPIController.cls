public class StravaAPIController implements Schedulable {
    private final String JOB_NAME = 'Strava Repeating Job';
    private final Integer TEN_MINUTES = 3; // Update to execute every 10 minutes
    private String stravaAthleteId;

    // Constructor
    public StravaAPIController(String stravaAthleteId) {
        this.stravaAthleteId = stravaAthleteId;
    }

    // Execute method called by the scheduler
    public void execute(SchedulableContext cont) {
        makeStravaAPICall(stravaAthleteId);
        findAndAbortJob(cont);
    }

    // Main logic to make the API Call
    public void makeStravaAPICall(String stravaAthleteId) {
        Map<String, Object> data;
        try {
            // Obtain refresh token configuration from custom metadata
            Strava_Refresh_Token__mdt stravaRefreshTokenConfig = Strava_Refresh_Token__mdt.getInstance('m00av000001MYVVAA4');
            String CLIENT_ID = stravaRefreshTokenConfig.client_id__c;
            String CLIENT_SECRET = stravaRefreshTokenConfig.client_secret__c;
            String GRANT_TYPE = stravaRefreshTokenConfig.grant_type__c;
            String REFRESH_TOKEN = stravaRefreshTokenConfig.refresh_token__c;

            // Construct the endpoint for refreshing the access token
            String endpoint = 'https://www.strava.com/api/v3/oauth/token' +
                              '?client_id=' + CLIENT_ID +
                              '&client_secret=' + CLIENT_SECRET +
                              '&grant_type=' + GRANT_TYPE +
                              '&refresh_token=' + REFRESH_TOKEN;

            Http http = new Http();
            HttpRequest refreshReq = new HttpRequest();
            refreshReq.setEndpoint(endpoint);
            refreshReq.setMethod('POST');
            HttpResponse tokenRes = http.send(refreshReq);

            // Parse the JSON response to retrieve the access token
            Map<String, Object> tokenData = (Map<String, Object>) JSON.deserializeUntyped(tokenRes.getBody());
            String accessToken = tokenData.containsKey('access_token') ? (String) tokenData.get('access_token') : null;

            // Use the access token to call the Strava API for athlete stats
            String athleteEndpoint = 'https://www.strava.com/api/v3/athletes/' + stravaAthleteId + '/stats';
            HttpRequest athleteReq = new HttpRequest();
            athleteReq.setEndpoint(athleteEndpoint);
            athleteReq.setMethod('GET');
            athleteReq.setHeader('Authorization', 'Bearer ' + accessToken);

            HttpResponse res = http.send(athleteReq);

            if (res.getStatusCode() == 200) {
                String responseBody = res.getBody();

                // Check if the response size is too large
            if(responseBody.length() > 6000000) {
                System.debug('Response size is too large');
                return;
            }
                
                data = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
                updateAthleteData(data);
            } else {
                System.debug('HTTP response status: ' + res.getStatusCode());
                System.debug('HTTP response body: ' + res.getBody());
            }
        } catch (Exception e) {
            System.debug('Exception during callout: ' + e.getMessage());
        }
    }

    // Method to update athlete data in Salesforce
    private void updateAthleteData(Map<String, Object> data) {
        if (data != null) {
            Id sfAthleteId = 'a00av000000w6jTAAQ';
            Athlete__c athlete = [SELECT Id, Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c FROM Athlete__c WHERE Id = :sfAthleteId LIMIT 1];

            // Mapping data from API response to Salesforce fields
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
            update athlete;
        }
    }

    // Abort the current job and schedule a new one
   private void findAndAbortJob(SchedulableContext cont) {
    if (cont == null) {
        System.debug('SchedulableContext is null');
        rescheduleJob();// Reschedule the job if the context is null
        return;
    }

    List<CronJobDetail> cronDetail = [SELECT Id FROM CronJobDetail WHERE Name= :JOB_NAME LIMIT 1];
    if (cronDetail.isEmpty()) {
        System.debug('No CronJobDetail found for job name: ' + JOB_NAME);
        rescheduleJob();// Reschedule the job if the CronJobDetail is not found
        return;
    }

    List<CronTrigger> cronTriggers = [SELECT Id FROM CronTrigger WHERE CronJobDetailId = :cronDetail[0].Id];
    if(cronTriggers.isEmpty()) {
        System.debug('No CronTrigger found for CronJobDetailId: ' + cronDetail[0].Id);
        rescheduleJob();// Reschedule the job if the CronTrigger is not found
        return;
    }

    try {
        System.abortJob(cronTriggers[0].Id);
    } catch (Exception e) {
        System.debug('Error aborting job: ' + e.getMessage());
    }finally {
        rescheduleJob(); // Reschedule the job even if an exception occurs while aborting it
    }
}

    // Schedule the next execution of this job
    private void rescheduleJob() {
        Datetime sysTime = System.now().addMinutes(TEN_MINUTES);
        String cronExpression = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule(JOB_NAME + sysTime.getTime(), cronExpression, new StravaAPIController(stravaAthleteId));
    }
}
// String cronExp = '0 0,10,20,30,40,50 * * * ?'; // Every 10 minutes
//StravaAPIController job = new StravaAPIController('130827242');
//String jobId = System.schedule('Strava Repeating Job', cronExp, job);
//System.debug('Scheduled Job ID: ' + jobId);