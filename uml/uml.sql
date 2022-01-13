select
uml_repos.repo_name is not null as uses_uml
, count(distinct r.repo_name) as repos
, avg(ccp) as ccp
, avg(refactor_mle) as refactor_mle
, avg(avg_coupling_code_size_cut) as avg_coupling_code_size_cut
, avg(tests_presence) as tests_presence
, avg(authors) as authors
, avg(same_day_duration_avg) as same_day_duration_avg
, avg(prev_touch_ago) as prev_touch_ago
, avg(uml_repos.commits) as uml_commits
from
general.repo_properties as r
left join
(
select
repo_name
, count(distinct commit) as commits
from
general.enhanced_commits
where
regexp_contains(lower(message), ' uml ')
group by
repo_name
having
count(*) >= 10
) as uml_repos
on
r.repo_name = uml_repos.repo_name
group by
uses_uml
order by
uses_uml
;

select
case
when authors < 10 then 'small'
when authors < 80 then 'medium'
else 'large'
end as developers_group
, uml_repos.repo_name is not null as uses_uml
, count(distinct r.repo_name) as repos
, avg(ccp) as ccp
, avg(refactor_mle) as refactor_mle
, avg(avg_coupling_code_size_cut) as avg_coupling_code_size_cut
, avg(tests_presence) as tests_presence
, avg(authors) as authors
, avg(same_day_duration_avg) as same_day_duration_avg
, avg(prev_touch_ago) as prev_touch_ago
, avg(uml_repos.commits) as uml_commits
from
general.repo_properties as r
left join
(
select
repo_name
, count(distinct commit) as commits
from
general.enhanced_commits
where
regexp_contains(lower(message), ' uml ')
group by
repo_name
having
count(*) >= 10
) as uml_repos
on
r.repo_name = uml_repos.repo_name
group by
developers_group
, uses_uml
order by
developers_group
, uses_uml
;