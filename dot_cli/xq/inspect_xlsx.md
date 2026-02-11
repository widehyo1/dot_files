# about xlsx:
- xlsx는 사실 zip 파일
```bash
/mnt/c/Users/widehyo/Desktop/work2/2026/02/11 $ unzip -l data.xlsx
Archive:  data.xlsx
  Length      Date    Time    Name
---------  ---------- -----   ----
     1432  1980-01-01 00:00   [Content_Types].xml
      588  1980-01-01 00:00   _rels/.rels
     2428  1980-01-01 00:00   xl/workbook.xml
      972  1980-01-01 00:00   xl/_rels/workbook.xml.rels
   550838  1980-01-01 00:00   xl/worksheets/sheet1.xml
     7747  1980-01-01 00:00   xl/worksheets/sheet2.xml
     8722  1980-01-01 00:00   xl/theme/theme1.xml
     4135  1980-01-01 00:00   xl/styles.xml
  2413781  1980-01-01 00:00   xl/sharedStrings.xml
      762  1980-01-01 00:00   xl/calcChain.xml
      612  1980-01-01 00:00   docProps/core.xml
      826  1980-01-01 00:00   docProps/app.xml
---------                     -------
  2992843                     12 files

`[Content_Types].xml`
{
  "Types": {
    "@xmlns": "http://schemas.openxmlformats.org/package/2006/content-types",
    "Default": [
      {
        "@Extension": "rels",
        "@ContentType": "application/vnd.openxmlformats-package.relationships+xml"
      },
      {
        "@Extension": "xml",
        "@ContentType": "application/xml"
      }
    ],
    "Override": [
      {
        "@PartName": "/xl/workbook.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"
      },
      {
        "@PartName": "/xl/worksheets/sheet1.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"
      },
      {
        "@PartName": "/xl/worksheets/sheet2.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"
      },
      {
        "@PartName": "/xl/theme/theme1.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.theme+xml"
      },
      {
        "@PartName": "/xl/styles.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"
      },
      {
        "@PartName": "/xl/sharedStrings.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"
      },
      {
        "@PartName": "/xl/calcChain.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.spreadsheetml.calcChain+xml"
      },
      {
        "@PartName": "/docProps/core.xml",
        "@ContentType": "application/vnd.openxmlformats-package.core-properties+xml"
      },
      {
        "@PartName": "/docProps/app.xml",
        "@ContentType": "application/vnd.openxmlformats-officedocument.extended-properties+xml"
      }
    ]
  }
}

`xl/_rels/workbook.xml.rels`
{
  "Relationships": {
    "@xmlns": "http://schemas.openxmlformats.org/package/2006/relationships",
    "Relationship": [
      {
        "@Id": "rId3",
        "@Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme",
        "@Target": "theme/theme1.xml"
      },
      {
        "@Id": "rId2",
        "@Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet",
        "@Target": "worksheets/sheet2.xml"
      },
      {
        "@Id": "rId1",
        "@Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet",
        "@Target": "worksheets/sheet1.xml"
      },
      {
        "@Id": "rId6",
        "@Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/calcChain",
        "@Target": "calcChain.xml"
      },
      {
        "@Id": "rId5",
        "@Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings",
        "@Target": "sharedStrings.xml"
      },
      {
        "@Id": "rId4",
        "@Type": "http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles",
        "@Target": "styles.xml"
      }
    ]
  }
}

`xl/sharedStrings.xml`
`xl/worksheets/sheet1.xml`
```

---

- paths
```xq
path(..) | join(".")
```

- `xl/sharedStrings.xml`
```txt
sst.si
sst.si.0
sst.si.0.t
sst.si.1
sst.si.1.t
sst.si.2
sst.si.2.t
...
```

