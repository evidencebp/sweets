# Bug fixes in the security domain
#
# See output in data/security_fixes.csv.zip

drop table if exists general.security_fixes;

create table
general.security_fixes
as
Select
repo_name
, commit
, commit_timestamp
, author_name
, author_email
, message
, regexp_contains(lower(message), 'cve(-d+)?(-d+)?')  as is_cve
from
general.enhanced_commits
where
is_corrective
and
is_security
#regexp_contains(lower(message), '(vulnerabilit(?:y|ies)|cve(-d+)?(-d+)?|security|cyber|threat)')
#regexp_contains(lower(message), 'cve(-d+)?(-d+)?') # 7905
order by
repo_name
, commit_timestamp
;

select
count(*) as fixes
, count(distinct author_name) as fixing_developers
, count(distinct repo_name) as fixing_repos
from
general.security_fixes
;

select
fixes
, count(*) as developers
from
(
select
author_name
, count(*) as fixes
from
general.security_fixes
group by
author_name
) as inSql
group by
fixes
order by
fixes
;

select *
from
(
select
distinct
d.*
from
general.security_fixes as s
join
general.developer_per_repo_profile as d
on
s.repo_name = d.repo_name
and
s.author_email = d.author_email
and
s.author_name = d.author_name
)
order by
repo_name
, author_name
;

# Sql injection
drop table if exists general.sql_injection_commits;

create table
general.sql_injection_commits
as
select
repo_name
, commit
, author_name
, commit_timestamp
, message
, is_corrective
, is_adaptive
, is_perfective
, is_refactor
, is_cursing
, is_positive_sentiment
, is_negative_sentiment
, is_performance
, files
, non_test_files
, code_files
, code_non_test_files
, duration
, same_date_as_prev
, prev_timestamp
, TIMESTAMP_DIFF(commit_timestamp, prev_timestamp, minute) as prev_touch_ago
from
general.enhanced_commits
where
regexp_contains(lower(message), 'sql(-| )injection')
;


select
count(*) as commits
, general.bq_ccp_mle(1.0*count(distinct if(is_corrective, commit, null))/count(distinct commit)) as ccp
, avg(if(same_date_as_prev, duration, null)) as same_day_duration_avg
, avg(if(is_performance, 1,0)) as performance_avg
, avg(if(is_corrective, TIMESTAMP_DIFF(commit_timestamp, prev_timestamp, minute), null)) as bug_prev_touch_ago
from
general.sql_injection_commits
;