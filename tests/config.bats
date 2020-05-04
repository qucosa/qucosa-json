prefix="[Config]"
schemadir="$BATS_TEST_DIRNAME/../schemas"
validator="justify -r $schemadir/event.json -s $schemadir/config.json"

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

@test "$prefix Validates changes property object" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2",
    "de.qucosa.config.changes": {
      "number": {
        "before": 1000,
        "after": 2000
      },
      "anObject": {
                "before": { "a": "A" },
                "after": { "a": "B" }
      }
    }
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Failes if changes property is not an object" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2",
    "de.qucosa.config.changes": ""
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}

@test "$prefix Failes if changes property contains non-objects" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2",
    "de.qucosa.config.changes": {
      "some": 1
    }
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}

@test "$prefix Failes if changes property contains null" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2",
    "de.qucosa.config.changes": {
      "some": null
    }
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}

@test "$prefix Failes if 'before' property is missing in changes object" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:kitodo:publication",
    "de.qucosa.config.uri": "https://foo.bar/configuration/xml/2",
    "de.qucosa.config.changes": {
      "number": {
        "after": 2000
      }
    }
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}
