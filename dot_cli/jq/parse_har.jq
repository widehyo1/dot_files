.log
| (.pages[0].title) as $domain
| .entries
| (first | keys) as $keys
| [.[]]
| map(.request)
| [{method: .[].method, url: .[].url}]
| [.[] | .url | select(
  (
    endswith("js")
    or endswith("png")
    or endswith("jpg")
    or endswith("svg")
    or endswith("ico")
    or endswith("woff")
    or endswith("woff2")
  ) | not
)
]
| sort
| unique
