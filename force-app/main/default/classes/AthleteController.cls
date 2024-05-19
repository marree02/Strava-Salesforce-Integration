public with sharing class AthleteController {
    @AuraEnabled(cacheable=true)
    public static Athlete__c getAthleteData(String athleteId) {
        // Query the athlete data
        return [SELECT Id, Recent_Ride_Count__c, Recent_Ride_Distance__c, Recent_Ride_Moving_Time__c, Recent_Ride_Elapsed_Time__c, Recent_Ride_Elevation_Gain__c, Recent_Ride_Achievement_Count__c, All_Ride_Count__c, All_Ride_Distance__c, All_Ride_Moving_Time__c, All_Ride_Elapsed_Time__c, All_Ride_Elevation_Gain__c, Biggest_Ride_Distance__c, Biggest_Climb_Elevation_Gain__c, City__c, Country__c, First_Name__c, Last_Name__c, Profile_Picture_Formula__c, Profile_Picture__c, Recent_Run_Count__c, Recent_Run_Distance__c, Recent_Run_Elapsed_Time__c, Recent_Run_Elevation_Gain__c, Recent_Run_Moving_Time__c FROM Athlete__c WHERE Id = :athleteId LIMIT 1];
    }
}