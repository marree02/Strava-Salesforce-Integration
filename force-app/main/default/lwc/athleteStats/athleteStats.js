import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

export default class AthleteStats extends LightningElement {
    @track athlete;
    @track error;

    // Hardcoded record ID
    recordId = 'a00av000000w6jS';

    @wire(getRecord, { recordId: '$recordId', fields: ['Athlete__c.Name', 'Athlete__c.Profile_Picture__c', 'Athlete__c.First_Name__c', 'Athlete__c.Last_Name__c', 'Athlete__c.City__c', 'Athlete__c.Country__c'] })
    wiredRecord({ error, data }) {
        if (data) {
            this.athlete = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.athlete = undefined;
        }
    }
}