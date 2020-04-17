#!/usr/bin/bats

schema="$BATS_TEST_DIRNAME/../schemas/result.json"
validator="justify -s $schema"

teardown() {
  rm -f $BATS_TMPDIR/test_*.json
}

@test "Fails on empty document" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{}' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "Validates minimal message with only proc.uri" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.proc.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.uri" : "http://foo.bar/xml/2"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "Validates minimal message with encoded content" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.proc.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "TG9yZW0gaXBzdW0=",
    "de.qucosa.proc.contentEncoding" : "base64",
    "de.qucosa.proc.contentType" : "application/vnd.qucosa.mets+xml"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}

@test "Failes if content encoding is not specified" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.proc.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "TG9yZW0gaXBzdW0=",
    "de.qucosa.proc.contentType" : "application/vnd.qucosa.mets+xml"
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "Failes if content type is not specified" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.proc.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "TG9yZW0gaXBzdW0=",
    "de.qucosa.proc.contentEncoding" : "base64",
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "Failes if encoded content is not base64" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.proc.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "1235-abc",
    "de.qucosa.proc.contentEncoding" : "base64",
    "de.qucosa.proc.contentType" : "application/vnd.qucosa.mets+xml"
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "Allows text content" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version" : "1.0",
    "de.qucosa.event.sourceID" : "urn:fcrepo3:sdvcmr-app03",
    "de.qucosa.proc.sourceID" : "urn:camel:disseminate-mets:sdvcmr-camel02",
    "de.qucosa.proc.content" : "This is text content",
    "de.qucosa.proc.contentEncoding" : "text",
    "de.qucosa.proc.contentType" : "text/plain"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
}
