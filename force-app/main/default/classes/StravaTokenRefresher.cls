public with sharing class StravaTokenRefresher {

    public Map<String, Object> refreshTokenAndReturnNewTokenInfo() {
        
        String CLIENT_ID = '120708';
        String CLIENT_SECRET = '525ede17509bf58c1df9147a90abe1a31cfa6c41';
        String REFRESH_TOKEN = '1ad7ad8ef71688d737f96122192923dbb553a271';

        String newAccessToken;
        Integer expiresIn;

        // Make a callout to the Strava API using the provided access token
        HttpRequest athleteReq = new HttpRequest();
        athleteReq.setEndpoint('https://www.strava.com/oauth/token');
        athleteReq.setMethod('POST');
        athleteReq.setHeader('client_id:'+ CLIENT_ID);
        athleteReq.setHeader('client_secret:'+ CLIENT_SECRET);
        athleteReq.setHeader('grant_type:'+ REFRESH_TOKEN);
        athleteReq.setHeader('refresh_token:'+ REFRESH_TOKEN);

        Http athleteHttp = new Http();
        HttpResponse athleteRes = athleteHttp.send(athleteReq);

        System.debug('Response Body: ' + athleteRes.getBody());
        System.debug('Response Status: ' + athleteRes.getStatus());
        // Parse the JSON response and receive the new access token
        if (athleteRes.getStatusCode() == 200) {
            System.debug('Success');
            String responseBody = athleteRes.getBody();
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            newAccessToken = (String) results.get('access_token');
            expiresIn = (Integer) results.get('expires_in');
        } else {
            System.debug('Failed');
        }
        
        // Create a map to hold the new access token and the expiration time
        Map<String, Object> tokenInfo = new Map<String, Object>();
        tokenInfo.put('newAccessToken', newAccessToken);
        tokenInfo.put('expiresIn', expiresIn);
        
        return newAccessToken;
    } 
}