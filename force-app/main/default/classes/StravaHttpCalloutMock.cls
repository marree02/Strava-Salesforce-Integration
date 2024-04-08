@isTest
global class StravaHttpCalloutMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"recent_ride_totals": {"count": 10, "distance": 100, "moving_time": 1000, "elapsed_time": 1000, "elevation_gain": 100, "achievement_count": 10}, "all_ride_totals": {"count": 10, "distance": 100, "moving_time": 1000, "elapsed_time": 1000, "elevation_gain": 100}, "biggest_ride_distance": 100, "biggest_climb_elevation_gain": 100}');
        res.setStatusCode(200);
        return res;
    }
}