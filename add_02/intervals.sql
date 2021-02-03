with dates_to as
     (select fio,
           (select dt from
                 (select fio,dt,
                         lead(stat) over (partition by fio
                                          order by dt) as stat2
                  from emplvisits) s
            where s.fio = e.fio
                 and (stat != stat2
                      or stat2 is null)
                 and s.dt >= e.dt
            limit 1) as date_to,
             stat
      from emplvisits e
      group by fio,
               date_to,
               stat)
               
select e.department,
       e.fio,
       min(e.dt) as date_from,
       o.date_to,
       e.stat
from emplvisits e
join dates_to as o on o.fio = e.fio
and e.dt <= o.date_to
and e.stat = o.stat
group by e.department,
         e.fio,
         o.date_to,
         e.stat

select * from emplvisits e