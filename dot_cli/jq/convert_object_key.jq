def convert_object_key(root_key):
  (root_key // "") as $root_key
  | with_entries(
    .key =
      (if $root_key == "" then "" else $root_key + "_" end)
      + .key
      + (if (.value | type) == "array" then "_item" else "" end)
  );

# ..
# | objects
# | convert_object_key("test")
