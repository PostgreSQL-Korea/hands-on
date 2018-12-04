set datestyle = 'ISO';
select 
	pid
	, pg_blocking_pids(pid) as lockers
	,usename || '@' || coalesce(client_addr::text,'') || ':' || client_port || '/' ||  datname as who
	,application_name as app
	, date_trunc('second', age(now(), state_change)) as elapse 
	, state
	, wait_event_type as wevt_t
	, wait_event as wait
	, age(backend_xmin) as age
	, substr(regexp_replace(regexp_replace(query, '[\t\n\r]', ' ', 'g'), '( ){2,}', ' ', 'g'), 1, 75) as query
from pg_stat_activity
where 1=1
and backend_type = 'client backend'
and pid <> pg_backend_pid()
order by 6;
\watch :watchinterval
