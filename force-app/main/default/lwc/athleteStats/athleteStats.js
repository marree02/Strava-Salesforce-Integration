import { LightningElement, track } from 'lwc';
import getAthletes from '@salesforce/apex/AthleteController.getAthletes';

export default class AthleteStats extends LightningElement {
    @track athletes;

    connectedCallback() {
        this.refreshData();
    }

    refreshData() {
        getAthletes()
            .then(result => {
                this.athletes = result;
            })
            .catch(error => {
                console.error('Error fetching athletes:', error);
            });
    }
}
