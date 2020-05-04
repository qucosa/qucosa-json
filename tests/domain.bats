prefix="[Domain]"
schemadir="$BATS_TEST_DIRNAME/../schemas"
validator="justify -r $schemadir/event.json -s $schemadir/domain.json"

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

@test "$prefix Failes if required fields are empty" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.domain.name": "",
    "de.qucosa.domain.type": "",
    "de.qucosa.domain.subject": ""
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}

@test "$prefix Validates minimal document" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.domain.name": "qucosa",
    "de.qucosa.domain.type": "published",
    "de.qucosa.domain.subject": "document"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Validates document with subtype property" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.domain.name": "qucosa",
    "de.qucosa.domain.type": "published",
    "de.qucosa.domain.subject": "document",
    "de.qucosa.domain.subtype": "embargoed"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Schema reference requires data property" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.domain.name": "qucosa",
    "de.qucosa.domain.type": "published",
    "de.qucosa.domain.subject": "document",
    "de.qucosa.domain.schema": "https://www.qucosa.de/api/schemas/publication.json"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]
}

@test "$prefix Data property has to be an object" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:qucosa-manager:workflow/publication",
    "de.qucosa.domain.name": "qucosa",
    "de.qucosa.domain.type": "published",
    "de.qucosa.domain.subject": "document",
    "de.qucosa.domain.data": {}
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}