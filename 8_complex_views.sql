
create view responsible_info_view as
    select occupation_nm, student_nm,
           case when room_num is null then '-' else room_num end as room_num,
            '+' || student_tel::varchar(11) as student_tel
    from (
        select 'Ответственный за: ' || zone_nm as occupation_nm,
               responsible_student_id as student_id
            from responsible_zone
        union
        select occupation_nm, student_id
            from manager
    ) as occups
    inner join student on occups.student_id = student.student_id
    left join student_x_room sxr on student.student_id = sxr.student_id
    order by occupation_nm;

select * from responsible_info_view;
drop view responsible_info_view;


create view student_full_info as
    select student_nm, student_group_no,
           case when room_num is null then '-' else room_num end as room_num,
           case when hours_of_work_amt is null then '' else hours_of_work_amt::varchar(15) end as hours_of_activism,
           case when rating_cnt is null then '' else rating_cnt::varchar(15) end as rating,
           case when rating_cnt is null then ''
                when rating_cnt >= 70 or a.student_id in (select student_id from manager) then 'Активист-руководитель'
                when rating_cnt < 4 then 'Активист-новичок'
                when rating_cnt < 16 then 'Активист'
                when rating_cnt < 35 then 'Активист-организатор'
                else 'Активист-лидер'
            end as level
    from student
    left join student_x_room sxr on student.student_id = sxr.student_id
    left join activist a on student.student_id = a.student_id
    order by student_nm;

select * from student_full_info limit 10;
drop view student_full_info;
