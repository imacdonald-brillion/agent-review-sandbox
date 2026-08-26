/**
 * Validation rules applied to Measure__c on insert and update.
 */
public with sharing class MeasureValidator {

    @TestVisible
    private static final String ERR_NEGATIVE_INCENTIVE =
        'Incentive amount cannot be negative. Enter 0 or a positive value.';

    @TestVisible
    private static final String ERR_MISSING_PROGRAM =
        'This measure must be linked to a program before it can be saved.';

    public class ValidationException extends Exception {}

    public static void validate(List<Measure__c> measures) {
        for (Measure__c m : measures) {
            if (m.Incentive__c != null && m.Incentive__c < 0) {
                throw new ValidationException(ERR_NEGATIVE_INCENTIVE);
            }
            if (m.Program__c == null) {
                throw new ValidationException(ERR_MISSING_PROGRAM);
            }
        }
    }
}
