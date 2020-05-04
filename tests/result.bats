prefix="[Results]"
schemadir="$BATS_TEST_DIRNAME/../schemas"
schema="result.json"
validator="justify -r $schemadir/event.json -s $schemadir/$schema"

teardown() {
  rm -f $BATS_TMPDIR/test_*.json
}

@test "$prefix Fails on empty document" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{}' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "$prefix Validates minimal message with only proc.uri" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.uri" : "http://foo.bar/xml/2"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Validates minimal message with encoded content" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "TG9yZW0gaXBzdW0=",
    "de.qucosa.proc.contentEncoding" : "base64",
    "de.qucosa.proc.contentType" : "application/vnd.qucosa.mets+xml"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Failes if content encoding is not specified" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "TG9yZW0gaXBzdW0=",
    "de.qucosa.proc.contentType" : "application/vnd.qucosa.mets+xml"
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "$prefix Failes if content type is not specified" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "TG9yZW0gaXBzdW0=",
    "de.qucosa.proc.contentEncoding" : "base64",
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "$prefix Failes if encoded content is not base64" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "1235-abc",
    "de.qucosa.proc.contentEncoding" : "base64",
    "de.qucosa.proc.contentType" : "application/vnd.qucosa.mets+xml"
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "$prefix Allows text content" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "This is text content",
    "de.qucosa.proc.contentEncoding" : "text",
    "de.qucosa.proc.contentType" : "text/plain"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "$prefix Metric time can not be negative" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.uri" : "http://foo.bar/xml/2",
    "de.qucosa.proc.metric.time": -1
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]

}

@test "$prefix Cycle time can not be negative" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.uri" : "http://foo.bar/xml/2",
    "de.qucosa.proc.metric.cycleTime": -1
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]

}

@test "$prefix Actions must be an array of strings" {

  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.uri" : "http://foo.bar/xml/2",
    "de.qucosa.proc.actions" : [
        "Schema validation successful",
        1,
        null
    ],
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 1 ]]

}