# Architecture Decision Record: Automated Code Quality Checks

## Status
accepted

## Context
Cacamber will hopefully find active contributers. Every developer has his own unique coding style. To avoid technical debt the
coding guidelines for Cacamber should be automatically checkable and be enforced when contricuting to Cacamber. Also it must be
guaranteed that there are no regression defects.

## Decision
1. Githab Actions will be used as a runner for the pipeline
1. Automated linting via abaplint will be used: push to main / pull request for main
1. Unit tests will be executed after downporting to 7.02: push to main / pull request for main

## Consequences
1. Increase of code quality
1. Every PR needs to follow the default coding guidelines via abaplint
1. Automated unit tests ensure that Cacamber is in a stable state
1. PRs won't be merged when there are linting-errors or the unit tests fail
