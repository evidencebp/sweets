drop table if exists general.ugly_commits;

create table
general.ugly_commits
as
select
repo_name
, commit
, author_name
, commit_timestamp
, subject
, message
, is_corrective
, is_refactor
, is_performance
, is_security
, duration
, same_date_as_prev
, prev_timestamp
from
general.enhanced_commits
where
regexp_contains(lower(message), r'ugly')
;


select
u.commit is not null as is_ugly
, count(*) as commits
, avg(if(ec.is_corrective, 1,0)) as fix_avg
, avg(if(ec.same_date_as_prev, ec.duration, null)) as same_day_duration_avg
, avg(if(ec.is_performance, 1,0)) as performance_avg
, avg(if(ec.is_security, 1,0)) as security_avg
, avg(if(ec.is_corrective, TIMESTAMP_DIFF(ec.commit_timestamp, ec.prev_timestamp, minute), null)) as bug_prev_touch_ago
from
general.enhanced_commits as ec
left join
general.ugly_commits as u
on
ec.repo_name = u.repo_name
and
ec.commit = u.commit
group by
is_ugly
order by
is_ugly
;


drop table if exists general.ugly_commits_files;

create table
general.ugly_commits_files
as
select
cf.repo_name
, cf.file
, count(distinct u.commit) as ugly_commits
from
general.ugly_commits as u
join
general.commits_files as cf
on
u.repo_name = cf.repo_name
and
u.commit = cf.commit
group by
cf.repo_name
, cf.file
;

# into ugly_commits_files_stats.csv
select
ugly_commits
, count(*) as files
, avg(commits) as commits
, avg(ccp) as ccp
, avg(refactor_mle) as refactor_mle
, avg(avg_coupling_code_size) as avg_coupling_code_size
, avg(authors) as authors
, avg(same_day_duration_avg) as same_day_duration_avg
, avg(bug_prev_touch_ago) as bug_prev_touch_ago
, avg(one_file_fix_rate) as one_file_fix_rate
, avg(typo_rate) as typo_rate
, avg(tangling_rate) as tangling_rate
, avg(bingo_rate) as bingo_rate
, avg(performance_rate) as performance_rate
, avg(security_rate) as security_rate
from
general.file_properties as fp
left join
general.ugly_commits_files as ucf
on
fp.repo_name = ucf.repo_name
and
fp.file = ucf.file
group by
ugly_commits
order by
ugly_commits
;


# into has_ugly_commits_files_stats.csv
select
ugly_commits is not null as has_ugly_commits
, count(*) as files
, avg(commits) as commits
, avg(ccp) as ccp
, avg(refactor_mle) as refactor_mle
, avg(avg_coupling_code_size) as avg_coupling_code_size
, avg(authors) as authors
, avg(same_day_duration_avg) as same_day_duration_avg
, avg(bug_prev_touch_ago) as bug_prev_touch_ago
, avg(one_file_fix_rate) as one_file_fix_rate
, avg(typo_rate) as typo_rate
, avg(tangling_rate) as tangling_rate
, avg(bingo_rate) as bingo_rate
, avg(performance_rate) as performance_rate
, avg(security_rate) as security_rate
from
general.file_properties as fp
left join
general.ugly_commits_files as ucf
on
fp.repo_name = ucf.repo_name
and
fp.file = ucf.file
group by
has_ugly_commits
order by
has_ugly_commits
;



drop table if exists general.ugly_content;


create table
general.ugly_content
as
select
repo_name
, path as file
from
general.contents
where
regexp_contains(lower(content), r'ugly')
;



# into has_ugly_content_files_stats.csv
select
uc.file is not null as is_ugly
, count(*) as files
, avg(commits) as commits
, avg(ccp) as ccp
, avg(refactor_mle) as refactor_mle
, avg(avg_coupling_code_size) as avg_coupling_code_size
, avg(authors) as authors
, avg(same_day_duration_avg) as same_day_duration_avg
, avg(bug_prev_touch_ago) as bug_prev_touch_ago
, avg(one_file_fix_rate) as one_file_fix_rate
, avg(typo_rate) as typo_rate
, avg(tangling_rate) as tangling_rate
, avg(bingo_rate) as bingo_rate
, avg(performance_rate) as performance_rate
, avg(security_rate) as security_rate
from
general.file_properties as fp
left join
general.ugly_content as uc
on
fp.repo_name = uc.repo_name
and
fp.file = uc.file
group by
is_ugly
order by
is_ugly
;


# into ugly_cm.csv
select
uc.file is not null as is_ugly_content
, ugly_commits is not null as has_ugly_commits
, count(*) as files
from
general.file_properties as fp
left join
general.ugly_content as uc
on
fp.repo_name = uc.repo_name
and
fp.file = uc.file
left join
general.ugly_commits_files as ucf
on
fp.repo_name = ucf.repo_name
and
fp.file = ucf.file
group by
is_ugly_content, has_ugly_commits
order by
is_ugly_content, has_ugly_commits
;
