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
            // Surface the failure -- an empty picker with no explanation reads
            // to the user as "no results", which is a different fact.
            this.results = [];
            this.errorMessage =
                'Measures could not be loaded. Check your connection and try again.';
        }
    }

    get hasResults() {
        return this.results.length > 0;
    }
}
