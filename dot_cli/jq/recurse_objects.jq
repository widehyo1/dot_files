def recurse_objects:
  . as $node
  | if type == "object" then
      $node,
      (.[] | recurse_objects)
    elif type == "array" then
      .[] | recurse_objects
    else
      empty
    end;
