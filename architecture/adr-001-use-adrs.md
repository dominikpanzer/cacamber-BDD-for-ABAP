# Architecture Decision Record: Use ADRs

## Status
accepted

## Context
Cacamber is a relatively small tool, but nethertheless while developing
Cacamber there will be several architectural decisions be made. To
make those decisions transparent for users of Cacamber and potential
future contributers, the decisions should be documented in a format that
software architects are used to.
It is important that descisions can be revisited to decide if they still
make sense or if the circumstances changed.
Also it is important to really actively think about Cacambers solution architecture and
make conscious decisions based on data and good reasons

## Decision
Every architecture-level decision for Cacamber will be documented via
the standardized format "Architecture Decision Record" (ADR).

* the ADRs will be saved in a subfolder of the project called "architecture"
* the files will be named "adr-NNN-topic.md", starting with NNN=001
* the following status will be used: proposed, accepted, rejected, revised
* the a ADRs is revised, a new ADR has to be created which references the revised ADR

## Consequences
1. every architectural decision has to be documented
2. decisions already made must be post-documented as ADRs
