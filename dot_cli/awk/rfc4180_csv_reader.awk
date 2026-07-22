function process_char(c) {
  # ++step
  # print "step: " step
  # print "= process_char(" c ") start(state: " state ") ="
  while (1) {
    switch(state) {
      case "START_RECORD":
        # print "# start record #"
        if (c == "EOL") break
        if (is_crlf(c)) {
          save_field()
          state = "EAT_CRLF"
          break
        } else {
          state = "START_FIELD"
          continue
        }
      case "START_FIELD":
        # print "# start field #"
        if (c == "EOL" || is_crlf(c)) {
          save_field()
          if (c == "EOL") state = "START_RECORD"
          else state = "EAT_CRLF"
        } else if (c == ",") {
          save_field()
          # state = "START_FIELD"
        } else if (c == "\"") {
          state = "IN_QUOTED_FIELD"
        } else {
          add_char(c)
          state = "IN_FIELD"
        }
        break
      case "IN_FIELD":
        # print "# in field #"
        if (c == "EOL" || is_crlf(c)) {
          save_field()
          if (c == "EOL") state = "START_RECORD"
          else state = "EAT_CRLF"
        } else if (c == ",") {
          save_field()
          state = "START_FIELD"
        } else {
          add_char(c)
          # state = "IN_FIELD"
        }
        break
      case "IN_QUOTED_FIELD":
        # print "# in quote field #"
        if (c == "EOL") {
          add_char("\n")
          # state = "IN_QUOTED_FIELD"
        } else if (c == "\"") {
          state = "QUOTE_IN_QUOTED_FIELD"
        } else {
          add_char(c)
          # state = "IN_QUOTED_FIELD"
        }
        break
      case "QUOTE_IN_QUOTED_FIELD":
        # print "# quote in quoted field #"
        if (c == "EOL" || is_crlf(c)) {
          save_field()
          if (c == "EOL") state = "START_RECORD"
          else state = "EAT_CRLF"
        } else if (c == ",") {
          save_field()
          state = "START_FIELD"
        } else if (c == "\"") {
          add_char(c)
          state = "IN_QUOTED_FIELD"
        } else {
          error(UNEXPECTED_CHAR_AFTER_END_QUOTE)
        }
        break
      case "EAT_CRLF":
        # print "# eat crlf #"
        if (is_crlf(c)) break
        else if (c == "EOL") {
          state = "START_RECORD"
          break
        } else {
          error(UNEXPECTED_CHAR_AFTER_CRLF)
        }
    }
    break
  }
  # print "= process_char stop ="
  # if (step == 500) {
  #   print_field()
  #   error("custum")
  # }
}

function print_field() {
  print "field: " field
}

function print_record() {
  print "record: " record
}

function is_crlf(c) {
  return c == "\n" || c == "\r" || c == "\r\n"
}

function join(arr, sep) {
  acc = arr[1]
  for (i = 2; i <= length(arr); i++) {
    acc = acc sep arr[i]
  }
  return acc
}


function add_char(c) {
  field = field c
}

function save_field() {
  # print_field()
  fields[++field_cnt] = field
  field = ""
}

function save_record() {
  record = join(fields, SUBSEP)
  # print_record()
  records[++record_cnt] = record
  delete fields
  field_cnt = 0
  split("", fields)
  record = ""
}

function error(msg) {
  print msg
  _exit_status = 1
  exit
}

BEGIN {
  # print "=== begin start ==="
  # exit_status
  _exit_status = 0
  UNEXPECTED_CHAR_AFTER_CRLF = "unexpected character after crlf"
  UNEXPECTED_CHAR_AFTER_END_QUOTE = "unexpected character after end quote"
  UNCLOSED_QUOTE = "quote is not properly closed"

  # parser states
  states = "START_RECORD START_FIELD IN_FIELD"
  states = states " IN_QUOTED_FIELD QUOTE_IN_QUOTED_FIELD EAT_CRLF"
  split(states, PARSER_STATE)

  # inputs
  inputs = "EOL CRLF delimiter quotechar other"
  split(inputs, INPUTS)

  # fields, records
  field = ""
  split("", fields)
  field_cnt = length(fields)
  record = ""
  split("", records)
  record_cnt = length(records)

  state = PARSER_STATE[1]
  line_number = NR

  # print "=== begin stop ==="
}

# each iterator item ($0)
# wrapping loop
{
  # print "== iter item start =="

  s = $0
  n = length(s)
  # print "length: " n

  for (i = 1; i <= n; i++) {
    process_char(substr(s,i,1))
  }

  line_number++
  process_char("EOL")
  if (state == "START_RECORD") {
    save_record()
  }
  # print "== iter item stop =="
}


END {
  # print "=== end start ==="
  # print "field_cnt: " field_cnt
  # print "record_cnt: " record_cnt
  # print "line_number: " line_number

  # exit
  if (_exit_status) exit

  # RFC 4180 disallow inquoted EOF
  if (state == "IN_QUOTED_FIELD") {
    error(UNCLOSED_QUOTE)
  }

  # print ""
  # print "### records ###"
  for (i in records) {
    print records[i]
  }

  # print "=== end stop ==="
}

