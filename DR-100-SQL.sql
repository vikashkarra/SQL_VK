with main_list as
(
select s.id sid,s.name sname,s.active sactive,s.internal_sample,ss.school_id,sc.name scname, sc.active scactive,sc.created_At,
(select first_name||' '||last_name from administrators where id=s.account_manager)sponsor_lead
    from sponsors s, sponsorships ss,schools sc
    where s.id=ss.sponsor_id
    and ss.school_id=sc.id
    --and sc.active='t'
    and ss.curriculum_id=2
    and s.deleted_at is null
    and ss.deleted_at is null
    and sc.deleted_at is null
    --and s.id =745
    --and sc.id=56345
    and sc.internal_sample='f'
    and sc.demo='f'
), --List of Sponsors & schools
list_enrollments as
 (select ml.sid,ml.sname,ml.sponsor_lead,c.school_id,e.state,e.id eid,date(e.created_at)created_at
 from enrollments e,cohorts c,main_list ml
 where e.cohort_id=c.id
 and c.curriculum_id=2
 --and c.active='t' active filter is not used on AtWork cohorts
 --and e.active='t' Commented out to include blanks
 and e.deleted_at is null
 and c.deleted_at is null
 and c.school_id=ml.school_id
 --and e.state<>'registered_not_started'
 --and e.id in(9134805,9134664,9134722)
 group by ml.sid,ml.sname,ml.sponsor_lead,c.school_id,e.state,e.id,e.created_at
 ),-- List of enrollments
