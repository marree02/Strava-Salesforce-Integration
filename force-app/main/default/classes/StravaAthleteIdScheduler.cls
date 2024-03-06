global class StravaAthleteIdScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        StravaTokenRefresher.fetchAndUpdateAthleteIds();
    }

}