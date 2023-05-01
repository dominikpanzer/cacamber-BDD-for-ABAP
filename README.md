[![Run abaplint](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/lint.yml/badge.svg)](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/lint.yml)
[![Run Unit Tests](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/unittest.yml/badge.svg)](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/unittest.yml)
[![Twitter](https://img.shields.io/twitter/follow/PanzerDominik?style=social)](https://twitter.com/PanzerDominik)

# Cacamber - the BDD-Framework for ABAP

Hi! Cacamber makes it possible to you to run BDD-style tests in a SAP-system. Behavior driven development is an agile approach to software development. It focusses on collaboration through a common language between the customer and developers, testers etc. Its doing it by defining examples which describe the behavior of a software system in a natural language. This language has a specific format and is called Gherkin.  In English using the ubiquitous language it looks like this:

```
_Feature_: Discount calculation

_Scenario_: Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)
_given_ the customers first name is Dominik and his last name is Panzer
_and_ his birthdate according to our CRM system is 06.06.2006
_when_ the sales clerk lets the system calculate the customers discount on a Slayer Album
_then_ 'the discount is 66% \m/
```
These examples will be delivered by the business and should be used as executionalbe specifications. You guessed it: Tests! So how can we execute those tests?

You might know the `given ... when ... then` syntax. It's quite similar to `arrange ... act ... assert`. They are both techniques to give tests a clear structure. In ABAP this usually looks like this. Why not just use the Scenario, give the test method an according name and write an acceptance test?

```ABAP
METHOD discount_on_slayer_albums.
* given
sut->do_this( parameter ).
sut->do_that( parameter ).
data(product) = |Slayer Album|.
"more complex stuff here

* when
DATA(discount) = sut->calculate( product ).

* then
cl_abap_unit_assert=>assert_equals(  exp = 66 act = discount ).
ENDMETHOD
```
The `given ... when ... then` comments are not very helpful. Also the individual parts of the test are not reusable. And the whole test is not very domain-centric compared to the scenario the business defined.

So some people wanted to do better and started writing their tests like this:

```ABAP
METHOD discount_on_slayer_albums.
given_cstmr_first_last_birthda( EXPORTING first_name = 'Dominik'
                                   last_name = 'Panzer'
                                   birthdate = '20060606' ).
when_the_price_is_calculated_for( 'Slayer Album' ).
then_the_discount_is_correct( ).
ENDMETHOD
```
Thats way better! Persoanlly I sadly only know one project with such tests. Most of the details and complexity are hidden behind well named methods. Also there is the possibility to change the test parameters. This make the test more flexible and reusable. But using parameterless methods would make the code more readable.

But this solution is no way near our original testcase description. Its not natural language, it is mainly code. The approach is limited by ABAPs maximum method length. Developers are forced to use abbreviations.

If you choose to use Cacamber as a bridge between the scenario written in Gherkin and ABAP Unit, your test might look like this:
```ABAP
 METHOD discount_on_slayer_albums.
    scenario( 'Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)' ).
    
    given( 'the customers first name is Dominik and his last name is Panzer' ).
    and( 'his birthdate according to our CRM system is 06.06.2006' ).
    when( 'the sales clerk lets the system calculate the customers discount on a Slayer Album' ).
    then( 'the discount is 66% \m/' ).
  ENDMETHOD.
  ```
  
  And if it fails ABAP Unit will tell you this way:
  ```
  ...
Critical Assertion Error: 'Discount Calcuation: Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)'
...
  ```
  
Have I sparked your interest? Great.

## How to use Cacamber

## The BDD Cycle
  
## Architecture: Cacamber vs. other BDD Testing Frameworks
There are many frameworks out there for other languages which interpret Gherkin. Usually there are textfiles which contain the test and there are test classes which have annotations to map the scenarions to different test methods. Thats great. But no fun at all to in the SAP world, because handling textfiles, parsing your own sourccode for annotations and integration this into ABAP Unit is no fun at all. Writing own test framesworks is imho also not a good idea.

So I chose this alternative approach to get something up and running fast. No magic involved.

## How to install RESULT for ABAP
You can copy and paste the source code into your system or simply clone this repository with [abapGit](https://abapgit.org/). 

## Test List
I like to create a simple [acceptance test list](https://agiledojo.de/2018-12-16-tdd-testlist/) before I start coding. It's my personal todo-list. Often the list is very domain-centric, this one is quite technical.

|Test List|
|----|
:white_check_mark: first proof of concept somehow seems to works
:black_square_button: a user can use the gherkin keyword "example" and it behaves like "scenario"
:black_square_button: a user can use the gherkin keyword "but" and it behaves like "scenario"
:black_square_button: a user can use the gherkin keyword "*" for lists. because "*" is not allowed in ABAP "_" should be used. it behaves like "scenario"
:black_square_button: a user can add a rule via the keyword "rule" and it is stored
:black_square_button: error handling: no regex match / no method found should throw
:black_square_button: error handling: method does not only have importing parameters
:black_square_button: error handling: method has more parameters than extracted variables(?) maybe thats ok to make the code more flexible?
:black_square_button: a user can use a float number in the tests (1.000,25) and it is parsed into a packed datatype succcessfully
:black_square_button: a user can use a time in the test (12:00:00 or 12:01, not 11am or 1pm) and it is parsed into TIMS datatype successfully
:black_square_button: a user can define tables via the keyword "following" and those are parsed and successfully
:black_square_button: a user can use the gherkin keyword "scenario outline" to shorten similar scenarios with different testdata
:black_square_button: a user can use the "background" keyword to execute steps before every scenario (like SETUP)
:black_square_button: your awesome idea

## How to support this project

PRs are welcome! You can also just pick one of the test list entries from above and implement the solution or implement your own idea. Fix a bug. Improve the docs... whatever suits you.

Greetings, 
Dominik

follow me on [Twitter](https://twitter.com/PanzerDominik) or [Mastodon](https://sw-development-is.social/web/@PanzerDominik)
