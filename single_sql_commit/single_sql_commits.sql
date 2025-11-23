drop table if exists general.single_sql_commits;

create table general.single_sql_commits
as
select 
ec.repo_name
, ec.commit
, ec.commit_timestamp
, ec.is_corrective
, ec.is_refactor
, ec.is_performance
, ec.is_security
, ec.message
, ec.duration
, ec.prev_commit
, ec.prev_timestamp
, ec.same_date_as_prev
from
general.enhanced_commits as ec
join
general.commits_files as cf
on
ec.repo_name = cf.repo_name
and
ec.commit = cf.commit
where
ec.files = 1 # A single file simple commit
and
lower(cf.extension) = '.sql'
#and (ec.is_corrective or ec.is_refactor) # commits of interest are bug fix or refactoring
;

# into single_sql_commits_stats.csv
select
count(*) as commits
, general.bq_ccp_mle(1.0*count(distinct if(is_corrective, commit, null))/count(distinct commit)) as ccp
, avg(if(same_date_as_prev, duration, null)) as same_day_duration_avg
, avg(if(is_performance, 1,0)) as performance_avg
, avg(if(is_security, 1,0)) as security_avg
, avg(if(is_corrective, TIMESTAMP_DIFF(commit_timestamp, prev_timestamp, minute), null)) as bug_prev_touch_ago
from
general.single_sql_commits
;