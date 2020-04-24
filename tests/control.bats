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