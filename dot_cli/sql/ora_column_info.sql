SELECT s.table_name
     , c.column_id
     ,  c.column_name
     ,  CASE
            WHEN c.data_type IN ('CHAR'
                               , 'VARCHAR2'
                               , 'NCHAR'
                               , 'NVARCHAR2') THEN c.data_type || '(' || c.char_col_decl_length || ' BYTE)'
            WHEN c.data_type = 'NUMBER'
                 AND c.data_precision IS NOT NULL THEN c.data_type || '(' || c.data_precision || ',' || c.data_scale || ')'
            WHEN c.data_type = 'NUMBER' THEN c.data_type
            ELSE c.data_type
        END AS data_type
     ,  CASE c.nullable
            WHEN 'Y' THEN 'Yes'
            ELSE 'No'
        END AS NULLABLE
     ,  c.data_default AS default_value
     ,  s.num_distinct
     ,  s.histogram
FROM user_tab_cols c
LEFT JOIN user_tab_col_statistics s ON s.table_name = c.table_name
AND s.column_name = c.column_name
ORDER BY s.table_name, c.column_id;
