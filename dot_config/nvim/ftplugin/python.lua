local common = require('common')
local b_local = { buffer = 0 }

common.add_snippet("main", "def main():\n    ${2:# content}\n\nif __name__ == '__main__':\n    ${1:main()}", b_local)
