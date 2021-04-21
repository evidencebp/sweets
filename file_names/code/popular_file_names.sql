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
