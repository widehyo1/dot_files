.paths
| to_entries[]
| . as $path_entry
| $path_entry.value
| to_entries[]
| select(.key | test("^(get|post|put|patch|delete|options|head)$"))
| . as $op
| .value
| (
  (.responses // {} | to_entries[]) as $resp_entry
  | .parameters // []
  | map({
    path: $path_entry.key,
    method: $op.key,
    param_name: .name,
    param_type: .type,
    param_in: .in,
    schema_ref: (.schema["$ref"] // ""),
    resp_code: $resp_entry.key,
    resp_schema: (
      $resp_entry.value.schema["$ref"] // ""
    )
  })
)
| .[]
| [
.path,
.method,
.param_name,
.param_type,
.param_in,
.schema_ref,
.resp_code,
.resp_schema
]
| @tsv
