[![Run abaplint](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/lint.yml/badge.svg)](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/lint.yml)
[![Run Unit Tests](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/unittest.yml/badge.svg)](https://github.com/dominikpanzer/cacamber-BDD-for-ABAP/actions/workflows/unittest.yml)
[![Twitter](https://img.shields.io/twitter/follow/PanzerDominik?style=social)](https://twitter.com/PanzerDominik)

# Cacamber - the BDD-Framework for ABAP

Hi! Cacamber makes it possible for you to run BDD-style tests in a SAP-system. [Behavior driven development](https://en.wikipedia.org/wiki/Behavior-driven_development) is an agile approach to software development. It focusses on collaboration through a common language between the customer and developers, testers etc. by defining examples which describe the behavior of a software system in a natural language. This language has a specific format and is called [Gherkin](https://cucumber.io/docs/gherkin/). In English when using the [ubiquitous language](https://martinfowler.com/bliki/UbiquitousLanguage.html) it looks like this:
```
Feature: Discount calculation

Scenario: Discount on Slayer albums for VIP Slayer fans (exclusive contract with BMG)

Given the customers first name is Dominik and his last name is Panzer
and his birthdate according to our CRM system is 06.06.2006
when the sales clerk lets the system calculate the customers discount on a Slayer album
then the discount is 66% \m/
```
These scenarios or examples will be delivered by the business or ideally by the (3 amigos)[https://automationpanda.com/2017/02/20/the-behavior-driven-three-amigos/] and will be used as executable specifications. You guessed it right: automated Tests! So how can we execute those scenarios as automated tests?

You might already know the `given ... when ... then` pattern. It's quite similar to `arrange ... act ... assert`. They are both techniques to give tests a clear structure. In ABAP this usually looks like this. We focus on the the feature, give the test method an according name and write an acceptance test:

```ABAP
METHOD discount_calculation.
* given
sut->do_this( parameter ).
sut->do_that( parameter ).
"more complex stuff here
DATA(product) = |Slayer Album|.


* when
DATA(discount) = sut->calculate( product ).

* then
cl_abap_unit_assert=>assert_equals(  exp = 66 act = discount ).
ENDMETHOD
```
The `given ... when ... then` comments are not very helpful. Also the individual parts of the test are not reusable. And the whole test is not very domain-centric compared to the scenario the business actually defined.

So some people wanted to do better and started writing their tests like this:

```ABAP
METHOD discount_on_slayer_albums.
given_cstmr_first_last_brthdy( EXPORTING first_name = 'Dominik'
                                         last_name = 'Panzer'
                                         birthdate = '20060606' ).
when_the_price_is_calculated_for( 'Slayer Album' ).
then_the_discount_is_correct( ).
ENDMETHOD
```
Thats way better! Persoanlly I only know one ABAP project with such kind of tests. Most of the details and complexity are hidden behind well named methods - another level of abstraction has been introduced. Also there is the possibility to change the test parameters. This make the steps of the test more flexible and reusable. But using parameterless methods would make the code more readable.

But this solution is no way near our original testcase description. It's not natural language, it is mainly code. Also this approach is limited by ABAPs maximum method length. Developers are forced to use abbreviations etc.

If you choose to use Cacamber as a bridge between the scenario written in plain Gherkin and ABAP Unit, your test steps will look like this:
```ABAP
METHOD discount_on_slayer_albums.
scenario( 'Discount on Slayer albums for VIP Slayer fans (exclusive contract with BMG)' ).
    
given( 'the customers first name is Dominik and his last name is Panzer' ).
and( 'his birthdate according to our CRM system is 06.06.2006' ).
when( 'the sales clerk lets the system calculate the customers discount on a Slayer album' ).
then( 'the discount is 66% \m/' ).
ENDMETHOD.
```
  
If it fails ABAP Unit can tell you this way:
```
...
Critical Assertion Error: 'Discount Calcuation: Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)'
...
```
Your tests can even look like this:
```ABAP
METHOD discount_on_a_shopping_cart.
scenario( 'Discount voucher applied to whole shopping card' ).
    
given( 'the customers has the following items in his shopping cart:' &&
         '| 2 | Slayer           | Reign In Blood  | LP | 9,99€ |' &&
         '| 1 | Slayer           | South Of Heaven | LP | 9,99€ |' &&
         '| 1 | David Hasselhoff | Crazy For You   | LP | 9,99€ |' ).
and( 'he adds a valid 10% voucher' ).
when( 'the customer checks out' ).
then( 'the discount is 4€.' ).
ENDMETHOD.
```
  
Have I sparked your interest? Great.

## Example
If you don't like to read docs, check out the example class ZCL_BDD_EXAMPLE, which shows how to use Cacamber. It's an implementation of the above scenario "Discount on Slayer albums for VIP Slayer fans (exclusive contract with BMG)".

## The BDD cycle when using Cacamber
BDDs main target is to deliver quality software by making the communication between different team members easier. But most people just think about tools like Cucumber (or Cacamber ;-)) and test automation whenever they hear about BDD.

So how does BDD work and how does Cacamber fit in? Let us have a look:
1. Identify the important business features for your software and prioritize them.
1. Identify different scenarios of these features and prioritize them.
1. Define acceptance test descriptions for these scenarios. Use the Gherkin language for this. Make sure the whole team understands them. Scenarios are no technical descriptions. They describe the users intention, what the user actually does and what he wants to achive.
1. Write the first scenario with Cacamber consisting of the relevant steps and place an `ASSERT` in the `THEN` step method. A step method needs to be a public method of your test class. Make sure there is just one `THEN`. You will need to inherit your test class from `ZCL_CACAMBER` and define a `FEATURE` and the `CONFIGURATION` for the steps in the `SETUP` of your test class. You will also need a test method, add a `SCENARIO` and different steps using `GIVEN`, `WHEN`, `THEN` and the other available methods.
1. The new test method will most likely fail with an exception, because the step methods are not implemented or the `ASSERT` failed. It might also go green, if the step methods are already implemented and the existing business logic is able to pass the criteria of the `ASSERT`. Then you are done.
1. If the scenario fails, you will most likely need to write a new method for your business logic. Use TDD for this: Red-Green-Refactor. When your TDD tests are green, place the newly created or changed method into your step method. There might be more than one method call to your business logic in a single step method. You will also need to save results of your business logic in attributes, so other step methods can access it (one step calculates a value, the next step validates it etc.)
1. Repeat unti your scenario is green.
1. Refactor.
1. Start with the next scenario and reuse your steps methods.

If this is too high level for you, have a look at the example implementation `ZCL_BDD_EXAMPLE` or check out the API description.

## Cacamber API

This part of the document describes the public methods of Cacamber. To get startet, your local test class needs to inherit from `ZCL_CACAMBER`.

`ZCL_CACAMBER` as your superclass provides the following public methods:

### FEATURE
The `FEATURE` method is optional and can be used to structure your test cases in a domain-centric way. Usually one test class will represents one feature, e.g. "discount calculation". This method has to be used in the `SETUP` of your test class. A `FEATURE` can be used to enhance the `MSG` parameter of your asserts.

Importing parameters:
* `FEATURE` - the name of your feature, max. 255 characters long

Example:
```ABAP 
...
feature( 'Discount Calcuation' ).
...
cl_abap_unit_assert=>assert_equals( msg = current_feature exp = expected act = actual ).
...
```

### CONFIGURE
The method `CONFIGURE` maps a regex-string to a method, which should be executed whenever the regex matches. This is called a step. If you are not a regex-pro, you can use tools like [regex101](https://regex101.com/) to make things easier. Inside the regex you can use (.+) or other matchers to extract the variables from the string, which will be used by Cacamber as parameters for the method call. The order of the variables must match the order of the parameters of the step method which should be called when the regex matches. The configuration is usually done in the `SETUP`-method of your test class.

Supported types and regular expressions:
Currently Cacamber is able to handle the following basic datatypes, which you can use in your step methods parameters. You can also use DDIC types based on these.
| datatype | example matcher | description | example value |
|----------|-----------------|-------------|---------|
| `STRING` | ^hello (.+)$ | a string can basically by anything, use this as a fallback, ALPHA IN will be applied | Dominik |
| `DATE` | ^today is (.+)$ | DD.MM.YYYY a date will automatically be converted to internal format | 24.12.2023 |
| `TIMS`| ^it's (.+) o'clock$ | HH:MM:SS a time will automatically be converted to internal format | 14:01:00 |
| `CHAR`| ^add (.+) to cart$ | a character sequence | book |
| `INTEGER`| ^I am (.+) years old$ | for positive or negative integers | -200 |
| `PACKED` | ^the price is (.+) | a number with decimals seperated by a _dot_ | 1001.50 |
| datatable | ^Slayer had the following members:(.+) | a line or a table | see section about datatables |


Importing parameters:
* `PATTERN` - a REGEX-string which is used as a matcher
* `METHODNAME` - name of a _public_ method of your _test class_ with a matching interface. Can be upper or lower case.

Example:
```ABAP 
...
configure->( pattern = '^the customers first name is (.+) and his last name is (.+)$' methodname = 'set_first_and_second_name' ).
...
```
The public method of your test class then must look like this:
```ABAP 
...
PUBLIC SECTION.
METHODS set_first_and_second_name IMPORTING first_name TYPE char30
                                            last_name  TYPE char30.
...
METHOD set_first_and_second_name.
discount_calculator->set_first_name( first_name ).
discount_calculator->set_last_name( last_name ).
ENDMETHOD.
```

### SCENARIO
A scenario describes a variant of a feature and represents a test case. Therefore the `SCENARIO` method is usually used as the first method call in a test method of your local test class. A `SCENARIO` can be used to enhance the `MSG` parameter of your asserts.

Importing parameters:
* `SCENARIO` - the name of the scenario, max. 255 characters long

Example:
```ABAP 
...
scenario( 'Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)' ).
...
cl_abap_unit_assert=>assert_equals( msg = current_scenario exp = expected act = actual ).
...
```

### EXAMPLE
The method `EXAMPLE` works the same way `SCENARIO` does. 

Importing parameters:
* `SCENARIO` - the name of the scenario, max. 255 characters long

Example:
```ABAP 
...
example( 'Discount on Slayer Albums for VIP Slayer fans (exclusive contract with BMG)' ).
...
cl_abap_unit_assert=>assert_equals( msg = current_scenario exp = expected act = actual ).
...
```

### RULE
With the method `RULE` you can describe a single business rule which will be implemented. It can be used in your local test methods just like `SCENARIO` or `EXAMPLE`. A `RULE` can be used to enhance the `MSG` parameter of your asserts.

Importing parameters:
* `RULE` - description of a business rule, max. 255 characters long

Example:
```ABAP 
...
rule( 'only VIP customers can buy the album 7 days before the officiall realease date' ).
...
cl_abap_unit_assert=>assert_equals( msg = current_rule exp = expected act = actual ).
...
```

### GIVEN
The `GIVEN` method is an actual keyword of the Gherkin language. It represents a step. A BDD test case consists of steps which combined represent an expectation of the bahavior of the system. The paramter `STEP` will be matched against the regex-patterns of the configuration to find an actual method to process the data provided by the step.
A step can use any supported data type. If this doesnt suit your usecase, import the variable as a `STRING` into your step method and convert it there. 

Importing parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
given( 'the customers first name is Dominik and his last name is Panzer' ).
...
given( 'the customers has the following items in his shopping cart:' &&
         '| 2 | Slayer           | Reign In Blood  | LP | 9,99€ |' &&
         '| 1 | Slayer           | South Of Heaven | LP | 9,99€ |' &&
         '| 1 | David Hasselhoff | Crazy For You   | LP | 9,99€ |' ).
...
```

### AND 
Also a Gherkin keyword to write tests in a natural language. The method `AND` works like `GIVEN`.

Importing parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
and( 'his birthdate according to our CRM system is 06.06.2006' ).
...
```

### OR
Also a Gherkin keyword to write tests in a natural language. The method `OR` works like `GIVEN`.

Importing parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
or( 'his birthdate according to our CRM system is 01.01.2001' ).
...
```

### BUT
Also a Gherkin keyword to write tests in a natural language. The method `Bb` works like `GIVEN`.

Importing parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
but( 'today is not the Monday' ).
...
```

### _ (underscore)
The underscore method `_` can be used to define a list, because `-` is not an allowed name for a method in ABAP.

Importing parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
``ABAP 
...
given( 'in the shopping cart there are: ).
_( '3 laptops' ).
_( '5 ipads' ).
_( '1 Slayer album' ).
-( '1 David Hassehoff album' ).
...
```

### WHEN 
Also a Gherkin keyword to write tests in a natural language. It usually desribes an action.  The method `WHEN` works like `GIVEN`.

Importing parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
when( 'the sales clerk lets the system calculate the customers discount on a Slayer Album' ).
...
```

### THEN 
Also a Gherkin keyword to write tests in a natural language. It describes an expected reaction of the system. The method `THEN` works like `GIVEN`.

Importing parameters:
* `STEP` - a string describing something relevant to the business using the ubiquitious language.

Example:
```ABAP 
...
then( 'the discount is 66% \m/' ).
...
```
## Datatable API
If you want to use datatables in your steps, you can use the class `ZCL_DATATABLE` to work with them in your test methods.

### FROM_STRING
To parse the table defined in your step to a datatable, you have to use the static method `TO_STRING`. 

Importing parameters:
* `TABLE_AS_STRING` - the table from your step configuration which has been extracted via your regex.
Returning parameters:
* `DATATABLE`- instance of `ZCL_DATATABLE`

Example:
```ABAP 
CLASS testclass DEFINITION FINAL FOR TESTING INHERITING FROM zcl_cacamber DURATION SHORT RISK LEVEL HARMLESS.

PUBLIC SECTION.
METHODS: process_shopping_cart IMPORTING shopping_cart_raw TYPE string.
...
PRIVATE SECTION.
METHODS: setup.
METHODS: no_discount_on_shopping_cart FOR TESTING RAISING cx_static_check.
...

CLASS testclass IMPLEMENTATION.
METHOD setup.
...
configure( pattern = '^in his shopping cart are the following items:(.*)$' methodname = 'process_shopping_cart' ).
...
ENDMETHOD.

METHOD process_shopping_cart.
shopping_cart = zcl_datatable=>from_string( shopping_cart_raw ).
ENDMETHOD.

METHOD no_discount_on_shopping_cart.
scenario( 'Customer is not eligable for a discount on the shopping cart' ).
given( 'in his shopping cart are the following items:' &&
         '| 1 | Scooter - Hyper Hyper |' &&
         '| 1 | Scooter - How Much Is The Fish |' &&
         '| 1 | Scooter - Maria (I like it loud) |' ).
...
ENDMETHOD.
...
```

### READ_ROW
With `READ_ROW` you can get the values of all columns of a certain row of your table as a table of strings for further processing.

Importing parameters:
* `ROWNUMBER` - the number of the row you want to read
Returning parameters:
* `LINE` - the values of the cells of the row as a string table

Example:
```ABAP
...
DATA(line) = datatable->read_row( 666 ).
...
```

### READ_CELL
With `READ_CELL` you can get the values of a cell of your table

Importing parameters:
* `ROWNUMBER` - the number of the row you want to read
* `COLUMNNUMBER` - the number of the column you want to read
Returning parameters:
* `VALUE` - the values of the cell as a string for further processing

Example:
```ABAP
...
DATA(cell) = datatable->read_cell( rownumber = 23 columnnumber = 23 ).
...
```

### TO_TABLE
`TO_TABLE` will transform your datatable into a plain internal table of a specified table type.

Importing parameters:
* `DDIC_TABLE_TYPE_NAME` - the name of a table type
Exporting parameters:
* `TABLE` - the converted table

Example:
```ABAP
...
DATA internal_table  TYPE ztt_bdd_demo.
datatable->to_table( EXPORTING ddic_table_type_name = 'ZTT_BDD_DEMO'
                     IMPORTING table = internal_table ).
...
```


## How to install Cacamber
You can copy and paste the source code into your system or simply clone this repository with [abapGit](https://abapgit.org/). There are currently no dependencies and it should work on 7.x systems.

## Feature List
I like to create a simple [acceptance test list](https://agiledojo.de/2018-12-16-tdd-testlist/) or feature lists before I start coding. It's my personal todo-list. Often the list is very domain-centric, this one is quite technical.

|Feature List|
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
:white_check_mark: update the docs 👹
:black_square_button: fix the linter / unit tests 
:white_check_mark: a user can use a float number in the tests (1000.25) and it is parsed into a packed datatype succcessfully
:white_check_mark: a user can use a time in the test (12:00:00 or 14:01:00) and it is parsed into TIMS datatype successfully
:white_check_mark: update the docs 👹
:black_square_button: find beta testers
:black_square_button: refactor to `RESULT`
:black_square_button: your awesome idea

## Cacamber vs. other Gherkin frameworks / solution architecture
There are many frameworks out there for other programming languages which support Gherkin. Usually there are textfiles which contain the tests and test classes, which have annotations to map the scenarios to the different step methods. Thats great. But seemed quite complicated to me in the SAP world (textfile handling, parsing own sourcecode for annotations, maybe generating sourcecode or even writing a test framework). So I decided to implement it the way I did now just to see, if the general concept of BDD is something the ABAP community finds valueable. The next step might be to enhance Cacamber for textfile-parsing or introduce a database concept.

## How to support this project

PRs are welcome! You can also just pick one of the test list entries from above and implement the solution or implement your own idea. Fix a bug. Improve the docs... whatever suits you.

Greetings, 
Dominik

follow me on [Twitter](https://twitter.com/PanzerDominik) or [Mastodon](https://sw-development-is.social/web/@PanzerDominik)
