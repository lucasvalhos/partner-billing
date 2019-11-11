import { LightningElement, api, track } from 'lwc';

import { getOrgProfiles } from 'c/utilities';
import getOrganizationProfiles from '@salesforce/apex/InvoicePdfController.getOrganizationProfiles';

export default class InvoicePdfGenTableRow extends LightningElement {
    @api invoice;

    @track selectedProfile;
    @track selectedLanguage;
    @track displayTimesheet;

    @track orgProfiles;
    @track hasPdf = false;
    @track isWorking = false;

    connectedCallback() {
        getOrganizationProfiles().then((data) => {this.orgProfiles = getOrgProfiles(data);});
    }

    handleOptionsChange(event) {
        this.selectedProfile = event.detail.profile;
        this.selectedLanguage = event.detail.language;
        this.displayTimesheet = event.detail.timesheet;
    }

    @api
    createPdf() {
        this.isWorking = true;
        setTimeout( () => {
            this.hasPdf = true;
            this.isWorking = false
        }, 1000);
    }

    @api
    deletePdf() {
        this.hasPdf = !this.hasPdf;
    }

}