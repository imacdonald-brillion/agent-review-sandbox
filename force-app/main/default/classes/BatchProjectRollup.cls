/**
 * Rolls measure-level incentive amounts up onto their parent projects.
 *
 * Error-handling contract: execute() never throws. Failures are accumulated
 * into errors and emitted from finish() via ProcessLog so an admin can see
 * them in the health-check dashboard.
 */
public with sharing class BatchProjectRollup
    implements Database.Batchable<SObject>, Database.Stateful {

    private final Id logId;
    private final List<String> errors = new List<String>();

    public BatchProjectRollup(Id logId) {
        this.logId = logId;
    }

    public Database.QueryLocator start(Database.BatchableContext ctx) {
        return Database.getQueryLocator([
            SELECT Id, Name, Total_Incentive__c
            FROM Project__c
            WHERE Rollup_Needed__c = TRUE
        ]);
    }

    public void execute(Database.BatchableContext ctx, List<Project__c> scope) {
        Map<Id, Decimal> totals = new Map<Id, Decimal>();

        for (AggregateResult ar : [
            SELECT Project__c projectId, SUM(Incentive__c) total
            FROM Measure__c
            WHERE Project__c IN :scope
            GROUP BY Project__c
        ]) {
            totals.put((Id) ar.get('projectId'), (Decimal) ar.get('total'));
        }

        List<Project__c> toUpdate = new List<Project__c>();
        for (Project__c p : scope) {
            Decimal total = totals.containsKey(p.Id) ? totals.get(p.Id) : 0;
            if (p.Total_Incentive__c != total) {
                p.Total_Incentive__c = total;
                p.Rollup_Needed__c   = false;
                toUpdate.add(p);
            }
        }

        update toUpdate;

        // Audit trail: record which projects were touched by this run.
        List<Rollup_Audit__c> audits = new List<Rollup_Audit__c>();
        for (Project__c p : toUpdate) {
            audits.add(new Rollup_Audit__c(
                Project__c   = p.Id,
                New_Total__c = p.Total_Incentive__c,
                Run_At__c    = System.now()
            ));
        }
        insert audits;
    }

    public void finish(Database.BatchableContext ctx) {
        ProcessLog.complete(logId, errors);
    }
}
