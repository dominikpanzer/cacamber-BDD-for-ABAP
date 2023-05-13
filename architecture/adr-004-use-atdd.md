# Architecture Decision Record: Use Acceptance Test Driven Development (ATDD)

## Status
accepted

## Context
Business requirements for Cacamber need to be defined, so the developers can implement them. 
Developers also need to know when they are "done", so acceptance criteria for these requirements
need to be defined.
To ensure the quality of Cacamber, developers need the possibility to check these criteria without manual testing
Automated tests enable developers to check if Cacamber is in a stable state. They also enable the developers to refactor
Cacamber without the fear of breaking anything. A high test coverage helps as a safety net.

## Decision
ATDD will be used to drive the implementation of Cacamber. ATDD is a development methology quite 
similar to BDD. It focuses on collaboration between business, IT and QA and collects specifications
with the help of acceptance tests. These tests will be implemented first. They fail, because the actual
implementation is missing. To make the tests pass a TDD cycle will be used to implement the underlying logic.

More details can be found [here](https://amcneil36.github.io/blogs/test-driven-development-recommendations.html).

## Consequences
1. Acceptance tests need to be defined
1. Every new method introduced needs scaffolding tests
1. There is always a test before the implementation begins
3. Refactoring can be done fearless
4. It's always clear if Cacamber is in a releasable state
5. Scaffolding tests can be deleted if the code is covered by acceptance tests
