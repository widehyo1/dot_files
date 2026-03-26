function join(arr, sep) {
  acc = arr[1]
  for (i = 2; i <= length(arr); i++) {
    acc = acc sep arr[i]
  }
  return acc
}

function strip(str) {
  gsub(/^\s+|\s+$/, "", str)
  return str
}

BEGIN {
  mapper["CLOB"] = "TEXT"
  mapper["DATE"] = "TIMESTAMP"
  mapper["NUMBER"] = "NUMERIC"
  mapper["NUMBER(13)"] = "NUMERIC"
  mapper["NUMBER(8)"] = "NUMERIC"
}

/SQL/ {
  tableName = strip($NF)
  next
}

/______________/ {
  block = 1
  colCnt = 0
  delete colInfo
  printf "DROP TABLE IF EXISTS public.%s;\n", tableName
  printf "CREATE TABLE public.%s (\n", tableName
  next
}

strip($0) ~ /^$/ {
  block = 0
  size = length(colInfo)
  last = colInfo[size]
  colInfo[size] = substr(last, 1, length(last) - 1)

  print join(colInfo, "\n")

  print ");"
  print ""
  next
}

block {
  colCnt++
  colName = $1
  colType = $(NF - 1)
  if (colType ~ /VARCHAR2/) {
    colType = "VARCHAR" substr(colType, 9)
  }
  if ((colType in mapper)) {
    colType = mapper[colType]
  }
  if (/NOT NULL/) {
    colInfo[colCnt] = sprintf("    %s %s NOT NULL,", $1, colType)
  } else {
    colInfo[colCnt] = sprintf("    %s %s,", $1, colType)
  }
}
