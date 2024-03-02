public with sharing class AthleteController {
    @AuraEnabled(cacheable=true)
    public static List<Athlete__c> getAthletes() {
        return [SELECT Id, Name, 
                       Biggest_Ride_Distance__c, 
                       Biggest_Climb_Elevation_Gain__c, 
                       Recent_Ride_Count__c, 
                       Recent_Ride_Distance__c, 
                       Recent_Ride_Moving_Time__c, 
                       Recent_Ride_Elapsed_Time__c, 
                       Recent_Ride_Elevation_Gain__c, 
                       Recent_Ride_Achievement_Count__c, 
                       All_Ride_Count__c, 
                       All_Ride_Distance__c, 
                       All_Ride_Moving_Time__c, 
                       All_Ride_Elapsed_Time__c, 
                       All_Ride_Elevation_Gain__c, 
                       Recent_Run_Count__c, 
                       Recent_Run_Distance__c, 
                       Recent_Run_Moving_Time__c, 
                       Recent_Run_Elapsed_Time__c, 
                       Recent_Run_Elevation_Gain__c
                FROM Athlete__c];
    }
}

