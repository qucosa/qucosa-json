#!/usr/bin/bats

validator="jsonschema"
schema="$BATS_TEST_DIRNAME/../schemas/event.json"

@test "Validate minimal example" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03"
  }' > $tmp

  run $validator -i $tmp $schema
  [[ $status = 0 ]]

}

@test "Validate full example" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.event.transactionID": "f5561cb7-f0f8-43e5-9a5f-9d8f5055b458",
    "de.qucosa.event.expires": 1524580811763
  }' > $tmp

  run $validator -i $tmp $schema
  [[ $status = 0 ]]

}

@test "Fails if sourceID is missing" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0"
  }' > $tmp

  run $validator -i $tmp $schema
  [[ $status = 1 ]]

}