- `xl/worksheets/sheet1.xml`
```txt
worksheet.sheetData.row.150
worksheet.sheetData.row.150.@r
worksheet.sheetData.row.150.@spans
worksheet.sheetData.row.150.@ht
worksheet.sheetData.row.150.@customHeight
worksheet.sheetData.row.150.@x14ac:dyDescent
worksheet.sheetData.row.150.c
worksheet.sheetData.row.150.c.0
worksheet.sheetData.row.150.c.0.@r
worksheet.sheetData.row.150.c.0.@s
worksheet.sheetData.row.150.c.0.@t
worksheet.sheetData.row.150.c.0.v
worksheet.sheetData.row.150.c.1
worksheet.sheetData.row.150.c.1.@r
worksheet.sheetData.row.150.c.1.@s
worksheet.sheetData.row.150.c.1.@t
worksheet.sheetData.row.150.c.1.v
worksheet.sheetData.row.150.c.2
worksheet.sheetData.row.150.c.2.@r
worksheet.sheetData.row.150.c.2.@s
worksheet.sheetData.row.150.c.2.@t
worksheet.sheetData.row.150.c.2.v
worksheet.sheetData.row.150.c.3
worksheet.sheetData.row.150.c.3.@r
worksheet.sheetData.row.150.c.3.@s
worksheet.sheetData.row.150.c.3.@t
worksheet.sheetData.row.150.c.3.v
worksheet.sheetData.row.150.c.4
worksheet.sheetData.row.150.c.4.@r
worksheet.sheetData.row.150.c.4.@s
worksheet.sheetData.row.150.c.4.@t
worksheet.sheetData.row.150.c.4.v
worksheet.sheetData.row.150.c.5
worksheet.sheetData.row.150.c.5.@r
worksheet.sheetData.row.150.c.5.@s
worksheet.sheetData.row.150.c.5.@t
worksheet.sheetData.row.150.c.5.v
worksheet.sheetData.row.150.c.6
worksheet.sheetData.row.150.c.6.@r
worksheet.sheetData.row.150.c.6.@s
worksheet.sheetData.row.150.c.6.@t
worksheet.sheetData.row.150.c.6.v
worksheet.sheetData.row.150.c.7
worksheet.sheetData.row.150.c.7.@r
worksheet.sheetData.row.150.c.7.@s
worksheet.sheetData.row.150.c.7.@t
worksheet.sheetData.row.150.c.7.v
```

---

- `xl/sharedStrings.xml` real content
```xq
.sst.si[]
| .t
```

```txt
단지사업계획
주택사업계획
도시재생사업계획
...
```

---

- `xl/worksheets/sheet1.xml` row content
```xq
.worksheet.sheetData.row[150]
```

```txt
worksheet.sheetData.row.150
worksheet.sheetData.row.150.@r
worksheet.sheetData.row.150.@spans
worksheet.sheetData.row.150.@ht
worksheet.sheetData.row.150.@customHeight
worksheet.sheetData.row.150.@x14ac:dyDescent
worksheet.sheetData.row.150.c
worksheet.sheetData.row.150.c.0
worksheet.sheetData.row.150.c.0.@r
worksheet.sheetData.row.150.c.0.@s
worksheet.sheetData.row.150.c.0.@t
worksheet.sheetData.row.150.c.0.v
worksheet.sheetData.row.150.c.1
worksheet.sheetData.row.150.c.1.@r
worksheet.sheetData.row.150.c.1.@s
worksheet.sheetData.row.150.c.1.@t
worksheet.sheetData.row.150.c.1.v
worksheet.sheetData.row.150.c.2
worksheet.sheetData.row.150.c.2.@r
worksheet.sheetData.row.150.c.2.@s
worksheet.sheetData.row.150.c.2.@t
worksheet.sheetData.row.150.c.2.v
worksheet.sheetData.row.150.c.3
worksheet.sheetData.row.150.c.3.@r
worksheet.sheetData.row.150.c.3.@s
worksheet.sheetData.row.150.c.3.@t
worksheet.sheetData.row.150.c.3.v
worksheet.sheetData.row.150.c.4
worksheet.sheetData.row.150.c.4.@r
worksheet.sheetData.row.150.c.4.@s
worksheet.sheetData.row.150.c.4.@t
worksheet.sheetData.row.150.c.4.v
worksheet.sheetData.row.150.c.5
worksheet.sheetData.row.150.c.5.@r
worksheet.sheetData.row.150.c.5.@s
worksheet.sheetData.row.150.c.5.@t
worksheet.sheetData.row.150.c.5.v
worksheet.sheetData.row.150.c.6
worksheet.sheetData.row.150.c.6.@r
worksheet.sheetData.row.150.c.6.@s
worksheet.sheetData.row.150.c.6.@t
worksheet.sheetData.row.150.c.6.v
worksheet.sheetData.row.150.c.7
worksheet.sheetData.row.150.c.7.@r
worksheet.sheetData.row.150.c.7.@s
worksheet.sheetData.row.150.c.7.@t
worksheet.sheetData.row.150.c.7.v
```

---

- 150번째 row 분석
- shared string index 추출
```xq
.worksheet.sheetData.row[150] | .[] | .v
```

```txt
22
1447
3986
1448
1449
129
1450
1451
```

- shared string value 추출
```xq
.sst.si[22],
.sst.si[1447],
.sst.si[3986],
.sst.si[1448],
.sst.si[1449],
.sst.si[129],
.sst.si[1450],
.sst.si[1451]
```

