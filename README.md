# qucosa-json
Documentation and specification of JSON messages used in the Qucosa repository system.

Defines JSON Schema for all JSON based message formats.

# Testing

Message variants can be tested against the JSON schemas. For schema validation the `jsonschema` command is used. To run all the tests use the `bats` commmand.

To execute all tests run `bats` and pass the test directory as parameter. The output should read like this:
```
$ bats tests
 ✓ Validate minimal example
 ✓ Validate full example
 ✓ Fails if sourceID is missing

3 tests, 0 failures
```

## Installation

Both `jsonschema` and `bats` must be installed. On major Linux distributions this should be possible with
`$ sudo apt-get install jsonschema bats`.

If your Linux distribution does not provide these packages, have a look at the internet:
* https://github.com/bats-core/bats-core
* https://pypi.org/project/jsonschema/