local common = require('common')
local b_local = { buffer = 0 }

common.add_snippet("post", "---\nlayout: post\ntitle: ${1:title}\nsubtitle: ${2:subtitle}\ntags: [${3:tag}]\ncomments: true\nauthor: widehyo\n---", b_local)

common.add_snippet("bash", "```bash\n${1:-- path}\n```", b_local)
common.add_snippet("java", "```java\n${1:// path}\n```", b_local)
common.add_snippet("js", "```js\n${1:// path}\n```", b_local)
common.add_snippet("py", "```py\n${1:# path}\n```", b_local)
common.add_snippet("jq", "```jq\n${1:# path}\n```", b_local)
common.add_snippet("awk", "```awk\n${1:# path}\n```", b_local)
common.add_snippet("log", "```log\n${1:content}\n```", b_local)
common.add_snippet("json", "```json\n${1:content}\n```", b_local)
common.add_snippet("curl", "```curl\n${1:content}\n```", b_local)
common.add_snippet("kt", "```kt\n${1:// path}\n```", b_local)
common.add_snippet("lua", "```lua\n${1:-- path}\n```", b_local)
common.add_snippet("vim", "```vim\n${1:content}\n```", b_local)
common.add_snippet("hs", "```hs\n${1:content}\n```", b_local)

common.add_snippet("asm", '```asm\n%include "io64.inc"\n\nsection .text\nglobal CMAIN\nCMAIN:\n    ;write your code here\nxor rax, rax\nret\n```', b_local)
common.add_snippet("datasection", "section .data", b_local)
common.add_snippet("bsssection", "section .bss", b_local)
common.add_snippet("textsection", "section .text", b_local)
