select * from [dbo].[Profiles];
select * from [dbo].[Tenancy_histories];

--edvancer question 1

select p.PROFILE_ID,p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,
cast(DATEDIFF(DAY, [MOVE_IN_DATE],[MOVE_OUT_DATE])as int) as LONGEST_STAY_DAYS from [dbo].[Profiles] as p
inner join
[dbo].[Tenancy_histories] as t
on p.PROFILE_ID=t.PROFILE_ID
where cast(DATEDIFF(DAY, [MOVE_IN_DATE],[MOVE_OUT_DATE])as int) in
(select max(cast(DATEDIFF(DAY, [MOVE_IN_DATE],[MOVE_OUT_DATE])as int)) from [dbo].[Tenancy_histories]);

--edvancer question 2

select p.PROFILE_ID,p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,
p.EMAIL,t.RENT from [dbo].[Profiles] as p
inner join
[dbo].[Tenancy_histories] as t
on p.PROFILE_ID=t.PROFILE_ID
where p.MARITAL_STATUS='Y' and t.RENT>9000;

--edvancer question 3

select p.PROFILE_ID,p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,p.EMAIL,p.CITY_HOMETOWN,t.house_id,
t.[MOVE_IN_DATE],t.[MOVE_OUT_DATE],t.rent,e.LATEST_EMPLOYER,e.OCCUPATIONAL_CATEGORY
from [dbo].[Profiles] as p
inner join
[dbo].[Tenancy_histories] as t
on p.PROFILE_ID=t.PROFILE_ID
inner join
[dbo].[Employment_details] as e
on p.PROFILE_ID=e.PROFILE_ID
where p.CITY_HOMETOWN in ('bangalore','pune')
and (t.MOVE_IN_DATE BETWEEN cast('2015-01-1 00:00:00.0'as datetime) AND cast('2016-01-1 23:59:59.0' as datetime)
or t.MOVE_OUT_DATE BETWEEN cast('2015-01-1 00:00:00.0'as datetime) AND cast('2016-01-1 23:59:59.0' as datetime))
order by t.RENT desc;

--WHERE ShipDate >= '2011-07-23' AND ShipDate < '2011-07-25';

select * from [dbo].[Profiles];
select * from [dbo].[Referrals];
select * from [dbo].[Tenancy_histories];
select * from [dbo].[Houses];

select * from [dbo].[Employment_details];

--edvancer question 4

select p.PROFILE_ID,p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,p.EMAIL,p.REFERRAL_CODE,r.REFERRER_BONUS_AMOUNT,
rcc.rc, r.REF_ID,
sum(r.REFERRER_BONUS_AMOUNT) over ( partition by p.REFERRAL_CODE) as [total_bonus]
from [dbo].[Profiles] as p
inner join
Referrals as r
on r.PROFILE_ID=p.PROFILE_ID
inner join
(select profile_id, count(profile_id) as rc from Referrals group by profile_id having count(*) > 1) as rcc
on rcc.PROFILE_ID=r.PROFILE_ID;

select p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,p.EMAIL,p.REFERRAL_CODE,r.REFERRER_BONUS_AMOUNT,
tc_count.count_total
from [dbo].[Profiles] as p
inner join
[dbo].[Referrals] as r
on p.PROFILE_ID=r.PROFILE_ID
inner join
(select PROFILE_ID,REFERRAL_CODE ,count(REFERRAL_CODE) over ( partition by REFERRAL_CODE) as [count_total]  from profiles) as tc_count
on tc_count.PROFILE_ID=p.PROFILE_ID;


select p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,p.EMAIL,p.REFERRAL_CODE,r.REFERRER_BONUS_AMOUNT,
sum(r.REFERRER_BONUS_AMOUNT) over ( partition by r.REFERRAL_CODE) as [total_bonus]
from [dbo].[Profiles] as p
inner join
[dbo].[Referrals] as r
on p.PROFILE_ID=r.PROFILE_ID
inner join
(select profile_id,REFERRAL_CODE,count(REFERRAL_CODE) over ( partition by REFERRAL_CODE) as [count] from Profiles) as rc_count
on rc_count.PROFILE_ID=p.PROFILE_ID;





count(REFERRAL_CODE) over ( partition by REFERRAL_CODE) as [count]
REFERRAL_CODE,count(*) as count_total from profiles group by REFERRAL_CODE

rank() over (order by salary desc) as [rank]

select s_name,s_gender,s_age,
count(s_gender) over (partition by s_gender) as gender_total,
max(s_age) over (partition by s_gender) as max_age,
min(s_age) over (partition by s_gender) as min_age,
avg(s_age) over (partition by s_gender) as avg_age
from tbl_student;


select s_name,s_age,tbl_student.s_gender,genders.gender_total,
genders.max_age,genders.min_age,genders.avg_age
from tbl_student
inner join
(select s_gender, count(s_gender) as gender_total,max(s_age) as max_age,min(s_age) as min_age,avg(s_age) as avg_age
from tbl_student group by s_gender) as genders
on tbl_student.s_gender=genders.s_gender;

