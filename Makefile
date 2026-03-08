db:
	sqlite3 -init rc.tasks tasks.db

count:
	sqlite3 -init rc.tasks tasks.db -cmd 'select count(1) from backlog' '.quit'

show:
	sqlite3 -init rc.tasks tasks.db -cmd 'select * from backlog' '.quit'

today:
	sqlite3 -init rc.tasks tasks.db -cmd "select * from backlog where status != 'done'" ".quit"

schema:
	sqlite3 -init rc.tasks tasks.db -cmd '.schema' '.quit'

dump:
	sqlite3 -init rc.tasks tasks.db -cmd '.mode csv' '.output data/backlogs.csv' 'select * from backlog' '.quit'

clean:
	sqlite3 -init rc.tasks tasks.db -cmd 'delete from backlog' '.quit'

append:
	sqlite3 -init rc.tasks tasks.db -cmd '.mode csv' '.import --skip 1 data/backlogs.csv backlog' '.quit'

drop:
	sqlite3 -init rc.tasks tasks.db -cmd 'drop table backlog' '.quit'

create:
	awk -f script/csv2createsql.awk data/backlogs.csv > script/table.sql && sqlite3 tasks.db < script/table.sql

sync: clean append
init: drop create

