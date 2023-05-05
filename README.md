[![Run abaplint](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/lint.yml/badge.svg)](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/lint.yml)
[![Run Unit Tests](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/unittest.yml/badge.svg)](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/unittest.yml)
[![Twitter](https://img.shields.io/twitter/follow/PanzerDominik?style=social)](https://twitter.com/PanzerDominik)

# Cacamber - the BDD-Framework for ABAP

Hi! Cacamber makes it possible for you to run BDD-style tests in a SAP-system. [Behavior driven development](https://en.wikipedia.org/wiki/Behavior-driven_development) is an agile approach to software development. It focusses on collaboration through a common language between the customer and developers, testers etc. Its doing it by defining examples which describe the behavior of a software system in a natural language. This language has a specific format and is called [Gherkin](https://cucumber.io/docs/gherkin/). In English when using the [ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html) it looks like this:
```
Feature: Discount calculation

Scenario: Discount on Slayer albums for VIP Slayer fans (exclusive contract with BMG)

Given the customers first name is Dominik and his last name is Panzer
and his birthdate according to our CRM system is 06.06.2006
when the sales clerk lets the system calculate the customers discount on a Slayer album
then the discount is 66% \m/
```
These scenarios or examples will be delivered by the business and will be used as executable specifications. You guessed it right: Tests! So how can we execute those scenarios as automated tests?

You might know the `given ... when ... then` pattern. It's quite similar to `arrange ... act ... assert`. They are both techniques to give tests a clear structure. In ABAP this usually looks like this. We focus on the the feature, give the test method an according name and write an acceptance test:

```ABAP
METHOD discount_calculation.
* given
sut->do_this( parameter ).
sut->do_that( parameter ).
DATA(product) = |Slayer Album|.
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
Thats way better! Persoanlly I only know one project with such tests. Most of the details and complexity are hidden behind well named methods. Also there is the possibility to change the test parameters. This make the test more flexible and reusable. But using parameterless methods would make the code more readable.
But this solution is no way near our original testcase description. It's not natural language, it is mainly code. Also this approach is limited by ABAPs maximum method length. Developers are forced to use abbreviations etc.

If you choose to use Cacamber as a bridge between the scenario written in Gherkin and ABAP Unit, your test might look something like this:
```ABAP
METHOD discount_on_slayer_albums.
scenario( 'Discount on Slayer albums for VIP Slayer fans (exclusive contract with BMG)' ).
    
given( 'the customers first name is Dominik and his last name is Panzer' ).
and( 'his birthdate according to our CRM system is 06.06.2006' ).
when( 'the sales clerk lets the system calculate the customers discount on a Slayer album' ).
then( 'the discount is 66% \m/' ).
ENDMETHOD.
```
  
  If it fails ABAP Unit will tell you this way:
  ```
  ...
Critical Assertion Error: 'Discount Calcuation: Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)'
...
  ```
  
Have I sparked your interest? Great.

## Example
If you don't like to read docs, check out the example class ZCL_BDD_EXAMPLE, which shows how to use Cacamber. It's an implementation of the above scenario "Discount on Slayer albums for VIP Slayer fans (exclusive contract with BMG)".

## Cacamber API

This part of the document describes the public methods of Cacamber. To get startet, your local test class needs to inherit from `ZCL_CACAMBER`.

ZCL_CACAMBER as your superclass provides the following public methods.

### FEATURE
The `FEATURE` method is optional and can be used to structure your test cases in a domain-centric way. Usually one test class will represents one feature, e.g. "discount calculation". This method has to be used in the `SETUP` of your test class.

Parameters:
* `FEATURE` - the name of your feature, max. 255 characters long

Example:
```ABAP 
...
feature( 'Discount Calcuation' ).
...
```

### CONFIGURE
The method `CONFIGURE` maps a regex-string to a method, which should be executed whenever the regex matches. If you are not a regex-pro, you can use tools like [regex101](https://regex101.com/) to make thingseasier. Inside the regex you can use (.+) or other matchers to extract the variables from the string, which will be used by Cacamber as parameters for the method call. The order of the variables must match the parameters of the method which should be called when the regex matches. The configuration is usually done in the `SETUP`-method of your test class.

Parameters
* `PATTERN` - a REGEX-string which is used as a matcher
* `METHODNAME` - name of a _public_ method of your _test class_ with a matching interface. can be upper or lower case.

Example:
```ABAP 
...
configure->( pattern = '^the customers first name is (.+) and his last name is (.+)$' methodname = 'set_first_and_second_name' ).
...
```

### SCENARIO
A scenario describes a variant of a feature and represents a test case. Therefore the `SCENARIO` method is usually being used as the first method call in a test method of your local test class.

Parameters:
* `SCENARIO` - the name of the scenario, max. 255 characters long

Example:
```ABAP 
...
scenario( 'Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)' ).
...
```

### EXAMPLE
The method `EXAMPLE` works the same way `SCENARIO` does.

Parameters:
* `SCENARIO` - the name of the scenario, max. 255 characters long

Example:
```ABAP 
...
example( 'Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)' ).
...
```

### RULE
With the method `RULE` you can describe a single business rule which will be implemented. It can be used in your local test methods just like `SCENARIO` or `EXAMPLE`.

Parameters:
* `rule` - description of a business rule, max. 255 characters long

Example:
```ABAP 
...
rule( 'only VIP customers can buy the album 7 days before the officiall realease date' ).
...
```

### GIVEN
The `GIVEN` method is an actual keyword of the Gherkin language. It represents a step. A BDD test case consists of steps which combined represent an expectation of the bahavior of the system. The paramter `STEP` will be matched against the regex-patterns of the configuration to find an actual method to process the data provided by the step.

Parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
given( 'the customers first name is Dominik and his last name is Panzer' ).
...
```

### AND 
Also a Gherkin keyword to write tests in a natural language. The method `AND` works like `GIVEN`.

Parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
and( 'his birthdate according to our CRM system is 06.06.2006' ).
...
```

### OR
Also a Gherkin keyword to write tests in a natural language. The method `OR` works like `GIVEN`.

Parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
or( 'his birthdate according to our CRM system is 01.01.2001' ).
...
```

### BUT
Also a Gherkin keyword to write tests in a natural language. The method `Bb` works like `GIVEN`.

Parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
but( 'today is not the Monday' ).
...
```

### WHEN 
Also a Gherkin keyword to write tests in a natural language. It usually desribes an action.  The method `WHEN` works like `GIVEN`.

Parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
when( 'the sales clerk lets the system calculate the customers discount on a Slayer Album' ).
...
```

### THEN 
Also a Gherkin keyword to write tests in a natural language. It describes an expected reaction of the system. The method `THEN` works like `GIVEN`.

Parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
then( 'the discount is 66% \m/' ).
...
```

## Architecture
There are many frameworks out there for other languages which interpret Gherkin. Usually there are textfiles which contain the test and there are test classes which have annotations to map the scenarions to different test methods. Thats great. But no fun at all to in the SAP world, because handling textfiles, parsing your own sourccode for annotations and integration this into ABAP Unit is complex. Additionally the alternative to write a own test frameswork is imho also not a good idea. 
Also currently every step is executed is called directly when the method is bein called. Maybe it is more flexible to execute the methods of every step only when a "THEN" is triggered. This might be needed to parse complex Gherkin syntax correctly.

## How to install Cacamber
You can copy and paste the source code into your system or simply clone this repository with [abapGit](https://abapgit.org/). 

## Test List
I like to create a simple [acceptance test list](https://agiledojo.de/2018-12-16-tdd-testlist/) before I start coding. It's my personal todo-list. Often the list is very domain-centric, this one is quite technical.

|Test List|
|----|
:white_check_mark: first proof of concept somehow seems to works
:white_check_mark: a user can use the gherkin keyword "example" and it behaves like "scenario"
:white_check_mark: a user can use the gherkin keyword "but" and it behaves like "scenario"
:white_check_mark: a user can use the gherkin keyword "*" for lists. because "*" is not allowed in ABAP an underscore should be used. it behaves like "scenario"
:white_check_mark: a user can add a rule via the keyword "rule" and it is stored so it can be used in assertions
:white_check_mark: error handling: method doesnt have the same number of parameters as variables exist
:white_check_mark: error handling: no regex match / no method found should throw
:white_check_mark: error handling: dynamic method call for the step-method fails. it should throw.
:white_check_mark: a user can define tables and those are parsed and successfully
:white_check_mark: a user can can read values from those tables
:white_check_mark: a user can transform the table into a real internal table
:white_check_mark: a user can use empty cells in a table
:white_check_mark: set up a class as example on how to use cacamber
:black_square_button: fix the linter / unit tests
:black_square_button: a user can use a float number in the tests (1.000,25) and it is parsed into a packed datatype succcessfully
:black_square_button: a user can use a time in the test (12:00:00 or 12:01, not 11am or 1pm) and it is parsed into TIMS datatype successfully
:black_square_button: update the docs 👹
:black_square_button: a user can use the gherkin keyword "scenario outline" to shorten similar scenarios with different testdata
:black_square_button: a user can use the "background" keyword to execute steps before every scenario (like SETUP)
:black_square_button: refactor to `RESULT`
:black_square_button: your awesome idea

## How to support this project

PRs are welcome! You can also just pick one of the test list entries from above and implement the solution or implement your own idea. Fix a bug. Improve the docs... whatever suits you.

Greetings, 
Dominik

follow me on [Twitter](https://twitter.com/PanzerDominik) or [Mastodon](https://sw-development-is.social/web/@PanzerDominik)
