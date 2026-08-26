@IsTest
private class MeasureValidatorTest {

    @IsTest
    static void rejectsNegativeIncentive() {
        Measure__c m = new Measure__c(Incentive__c = -5, Program__c = fakeId());
        try {
            MeasureValidator.validate(new List<Measure__c>{ m });
            System.assert(false, 'Expected a ValidationException for a negative incentive');
        } catch (MeasureValidator.ValidationException e) {
            System.assertEquals(
                MeasureValidator.ERR_NEGATIVE_INCENTIVE,
                e.getMessage(),
                'The crafted user-facing message must be preserved verbatim'
            );
        }
    }

    @IsTest
    static void acceptsZeroIncentive() {
        Measure__c m = new Measure__c(Incentive__c = 0, Program__c = fakeId());
        MeasureValidator.validate(new List<Measure__c>{ m });
        System.assert(true, 'Zero is a valid incentive and must not throw');
    }

    private static Id fakeId() {
        return Id.valueOf('a005g000004ZZZZAA2');
    }
}
