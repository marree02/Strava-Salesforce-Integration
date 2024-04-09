@isTest
global class StravaHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"recent_ride_totals": {"count": 2.00, "distance": 19566.3291015625, "moving_time": 3455.00, "elapsed_time": 4185, "elevation_gain": 145.70810317993164, "achievement_count": 0}, "all_ride_totals": {"count": 2.00, "distance": 19566.00, "moving_time": 3455, "elapsed_time": 4185, "elevation_gain": 146}, "biggest_ride_distance": 11388.2, "biggest_climb_elevation_gain": null}');
        res.setStatusCode(200);
        return res;
    }
}