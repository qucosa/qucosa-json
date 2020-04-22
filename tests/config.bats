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
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Validates modified date" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2",
    "de.qucosa.config.modified": "2018-11-13T20:20:39+00:00"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Failes on invalid modified date" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2",
    "de.qucosa.config.modified": "13.11.18, 20:00 Uhr"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}