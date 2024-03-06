import { LightningElement, wire } from 'lwc';
import getAthletes from '@salesforce/apex/AthleteController.getAthletes';
import { refreshApex } from '@salesforce/apex';
import fetchAthleteStats from '@salesforce/apex/AthleteController.fetchAthleteStats';

export default class AthleteStatsComponent extends LightningElement {
    athletes = []; // List of Athlete__c records
    wiredAthletesResult; // Reference to the wired Apex method result

    // Call the Apex method to fetch athletes from Salesforce
    @wire(getAthletes)
    wiredAthletes(result) {
        this.wiredAthletesResult = result;
        if (result.data) {
            // Store the fetched athletes in the component property
            this.athletes = result.data;
        } else if (result.error) {
            // Handle error
            console.error('Error fetching athletes:', result.error);
        }
    }

    // Method to fetch athlete stats from the Strava API
    fetchAthleteStats() {
        fetchAthleteStats({ athletes: this.athletes })
            .then(result => {
                // Handle success if needed
                console.log('Athlete stats fetched successfully');
                // Refresh the wired Apex method result to update the UI
                return refreshApex(this.wiredAthletesResult);
            })
            .catch(error => {
                // Handle error
                console.error('Error fetching athlete stats:', error);
            });
    }
}