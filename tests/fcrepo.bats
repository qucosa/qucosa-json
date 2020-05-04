#!/usr/bin/bats

prefix="[Fcrepo]"
schemadir="$BATS_TEST_DIRNAME/../schemas"
validator="justify -r $schemadir/event.json -s $schemadir/fcrepo.json"

teardown() {
  rm -f $BATS_TMPDIR/test_*.json
}

@test "$prefix Fails on empty document" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{}' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
}

@test "$prefix Validates minimal message" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "org.fcrepo.jms.user": "bypassAdmin",
    "org.fcrepo.jms.eventID": "2096784f-8915-4f76-9114-10f516553554",
    "org.fcrepo.jms.identifier": "/test1",
    "org.fcrepo.jms.timestamp": "2018-11-13T20:20:39+00:00",
    "org.fcrepo.jms.baseURL": "http://localhost:8080/rest",
    "org.fcrepo.jms.resourceType": [
      "http://www.w3.org/ns/ldp#Container",
      "http://fedora.info/definitions/v4/repository#Resource"
    ],
    "org.fcrepo.jms.eventType": [
      "https://www.w3.org/ns/activitystreams#Create",
      "https://www.w3.org/ns/activitystreams#Update"
    ]
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
  
}

@test "$prefix Validates message with optional fields" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "org.fcrepo.jms.user": "bypassAdmin",
    "org.fcrepo.jms.eventID": "2096784f-8915-4f76-9114-10f516553554",
    "org.fcrepo.jms.identifier": "/test1",
    "org.fcrepo.jms.timestamp": "2018-11-13T20:20:39+00:00",
    "org.fcrepo.jms.baseURL": "http://localhost:8080/rest",
    "org.fcrepo.jms.resourceType": [
      "http://www.w3.org/ns/ldp#Container"
    ],
    "org.fcrepo.jms.eventType": [
      "https://www.w3.org/ns/activitystreams#Create"
    ],
    "org.fcrepo.jms.userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/66.0.3359.117 Safari/537.36",
    "de.qucosa.object.owner": "slub"
  }' > $tmp

  run $validator -i $tmp
  [[ $status = 0 ]]
  
}

@test "$prefix Failes if eventID is not UUID" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "org.fcrepo.jms.user": "bypassAdmin",
    "org.fcrepo.jms.eventID": "!!not-uuid!!",
    "org.fcrepo.jms.identifier": "/test1",
    "org.fcrepo.jms.timestamp": 1524580811763,
    "org.fcrepo.jms.baseURL": "http://localhost:8080/rest",
    "org.fcrepo.jms.resourceType": [
      "http://www.w3.org/ns/ldp#Container",
      "http://fedora.info/definitions/v4/repository#Resource"
    ],
    "org.fcrepo.jms.eventType": [
      "https://www.w3.org/ns/activitystreams#Create",
      "https://www.w3.org/ns/activitystreams#Update"
    ]
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
  
}

@test "$prefix Failes if timestamp is negative" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "org.fcrepo.jms.user": "bypassAdmin",
    "org.fcrepo.jms.eventID": "2096784f-8915-4f76-9114-10f516553554",
    "org.fcrepo.jms.identifier": "/test1",
    "org.fcrepo.jms.timestamp": -1,
    "org.fcrepo.jms.baseURL": "http://localhost:8080/rest",
    "org.fcrepo.jms.resourceType": [
      "http://www.w3.org/ns/ldp#Container",
      "http://fedora.info/definitions/v4/repository#Resource"
    ],
    "org.fcrepo.jms.eventType": [
      "https://www.w3.org/ns/activitystreams#Create",
      "https://www.w3.org/ns/activitystreams#Update"
    ]
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
  
}

@test "$prefix Failes if resourceType is string" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "org.fcrepo.jms.user": "bypassAdmin",
    "org.fcrepo.jms.eventID": "2096784f-8915-4f76-9114-10f516553554",
    "org.fcrepo.jms.identifier": "/test1",
    "org.fcrepo.jms.timestamp": 1524580811763,
    "org.fcrepo.jms.baseURL": "http://localhost:8080/rest",
    "org.fcrepo.jms.resourceType": "http://www.w3.org/ns/ldp#Container",
    "org.fcrepo.jms.eventType": [
      "https://www.w3.org/ns/activitystreams#Create",
      "https://www.w3.org/ns/activitystreams#Update"
    ]
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
  
}

@test "$prefix Failes if eventType contains invalid item" {
  tmp="$BATS_TMPDIR/$BATS_TEST_NAME.json"
  echo '{
    "de.qucosa.event.version": "1.0",
    "de.qucosa.event.sourceID": "urn:fcrepo3:sdvcmr-app03",
    "org.fcrepo.jms.user": "bypassAdmin",
    "org.fcrepo.jms.eventID": "2096784f-8915-4f76-9114-10f516553554",
    "org.fcrepo.jms.identifier": "/test1",
    "org.fcrepo.jms.timestamp": 1524580811763,
    "org.fcrepo.jms.baseURL": "http://localhost:8080/rest",
    "org.fcrepo.jms.resourceType": [
      "http://www.w3.org/ns/ldp#Container",
      "http://fedora.info/definitions/v4/repository#Resource"
    ],
    "org.fcrepo.jms.eventType": [
      "https://www.w3.org/ns/activitystreams#Invalid"
    ]
  }' > $tmp

  run $validator -i $tmp
  [[ $status != 0 ]]
  
}
