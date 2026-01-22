BEGIN {
  FS = "\t"
}

{
  key = $1 "|" $2

  path[key] = $1
  method[key] = toupper($2)

  if ($5 == "header")
    headers[key] = headers[key] " -H \"" $3 ": " $6 "\""

  else if ($5 == "cookie")
    cookies[key] = cookies[key] ($6 "; ")

  else if ($5 == "query")
    query[key] = query[key] (query[key] ? "&" : "") $3 "=" $6

  else if ($5 == "body")
    body[key] = $6
}

END {
  for (k in path) {
    url = "http://localhost:8080" path[k]
    if (query[k] != "")
      url = url "?" query[k]

    printf "curl -X %s \\\n", method[k]
    printf "  \"%s\" \\\n", url

    if (headers[k] != "")
      printf "  %s \\\n", headers[k]

    if (cookies[k] != "")
      printf "  -H \"Cookie: %s\" \\\n", cookies[k]

    if (body[k] != "")
      printf "  -H \"Content-Type: application/json\" \\\n  -d '%s' \\\n", body[k]

    print ""
  }
}

