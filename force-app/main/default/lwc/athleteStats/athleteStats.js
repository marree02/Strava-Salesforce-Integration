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

    // Helper method to format seconds to minutes
    formatSecondsToMinutes(seconds) {
        return seconds / 60;
    }

    // Helper method to format meters to kilometers
    formatMetersToKilometers(meters) {
        return meters / 1000;
    }

    get gridData() {
        return [
            {
                name: 'Recent Rides',
                Count: this.athlete.Recent_Ride_Count__c,
                Distance: this.formatMetersToKilometers(this.athlete.Recent_Ride_Distance__c),
                MovingTime: this.formatSecondsToMinutes(this.athlete.Recent_Ride_Moving_Time__c),
                ElapsedTime: this.formatSecondsToMinutes(this.athlete.Recent_Ride_Elapsed_Time__c),
                ElevationGain: this.formatMetersToKilometers(this.athlete.Recent_Ride_Elevation_Gain__c),
                AchievementCount: this.athlete.Recent_Ride_Achievement_Count__c,
                _children: [
                    {
                        name: 'All Rides',
                        Count: this.athlete.All_Ride_Count__c,
                        Distance: this.formatMetersToKilometers(this.athlete.All_Ride_Distance__c),
                        MovingTime: this.formatSecondsToMinutes(this.athlete.All_Ride_Moving_Time__c),
                        ElapsedTime: this.formatSecondsToMinutes(this.athlete.All_Ride_Elapsed_Time__c),
                        ElevationGain: this.formatMetersToKilometers(this.athlete.All_Ride_Elevation_Gain__c),
                    },
                    {
                        name: 'Recent Runs',
                        Count: this.athlete.Recent_Run_Count__c,
                        Distance: this.formatMetersToKilometers(this.athlete.Recent_Run_Distance__c),
                        MovingTime: this.formatSecondsToMinutes(this.athlete.Recent_Run_Moving_Time__c),
                        ElapsedTime: this.formatSecondsToMinutes(this.athlete.Recent_Run_Elapsed_Time__c),
                        ElevationGain: this.formatMetersToKilometers(this.athlete.Recent_Run_Elevation_Gain__c),
                    }
                ]
            }
        ];
    }


    get columns() {
     return [
        { label: 'Name', fieldName: 'name', type: 'text' },
        { label: 'Count', fieldName: 'Count', type: 'number' },
        { label: 'Distance', fieldName: 'Distance', type: 'number' },
        { label: 'Moving Time', fieldName: 'MovingTime', type: 'number' },
        { label: 'Elapsed Time', fieldName: 'ElapsedTime', type: 'number' },
        { label: 'Elevation Gain', fieldName: 'ElevationGain', type: 'number' },
        { label: 'Achievement Count', fieldName: 'AchievementCount', type: 'number' },
        ];
    }
}   