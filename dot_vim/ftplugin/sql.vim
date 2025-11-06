iabbrev <buffer> \ctable; CREATE TABLE table_name ();
iabbrev <buffer> \ctas; CREATE TABLE table_name AS SELECT * FROM ref_table;
iabbrev <buffer> \atable; ALTER TABLE table_name ;
iabbrev <buffer> \cseq; CREATE SEQUENCE sequence_name INCREMENT BY 1;
iabbrev <buffer> \cview; CREATE VIEW v_name AS SELECT * FROM ref_table;

iabbrev <buffer> \ine; IF NOT EXISTS
iabbrev <buffer> \orr; OR REPLACE
iabbrev <buffer> \alt; ALTER
iabbrev <buffer> \tab; TABLE
iabbrev <buffer> \col; COLUMN

iabbrev <buffer> \def; DEFAULT
iabbrev <buffer> \nn; NOT NULL
iabbrev <buffer> \pk; PRIMARY KEY
iabbrev <buffer> \fk; FOREIGN KEY
iabbrev <buffer> \uniq; CONSTRAINT name_uk UNIQUE (column)
iabbrev <buffer> \ref; REFERENCES ref_table (column)

iabbrev <buffer> \int; INTEGER
iabbrev <buffer> \time; TIMESTAMP

iabbrev <buffer> \with; WITH cte_name AS ( SELECT * FROM table_name )

iabbrev <buffer> \select; SELECT * FROM table_name
iabbrev <buffer> \count; SELECT count(1) FROM table_name
iabbrev <buffer> \case; CASE WHEN condition THEN value ELSE evalue END
iabbrev <buffer> \csv; read_csv_auto()

iabbrev <buffer> \join; JOIN target t ON t.id = source.id
iabbrev <buffer> \ljoin; LEFT OUTER JOIN target t ON t.id = source.id
iabbrev <buffer> \rjoin; RIGHT OUTER JOIN target t ON t.id = source.id
iabbrev <buffer> \fjoin; FULL OUTER JOIN target t ON t.id = source.id

iabbrev <buffer> \grp; GROUP BY
iabbrev <buffer> \grpa; GROUP BY ALL
iabbrev <buffer> \gset; GROUPING SETS
iabbrev <buffer> \ord; ORDER BY
iabbrev <buffer> \orda; ORDER BY ALL
iabbrev <buffer> \nf; NULLS FIRST
iabbrev <buffer> \roll; ROLLUP
iabbrev <buffer> \part; PARTITION BY
iabbrev <buffer> \between; BETWEEN a AND b
iabbrev <buffer> \prev; PRECEDING
iabbrev <buffer> \next; FOLLOWING
iabbrev <buffer> \window; WINDOW win_name AS ()

iabbrev <buffer> \insert; INSERT INTO table_name VALUES ();
iabbrev <buffer> \byname; BY NAME
iabbrev <buffer> \oconf; ON CONFLICT
iabbrev <buffer> \nop; DO NOTHING

vnoremap <buffer> gcc :s/^/-- /<CR>
