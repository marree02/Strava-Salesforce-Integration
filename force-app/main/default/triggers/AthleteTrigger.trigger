trigger AthleteTrigger on Athlete__c (after insert) {
    System.enqueueJob(new StravaAPIController());
}
