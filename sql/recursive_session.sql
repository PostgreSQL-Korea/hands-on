with recursive cte1 as (
        select *, 0::int as level
        from (
                select
                pid
                , unnest(
                  case when pg_blocking_pids(pid) = '{}'
                       then array_append('{}', pid)
                       else pg_blocking_pids(pid) end)
                 as locker
                from pg_stat_activity
                where 1=1
                and backend_type = 'client backend'
                and pid <> pg_backend_pid()
        ) a where pid = locker

        union all

        select a.pid,a.locker,b.level + 1
        from (
                select
                pid
                , unnest(
                  case when pg_blocking_pids(pid) = '{}'
                       then array_append('{}', pid)
                       else pg_blocking_pids(pid) end)
                 as locker
                from pg_stat_activity
                where 1=1
                and backend_type = 'client backend'
                and pid <> pg_backend_pid()
        ) a, cte1 b where a.locker <> a.pid and a.locker = b.pid
)
select * from cte1;
