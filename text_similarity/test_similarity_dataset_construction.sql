drop table if exists general.text_similarity_files;

create table
general.text_similarity_files
as
SELECT
f.repo_name
, f.path as file
, general.bq_repo_split(f.repo_name) as repo_split
, general.bq_file_split(f.repo_name
                         , f.path) as file_split
, -1 as first_period_commits
, -1 as second_period_commits
from
general.contents_1_june_2021 as f
join
`bigquery-public-data.github_repos.licenses` as lcn
on
f.repo_name = lcn.repo_name
join
general.contents_1_august_2021 as m
on
f.repo_name = m.repo_name
and
f.path = m.path
and
f.content != m.content
join
general.contents_1_december_2021 as l
on
f.repo_name = l.repo_name
and
f.path = l.path
and
f.content != l.content
and
m.content != l.content
where
f.extension = '.txt'
and
lcn.license in (
'agpl-3.0'
, 'apache-2.0'
, 'artistic-2.0'
, 'bsd-2-clause'
, 'bsd-3-clause'
, 'cc0-1.0'
, 'epl-1.0'
, 'gpl-2.0'
, 'gpl-3.0'
, 'isc'
, 'lgpl-2.1'
, 'lgpl-3.0'
, 'mit'
, 'mpl-2.0'
, 'unlicense'
)
;

DECLARE f_date DATE DEFAULT PARSE_DATE('%d/%m/%Y',  '1/6/2021');
DECLARE m_date DATE DEFAULT PARSE_DATE('%d/%m/%Y',  '1/8/2021') ;
DECLARE l_date DATE DEFAULT PARSE_DATE('%d/%m/%Y',  '1/12/2021') ;


drop table if exists general.relevant_commits_per_period;


create table
general.relevant_commits_per_period
as
select
f.repo_name
, f.file
, count(distinct commit) as commits
from
general.text_similarity_files as f
join
general.commits_files as cf
on
f.repo_name = cf.repo_name
and
f.file = cf.file
where
date(cf.commit_timestamp) > f_date
and
date(cf.commit_timestamp) <= m_date
group by
f.repo_name
, f.file
;


update general.text_similarity_files as t
set
first_period_commits = aux.commits
from
general.relevant_commits_per_period as aux
where
t.repo_name = aux.repo_name
and
t.file = aux.file
;


drop table if exists general.relevant_commits_per_period;


create table
general.relevant_commits_per_period
as
select
f.repo_name
, f.file
, count(distinct commit) as commits
from
general.text_similarity_files as f
join
general.commits_files as cf
on
f.repo_name = cf.repo_name
and
f.file = cf.file
where
date(cf.commit_timestamp) > m_date
and
date(cf.commit_timestamp) <= l_date
group by
f.repo_name
, f.file
;


update general.text_similarity_files as t
set
second_period_commits = aux.commits
from
general.relevant_commits_per_period as aux
where
t.repo_name = aux.repo_name
and
t.file = aux.file
;

drop table if exists general.relevant_commits_per_period;


update general.text_similarity_files as t
set
first_period_commits = null
where
first_period_commits = -1
;

update general.text_similarity_files as t
set
second_period_commits = null
where
second_period_commits = -1
;


select
count(*) as file
, sum(if(second_period_commits > first_period_commits, 1,0))/count(*) as date_commit_match
from
general.text_similarity_files
;

drop table if exists general.text_similarity_content_tmp;

create table
general.text_similarity_content_tmp
as
select
s.repo_name
, s.file
, f_date as date
, c.content
from
general.text_similarity_files as s
join
general.contents_1_june_2021 as c
on
s.repo_name = c.repo_name
and
s.file = c.path
;

insert into general.text_similarity_content_tmp
select
s.repo_name
, s.file
, m_date as date
, c.content
from
general.text_similarity_files as s
join
general.contents_1_august_2021 as c
on
s.repo_name = c.repo_name
and
s.file = c.path
;


insert into general.text_similarity_content_tmp
select
s.repo_name
, s.file
, l_date as date
, c.content
from
general.text_similarity_files as s
join
general.contents_1_december_2021 as c
on
s.repo_name = c.repo_name
and
s.file = c.path
;

drop table if exists general.text_similarity_content;


create table
general.text_similarity_content
as
select
*
from
general.text_similarity_content_tmp
order by
repo_name
, file
, date
;

drop table if exists general.text_similarity_content_tmp;

