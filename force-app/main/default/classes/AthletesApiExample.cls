public class AthletesApiExample {
    public void getStats() {
        // Endpoint for the Strava API
        String endpoint = 'https://www.strava.com/api/v3/athletes/130827242/stats';

        // Create a new HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        // Add your Strava API token to the request headers
        req.setHeader('Authorization', 'Bearer ' + '0e3487436e8be08719156e2a99b69bf5b2223ab9');

        // Send the request
        Http http = new Http();
        HttpResponse res = http.send(req);

        // Parse the response
        if (res.getStatusCode() == 200) {
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            System.debug(data);
        } else {
            System.debug('HTTP request failed with status code ' + res.getStatusCode());
        }
    }
}