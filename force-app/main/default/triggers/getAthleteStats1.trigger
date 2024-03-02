trigger getAthletesStats1 on Athlete__c (after insert) {
  new AthleteApiStats().getStats(Trigger.new);
}