Enrollment_count as
(select sid,sname,sponsor_lead,school_id,count(distinct eid)tot_enrollments_alltime,
 count(case when created_at between '2017-01-01' and '2017-12-31' then eid end)tot_enrollments_2017,
 count(case when created_at between '2017-01-01' and '2017-01-31' then eid end)tot_enrollments_jan2017,
 count(case when created_at between '2017-02-01' and '2017-02-28' then eid end)tot_enrollments_feb2017,
 count(case when created_at between '2017-03-01' and '2017-03-31' then eid end)tot_enrollments_mar2017,
 count(case when created_at between '2017-04-01' and '2017-04-30' then eid end)tot_enrollments_apr2017,
 count(case when created_at between '2017-05-01' and '2017-05-31' then eid end)tot_enrollments_may2017,
 count(case when created_at between '2017-06-01' and '2017-06-30' then eid end)tot_enrollments_jun2017,
 count(case when created_at between '2017-07-01' and '2017-07-31' then eid end)tot_enrollments_jul2017,
 count(case when created_at between '2017-08-01' and '2017-08-31' then eid end)tot_enrollments_aug2017,
 count(case when created_at between '2016-01-01' and '2016-12-31' then eid end)tot_enrollments_2016,
 count(case when created_at between '2016-01-01' and '2016-01-31' then eid end)tot_enrollments_jan2016,
 count(case when created_at between '2016-02-01' and '2016-02-29' then eid end)tot_enrollments_feb2016,
 count(case when created_at between '2016-03-01' and '2016-03-31' then eid end)tot_enrollments_mar2016,
 count(case when created_at between '2016-04-01' and '2016-04-30' then eid end)tot_enrollments_apr2016,
 count(case when created_at between '2016-05-01' and '2016-05-31' then eid end)tot_enrollments_may2016,
 count(case when created_at between '2016-06-01' and '2016-06-30' then eid end)tot_enrollments_jun2016,
 count(case when created_at between '2016-07-01' and '2016-07-31' then eid end)tot_enrollments_jul2016,
 count(case when created_at between '2016-08-01' and '2016-08-31' then eid end)tot_enrollments_aug2016,
 count(case when created_at between '2016-09-01' and '2016-09-30' then eid end)tot_enrollments_sep2016,
 count(case when created_at between '2016-10-01' and '2016-10-31' then eid end)tot_enrollments_oct2016,
 count(case when created_at between '2016-11-01' and '2016-11-30' then eid end)tot_enrollments_nov2016,
 count(case when created_at between '2016-12-01' and '2016-12-31' then eid end)tot_enrollments_dec2016
 from list_enrollments le
 group by sid,sname,sponsor_lead,school_id
),
activity_list as
( select sid,sname,school_id,le.eid,ap.activity_id,date(ap.created_at) created
  from list_enrollments le,activity_progresses ap,content_page_progresses cpp,activities a
  where le.eid=ap.enrollment_id
  and ap.enrollment_id=cpp.enrollment_id
  and ap.activity_id=a.id
  and a.activity_type='module'
  and a.active='t'
  and ap.deleted_at is null
  and a.curriculum_id=2
  group by sid,sname,school_id,eid,ap.activity_id,date(ap.created_at)
),
activity_count as
(select sid,sname,school_id,eid,count(distinct activity_id)tot_modules_alltime,
count(distinct(Case when created between '2017-01-01' and '2017-12-31' then activity_id end))modules_completed_2017,
count(distinct(Case when created between '2017-01-01' and '2017-01-31' then activity_id end))modules_completed_jan2017,
count(distinct(Case when created between '2017-02-01' and '2017-02-28' then activity_id end))modules_completed_feb2017,
count(distinct(Case when created between '2017-03-01' and '2017-03-31' then activity_id end))modules_completed_mar2017,
count(distinct(Case when created between '2017-04-01' and '2017-04-30' then activity_id end))modules_completed_apr2017,
count(distinct(Case when created between '2017-05-01' and '2017-05-31' then activity_id end))modules_completed_may2017,
count(distinct(Case when created between '2017-06-01' and '2017-06-30' then activity_id end))modules_completed_jun2017,
count(distinct(Case when created between '2017-07-01' and '2017-07-31' then activity_id end))modules_completed_jul2017,
count(distinct(Case when created between '2017-08-01' and '2017-08-31' then activity_id end))modules_completed_aug2017,
count(distinct(Case when created between '2016-01-01' and '2016-12-31' then activity_id end))modules_completed_2016,
count(distinct(Case when created between '2016-01-01' and '2016-01-31' then activity_id end))modules_completed_jan2016,
count(distinct(Case when created between '2016-02-01' and '2016-02-29' then activity_id end))modules_completed_feb2016,
count(distinct(Case when created between '2016-03-01' and '2016-03-31' then activity_id end))modules_completed_mar2016,
count(distinct(Case when created between '2016-04-01' and '2016-04-30' then activity_id end))modules_completed_apr2016,
count(distinct(Case when created between '2016-05-01' and '2016-05-31' then activity_id end))modules_completed_may2016,
count(distinct(Case when created between '2016-06-01' and '2016-06-30' then activity_id end))modules_completed_jun2016,
count(distinct(Case when created between '2016-07-01' and '2016-07-31' then activity_id end))modules_completed_jul2016,
count(distinct(Case when created between '2016-08-01' and '2016-08-31' then activity_id end))modules_completed_aug2016,
count(distinct(Case when created between '2016-09-01' and '2016-09-30' then activity_id end))modules_completed_sep2016,
count(distinct(Case when created between '2016-10-01' and '2016-10-31' then activity_id end))modules_completed_oct2016,
count(distinct(Case when created between '2016-11-01' and '2016-11-30' then activity_id end))modules_completed_nov2016,
count(distinct(Case when created between '2016-12-01' and '2016-12-31' then activity_id end))modules_completed_dec2016
from activity_list
group by sid,sname,school_id,eid
),
activity_count_1 as
(select sid,sname,school_id,sum(tot_modules_alltime)tot_modules_alltime,
sum(modules_completed_2017)modules_completed_2017,
sum(modules_completed_jan2017)modules_completed_jan2017,
sum(modules_completed_feb2017)modules_completed_feb2017,
sum(modules_completed_mar2017)modules_completed_mar2017,
sum(modules_completed_apr2017)modules_completed_apr2017,
sum(modules_completed_may2017)modules_completed_may2017,
sum(modules_completed_jun2017)modules_completed_jun2017,
sum(modules_completed_jul2017)modules_completed_jul2017,
sum(modules_completed_aug2017)modules_completed_aug2017,
sum(modules_completed_2016)modules_completed_2016,
sum(modules_completed_jan2016)modules_completed_jan2016,
sum(modules_completed_feb2016)modules_completed_feb2016,
sum(modules_completed_mar2016)modules_completed_mar2016,
sum(modules_completed_apr2016)modules_completed_apr2016,
sum(modules_completed_may2016)modules_completed_may2016,
sum(modules_completed_jun2016)modules_completed_jun2016,
sum(modules_completed_jul2016)modules_completed_jul2016,
sum(modules_completed_aug2016)modules_completed_aug2016,
sum(modules_completed_sep2016)modules_completed_sep2016,
sum(modules_completed_oct2016)modules_completed_oct2016,
sum(modules_completed_nov2016)modules_completed_nov2016,
sum(modules_completed_dec2016)modules_completed_dec2016
from activity_count
group by sid,sname,school_id
),
content_module_list as
(select sid,sname,school_id,le.eid,cms.content_module_id content_module_id,date(cms.module_completed_at) module_completed_at
  from list_enrollments le,content_module_statuses cms,activities a
  where le.eid=cms.enrollment_id
  and a.activity_type='module'
  and a.active='t'
  and a.curriculum_id=2
  and a.module_id=cms.content_module_id
  and cms.module_completed_at is not null
  and cms.completed='t'
  group by sid,sname,school_id,eid,cms.content_module_id,module_completed_at
),
content_module_count as
(select sid,sname,school_id,eid,count(distinct content_module_id)tot_content_modules_alltime,
count(distinct(Case when module_completed_at between '2017-01-01' and '2017-12-31' then content_module_id end))content_modules_completed_2017,
count(distinct(Case when module_completed_at between '2017-01-01' and '2017-01-31' then content_module_id end))content_modules_completed_jan2017,
count(distinct(Case when module_completed_at between '2017-02-01' and '2017-02-28' then content_module_id end))content_modules_completed_feb2017,
count(distinct(Case when module_completed_at between '2017-03-01' and '2017-03-31' then content_module_id end))content_modules_completed_mar2017,
count(distinct(Case when module_completed_at between '2017-04-01' and '2017-04-30' then content_module_id end))content_modules_completed_apr2017,
count(distinct(Case when module_completed_at between '2017-05-01' and '2017-05-31' then content_module_id end))content_modules_completed_may2017,
count(distinct(Case when module_completed_at between '2017-06-01' and '2017-06-30' then content_module_id end))content_modules_completed_jun2017,
count(distinct(Case when module_completed_at between '2017-07-01' and '2017-07-31' then content_module_id end))content_modules_completed_jul2017,
count(distinct(Case when module_completed_at between '2017-08-01' and '2017-08-31' then content_module_id end))content_modules_completed_aug2017,
count(distinct(Case when module_completed_at between '2016-01-01' and '2016-12-31' then content_module_id end))content_modules_completed_2016,
count(distinct(Case when module_completed_at between '2016-01-01' and '2016-01-31' then content_module_id end))content_modules_completed_jan2016,
count(distinct(Case when module_completed_at between '2016-02-01' and '2016-02-29' then content_module_id end))content_modules_completed_feb2016,
count(distinct(Case when module_completed_at between '2016-03-01' and '2016-03-31' then content_module_id end))content_modules_completed_mar2016,
count(distinct(Case when module_completed_at between '2016-04-01' and '2016-04-30' then content_module_id end))content_modules_completed_apr2016,
count(distinct(Case when module_completed_at between '2016-05-01' and '2016-05-31' then content_module_id end))content_modules_completed_may2016,
count(distinct(Case when module_completed_at between '2016-06-01' and '2016-06-30' then content_module_id end))content_modules_completed_jun2016,
count(distinct(Case when module_completed_at between '2016-07-01' and '2016-07-31' then content_module_id end))content_modules_completed_jul2016,
count(distinct(Case when module_completed_at between '2016-08-01' and '2016-08-31' then content_module_id end))content_modules_completed_aug2016,
count(distinct(Case when module_completed_at between '2016-09-01' and '2016-09-30' then content_module_id end))content_modules_completed_sep2016,
count(distinct(Case when module_completed_at between '2016-10-01' and '2016-10-31' then content_module_id end))content_modules_completed_oct2016,
count(distinct(Case when module_completed_at between '2016-11-01' and '2016-11-30' then content_module_id end))content_modules_completed_nov2016,
count(distinct(Case when module_completed_at between '2016-12-01' and '2016-12-31' then content_module_id end))content_modules_completed_dec2016
from content_module_list
group by sid,sname,school_id,eid
),
content_modules_count_1 as
(select sid,sname,school_id,sum(tot_content_modules_alltime)tot_content_modules_alltime,
sum(content_modules_completed_2017)content_modules_completed_2017,
sum(content_modules_completed_jan2017)content_modules_completed_jan2017,
sum(content_modules_completed_feb2017)content_modules_completed_feb2017,
sum(content_modules_completed_mar2017)content_modules_completed_mar2017,
sum(content_modules_completed_apr2017)content_modules_completed_apr2017,
sum(content_modules_completed_may2017)content_modules_completed_may2017,
sum(content_modules_completed_jun2017)content_modules_completed_jun2017,
sum(content_modules_completed_jul2017)content_modules_completed_jul2017,
sum(content_modules_completed_aug2017)content_modules_completed_aug2017,
sum(content_modules_completed_2016)content_modules_completed_2016,
sum(content_modules_completed_jan2016)content_modules_completed_jan2016,
sum(content_modules_completed_feb2016)content_modules_completed_feb2016,
sum(content_modules_completed_mar2016)content_modules_completed_mar2016,
sum(content_modules_completed_apr2016)content_modules_completed_apr2016,
sum(content_modules_completed_may2016)content_modules_completed_may2016,
sum(content_modules_completed_jun2016)content_modules_completed_jun2016,
sum(content_modules_completed_jul2016)content_modules_completed_jul2016,
sum(content_modules_completed_aug2016)content_modules_completed_aug2016,
sum(content_modules_completed_sep2016)content_modules_completed_sep2016,
sum(content_modules_completed_oct2016)content_modules_completed_oct2016,
sum(content_modules_completed_nov2016)content_modules_completed_nov2016,
sum(content_modules_completed_dec2016)content_modules_completed_dec2016
from content_module_count
group by sid,sname,school_id
)

