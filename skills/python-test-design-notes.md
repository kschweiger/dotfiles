# Python Test Design — Design Notes

Status: **draft / tuning version**

This repository contains an opinionated agent skill at `skills/python-test-design/` for designing and reviewing Python tests with `pytest` and `pytest-mock`. These notes preserve the design rationale for future tuning without becoming part of the skill package loaded during normal use.

The point of the skill is not to teach an agent pytest syntax. Modern coding agents generally know how to write a fixture, patch a function, or use `@pytest.mark.parametrize`. The problem this skill targets is **judgment**: agents frequently produce tests that technically pass but are brittle, overmocked, overspecified, hard to diagnose, or unnecessarily coupled to implementation details.

`SKILL.md` is intentionally operational. This README records the design intent so the skill can be tuned later without losing the reasoning behind individual rules.

## Current design goal

The desired test suite should be:

- behavior-oriented,
- resilient to behavior-preserving refactors,
- minimally mocked,
- appropriately specific rather than maximally specific,
- diagnostic when it fails,
- concise where several cases express the same behavior.

The governing question is:

> What meaningful production break should make this test fail?

A test should earn its maintenance cost by protecting a contract, branch, side effect, invariant, boundary case, or regression that matters.

## Relationship to Superpowers

This skill is designed to work **alongside** [obra/superpowers](https://github.com/obra/superpowers), not replace it.

Superpowers' current TDD material already contains several principles that align strongly with this skill:

- tests should exercise real behavior,
- mocks should be used only when necessary,
- a test should correspond to a meaningful break,
- expectations should not be computed using the implementation under test,
- tests should be written as part of the implementation cycle rather than as decorative coverage afterwards.

The purpose of this skill is to make the test-design preferences more explicit, especially where coding agents still tend to make poor local choices despite those general principles.

If Superpowers' TDD skill is active, its red/green/refactor workflow can govern **when** tests are written. This skill governs more of **what shape those tests should take**.

## Assumptions

### Pytest and pytest-mock are required project assumptions

The target projects use `pytest` and provide `pytest-mock`. This is not merely a compatibility preference: generated tests should use pytest conventions consistently. The agent should not fall back to `unittest.TestCase` style even though pytest can execute such tests.

For ordinary value and state assertions, use Python's plain `assert` syntax and pytest helpers such as `pytest.raises`, `pytest.warns`, and `pytest.approx` where appropriate. Use pytest fixtures instead of `setUp()` / `tearDown()`, `@pytest.mark.parametrize` for data-driven cases, and the `mocker` fixture for patching, spying, and stubbing.

The skill explicitly rejects `unittest.TestCase` subclasses and `self.assert*` methods such as `self.assertEqual`, `self.assertTrue`, and `self.assertRaises`. It also prefers `mocker.patch(...)` over direct `unittest.mock.patch(...)` decorators or context managers.

This does **not** prohibit interaction assertions such as `spy.assert_called_once_with(...)`. Those are useful when the interaction is the contract and remain the normal mock-object API exposed through pytest-mock.

Most of the broader test-design philosophy still applies outside pytest, but the generated code from this skill is intentionally pytest-native.

The initial draft was checked against:

- pytest 9.1.x documentation,
- pytest-mock 3.15.1 documentation,
- Python's `unittest.mock` documentation,
- current OpenAI Agent Skills documentation,
- current Superpowers testing and skill-authoring material.

The skill itself is deliberately not pinned to one Python minor release or one pytest release.

### "Unit" does not mean "everything around the function is mocked"

This is one of the strongest assumptions in the skill.

A unit test may exercise several real Python objects together while still testing one small behavioral contract. Isolation is useful when it controls a meaningful boundary; isolation for its own sake often reduces confidence and increases maintenance cost.

This matters particularly in active repositories. A test that patches several internal collaborators can fail after a harmless refactor even when the externally meaningful behavior has not changed.

### Mocks are allowed

This is **not** an anti-mock skill.

Mocks and patches are useful for real boundaries such as external services, destructive side effects, expensive operations, difficult failure injection, or nondeterministic dependencies. Interaction assertions are also useful when the interaction is itself meaningful.

The preference is simply:

> Do not replace real behavior unless replacement buys something important.

### Spies are valuable

A spy is a particularly useful middle ground when the test needs to observe which path was taken without replacing the implementation.

Example use case:

- a function chooses among several strategies,
- every strategy returns the same broad result type,
- the test is about routing rather than the exact result contents,
- the real selected strategy is cheap and deterministic.

In that situation, spying on the strategy can express the contract more directly than mocking the strategy or pinning incidental result values.

`pytest-mock` is assumed to be available. `mocker.spy()` is therefore the preferred mechanism when the test needs to observe a real call without replacing its behavior. Likewise, use `mocker.patch`, `mocker.stub`, and related pytest-mock facilities instead of dropping down to direct `unittest.mock.patch` plumbing unless a concrete edge case requires it.

## Design decisions

### 1. Pytest-native style is mandatory

The skill should produce tests that look and behave like idiomatic pytest tests rather than unittest tests executed by pytest.

Preferred forms include:

```python
assert result.status is Status.READY
```

and:

```python
with pytest.raises(ValueError):
    parse(value)
```

rather than:

```python
class TestParser(unittest.TestCase):
    def test_invalid_value(self):
        with self.assertRaises(ValueError):
            parse(value)
```

Similarly, test setup should use fixtures rather than `setUp()` / `tearDown()`. Mocking should normally enter through pytest-mock's `mocker` fixture so patches are scoped and cleaned up by pytest-mock.

The exception is mock interaction assertions such as `assert_called_once_with`. These are not considered unittest-style value assertions; they express interaction contracts on mocks and spies and are fully compatible with the intended style.

### 2. Tests should survive behavior-preserving refactors

This is probably the most important high-level principle.

A test should normally not break just because:

- a private helper was renamed,
- a helper was extracted or inlined,
- internal call ordering changed without semantic effect,
- an internal representation changed,
- code moved between modules while the public contract remained the same.

This principle is the main reason for discouraging unnecessary patches and irrelevant call assertions.

It is not absolute. If a particular interaction is itself part of the contract, asserting it is correct.

### 3. Mock as little as practical

The preferred progression is roughly:

1. real implementation,
2. lightweight real or in-memory implementation,
3. fake or simple stub,
4. mock or patch.

This is not a formal taxonomy the agent must mechanically follow. It is a bias toward retaining real behavior.

A recurring failure mode this is intended to prevent is an agent patching every dependency reachable from the target function, then verifying that its own mock configuration was exercised correctly.

### 4. Observation and replacement are different decisions

Agents often jump from "I need to know whether method X was called" to "I should replace method X with a mock."

That does not follow.

If the real behavior is safe and useful, observation can be preferable to replacement. This is where spies fit.

Call assertions are therefore not discouraged in general. The question is whether the test cares about a meaningful interaction or merely mirrors implementation structure.

### 5. Assertion specificity should match contract specificity

Another common agent behavior is to assert explicit values simply because they are available.

The skill deliberately rejects the idea that more exact assertions automatically make a stronger test.

Examples:

| Actual contract | Appropriate assertion | Usually too specific |
| --- | --- | --- |
| Returns some valid UUID | value parses/is a UUID | exact generated UUID |
| Preserves caller's request ID | exact equality | only checking UUID type |
| Chooses strategy B | strategy B observed/called | full equality of strategy B's incidental result |
| Results are ordered by score | ordering invariant | exact scores if scores are not contractual |
| Result is ready | `status == READY` | equality of every field on a large result object |

Overspecification creates false failures when incidental details change.

Underspecification is also bad. `assert result` is not a substitute for identifying the real contract.

### 6. Parameterize cases, separate behaviors

The skill prefers `pytest.mark.parametrize` when several inputs represent examples of the same rule and share the same setup and assertion structure.

For example, several representations of blank input are good candidates for one parameterized test.

Different contracts such as "invalid input raises," "valid input is normalized," and "duplicate input is ignored" should normally remain separate tests even if they touch the same function.

The goal is not minimizing the number of test functions. The goal is aligning test structure with semantic behavior.

### 7. Semantic parameter IDs are part of failure diagnostics

Parameterized tests are especially useful when their cases are understandable in CI output.

For simple literals, pytest's generated IDs are often enough. For tuples, dataclasses, request objects, nested dictionaries, or otherwise complicated cases, semantic IDs make failures much easier to interpret.

Prefer:

```python
pytest.param(
    disabled_provider,
    fallback_provider,
    id="disabled-provider-uses-fallback",
)
```

over:

```python
pytest.param(disabled_provider, fallback_provider, id="case-2")
```

The ID should describe the scenario, not serialize the data and not merely number it.

### 8. Failure quality matters

Tests are debugging tools as much as regression detectors.

A useful CI failure should quickly communicate:

- which behavior failed,
- which scenario caused it,
- what expectation was violated.

This is why the skill cares about descriptive test names, semantic parameter IDs, focused assertions, and keeping distinct behaviors in distinct tests.

## What the skill intentionally does not decide yet

This draft avoids encoding preferences that have not been discussed or validated yet. These are likely areas for future tuning.

### Fixture style

Open questions:

- How aggressively should repeated setup become fixtures?
- Should local fixtures generally be preferred over global `conftest.py` fixtures?
- When is a factory/helper clearer than a fixture?
- How much fixture indirection is acceptable before test setup becomes hard to trace?

### `autospec` / `spec_set`

If a mock is necessary, should the skill strongly prefer specced mocks? They can catch interface drift, but they can also add friction and do not solve the larger issue of unnecessary mocking.

### Database tests

Possible policy questions:

- Prefer SQLite/in-memory implementations where semantics are close enough?
- Prefer real ephemeral Postgres/MySQL for code that relies on database-specific behavior?
- At what point should such tests be classified as integration tests rather than unit tests?

### File-system tests

`tmp_path` often allows real file-system behavior with very little cost. This likely fits the overall philosophy well, but it has not yet been made an explicit rule.

### Time, randomness, UUIDs, and clocks

A useful future section could distinguish:

- injecting controllable sources,
- freezing time,
- patching module functions,
- asserting invariants instead of exact generated values.

### Network and HTTP clients

The skill currently says external calls are a good reason for replacement, but there are several possible approaches:

- stub the client boundary,
- fake transport,
- local test server,
- recorded responses,
- integration tests against a real service.

The preferred hierarchy may depend on the repository.

### Async and concurrency

No strong policy has been encoded yet for:

- async mocks,
- task scheduling,
- concurrency-sensitive assertions,
- retry behavior,
- timing-dependent tests.

### Property-based testing

Hypothesis can be very useful for invariants and boundary exploration. The current draft does not instruct agents when to prefer it over example-based parametrization.

### Snapshot / golden tests

The philosophy of "assert only what matters" can conflict with large snapshots that lock down every serialized detail. There are legitimate snapshot use cases, so this deserves a nuanced rule rather than a blanket prohibition.

### Coverage targets

The skill does not treat line coverage as the goal. A future revision could say more about meaningful branch coverage, mutation testing, or using coverage only as a diagnostic.

### Test naming conventions

The current rule is semantic rather than syntactic: names should identify behavior. It does not prescribe a specific `test_given_when_then` or `test_<behavior>` structure.

## Suggested evaluation scenarios

A useful way to tune this skill is to give an agent small testing tasks and compare behavior with and without the skill.

### Scenario A: dependency-heavy service

Give the agent a function that coordinates three ordinary local Python objects and one real HTTP client.

Desired behavior:

- keep the ordinary local objects real,
- replace or fake the HTTP boundary,
- avoid nested `MagicMock` graphs.

Failure signal:

- the agent patches all four collaborators merely because they are dependencies.

### Scenario B: branch routing

Give the agent a dispatcher where three branches all return a `Result` with many fields.

Desired behavior:

- test meaningful branch selection,
- use a spy when appropriate,
- avoid pinning unrelated result fields.

Failure signal:

- the agent replaces every branch with mocks and asserts a giant exact result object.

### Scenario C: repeated equivalent inputs

Give the agent several syntactic forms of semantically blank input.

Desired behavior:

- one parameterized behavior test,
- no unnecessary explicit IDs if the literal values are already readable.

Failure signal:

- five nearly identical test functions.

### Scenario D: complex parameter table

Give the agent nested request objects with several routing cases.

Desired behavior:

- parametrization if the contract and assertions are the same,
- semantic IDs such as `disabled-provider-uses-fallback`.

Failure signal:

- CI node IDs like `request2-expected1` or `case3`.

### Scenario E: generated values

Give the agent a function that creates a result containing a generated UUID and timestamp, where the business contract only requires both to be valid and the request ID to be preserved.

Desired behavior:

- exact assertion for the preserved request ID,
- structural/invariant assertions for generated values.

Failure signal:

- patching UUID and time solely to make every field exactly predictable when exactness is irrelevant.

### Scenario F: meaningful interaction

Give the agent a function where a transaction must roll back on one error path.

Desired behavior:

- an interaction assertion is acceptable because rollback is a meaningful side effect,
- do not reject the assertion merely because it is a call assertion.

Failure signal:

- blindly avoiding interaction assertions despite the interaction being the contract.

## How to tune the skill

When an agent produces a test you dislike, capture three things:

1. **What did the agent do?**
   Example: patched three internal helpers and asserted their exact call order.
2. **Why is that harmful here?**
   Example: harmless helper extraction now breaks the test even though behavior is unchanged.
3. **What decision rule should have prevented it?**
   Example: interaction assertions should correspond to meaningful contracts, not internal sequencing.

Then decide whether the fix belongs in:

- a core principle,
- a specific decision rule,
- an anti-pattern,
- an example/evaluation scenario,
- or repository-specific instructions rather than this general skill.

Avoid adding rules merely because one test looked aesthetically unpleasant. The skill should encode reusable engineering judgment.

### Scenario G: pytest conventions

Give the agent an existing pytest suite and ask it to add tests involving exceptions and one patched boundary.

Desired behavior:

- plain `assert` statements,
- `pytest.raises(...)`,
- pytest fixtures,
- `mocker.patch(...)` / `mocker.spy(...)`,
- mock call assertions only where interaction matters.

Failure signal:

- introducing `unittest.TestCase`, `self.assert*`, `setUp()` / `tearDown()`, or direct `unittest.mock.patch(...)` without a concrete reason.

## Potential future structure

If `SKILL.md` grows too large, move detailed material into references while keeping the core decision rules in the main skill:

```text
python-test-design/
├── SKILL.md
└── references/
    ├── mocking-and-spies.md
    ├── assertions.md
    ├── parametrization.md
    └── evaluation-scenarios.md
```

OpenAI's current skill guidance recommends keeping the main `SKILL.md` focused and using `references/` for supporting material.

## Sources and compatibility notes

The initial draft was informed by the following current documentation:

- OpenAI, **Creating Skills**: https://developers.openai.com/docs/build-skills
- OpenAI, **Skills API guide**: https://developers.openai.com/api/docs/guides/tools-skills
- Superpowers, **test-driven-development/SKILL.md**: https://github.com/obra/superpowers/blob/main/skills/test-driven-development/SKILL.md
- Superpowers, **writing-good-tests.md**: https://github.com/obra/superpowers/blob/main/skills/test-driven-development/writing-good-tests.md
- Superpowers, **writing-skills/SKILL.md**: https://github.com/obra/superpowers/blob/main/skills/writing-skills/SKILL.md
- pytest, **parametrization documentation**: https://docs.pytest.org/en/stable/how-to/parametrize.html
- pytest-mock, **usage / spy documentation**: https://pytest-mock.readthedocs.io/en/latest/usage.html
- Python, **unittest.mock** (underlying mock API reference, not the desired test style): https://docs.python.org/3/library/unittest.mock.html

The design is intentionally a draft. The README is expected to change as concrete agent failures reveal additional preferences or exceptions.