```txt
{
      "t": "운영관리"
}
{
      "t": "개 짖는 소리 해결"
}
...
```

- unzip과 xq를 이용해 xlsx 내용 추출 가능

---

- [xq](https://github.com/sibprogrammer/xq)
```bash
curl -sSL https://bit.ly/install-xq | sudo bash
```

- [xlsx2csv](https://github.com/dilshod/xlsx2csv)
```bash
pip install xlsx2csv
```

- [csvkit](https://csvkit.readthedocs.io/en/latest/)
```bash
pip install csvkit
```

- [parquet-tools](https://pypi.org/project/parquet-tools/)
```bash
pip install parquet-tools
```

- [duckdb](https://duckdb.org/#quickinstall)
```bash
curl https://install.duckdb.org | sh
```


```bash
$ # row수가 원본보다 많은 Row count: 1855임을 확인 (real: 960)(xlsx2csv, csvkit 사용)
$ xlsx2csv -s 1 data.xlsx | csvstat
$
$ # 첫 번째 컬럼만 추출하여 확인
$ xlsx2csv -s 1 data.xlsx | csvcut -c 1 | cat -n
     1	중분류
     2	보상준비
     3	이주/생활대책
     ...
   959	아파트분양
   960	이주/생활대책
   961	조경하자
   962	""
   963	""
   964	""
   965	""
$
$ # empty row가 나머지 행을 채우고 있을거라고 예상, empty row를 삭제후 960건인지 확인
$ xlsx2csv -s 1 data.xlsx | csvcut --delete-empty-rows | csvstat 

Row count: 960

$ # 데이터 검증 완료, csv파일로 변환
$ xlsx2csv -s 1 data.xlsx | csvcut --delete-empty-rows > data.csv
$
$ # 헤더 확인
$ csvcut --names data.csv
  1: 중분류
  2: 민원제목
  3: 민원상세내용
  4: 민원내역요약내용
  5: 민원VOC코드
  6: 민원종결분류명
  7: 민원답변상세내용
  8: 민원답변요약내용
$ cat csv2parquet 
#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage: $(basename "$0") <input.csv>" >&2
    exit 1
}

# argument count check
if [ "$#" -ne 1 ]; then
    usage
fi

csvfile="$1"

# basic validation
if [ ! -f "$csvfile" ]; then
    echo "Error: file not found: $csvfile" >&2
    exit 1
fi

if [[ "$csvfile" != *.csv ]]; then
    echo "Error: input file must have .csv extension" >&2
    exit 1
fi

parquetfile="${csvfile%.csv}.parquet"

echo "Input CSV    : $csvfile"
echo "Output Parquet: $parquetfile"

duckdb -c "COPY (SELECT * FROM read_csv_auto('$csvfile', delim=',')) TO '$parquetfile' (FORMAT PARQUET);"

$ # 원본 데이터 저장을 위해 parquet으로 형변환(duckdb 사용)
$ chmod +x csv2parquet 
$ csv2parquet data.csv
Input CSV    : data.csv
Output Parquet: data.parquet
$ 
$ # 터미널에서 parquet 파일 확인(parquet-tools 사용)
$ parquet-tools inspect data.parquet

############ file meta data ############
created_by: DuckDB version v1.4.0 (build b8a06e4a22)
num_columns: 8
num_rows: 960
num_row_groups: 1
format_version: 1.0
serialized_size: 3928


############ Columns ############
중분류
민원제목
민원상세내용
민원내역요약내용
민원VOC코드
민원종결분류명
민원답변상세내용
민원답변요약내용

############ Column(중분류) ############
name: 중분류
path: 중분류
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 9%)

############ Column(민원제목) ############
name: 민원제목
path: 민원제목
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 42%)

############ Column(민원상세내용) ############
name: 민원상세내용
path: 민원상세내용
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 50%)

############ Column(민원내역요약내용) ############
name: 민원내역요약내용
path: 민원내역요약내용
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 47%)

############ Column(민원VOC코드) ############
name: 민원VOC코드
path: 민원VOC코드
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 68%)

############ Column(민원종결분류명) ############
name: 민원종결분류명
path: 민원종결분류명
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 7%)

############ Column(민원답변상세내용) ############
name: 민원답변상세내용
path: 민원답변상세내용
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 52%)

############ Column(민원답변요약내용) ############
name: 민원답변요약내용
path: 민원답변요약내용
max_definition_level: 1
max_repetition_level: 0
physical_type: BYTE_ARRAY
logical_type: String
converted_type (legacy): UTF8
compression: SNAPPY (space_saved: 47%)
```