Select ec.sid"Sponsor Id",ec.sname"Sponsor Name",ec.sponsor_lead"Sponsor Lead",sum(tot_enrollments_alltime)"Total Enrollment All Time",sum(tot_modules_alltime)"Total Modules Completed All Time",
sum(tot_enrollments_2017)"Enrollments in 2017",sum(modules_completed_2017)"Modules Completed in 2017",sum(content_modules_completed_2017)"Modules Completed in 2017 - Deduped",
sum(tot_enrollments_jan2017)"New Enrollments in Jan 2017",sum(modules_completed_jan2017)"Modules Completed in Jan 2017",
sum(tot_enrollments_feb2017)"New Enrollments in Feb 2017",sum(modules_completed_feb2017)"Modules Completed in Feb 2017",
sum(tot_enrollments_mar2017)"New Enrollments in Mar 2017",sum(modules_completed_mar2017)"Modules Completed in Mar 2017",
sum(tot_enrollments_apr2017)"New Enrollments in Apr 2017",sum(modules_completed_apr2017)"Modules Completed in Apr 2017",
sum(tot_enrollments_may2017)"New Enrollments in May 2017",sum(modules_completed_may2017)"Modules Completed in May 2017",
sum(tot_enrollments_jun2017)"New Enrollments in Jun 2017",sum(modules_completed_jun2017)"Modules Completed in Jun 2017",
sum(tot_enrollments_jul2017)"New Enrollments in Jul 2017",sum(modules_completed_jul2017)"Modules Completed in Jul 2017",
sum(tot_enrollments_aug2017)"New Enrollments in Aug 2017",sum(modules_completed_aug2017)"Modules Completed in Aug 2017",
sum(tot_enrollments_2016)"Enrollments in 2016",sum(modules_completed_2016)"Modules Completed in 2016",sum(content_modules_completed_2016)"Modules Completed in 2016 - Deduped",
sum(tot_enrollments_jan2016)"New Enrollments in Jan 2016",sum(modules_completed_jan2016)"Modules Completed in Jan 2016",
sum(tot_enrollments_feb2016)"New Enrollments in Feb 2016",sum(modules_completed_feb2016)"Modules Completed in Feb 2016",
sum(tot_enrollments_mar2016)"New Enrollments in Mar 2016",sum(modules_completed_mar2016)"Modules Completed in Mar 2016",
sum(tot_enrollments_apr2016)"New Enrollments in Apr 2016",sum(modules_completed_apr2016)"Modules Completed in Apr 2016",
sum(tot_enrollments_may2016)"New Enrollments in May 2016",sum(modules_completed_may2016)"Modules Completed in May 2016",
sum(tot_enrollments_jun2016)"New Enrollments in Jun 2016",sum(modules_completed_jun2016)"Modules Completed in Jun 2016",
sum(tot_enrollments_jul2016)"New Enrollments in Jul 2016",sum(modules_completed_jul2016)"Modules Completed in Jul 2016",
sum(tot_enrollments_aug2016)"New Enrollments in Aug 2016",sum(modules_completed_aug2016)"Modules Completed in Aug 2016",
sum(tot_enrollments_sep2016)"New Enrollments in Sep 2016",sum(modules_completed_sep2016)"Modules Completed in Sep 2016",
sum(tot_enrollments_oct2016)"New Enrollments in Oct 2016",sum(modules_completed_oct2016)"Modules Completed in Oct 2016",
sum(tot_enrollments_nov2016)"New Enrollments in Nov 2016",sum(modules_completed_nov2016)"Modules Completed in Nov 2016",
sum(tot_enrollments_dec2016)"New Enrollments in Dec 2016",sum(modules_completed_dec2016)"Modules Completed in Dec 2016"
from enrollment_count ec
left outer join  activity_count_1 ac
on ec.sid=ac.sid
and ec.school_id=ac.school_id
left outer join  content_modules_count_1 cmc
on ec.sid=cmc.sid
and ec.school_id=cmc.school_id
group by ec.sid,ec.sname,ec.sponsor_lead
