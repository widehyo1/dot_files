.definitions
| to_entries[]
| .key as $schema_name
| .value.properties
| to_entries[]
| .key as $param_name
| [
  $schema_name,
  $param_name,
  .value.type
]
| @tsv
