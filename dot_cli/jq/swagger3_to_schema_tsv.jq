def schema_types:
  (
    .type
    // ((.anyOf // []) | map(.type))
    // empty
  ) as $t
  | if ($t | type) == "array" then
      $t
    else
      [$t]
    end
  | join("|");

.components
| .schemas
| to_entries[]
| .key as $schema_name
| .value.properties
| to_entries[]
| .key as $param_name
| .value
| [
  $schema_name,
  $param_name,
  schema_types
]
| @tsv
