![Test](https://github.com/qucosa/qucosa-json/workflows/Test/badge.svg)

# qucosa-json
Documentation and specification of JSON messages used in the Qucosa repository system.

Defines JSON Schema for all JSON based message formats.

# Testing

Message variants can be tested against the JSON schemas. For schema validation the `justify` command is used. To run all the tests use the `bats` commmand.

To execute all tests run `./run-tests.sh`. The output should read like this:
```
$ ./run-tests.sh 
Using Bats 0.4.0
Justify is present
Testing...
 ✓ Validate minimal example
 ✓ Validate full example
 ✓ Fails if sourceID is missing

3 tests, 0 failures
```

To execute individual tests run `bats` and pass the files you want to run as parameter. E.g:
```
$ bats tests/event.bats
 ✓ Validate minimal example
 ✓ Validate full example
 ✓ Fails if sourceID is missing

3 tests, 0 failures
```

## Installation

Both `justify` and `bats` must be installed. On major Linux distributions `bats` should be available via
`$ sudo apt-get install bats`. The `justify` Java code can be found on GitHub.

* https://github.com/bats-core/bats-core
* https://github.com/leadpony/justify