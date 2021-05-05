
drop table if exists general.relevant_java_files;

create table
general.relevant_java_files
as
select
fpy.*
from
general.file_properties_per_year as fpy
join
general.repo_properties as r
on
fpy.repo_name = r.repo_name
where
r.language = 'Java'
and
fpy.commits >= 5
and
extension = '.java'
and
(( fpy.corrective_rate = 0) or (fpy.corrective_rate >= 0.33))
and
not is_test
and fpy.year in (2019, 2020)
;

drop table if exists general.java_file_quality_dataset;

create table
general.java_file_quality_dataset
as
select
fpy1.repo_name
, fpy1.file
, max(( fpy1.corrective_rate = 0) and ( fpy2.corrective_rate = 0)) as high_ccp_quality
# Max in just for the aggregation, should have a single value per file anyway
from
general.relevant_java_files as fpy1
join
general.relevant_java_files as fpy2
on
fpy1.repo_name = fpy2.repo_name
and
fpy1.file = fpy2.file
where
fpy1.year = 2020
and
fpy2.year = 2019
and
(
(( fpy1.corrective_rate = 0) and ( fpy2.corrective_rate = 0))
or
(( fpy1.corrective_rate >= 0.33) and ( fpy2.corrective_rate >= 0.33))
)
group by
fpy1.repo_name
, fpy1.file
;


select
high_ccp_quality
, count(*) as files
from
general.java_file_quality_dataset
group by
high_ccp_quality
;

select
repo_name
, avg(if(high_ccp_quality,1,0)) as  high_ccp_quality_avg
, stddev(if(high_ccp_quality,1,0)) as  high_ccp_quality_std
, count(*) as files
from
general.java_file_quality_dataset
group by
repo_name
order by
count(*) desc
;

select
repo_name
, avg(if(high_ccp_quality,1,0)) as  high_ccp_quality_avg
, stddev(if(high_ccp_quality,1,0)) as  high_ccp_quality_std
, count(*) as files
from
general.java_file_quality_dataset
group by
repo_name
having
count(*) >= 10
and
stddev(if(high_ccp_quality,1,0)) > 0
order by
count(*) desc
;

select
high_ccp_quality
, case
when prev.corrective_rate = 0 then 1
else 0
end
as predicted_quality
, count(*) as files
from
general.java_file_quality_dataset as d
join
general.file_properties_per_year as prev
on
d.repo_name = prev.repo_name
and
d.file = prev.file
where
prev.year = 2018
and
prev.commits >= 5
group by
high_ccp_quality
, predicted_quality
order by
high_ccp_quality
, predicted_quality
;

select
not high_ccp_quality as low_quality
, case
when prev.corrective_rate >= 0.33 then 1
else 0
end
as predicted_low_quality
, count(*) as files
from
general.java_file_quality_dataset as d
join
general.file_properties_per_year as prev
on
d.repo_name = prev.repo_name
and
d.file = prev.file
where
prev.year = 2018
and
prev.commits >= 5
group by
low_quality
, predicted_low_quality
order by
low_quality
, predicted_low_quality
;