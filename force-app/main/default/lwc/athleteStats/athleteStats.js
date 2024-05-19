import { LightningElement, wire } from 'lwc';
import getAthleteData from '@salesforce/apex/AthleteController.getAthleteData';

export default class AthleteStatsComponent extends LightningElement {
    athlete; // Athlete__c record
    wiredAthleteResult; // Reference to the wired Apex method result

    // Call the Apex method to fetch athlete data from Salesforce
    @wire(getAthleteData, { athleteId: 'a00av000000w6jTAAQ' })
    wiredAthlete(result) {
        this.wiredAthleteResult = result;
        if (result.data) {
            this.athlete = result.data;
        } else if (result.error) {
            // Handle error
            console.error('Error fetching athlete:', result.error);
        }
    }
    get formattedElevationGain() {
        return this.athlete && this.athlete.Recent_Ride_Elevation_Gain__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.Recent_Ride_Elevation_Gain__c)
            : '00.0';
    }
    get formattedDistance() {
        return this.athlete && this.athlete.Recent_Ride_Distance__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.Recent_Ride_Distance__c / 1000)
            : '00.0';
    }
    
    get formattedMovingTime() {
        return this.athlete && this.athlete.Recent_Ride_Moving_Time__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.Recent_Ride_Moving_Time__c / 60)
            : '00.0';
    }
    
    get formattedElapsedTime() {
        return this.athlete && this.athlete.Recent_Ride_Elapsed_Time__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.Recent_Ride_Elapsed_Time__c / 60)
            : '00.0';
    }
    get formattedAllRideDistance() {
        return this.athlete && this.athlete.All_Ride_Distance__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.All_Ride_Distance__c / 1000)
            : '00.0';
    }
    
    get formattedAllRideMovingTime() {
        return this.athlete && this.athlete.All_Ride_Moving_Time__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.All_Ride_Moving_Time__c / 60)
            : '00.0';
    }
    
    get formattedAllRideElapsedTime() {
        return this.athlete && this.athlete.All_Ride_Elapsed_Time__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.All_Ride_Elapsed_Time__c / 60)
            : '00.0';
    }
    
    get formattedAllRideElevationGain() {
        return this.athlete && this.athlete.All_Ride_Elevation_Gain__c 
            ? new Intl.NumberFormat('en-US', { minimumFractionDigits: 1, maximumFractionDigits: 1 }).format(this.athlete.All_Ride_Elevation_Gain__c)
            : '00.0';
    }
}