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
            this.filterAthletes(result.data);
        } else if (result.error) {
            // Handle error
            console.error('Error fetching athletes:', result.error);
        }
    }

    // Method to filter athletes based on name
    filterAthletes(data) {
        this.athletes = data.filter(athlete => athlete.Name === 'a00av000000w6jS');
    }


    
}
