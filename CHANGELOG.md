# Cacamber - BDD for ABAP Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.1] - 2023-05-30

### Added

- none

### Fixed

- unit tests on Github are now running fine

### Changed

- none

### Removed

- none

## [1.1.0] - 2023-05-26

### Added

- support for german keywords (class `ZCL_CACAMBER_GERMAN`) (verfiy-feature + keyword-methods)
- keywords for `VERIFY` etc. can be configured in the constructor to enable i18n. just write a wrapper, example see `ZCL_CACAMBER_GERMAN`
- current scenario / rule / feature can be accessed by public getters

### Fixed

- test examples did a wrong date comparsion

### Changed

- in the past Cacamber threw the exception `ZCX_CACAMBER_ERROR` when the framework couldn't find a step method or something else was wrong. The exception now has aadditional texts that descibe the actual problem so the user can change his configuration/coding accordingly.

### Removed

- none

## [1.0.0] - 2023-05-19

### Added

- first public release

### Fixed

- none

### Changed

- none

### Removed

- none
