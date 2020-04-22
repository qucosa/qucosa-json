prefix="[Config]"
schema="$BATS_TEST_DIRNAME/../schemas/config.json"
validator="justify -s $schema"

teardown() {
  rm -f $BATS_TMPDIR/test_*.json
}

@test "$prefix Validate schema" {
  $validator
}

@test "$prefix Fails on empty document" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{}' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}

@test "$prefix Validates minimal document" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

