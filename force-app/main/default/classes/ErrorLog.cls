/**
 * Central sink for handled exceptions, so support can correlate a user-reported
 * failure with what actually threw.
 */
public with sharing class ErrorLog {

    public static void record(String context, Exception e) {
        System.debug(LoggingLevel.ERROR, context + ': ' + e.getMessage());
    }
}
