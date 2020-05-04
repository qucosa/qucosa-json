prefix="[Events]"
schema="$BATS_TEST_DIRNAME/../schemas/event.json"
validator="justify -s $schema"


teardown() {
  rm -f $BATS_TMPDIR/test_*.json
}

@test "$prefix Validate minimal example" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]

}

@test "$prefix Validate full example" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.event.transactionID": "f5561cb7-f0f8-43e5-9a5f-9d8f5055b458",
    "de.qucosa.event.occured": "2018-11-13T20:20:39+00:00",
    "de.qucosa.event.expires": "2019-12-13T20:20:39+00:00"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]

}

@test "$prefix Fails if sourceID is missing" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]

}