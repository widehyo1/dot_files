def array_types:
  [ .[] | type ] | unique | sort;

def is_object_array:
  type == "array" and ((array_types) == ["object"]);

def is_homogeneous_array:
  type == "array" and ((array_types | length) == 1);

def is_nullable_homogeneous_array:
  type == "array"
  and ((array_types | length) == 2)
  and ((array_types | .[0]) == "null");

def array_schema:
  array_types as $t
  | (if length == 0 then
      "array(empty)"
    elif $t == ["object"] then
      "array(ref)"
    elif ($t | length) == 1 then
      "array(\($t[0]))"
    elif ($t | length) == 2 and $t[0] == "null" then
      "array(\($t[1])?)"
    else
      "array(\($t | join("|")))"
    end
  );

# ..
# | select(type == "array")
# | array_schema
