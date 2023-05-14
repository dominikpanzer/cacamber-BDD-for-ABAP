# Architecture Decision Record: Docs Are As Important As Code

## Status
accepted

## Context
Cacamber is not a very big solution, but it's usage is not very intuitive if you don't know BDD. Users don't want to spend
time figuring out how to use software by themselfes. Repositories with no documentation at all or a very 
short `README.md` are not very popular. 

Without a good documentation Cacamber might not get many users. 

## Decision
1. Documentation is as important as source code
2. Cacamber will have an extensive `README.MD`. Every public method will be described. Examples will 
be provided.
1. Additionally Cacamber will provide the user with example-classes which show how Cacamber can be used. These 
examples will include executable tests.
3. Cacamber will be developed using ATDD. The resulting acceptance tests and unit tests will be part of the "living
documentation".

## Consequences
1. Every change to the user-facing functionality of Cacamber results in an update of the documentation
2. Refactorings won't
3. Hopefully higher user-acceptance
