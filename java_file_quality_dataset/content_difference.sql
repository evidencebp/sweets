create table
general.contents_1_june_2021
as
SELECT
*
FROM
general.contents
;


drop table if exists general.contents_diff_1_june_2021;


create table
general.contents_diff_1_june_2021
as
select
n.repo_name
, n.path as file
, n.content
from
general.java_file_quality_content_6_may_2021 as p
join
general.contents_1_june_2021 as n
on
p.repo_name = n.repo_name
and
p.file = n.path
where
p.content != n.content
;

