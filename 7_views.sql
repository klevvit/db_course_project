
create view students_823_view as
    select student_nm, student_group_no,
           '+' || left(student_tel::varchar(11), 4) || '*****' || right(student_tel::varchar(11), 2) as student_tel
    from student
    where student_group_no in ('823', 'Б05-823');

select * from students_823_view;
drop view students_823_view;


create view room_floor3_view as
    select *
    from room
where left(room_num, 1) = '3';

select * from room_floor3_view;
drop view room_floor3_view;


create view activist_novices_view as
    select student_nm, hours_of_work_amt, rating_cnt
    from activist
    inner join student on activist.student_id = student.student_id
    where rating_cnt < 4;

select * from activist_novices_view;
drop view activist_novices_view;


create view manager_view as
    select occupation_nm, student_nm
    from manager
    inner join student s on manager.student_id = s.student_id;

select * from manager_view;
drop view manager_view;


create view responsible_zone_view as
    select zone_nm, student_nm
    from responsible_zone
    inner join student s on responsible_zone.responsible_student_id = s.student_id
    order by zone_nm;

select * from responsible_zone_view;
drop view responsible_zone_view;


create view room_of_student_council_view as
    select zone_nm, count(*) as lock_activations
    from room_of_student_council
    inner join lock_log ll on room_of_student_council.room_id = ll.room_id
    where access_granted_flag
    group by zone_nm;

select * from room_of_student_council_view;
drop view room_of_student_council_view;


-- for each student show which rooms she/he uses
create view lock_log_view as
    select distinct student_nm, student_group_no, room_id
    from lock_log
    inner join student on lock_log.id_card_no = student.student_id_card_no
    order by student_nm;

select * from lock_log_view;
drop view lock_log_view;


create view ban_list_view as
    select distinct student_nm, student_group_no, count(*) over (partition by s.student_id) as ban_count
    from ban_list
    inner join student s on ban_list.student_id = s.student_id
    order by student_nm;

select * from ban_list_view;
drop view ban_list_view;


create view student_x_room_view as
    select room_num, count(student_id) as student_count
    from student_x_room
    group by room_num
    order by room_num;

select * from student_x_room_view;
drop view student_x_room_view;


create view access_view as
    select room_id, count(occupation_nm) as count_has_occupation_access
    from access_manager_x_room_of_sc
    group by room_id
    order by room_id;

select * from access_view;
drop view access_view;
