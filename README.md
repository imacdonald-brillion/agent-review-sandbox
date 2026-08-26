# agent-review-sandbox

A small, synthetic Salesforce codebase used to exercise an automated PR review
agent. **Nothing here is production code**, and none of it is derived from a
real package — the objects, fields, and business rules are invented.

## Why it exists

Built for the M33 Dev Day workshop (Agent Foundations — Control Plane & Evals).
A review agent is only as good as the criteria it is given, so this repo pairs
realistic-looking code with an explicit, written standard in
[docs/CODING_STANDARDS.md](docs/CODING_STANDARDS.md).

The open pull requests each contain a defect that violates one of those rules.
They are the test set: a good review agent finds them and explains why.

## Layout

```
force-app/main/default/
  classes/     Apex — batch, trigger handler, validation, parsing, tests
  triggers/    Measure__c trigger
  lwc/         a small Lightning Web Component
docs/
  CODING_STANDARDS.md   the review criteria
```

## Running

There is no org attached and no build. This repo exists to be read and
reviewed, not deployed.
