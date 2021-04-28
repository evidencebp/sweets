# Inspired by Demystifying Regular Expression Bugs
# https://arxiv.org/pdf/2104.09693.pdf

# Generate regex for regex as
#     print(build_sepereted_term(['regular\sexpression(s)?','reg(?:-|\s)?ex(p)?(s)?','grep', 'iregex']))

drop table if exists general.regex_commits;

create table
general.regex_commits
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
regexp_contains(lower(message), r'(\s|\.|\?|\!|\[|\]|\(|\)|\:|^|$|\,|/|#|\$|\%|&|\*|\+|=|`|;|<|>|@|~|{|}|_|\|)(regular\sexpression(s)?|reg(?:-|\s)?ex(p)?(s)?|grep|iregex)(\s|\.|\?|\!|\[|\]|\(|\)|\:|^|$|\,|/|#|\$|\%|&|\*|\+|=|`|;|<|>|@|~|{|}|_|\|)')
;


select
count(*) as commits
, general.bq_ccp_mle(1.0*count(distinct if(is_corrective, commit, null))/count(distinct commit)) as ccp
, avg(if(same_date_as_prev, duration, null)) as same_day_duration_avg
, avg(if(is_performance, 1,0)) as performance_avg
, avg(if(is_security, 1,0)) as security_avg
, avg(if(is_corrective, TIMESTAMP_DIFF(commit_timestamp, prev_timestamp, minute), null)) as bug_prev_touch_ago
from
general.enhanced_commits
;

select
count(*) as commits
, general.bq_ccp_mle(1.0*count(distinct if(is_corrective, commit, null))/count(distinct commit)) as ccp
, avg(if(same_date_as_prev, duration, null)) as same_day_duration_avg
, avg(if(is_performance, 1,0)) as performance_avg
, avg(if(is_security, 1,0)) as security_avg
, avg(if(is_corrective, TIMESTAMP_DIFF(commit_timestamp, prev_timestamp, minute), null)) as bug_prev_touch_ago
from
general.regex_commits
;