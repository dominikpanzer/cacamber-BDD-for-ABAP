# Architecture Decision Record: Use Semantic Versioning

## Status
accepted

## Context
Tools which are used by more than one person need a versioning approach based on releases. 

Cacambers users should be able to know that there is an official new release.

For the users it is also very important to know if the API of a new release is downward compatible to prior versions / only has non breaking changes.

Users need this to manage the dependencies of their software system.

As a concequence a versioning-system is needed to provide safety.

## Decision
1. [Semantic Versioning](https://semver.org/) will be used to track Cacambers releases; MAJOR:MINOR:PATCH, e.g. 1.5.1
1. Github will be used to manage releases.
1. The current version number will be stored in the interface `ZIF_CACAMBER_VERSION`. It has a public attribute called `VERSION`.
1. The first public release of Cacamber will have the version number 1.0.0. Everything before the public
release won't be tracked.

## Consequences
1. Every change of Cacambers sourcecode or docs means a new release
1. To make things easier branches can be used to group a number of changes
1. A change of the major version resets minor and patch version to 0
1. A change of the minor version resets patch version to 0
1. Changing the docs will lead to a change of the patch version
For more details have a look at [Semantic Versioning](https://semver.org/)
