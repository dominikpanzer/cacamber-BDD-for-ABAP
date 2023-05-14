# Architecture Decision Record: Naming

## Status
accepted

## Context
When communication with Cacambers users it can lead to problems, when not all relevant parties "speak the same language".
It needs to be clear what a "step" is so no wrong logic will be implemented etc.

Also naming is an important topic regarding to source code, tests and docs. What should a variable be called etc.

## Decision
1. Cacamber will use the [ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html)) in regards
 to [BDD](https://wikipedia.org/wiki/Behavior_Driven_Development) / [Gherkin](https://cucumber.io/docs/gherkin/reference/)
3. Cacamber will use domain names in the source code and test, technical names will be avoided
4. Cacamber won't use [hungarian notation](https://en.wikipedia.org/wiki/Hungarian_notation) besides the naming of types and ddic-objects. 
Types will use the convention <domainname>_<t/ts/tt> ("postfixing") to mock people who like 
  hungarian notation / prefixing. ;-) The information <domainname> is more important than the information if the type is a structure or table type.
  Also a well-chosen domain name will make it clear whether something is a list of things or not.

## Consequences
1. IT, business and QA can communicate with the same language - less misunderstandings and errors
1. All created artifacts (code, tests, comments, docs) follow this language and are easier to understand
1. No "mental mapping" needed business language<->it language - less errors, less mental load

