/File/{
    gsub("\"", "", $2)
    gsub(",", "", $2)
    gsub(",", "", $4)
    print $2 ":" $4
}
