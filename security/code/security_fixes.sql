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
regexp_contains(lower(message), '(vulnerabilit(?:y|ies)|cve(-d+)?(-d+)?|security|cyber|threat)')
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
