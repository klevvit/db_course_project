
-- 'student' table
insert into student values(19, 'Халяпов Александр Фаритович', NULL, '396а', 79054321098);
select * from student;
update student set student_tel = 79005553535 where student_id = 19;
delete from student where student_id = 19;

-- 'ban_list' table
insert into ban_list values (current_timestamp, 'kds2', 12, '2019-10-14',
                             'Распитие газировки в переговорной.');
update ban_list set reason_txt = 'Распитие газировки в переговорной. Временный бан до обсуждения на собрании'
    where student_id = 12 and room_id = 'kds2' and ends_dttm = '2019-10-14';
select * from ban_list where room_id = 'kds2';
delete from ban_list where student_id = 12 and room_id = 'kds2' and ends_dttm = '2019-10-14';
