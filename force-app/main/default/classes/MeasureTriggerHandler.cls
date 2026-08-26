/**
 * Trigger handler for Measure__c.
 *
 * Deliberately-crafted validation messages must reach the user intact. A
 * generic catch that runs them through parseSaveError() garbles them, so
 * ValidationException is caught specifically, ahead of the generic catch.
 */
public with sharing class MeasureTriggerHandler {

    public static void beforeInsert(List<Measure__c> newMeasures) {
        try {
            MeasureValidator.validate(newMeasures);
        } catch (Exception e) {
            ErrorLog.record('MeasureTriggerHandler.beforeInsert', e);
            addErrorToAll(newMeasures, parseSaveError(e));
        }
    }

    private static void addErrorToAll(List<Measure__c> measures, String message) {
        for (Measure__c m : measures) {
            m.addError(message);
        }
    }

    private static String parseSaveError(Exception e) {
        return 'The measure could not be saved. Contact your administrator. '
            + 'Reference: ' + e.getTypeName();
    }
}
