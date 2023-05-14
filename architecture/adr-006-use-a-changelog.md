# Architecture Decision Record: Use A Changelog

## Status
accepted

## Context
Besides the version number of Cacambers releases it is also important for the users  to know what is actually
part of a new release. Users might bei waiting for new features or bugfixes or want to check what breaking changes
have been introduced.
Users need do know about:
- Added features
- Changed features
- Removed features
- Fixed bugs

## Decision
1. Starting with version 1.0.0 a changelog will be maintained
1. The changelog will follow the format of [keepachangelog](https://keepachangelog.com/en/1.1.0/)

## Consequences
1. Every relevant change of Cacambers functionality and docs will be tracked in the change log
2. Changes are transparent for the users
3. Changes are traceable
