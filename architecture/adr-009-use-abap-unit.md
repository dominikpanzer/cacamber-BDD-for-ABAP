# Architecture Decision Record: Use ABAP Unit

## Status
accepted

## Context
Cacamber acts as an additional layer above the usual unit testing layer. The actual running of tests, assertion librarys and coverage analysis are out of 
scope of this project. But to be actually usable, Cacamber needs an underlying unit test framework.

## Decision
1. ABAP Unit will be used as the underlying testframework
1. No new framework / testrunnter / coverage analyzer will be written

## Consequences
1. Tests will be runable from SE80 / ADT / etc. without any additional reports or tooling
2. Coverage can be calculated automatically
3. Tests can exeuted automatically via abaplint and Github actions
4. User doesn't need to learn a completely new framework, just an additional layer on top of ABAP Unit
5. Much less effort to implement Cacamber
6. Less flexibility for Cacambers features
