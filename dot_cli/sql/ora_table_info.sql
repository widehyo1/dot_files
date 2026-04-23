SELECT t.table_name
     ,  s.last_analyzed
     ,  s.num_rows
     ,  s.sample_size
     ,  t.inmemory
     ,  c.comments
FROM user_tables t
LEFT JOIN user_tab_statistics s ON s.table_name = t.table_name
LEFT JOIN user_tab_comments c ON c.table_name = t.table_name
;
