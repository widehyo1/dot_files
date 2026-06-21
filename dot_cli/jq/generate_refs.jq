def path_segment:
  tostring
  | gsub("%"; "%25")
  | gsub("/"; "%2F");

def reference_path($outdir; $segments):
  "\($outdir)/\($segments | map(path_segment) | join("/"))";

def canonical_json:
  to_entries | sort_by(.key) | from_entries | tojson;

def primitive_label($values; $total):
  ($values | length) as $present
  | ([$values[] | type] | unique | sort) as $types
  | (if $types == ["null"] then "null"
     elif ($types | length) == 1 then $types[0]
     elif ($types | length) == 2 and $types[0] == "null" then "\($types[1])?"
     else $types | join("|")
     end) as $result
  | if $present < $total and $result != "null" and (($result | endswith("?")) | not) then
      "\($result)?"
    else
      $result
    end;

def primitive_array_label($arrays; $total):
  [$arrays[] | .[]] as $members
  | ([$members[] | type] | unique | sort) as $types
  | (if ($members | length) == 0 then "array(empty)"
     elif ($types | length) == 1 then "array(\($types[0]))"
     elif ($types | length) == 2 and $types[0] == "null" then "array(\($types[1])?)"
     else "array(\($types | join("|")))"
     end) as $result
  | if ($arrays | length) < $total then "\($result)?" else $result end;

def object_occurrences($segments; $role; $array_index):
  . as $value
  | ({segments: $segments, value: $value, role: $role}
     + (if $array_index == null then {} else {array_index: $array_index} end)),
    ($value | to_entries[] | . as $entry
     | if ($entry.value | type) == "object" then
         $entry.value | object_occurrences($segments + [$entry.key]; "object"; null)
       elif ($entry.value | type) == "array" then
         $entry.value | to_entries[] | select((.value | type) == "object")
         | . as $item
         | $item.value
         | object_occurrences($segments + [$entry.key]; "array_item"; $item.key)
       else
         empty
       end);

def schema_for_values($outdir; $segments; $objects):
  ($objects | length) as $total
  | ([$objects[] | keys_unsorted[]] | unique | sort) as $keys
  | reduce $keys[] as $key
      ({};
       ([$objects[] | select(has($key)) | .[$key]]) as $values
       | ([$values[] | type] | unique | sort) as $types
       | .[$key] =
           (if $types == ["object"] then
              reference_path($outdir; $segments + [$key]) + ".json"
            elif $types == ["array"] then
              ([$values[] | .[] | type] | unique | sort) as $member_types
              | if ($member_types | index("object")) != null then
                  if ($member_types | any(. != "object")) then
                    error("mixed object/non-object array at \(($segments + [$key]) | ("/"))")
                  else
                    reference_path($outdir; $segments + [$key]) + ".json"
                  end
                elif ($member_types | index("array")) != null then
                  error("nested array value at \(($segments + [$key]) | ("/"))")
                else
                  primitive_array_label($values; $total)
                end
            elif $types == ["null", "object"] then
              "object?"
            elif ($types | index("array")) != null then
              ([$values[] | select(type == "array") | .[] | type] | unique | sort) as $member_types
              | if ($member_types | index("object")) != null and ($member_types | any(. != "object")) then
                  error("mixed object/non-object array at \(($segments + [$key]) | ("/"))")
                else
                  $types | join("|")
                end
            elif ($types | index("object")) != null then
              $types | join("|")
            else
              primitive_label($values; $total)
            end));

def object_records($outdir; $occurrences):
  $occurrences
  | group_by(.segments)
  | map(. as $group
        | $group[0].segments as $segments
        | {schema_path: (reference_path($outdir; $segments) + ".json"),
           schema: schema_for_values($outdir; $segments; [$group[].value])})
  | map(. + {canonical: (.schema | canonical_json)})
  | group_by(.canonical)
  | .[]
  | . as $same
  | ([$same[].schema_path] | unique) as $paths
  | {schema_path: $paths[0], object_paths: $paths, schema: $same[0].schema};

def array_records($outdir; $items):
  $items
  | group_by(.segments)
  | .[]
  | . as $items_at_path
  | $items_at_path[0].segments as $segments
  | (reference_path($outdir; $segments)) as $array_base
  | [$items_at_path[]
     | {index: .array_index,
        schema: (.value | schema_for_values($outdir; $segments; [.]))}]
    as $schemas
  | ($schemas
     | map(. + {canonical: (.schema | canonical_json)})
     | group_by(.canonical)) as $groups
  | if ($groups | length) == 1 then
      {
        schema_path: ($array_base + ".json"),
        object_paths: [($array_base + ".json")],
        schema: $groups[0][0].schema
      }
    else
      {
        schema_path: ($array_base + ".json"),
        object_paths: [($array_base + ".json")],
        schema: {"$refs_mut": ($array_base + "/")}
      },
      (
        $groups
        | map(
            . as $same
            | {
                first_index: ([$same[].index] | min),
                same: $same
              }
          )
        | group_by(.first_index)
        | .[]
        | to_entries[]
        | . as $entry
        | ($entry.value.first_index) as $first_index
        | ($entry.key) as $collision_index
        | ($entry.value.same) as $same
        | (
            if $collision_index == 0 then
              ($first_index | tostring)
            else
              "\($first_index)_\($collision_index)"
            end
          ) as $file_stem
        | {
            schema_path: ($array_base + "/" + $file_stem + ".json"),
            object_paths: [($array_base + "/" + $file_stem + ".json")],
            schema: $same[0].schema,
            array_parent: ($array_base + ".json"),
            array_indexes: ([$same[].index] | sort | unique)
          }
      )
    end;

def root_collection_records($outdir; $items):
  $items
  | group_by(.segments)
  | .[]
  | . as $items_at_path
  | $items_at_path[0].segments as $segments
  | (reference_path($outdir; $segments)) as $collection_base
  | [$items_at_path[]
     | {index: .array_index,
        schema: (.value | schema_for_values($outdir; $segments; [.]))}]
    as $schemas
  | ($schemas
     | map(. + {canonical: (.schema | canonical_json)})
     | group_by(.canonical)) as $groups
  | if ($groups | length) == 1 then
      {schema_path: ($collection_base + ".json"),
       object_paths: [($collection_base + ".json")],
       schema: $groups[0][0].schema,
       array_parent: ($collection_base + ".json"),
       array_indexes: ([$schemas[].index] | sort | unique)}
    else
      ($groups[]
       | . as $same
       | ([$same[].index] | min) as $first_index
       | {schema_path: ($collection_base + "/" + ($first_index | tostring) + ".json"),
          object_paths: [($collection_base + "/" + ($first_index | tostring) + ".json")],
          schema: $same[0].schema,
          array_parent: ($collection_base + ".json"),
          array_indexes: ([$same[].index] | sort | unique)})
    end;

def distinct_schemas($outdir):
  . as $input
  | [$input[]
     | . as $entry
     | $entry.value
     | object_occurrences(
         $entry.path;
         (if $entry.collection == true then "root_collection" else "object" end);
         (if $entry.collection == true then $entry.index else null end))]
    as $occurrences
  | [object_records($outdir; ($occurrences | map(select(.role == "object"))))] as $objects
  | [array_records($outdir; ($occurrences | map(select(.role == "array_item"))))] as $arrays
  | [root_collection_records($outdir; ($occurrences | map(select(.role == "root_collection"))))] as $roots
  | $objects[], $arrays[], $roots[];

distinct_schemas($outdir)
