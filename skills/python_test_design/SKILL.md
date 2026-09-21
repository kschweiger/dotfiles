---
name: python-test-design
description: Use when writing, reviewing, or refactoring Python tests with pytest and pytest-mock, where choices about test boundaries, mocks or spies, assertions, fixtures, or parametrization affect maintainability.
---

# Python Test Design

## Purpose

Write tests that protect meaningful behavior without unnecessarily coupling the test suite to the current implementation.

The primary goal is not maximum isolation or maximum assertion count. The goal is a test suite that:

- catches meaningful regressions,
- survives behavior-preserving refactors,
- makes failures easy to diagnose,
- uses real behavior whenever practical,
- and expresses the contract at the right level of specificity.

This skill governs **test design and test shape**. If another skill or project rule defines a workflow such as TDD, follow that workflow as well. Explicit user and repository instructions take precedence.


## Required Testing Stack and Style

Assume the project uses **pytest** and **pytest-mock**. Write tests in pytest-native style.

Do not fall back to `unittest.TestCase` or unittest-style assertion APIs.

Use:

- plain `assert` statements for value, state, membership, and invariant assertions,
- `pytest.raises(...)` for expected exceptions,
- `pytest.warns(...)` for expected warnings,
- `pytest.approx(...)` when approximate numeric comparison is appropriate,
- pytest fixtures rather than `setUp()` / `tearDown()`,
- `@pytest.mark.parametrize` for data-driven cases,
- the `mocker` fixture for mocking, patching, stubbing, and spying.

Do not introduce patterns such as:

- subclasses of `unittest.TestCase`,
- `self.assertEqual`, `self.assertTrue`, `self.assertIsInstance`, `self.assertRaises`, or other `TestCase.assert*` methods,
- `setUp()` / `tearDown()` lifecycle methods,
- direct `unittest.mock.patch(...)` decorators or context managers when `mocker.patch(...)` provides the equivalent pytest-native mechanism.

Mock interaction assertions such as `spy.assert_called_once_with(...)` are allowed when the interaction is part of the contract. These are assertions on pytest-mock/mock objects and are distinct from `unittest.TestCase` assertion style.

## Core Principle

Before writing or changing a test, answer:

> What production behavior is this test protecting, and what realistic bug should make it fail?

Every setup choice, test double, and assertion should support that answer.

## 1. Prefer Behavior Over Implementation

Test externally meaningful behavior and contracts rather than the current internal structure.

Prefer tests that continue to pass after behavior-preserving changes such as:

- renaming or extracting private helpers,
- reorganizing internal calls,
- replacing one internal algorithm with another,
- changing incidental intermediate representations.

Do not assert private implementation details merely because they are observable.

Interaction assertions are valid when the interaction itself matters, for example:

- selecting the correct branch or strategy,
- invoking a required side effect,
- passing a semantically important argument,
- avoiding an operation that must not occur.

## 2. Use Real Collaborators by Default

Do not equate "unit test" with "mock every dependency."

Use real collaborators when they are cheap, deterministic, safe, and local to the process. A test can still have a narrow behavioral scope while exercising several real objects together.

When a dependency must be replaced, prefer the least artificial option that solves the problem:

1. real implementation,
2. lightweight real or in-memory implementation,
3. fake or simple stub,
4. mock or patch.

Good reasons to replace a dependency include:

- real network or external service calls,
- destructive or unsafe side effects,
- nondeterministic behavior that cannot reasonably be controlled,
- very expensive operations,
- unavailable infrastructure,
- testing a failure that is impractical to produce with the real dependency.

"It is a dependency" is not by itself a reason to mock it.

Before adding a mock or patch, ask whether using the real collaborator would make the test simpler and more robust.

## 3. Prefer Observation Over Replacement

When real behavior should still execute but the test needs to know which path was taken, prefer a **spy** over replacing the collaborator with a mock.

A spy is especially useful when:

- several branches return the same type,
- the branch choice is meaningful,
- the detailed returned data is irrelevant to this test,
- replacing the implementation would reduce confidence in the behavior being exercised.

The project is assumed to provide `pytest-mock`. Use `mocker.spy()` when observation is sufficient and real behavior should continue to execute. Prefer the `mocker` fixture over direct `unittest.mock.patch(...)` usage.

Call assertions are not inherently bad. Use them when they verify meaningful routing, side effects, or collaboration. Avoid call assertions that merely mirror the current implementation sequence.

## 4. Assert Only What the Contract Requires

Make assertions as specific as the behavior under test requires, but no more specific.

Use exact values when the exact value is part of the contract.

Use properties, invariants, types, selected fields, ordering, shape, membership, ranges, or interaction assertions when exact values are incidental.

Examples:

- If the contract is "returns a UUID," verify that property; do not pin a random UUID value.
- If the contract is "preserves this request ID," assert exact equality because identity matters.
- If the contract is "uses strategy B," observe strategy B rather than asserting unrelated details of B's result.
- If only `status` and `owner` matter, do not compare an entire large result object unless the entire object is the contract.
- Do not assert an exact exception message unless message text is intentionally part of the public contract.

Avoid assertions added only because a value is available to assert.

Avoid duplicating production logic in the test to compute expected values. Expected behavior should be independently understandable.

## 5. Parameterize Cases, Separate Behaviors

