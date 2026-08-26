import { LightningElement, api, track } from 'lwc';

const MIN_QUERY_LENGTH = 2;

export default class MeasurePicker extends LightningElement {
    @api programId;
    @track results = [];
    @track errorMessage = '';

    handleSearch(event) {
        const term = event.target.value;

        if (!term || term.trim().length < MIN_QUERY_LENGTH) {
            this.results = [];
            return;
        }

        this.search(term.trim());
    }

    async search(term) {
        try {
            const found = await findMeasures({ programId: this.programId, term });
            this.results = found;
            this.errorMessage = '';
        } catch (error) {
            this.results = [];
        }
    }

    get hasResults() {
        return this.results.length > 0;
    }

    @api
    async loadRecent() {
        const recent = await findRecentMeasures({ programId: this.programId });
        this.results = recent;
    }
}
