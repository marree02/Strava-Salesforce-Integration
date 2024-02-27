public class StravaTokenRequest {

    // Method to send a POST request to Strava OAuth token endpoint
    public static void getToken(String clientId, String clientSecret, String code) {
        // Construct the POST request body
        String requestBody = 'client_id=120708' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                             '&client_secret=525ede17509bf58c1df9147a90abe1a31cfa6c41' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
                             '&code=e6b36fe6b65bb3f49eb42c39df5430bae3051d03' + EncodingUtil.urlEncode(code, 'UTF-8') +
                             '&grant_type=authorization_code';

        // Define the endpoint URL
        String endpointUrl = 'https://www.strava.com/oauth/token';

        // Create the HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpointUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(requestBody);

        // Create the HTTP object and send the request
        Http http = new Http();
        HttpResponse res = http.send(req);

        // Parse and handle the response
        if (res.getStatusCode() == 200) {
            // Successful response handling
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            String accessToken = (String) responseMap.get('access_token');
            // Handle the access token and athlete details as needed
            System.debug('Access Token: ' + accessToken);
            // Retrieve and handle athlete details
            Map<String, Object> athleteMap = (Map<String, Object>) responseMap.get('athlete');
            String athleteName = (String) athleteMap.get('firstname') + ' ' + (String) athleteMap.get('lastname');
            System.debug('Athlete Name: ' + athleteName);
        } else {
            // Error handling
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
    }
}
