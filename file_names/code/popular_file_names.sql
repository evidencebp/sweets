select
reverse(substr(reverse(file), 0, STRPOS(reverse(file), '/'))) as file_first_name
, max(code_extension) as code_extension
, count(*) as cnt
from
general.file_properties
group by
file_first_name
order by
count(*) desc
limit 1000
;


select
lower(REGEXP_EXTRACT(reverse(substr(reverse(file), 0, STRPOS(reverse(file), '/')))
, concat(r'(?i)(index|main|test|client|errors|build|models|util|input|program|__init__\.py|register|service|config|view'
            , '|server|api|urls|base|server|constants|admin|table|script|exceptions|default|component|install|output'
            , '|types|helper|settings|application|values|api|token|math|deployment)'))) as file_name_group

, max(code_extension) as code_extension
, count(*) as cnt
from
general.file_properties
group by
file_name_group
order by
count(*) desc
;


select
lower(left(reverse(substr(reverse(file), 0, STRPOS(reverse(file), '/'))), STRPOS(reverse(substr(reverse(file), 0
    , STRPOS(reverse(file), '/'))), '.'))) as file_first_name
, max(code_extension) as code_extension
, count(*) as cnt
from
general.file_properties
group by
file_first_name
order by
count(*) desc
limit 1000
;


# Name popularity distribution
select
cnt as occurrences
, count(*) as files
from
(
select
lower(left(reverse(substr(reverse(file), 0, STRPOS(reverse(file), '/'))), STRPOS(reverse(substr(reverse(file), 0
    , STRPOS(reverse(file), '/'))), '.'))) as file_first_name
, max(code_extension) as code_extension
, count(*) as cnt
from
general.file_properties
group by
file_first_name
) as inSql
group by
cnt
order by
cnt
;

# see results in and_or_in_code_file_names.csv
select
lower(REGEXP_EXTRACT(reverse(substr(reverse(file), 0, STRPOS(reverse(file), '/')))
, concat(r'(?i)[_\.-](and|or)[_\.-]'))) as file_name_group
, count(*) as cnt
, avg(ccp) as ccp
, avg(refactor_mle) as refactor_mle
, avg(avg_coupling_code_size_cut) as avg_coupling_code_size_cut
, avg(same_day_duration_avg) as same_day_duration_avg
, avg(bug_prev_touch_ago) as bug_prev_touch_ago
, avg(size) as size
, avg(abs_content_ratio) as abs_content_ratio
, avg(performance_rate) as performance_rate
, avg(security_rate) as security_rate
, avg(one_file_fix_rate) as one_file_fix_rate
, avg(one_file_refactor_rate) as one_file_refactor_rate
from
general.file_properties
where
not is_test
and
code_extension
group by
file_name_group
order by
count(*) desc
;