
create table STUDENT
(
  student_id serial
    constraint STUDENT_pk
			primary key,
  student_nm varchar(255) not null,
  student_id_card_no int,
  student_group_no varchar(10),
  student_tel bigint check(student_tel between 79000000000 and 79999999999)
);


create table ROOM
(
  room_num varchar(4)	primary key,
	table_cnt smallint not null check(table_cnt >= 0),
	chair_cnt smallint not null check(chair_cnt >= 0),
	bookshelf_cnt smallint not null check(bookshelf_cnt >= 0),
	wardrobe_cnt smallint not null check(wardrobe_cnt >= 0)
);


create table ACTIVIST
(
	student_id int
		constraint ACTIVIST_pk
			primary key
		constraint ACTIVIST_STUDENT_student_id_fk
			references STUDENT (student_id),
	hours_of_work_amt decimal not null check(hours_of_work_amt >= 0),
	rating_cnt smallint not null check(rating_cnt >= 0)
);


create table MANAGER
(
	occupation_nm varchar(255)
		constraint MANAGER_pk
			primary key,
	student_id int
		constraint MANAGER_STUDENT_student_id_fk
			references STUDENT (student_id),
	salary_amt decimal check(salary_amt >= 0)
);


create table RESPONSIBLE_ZONE
(
	zone_nm varchar(255)
		constraint RESPONSIBLE_ZONE_pk
			primary key,
	responsible_student_id int
		constraint RESPONSIBLE_ZONE_STUDENT_student_id_fk
			references STUDENT (student_id),
	room_num varchar(4),
	hours_per_month_salary_amt decimal check(hours_per_month_salary_amt >= 0)
);


create table ROOM_OF_STUDENT_COUNCIL
(
	room_id varchar(20)
		constraint ROOM_OF_STUDENT_COUNCIL_pk
			primary key,
	zone_nm varchar(255)
		constraint ROOM_OF_STUDENT_COUNCIL_RESPONSIBLE_ZONE_zone_nm_fk
			references RESPONSIBLE_ZONE (zone_nm),
	rules_txt varchar
);


create table LOCK_LOG
(
	enter_dttm timestamp
		constraint LOCK_LOG_pk
			primary key,
	room_id varchar(20)
		constraint LOCK_LOG_ROOM_OF_STUDENT_COUNCIL_room_id_fk
			references ROOM_OF_STUDENT_COUNCIL (room_id),
	id_card_no int not null,
	access_granted_flag boolean not null
);


create table BAN_LIST
(
	added_dttm timestamp
		constraint BAN_LIST_pk
			primary key,
	room_id varchar(20)
		constraint BAN_LIST_ROOM_OF_STUDENT_COUNCIL_room_id_fk
			references ROOM_OF_STUDENT_COUNCIL (room_id),
	student_id int
		constraint BAN_LIST_STUDENT_student_id_fk
			references STUDENT (student_id),
	ends_dttm timestamp not null,
	reason_txt varchar
);


create table STUDENT_X_ROOM
(
	student_id int
		constraint STUDENT_X_ROOM_pk
			primary key
		constraint STUDENT_X_ROOM_student_id_fk
			references STUDENT (student_id),
	room_num varchar(4)
		constraint STUDENT_X_ROOM_room_num_fk
			references ROOM (room_num)
);


create table ACCESS_MANAGER_X_ROOM_OF_SC
(
	occupation_nm varchar(255)
		constraint ACCESS_MANAGER_X_ROOM_OF_SC_occupation_nm_fk
			references MANAGER (occupation_nm),
	room_id varchar(30)
		constraint ACCESS_MANAGER_X_ROOM_OF_SC_room_id_fk
			references ROOM_OF_STUDENT_COUNCIL (room_id),
	constraint ACCESS_MANAGER_X_ROOM_OF_SC_pk
		primary key (occupation_nm, room_id)
);



-- DROP TABLE ACCESS_MANAGER_X_ROOM_OF_SC;
-- DROP TABLE STUDENT_X_ROOM;
-- DROP TABLE BAN_LIST;
-- DROP TABLE LOCK_LOG;
-- DROP TABLE ROOM_OF_STUDENT_COUNCIL;
-- DROP TABLE RESPONSIBLE_ZONE;
-- DROP TABLE MANAGER;
-- DROP TABLE ACTIVIST;
-- DROP TABLE ROOM;
-- DROP TABLE STUDENT;
