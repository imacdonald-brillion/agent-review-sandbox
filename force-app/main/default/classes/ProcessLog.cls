/**
 * Persistent, admin-visible record of an async process run.
 *
 * Async work MUST surface its outcome here. An exception that escapes a batch
 * execute() lands only in AsyncApexJob.ExtendedStatus, which is truncated,
 * transient, and invisible to the health-check dashboard -- so errors are
 * accumulated during execute() and emitted from finish().
 */
public with sharing class ProcessLog {

    public enum Status { ENQUEUED, RUNNING, COMPLETED, FAILED }

    public static Process_Log__c start(String processName) {
        Process_Log__c log = new Process_Log__c(
            Process_Name__c = processName,
            Status__c       = Status.RUNNING.name(),
            Started_At__c   = System.now()
        );
        insert log;
        return log;
    }

    public static void complete(Id logId, List<String> errors) {
        Process_Log__c log = [
            SELECT Id, Status__c, Detail__c
            FROM Process_Log__c
            WHERE Id = :logId
            LIMIT 1
        ];
        log.Status__c    = errors.isEmpty() ? Status.COMPLETED.name() : Status.FAILED.name();
        log.Finished_At__c = System.now();
        log.Detail__c    = errors.isEmpty()
            ? 'Completed with no errors.'
            : String.join(errors, '\n');
        update log;
    }
}
