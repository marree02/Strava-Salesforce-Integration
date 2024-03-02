trigger getAthletesStats on Athlete__c (after insert) {
    new AthleteApiStats.getStats().run;
  }
  