# Coding Standards

Reviewers — human or agent — should treat every rule below as a blocking
finding when violated. Each exists because it was violated in production at
least once.

## Describe & Schema Caching

All describe access goes through `SchemaCache`. Never call these directly:

| Avoid | Use instead |
|---|---|
| `MyObj__c.SObjectType.getDescribe()` | `SchemaCache.getDescribe(MyObj__c.SObjectType)` |
| `getDescribe(t).fields.getMap()` | `SchemaCache.getFields(t)` |
| `Schema.getGlobalDescribe()` | *(not permitted)* |

Repeated describe calls are a documented source of CPU-limit pressure in
large transactions.

## Async Error Visibility

An exception that escapes a batch `execute()` lands in
`AsyncApexJob.ExtendedStatus` — truncated, transient, and invisible to the
admin health-check dashboard.

- `execute()` must not throw. Accumulate failures into a `Database.Stateful`
  member and emit them from `finish()` via `ProcessLog`.
- DML inside `execute()` uses the partial-success form
  (`Database.update(records, false)`) and inspects every `SaveResult`.
- A batch must never leave its parent `Process_Log__c` stuck in `RUNNING`.

## Exception Handling

- A broad `catch (Exception)` must never be the only catch when a
  deliberately-crafted user-facing message can reach it. Catch the specific
  type first — a guard firing must be distinguishable from an NPE or a limit
  exception.
- Never swallow an exception silently. If a failure is genuinely acceptable,
  say so in a comment and record it.

## String & Token Parsing

Parsing code must state and test its behavior for:

- empty string and whitespace-only input
- a separator character appearing inside a free-text value
- trailing empty segments (`String.split` discards them by default)

## Tests

- Every assertion carries a message explaining what invariant it protects.
- A test for a *fixed* bug must fail before the fix and pass after it.
- A test that cannot fail is worse than no test — it reports false safety.
