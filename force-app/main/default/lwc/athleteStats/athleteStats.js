import { LightningElement, wire } from 'lwc';
import getAthletes from '@salesforce/apex/AthleteController.getAthletes';



export default class AthleteStatsComponent extends LightningElement {
    athletes = []; // List of Athlete__c records
    wiredAthletesResult; // Reference to the wired Apex method result


   // Call the Apex method to fetch athletes from Salesforce
@wire(getAthletes)
wiredAthletes(result) {
    this.wiredAthletesResult = result;
    if (result.data) {
        // Filter the fetched athletes to include only the athlete with the ID 'a00av000000wUvN'
        this.athletes = result.data.filter(athlete => athlete.Id === 'a00av000000wUvN');
    }
}

}
