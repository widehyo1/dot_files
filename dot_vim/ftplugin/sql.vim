iabbrev <buffer> \select; SELECT *<CR>FROM table_name tn<CR>WHERE 1 = 1
iabbrev <buffer> \insert; INSERT INTO table_name(fields) VALUES (values)
iabbrev <buffer> \delete; DELETE FROM table_name<CR>WHERE 1 = 0
iabbrev <buffer> \update; UPDATE table_name<CR>SET field = value<CR>WHERE 1 = 0
iabbrev <buffer> \from; FROM table_name tn
iabbrev <buffer> \where; WHERE 1 = 1
iabbrev <buffer> \and; AND 1 = 1
iabbrev <buffer> \or; OR 1 = 1
iabbrev <buffer> \orderby; ORDER BY field1 asc
iabbrev <buffer> \left; LEFT OUTER JOIN table_name tn ON (base.join_key = tn.join_key)
iabbrev <buffer> \right; RIGHT OUTER JOIN table_name tn ON (base.join_key = tn.join_key)
iabbrev <buffer> \inner; INNER JOIN table_name tn ON (base.join_key = tn.join_key)
iabbrev <buffer> \groupby; GROUP BY field
iabbrev <buffer> \with; WITH 

