BEGIN {
  FS = "\t"
  OS_SEP = "/"
  MODULE_SEP = "."
}
# deal with project classes
$4 == "c"{
  gsub(/.py$/, "", $2)
  gsub(OS_SEP, ".", $2)
  if (!uniq[$2 MODULE_SEP $1]++) {
    print $2 MODULE_SEP $1
  }
}
# deal with project functions
$4 == "f"{
  gsub(/.py$/, "", $2)
  gsub(OS_SEP, ".", $2)
  if (!uniq[$2 MODULE_SEP $1]++) {
    print $2 MODULE_SEP $1
  }
}
# deal with project methods in class
$4 == "m"{
  gsub(/.py$/, "", $2)
  gsub(OS_SEP, ".", $2)
  gsub("class:", "", $5)
  if (!uniq[$2 MODULE_SEP $5 MODULE_SEP $1]++) {
    print $2 MODULE_SEP $5 MODULE_SEP $1
  }
}

