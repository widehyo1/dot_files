SELECT i.table_name
     , i.index_name
     ,  i.uniqueness
     ,  i.status
     ,  i.funcidx_status
     ,  listagg(ic.column_name, ', ') within GROUP (
                                                    ORDER BY ic.column_position) AS columns
FROM user_indexes i
JOIN user_ind_columns ic ON ic.index_name = i.index_name
AND ic.table_name = i.table_name
GROUP BY i.table_name
       , i.index_name
       ,  i.uniqueness
       ,  i.status
       ,  i.funcidx_status
ORDER BY i.table_name, i.index_name;