Use parametrization when multiple cases exercise the **same semantic behavior with the same test structure** and only the data varies.

Prefer separate tests when cases represent meaningfully different contracts, branches with different intent, different setup models, or different assertion structures.

A useful rule:

> Parameterize cases; separate behaviors.

Do not create several nearly identical test functions solely because the input values differ.

Do not force unrelated behaviors into one parameter table merely to reduce line count.

## 6. Give Complex Parameter Sets Semantic IDs

For simple values, pytest's generated IDs may already be clear.

When parameter values are complex or their representation would make CI failures difficult to understand, assign a meaningful semantic ID with `pytest.param(..., id="...")` or `ids=...`.

Good IDs describe the scenario or rule:

- `missing-user-falls-back-to-anonymous`
- `disabled-provider-uses-fallback`
- `duplicate-id-keeps-existing-record`

Bad IDs merely number cases:

- `case-1`
- `case-2`

A developer should ideally be able to understand which scenario failed from the test node ID alone.

## 7. Optimize for Useful Failures

A good test failure should answer, with minimal investigation:

- what behavior broke,
- which scenario triggered it,
- what was expected,
- and what actually happened.

Use:

- descriptive test names,
- semantic parameter IDs when needed,
- focused assertions,
- separate tests for distinct contracts.

Avoid giant tests whose failure requires first determining which of many unrelated behaviors mattered.

## 8. Keep Test Doubles Narrow

When a mock, fake, stub, or spy is justified:

- replace only the boundary that needs control,
- do not mock an entire dependency graph if one boundary is enough,
- avoid chains of nested mocks,
- avoid reproducing the production object graph in mock configuration,
- prefer interfaces and values that resemble real behavior,
- do not add interaction assertions unrelated to the behavior being tested.

If the mock setup is larger or harder to understand than using the real code, reconsider the boundary.

## 9. Follow Existing Repository Conventions Deliberately

Inspect nearby tests before introducing a new testing pattern.

Reuse established fixtures, factories, helpers, test layout, and naming when they support the principles above.

Do not blindly copy an existing pattern that creates brittle or overmocked tests. If repository conventions conflict with this skill, prefer explicit repository or user instructions and make the trade-off visible.

Do not add testing dependencies or large abstractions for a single test without a clear benefit.

## Test Design Procedure

Before writing the test:

1. Identify the specific behavior or regression being protected.
2. Identify which outputs, state changes, or interactions are actually part of that contract.
3. Inspect nearby tests and existing project utilities, while keeping pytest-native style mandatory.
4. Decide whether collaborators can remain real.
5. If observation is needed, prefer spying before replacement.
6. If replacement is needed, isolate the smallest meaningful boundary.
7. Decide whether cases represent one parameterized behavior or distinct tests.
8. Decide whether exact values are semantically important or incidental.

After writing the test:

1. Run the focused test.
2. Run the relevant surrounding test suite according to repository practice.
3. Review every mock or patch and ask whether it is necessary.
4. Review every exact assertion and ask whether that exact value is part of the contract.
5. Check whether equivalent cases should be parameterized.
6. Check whether complex parameter sets need semantic IDs.
7. Mentally perform a behavior-preserving refactor. The test should not fail merely because internals moved.
8. Mentally introduce the intended regression. The test should fail for a useful reason.

## Review Checklist

Before considering test work complete, verify:

- [ ] Tests use pytest-native style; no `unittest.TestCase` or `TestCase.assert*` APIs are introduced.
- [ ] Mocking/spying uses the `mocker` fixture unless there is a concrete repository-specific reason otherwise.
- [ ] Each test protects a specific meaningful behavior or regression.
- [ ] The test name communicates that behavior.
- [ ] Real collaborators are used unless replacement has a concrete reason.
- [ ] Spies are preferred when observation is sufficient and real behavior should execute.
- [ ] Mocks and patches are limited to meaningful boundaries.
- [ ] Interaction assertions verify relevant routing or side effects, not incidental call structure.
- [ ] Exact values are asserted only when exactness matters.
- [ ] Large objects are not compared wholesale when only selected properties matter.
- [ ] Equivalent cases use parametrization when that improves clarity.
- [ ] Distinct behaviors remain distinct tests.
- [ ] Complex parameter sets have semantic IDs when generated IDs would be unclear.
- [ ] Failures are understandable from the test name, parameter ID, and assertion output.
- [ ] The test is likely to survive a behavior-preserving refactor.

## Anti-Patterns

Treat these as warning signs, not automatic proof that a test is wrong:

- patching several internal functions of the unit under test,
- deeply nested `MagicMock` configuration,
- asserting a long list of exact fields that are irrelevant to the named behavior,
- asserting exact generated IDs, timestamps, or ordering when those details are not contractual,
- one test function per literal input despite identical behavior and assertions,
- parameter IDs such as `case1` for complicated inputs,
- asserting internal helper calls solely because they currently happen,
- replacing a cheap deterministic collaborator and then testing the mock instead of real behavior,
- whole-object equality when the test only cares about one or two properties,
- tests that fail after a harmless extraction or rename of private implementation code,
- `unittest.TestCase` subclasses or `self.assert*` assertions in pytest tests,
- direct `unittest.mock.patch(...)` decorators/context managers where `mocker.patch(...)` would be clearer and automatically scoped.

When one of these appears, reconsider the test design before proceeding.
