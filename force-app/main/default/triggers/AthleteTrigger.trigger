trigger AthleteTrigger on Athlete__c (after insert) {
    for (Athlete__c athlete : Trigger.new) {
        System.enqueueJob(new StravaAPIController(athlete.Id));
    }
}