
-- Список жилых комнат, число книжных полок в которых превышает число жителей
select room.room_num, count(student_x_room.student_id) as people_cnt, room.bookshelf_cnt
    from room
    inner join student_x_room
    on room.room_num = student_x_room.room_num
    group by room.room_num, room.bookshelf_cnt
    having room.bookshelf_cnt > count(student_x_room.student_id);

-- Список людей, всегда имеющих доступ в помещение 'Клуб'
select student_nm, student_group_no
    from student
    where student_id in (
        select student_id
            from access_manager_x_room_of_sc
            inner join manager
            on access_manager_x_room_of_sc.occupation_nm = manager.occupation_nm and
                room_id = (
                select room_id
                    from room_of_student_council
                    where zone_nm = 'Клуб'
                )
        union
        select responsible_student_id
            from responsible_zone
            where zone_nm = 'Клуб'
    );

-- Список активистов, имеющих >= 1 соседей при рейтинге >= 16
select student_nm, student_group_no
    from student
    where student_id in (
        select student_id
            from activist
            where rating_cnt >= 16
        intersect
        select student_id
            from (
            select student_id,
                   count(room_num) over (partition by room_num) as students_count
                from student_x_room
            ) as t
            where students_count > 1
    );

-- Список комнат, в которые заходил студент 'Зименков Александр' в период с "2018-10-07 00:00" по "2018-10-13 11:00", со
-- временем захода
select room_id, enter_dttm
    from lock_log
    where id_card_no = (
        select student_id_card_no
            from student
            where student_nm like 'Зименков Александр%'
        ) and enter_dttm between '2018-10-07 00:00' and '2018-10-13 11:00' and access_granted_flag;

-- Вывести статус доступа студента 'Коваленко Лев' в помещение 'Клуб': ALWAYS (доступ есть в любое время) /
-- NORMAL (обычный студент, доступ открыт по записи) / BANNED (доступ запрещён)

with user_id as (
    select student_id
        from student
        where student_nm like 'Коваленко Лев%'
), manager_id as (
    select distinct manager.student_id
        from user_id
        inner join manager
            on user_id.student_id = manager.student_id
        inner join access_manager_x_room_of_sc access
            on manager.occupation_nm = access.occupation_nm and room_id = 'kds2'
), actual_ban_list as (
    select *
        from ban_list
    where ends_dttm > current_timestamp and room_id = 'kds2'
)
select case
    when NOT exists(select * from (select count(student_id) as c from user_id) as t where t.c = 1)
    then 'SEARCH ERROR'
    when exists(select * from manager_id)
    then 'ALWAYS'
    when exists(select * from user_id inner join actual_ban_list on user_id.student_id = actual_ban_list.student_id)
    then 'BANNED'
    else 'NORMAL'
    end;