select REFERRAL_CODE, count(REFERRAL_CODE) as REFERRAL_CODE_count
from [dbo].[Profiles] group by REFERRAL_CODE;

select * from [dbo].[Referrals];
select * from [dbo].[Profiles];
select * from [dbo].[Tenancy_histories];

select city,gender,sum(salary) as total_salary
from Profiles
group by city,gender
union all
select city,null,sum(salary) as total_salary
from employee
group by city
union all
select null,gender,sum(salary) as total_salary
from employee
group by gender;

--edvancer question 5

select p.CITY_HOMETOWN,sum(t.RENT)
from profiles as p
inner join
Tenancy_histories as t
on p.PROFILE_ID=t.PROFILE_ID
group by p.CITY_HOMETOWN
union all
select null,sum(t.RENT)
from profiles as p
inner join
Tenancy_histories as t
on p.PROFILE_ID=t.PROFILE_ID;

----edvancer question 6

create view vw_tenant
as
select p.PROFILE_ID,t.RENT,t.MOVE_IN_DATE,h.HOUSE_TYPE,h.BEDS_VACANT,a.[DESCRIPTION_],p.CITY_HOMETOWN,
a.NAME_+' '+a.CITY+' '+cast(a.PINCODE as varchar(25)) as [address]
from profiles as p
inner join
Tenancy_histories as t
on p.PROFILE_ID=t.PROFILE_ID
inner join
Houses as h
on t.HOUSE_ID=h.HOUSE_ID
inner join
Addresses as a
on a.HOUSE_ID=h.HOUSE_ID
where (t.MOVE_OUT_DATE > cast('2015-04-30 00:00:00.0'as datetime) or t.MOVE_OUT_DATE = cast('2015-04-30 00:00:00.0'as datetime))
and (h.BEDS_VACANT > 0);

select * from vw_tenant;

select * from [dbo].[Referrals];
select * from [dbo].[Profiles];
select * from [dbo].[Addresses];
select * from [dbo].[Tenancy_histories];
select * from [dbo].[Houses];

select * from [dbo].[Employment_details];

--edvancer question 7
SELECT s.Name,
COUNT(w.WorkOrderID) AS Cnt
FROM Production.ScrapReason s
INNER JOIN Production.WorkOrder w
ON s.ScrapReasonID = w.ScrapReasonID
GROUP BY s.Name
HAVING COUNT(*) > 50;









 
 --edvancer question 8

select p.PROFILE_ID, p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME, p.PHONE,
case 
when t.RENT> 10000 then 'grade a'
when t.RENT> 7500 and t.RENT< 10000 then 'grade b'
else 'grade c'
end as customer_segment
from profiles as p
inner join
Tenancy_histories as t
on p.PROFILE_ID=t.PROFILE_ID;

--edvancer question 9


--edvancer question 10

select * from [dbo].[Referrals];
select * from [dbo].[Profiles];
select * from [dbo].[Addresses];
select * from [dbo].[Tenancy_histories];
select * from [dbo].[Houses];

select * from [dbo].[Employment_details];


select h.HOUSE_TYPE,h.BED_COUNT,h.FURNISHING_TYPE,h.BEDS_VACANT,h.BHK_DETAILS,t.BED_TYPE,
a.NAME_+' '+cast(a.DESCRIPTION_ as varchar(150))+' '+a.CITY+' '+cast(a.PINCODE as varchar(50)) as [complete_address],
cast(DATEDIFF(DAY, t.[MOVE_IN_DATE],t.[MOVE_OUT_DATE])as int) as highest_occupancy
from houses as h
inner join
Tenancy_histories as t
on h.HOUSE_ID=t.HOUSE_ID
inner join
Addresses as a
on h.HOUSE_ID=a.HOUSE_ID
where cast(DATEDIFF(DAY, t.[MOVE_IN_DATE],t.[MOVE_OUT_DATE])as int) =
(select max(cast(DATEDIFF(DAY, [MOVE_IN_DATE],[MOVE_OUT_DATE])as int)) from [dbo].[Tenancy_histories]);












select p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,p.EMAIL,p.REFERRAL_CODE,r.REFERRER_BONUS_AMOUNT,
count(REFERRAL_CODE) over ( partition by REFERRAL_CODE) as [count],
sum(r.REFERRER_BONUS_AMOUNT) over ( partition by REFERRAL_CODE) as [total_bonus]
from [dbo].[Profiles] as p
inner join
[dbo].[Referrals] as r
on p.PROFILE_ID=r.PROFILE_ID



WITH cte AS
(
select p.FIRST_NAME+' '+p.LAST_NAME as FULL_NAME,p.PHONE,p.EMAIL,p.REFERRAL_CODE,r.REFERRER_BONUS_AMOUNT,
count(REFERRAL_CODE) over ( partition by REFERRAL_CODE) as [rc_count],
sum(r.REFERRER_BONUS_AMOUNT) over ( partition by REFERRAL_CODE) as [total_bonus]
from [dbo].[Profiles] as p
inner join
[dbo].[Referrals] as r
on p.PROFILE_ID=r.PROFILE_ID
)
SELECT [rc_count] not 1
FROM cte;


