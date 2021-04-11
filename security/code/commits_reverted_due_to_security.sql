# commits_reverted_due_to_security
# Interest triggered by
# Anomalicious: Automated Detection of Anomalous
# and Potentially Malicious Commits on GitHub
# https://arxiv.org/pdf/2103.03846.pdf
#
# See output at data/commits_reverted_due_to_security.csv

select
r.*
, ec_reverting.message as reverting_message
, ec_reverted.message as reverted_message
, regexp_contains(lower(ec_reverted.message)
    , 'vulnerabilit(?:y|ies)|cve(-d+)?(-d+)?|security|cyber|threat') as is_original_security
from
general.reverted_commits as r
join
general.enhanced_commits as ec_reverting
on
r.repo_name = ec_reverting.repo_name
and
r.reverting_commit = ec_reverting.commit
join
general.enhanced_commits as ec_reverted
on
r.repo_name = ec_reverted.repo_name
and
r.reverted_commit = ec_reverted.commit
where
regexp_contains(lower(ec_reverting.message)
, 'vulnerabilit(?:y|ies)|cve(-d+)?(-d+)?|security|cyber|threat') # reverted due to security
 order by
repo_name
, reverting_commit_timestamp desc
;
