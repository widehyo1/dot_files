def resp_type:
  (.value.schema // {}) as $schema
  | if ($schema | has("$ref")) then
      $schema["$ref"]
    elif ($schema | has("type")) then
      $schema.type
    else
      ""
    end;

def row:
  [
    .path,
    .method,
    .param_name,
    .param_type,
    .param_in,
    .schema_ref,
    .resp_code,
    .resp_schema,
    .resp_description
  ];

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
      $resp_entry.value.content
      | to_entries[]
      | resp_type
    ),
    resp_description: $resp_entry.value.description
  })
)
| .[]
| row
| @tsv
