trigger getAthletesStats on Athlete__c (after insert) {
  new AthletesApiExample.getStats().run;
}
