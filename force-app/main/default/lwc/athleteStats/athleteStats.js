import { LightningElement, wire } from 'lwc';
import getAthletes from '@salesforce/apex/AthleteController.getAthletes';
import { refreshApex } from '@salesforce/apex';
import fetchAthleteStats from '@salesforce/apex/AthleteApiStats.getStats';

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

            // Call the method to fetch stats from external API
            this.fetchStats();
        } else if (result.error) {
            // Handle error
            console.error('Error fetching athletes:', result.error);
        }
    }

    // Method to fetch stats from external API
    fetchStats() {
        fetchAthleteStats({ newAthletes: this.athletes })
            .then(result => {
                // Handle API response if needed
                // Refresh the wired Apex method result to update the UI
                return refreshApex(this.wiredAthletesResult);
            })
            .catch(error => {
                // Handle error
                console.error('Error fetching athlete stats:', error);
            });
    }

    // Method to handle button click for refreshing data
    refreshData() {
        // Call the method to fetch stats from external API
        this.fetchStats();
    }
}
