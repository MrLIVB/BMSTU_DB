-- Все возможные комбинации
with combinations(id, valid_from_dttm, valid_to_dttm) as
    -- Все даты в одной таблице
    (with united(id, var2, valid_from_dttm, valid_to_dttm) as
         (select id,
                 var1 as var2,
                 valid_from_dttm,
                 valid_to_dttm
          from table1 t1
          union select *
          from table2) 
    
    -- Выбор только правильных дат
    select  froms.id,
            valid_from_dttm,
            valid_to_dttm
     from
        -- Выбор правильных дат "от"
         (select distinct id,
                          valid_from_dttm
          from united u
          where (exists
                     (select u.id
                      from united
                      where united.id = u.id
                          and united.valid_to_dttm + 1 = u.valid_from_dttm))
              or
                  (select count(united.valid_from_dttm)
                   from united
                   where u.id = united.id
                       and u.valid_from_dttm = united.valid_from_dttm) = 2) froms
     join
        -- все правильные даты "до"
         (select distinct id,
                          valid_to_dttm
          from united u
          where exists
                  (select u.id
                   from united
                   where united.id = u.id
                       and united.valid_from_dttm - 1 = u.valid_to_dttm)
              or
                  (select count(united.valid_to_dttm)
                   from united
                   where u.id = united.id
                       and u.valid_to_dttm = united.valid_to_dttm) = 2) tos on froms.id = tos.id
     and froms.valid_from_dttm < tos.valid_to_dttm)


select t.id,
        -- правильный var1
       case
           when t.valid_from_dttm = t1.valid_from_dttm
                and t.id = t1.id then t1.var1
           when t.valid_from_dttm = t2.valid_from_dttm
                and t.id = t2.id then t2.var2
       end as "var1",
       -- правильный var2
       case
           when t.valid_to_dttm = t1.valid_to_dttm
                and t.id = t1.id then t1.var1
           when t.valid_to_dttm = t2.valid_to_dttm
                and t.id = t2.id then t2.var2
       end as "var2",
       t.valid_from_dttm,
       t.valid_to_dttm
from
    -- Выбор минимальной "до" для каждого при группировке по "от"
    (select id,
            valid_from_dttm,
            min(valid_to_dttm) as valid_to_dttm
     from combinations c
     group by id,
              valid_from_dttm) t
-- для подбора var1 и var2
join table1 t1 on t1.id = t.id
join table2 t2 on t2.id = t.id
where (t1.valid_from_dttm = t.valid_from_dttm
       or t1.valid_to_dttm = t.valid_to_dttm)
    and (t2.valid_from_dttm = t.valid_from_dttm
         or t2.valid_to_dttm = t.valid_to_dttm)