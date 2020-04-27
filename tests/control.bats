prefix="[Control]"
schema="$BATS_TEST_DIRNAME/../schemas/control.json"
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
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.control.targetID": "urn:sitemap:register",
    "de.qucosa.control.message": {}
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Requires at least one header when no message is given" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.control.targetID": "urn:sitemap:register"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}

@test "$prefix Failes if header is not an object" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.control.targetID": "urn:sitemap:register",
    "de.qucosa.control.headers": null
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}