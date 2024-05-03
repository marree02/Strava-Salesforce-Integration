public with sharing class StravaAthleteInfoController implements Schedulable {
    public void execute(SchedulableContext cont) {
        getAthleteInfo();
    }

    @future(callout=true)
    public static void getAthleteInfo() {

        Strava_refresh_token__mdt StravaAccessToken = Strava_refresh_token__mdt.getInstance('m00av000001MYVVAA4');
        String accessToken = StravaAccessToken.accesstoken__c;

        String endpoint = 'https://www.strava.com/api/v3/athlete';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + 'd50c944672964ebfd963f2e004a7c1e851ceffa1');

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            updateAthleteInfo(data);
        } else {
            System.debug('HTTP response status: ' + res.getStatusCode());
            System.debug('HTTP response body: ' + res.getBody());
        }
    }

    private static void updateAthleteInfo(Map<String, Object> data) {
        Id sfAthleteId = 'a00av000000w6jTAAQ'; // Replace with the actual Salesforce ID of the athlete
        Athlete__c athlete = [SELECT Id, Profile_Picture__c, First_Name__c, Last_Name__c, City__c, Country__c FROM Athlete__c WHERE Id = :sfAthleteId LIMIT 1];
        athlete.Profile_Picture__c = (String) data.get('profile_medium');
        athlete.First_Name__c = (String) data.get('firstname');
        athlete.Last_Name__c = (String) data.get('lastname');
        athlete.City__c = (String) data.get('city');
        athlete.Country__c = (String) data.get('country');
        update athlete;
    }
}