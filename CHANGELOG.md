# Change log

## master (unreleased)

### New features

* [#88](https://github.com/rootstrap/exception_hunter/pull/88) Add slack notifications. ([@andresg4][])
* [#93](https://github.com/rootstrap/exception_hunter/pull/93) Show project name instead of repo name on navbar. ([@yurichandra][])
* [#94](https://github.com/rootstrap/exception_hunter/pull/101) Allow user to ignore certain errors. ([@ajazfarhad][])

### Bug fixes

* [#98](https://github.com/rootstrap/exception_hunter/pull/98) Fix module_parent_name not present on rails < 6.0.0. ([@ivoloshy][], [@Snick555][])

### Changes

* [#99](https://github.com/rootstrap/exception_hunter/pull/100) Add CHANGELOG. ([@brunvez][])
* [#99](https://github.com/rootstrap/exception_hunter/pull/99) Add matrix testing. ([@brunvez][])
* [#92](https://github.com/rootstrap/exception_hunter/pull/92) Add documentation on how to test on dev. ([@brunvez][])
* [#87](https://github.com/rootstrap/exception_hunter/pull/87) Add manual tracking to documentation. ([@brunvez][])

## 0.4.2 (2020-09-17)

### Bug fixes

* [#84](https://github.com/rootstrap/exception_hunter/pull/84) Fix constants not being found correctly. ([@brunvez][])
* [#84](https://github.com/rootstrap/exception_hunter/pull/84) Fix error with no backtrace breaking the dashboard. ([@brunvez][])
* [#84](https://github.com/rootstrap/exception_hunter/pull/84) Fix manually tracked error having `nil` environment data. ([@brunvez][])

### Changes

* [#83](https://github.com/rootstrap/exception_hunter/pull/83) Add PR and ISSUE templates. ([@vitogit][])
* [#82](https://github.com/rootstrap/exception_hunter/pull/82) Create CONTRIBUTING.md. ([@vitogit][])
* [#81](https://github.com/rootstrap/exception_hunter/pull/81) Create CODE_OF_CONDUCT.md. ([@vitogit][])

## 0.4.1 (2020-07-20)

### Bug fixes

* [#77](https://github.com/rootstrap/exception_hunter/pull/77) Fix ErrorPresenter failing when the error does not have environment data. ([@SandroDamilano][])

## < 0.4.0

* Lots of features ([@t-romani][])

[@brunvez]: https://github.com/brunvez
[@andresg4]: https://github.com/andresg4
[@ivoloshy]: https://github.com/ivoloshy
[@SandroDamilano]: https://github.com/SandroDamilano
[@Snick555]: https://github.com/Snick555
[@t-romani]: https://github.com/t-romani
[@vitogit]: https://github.com/vitogit
[@yurichandra]: https://github.com/yurichandra
[@ajazfarhad]: https://github.com/ajazfarhad
