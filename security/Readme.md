This sweet contains security related commits.
# Security Fixes
We [extracted](https://github.com/evidencebp/sweets/blob/main/security/code/security_fixes.sql) 261,495 security fixes from 22,820 repositories.
The repositories are from the BigQuery GitHub schema with 50+ commits during 2020.
Redundant and non software repositories were filtered out as described in [The Corrective Commit Probability](https://arxiv.org/pdf/2007.10912.pdf).

The data is at [security_fixes.csv.zip](https://github.com/evidencebp/sweets/blob/main/security/data/security_fixes.csv.zip)

Security was identified using the [security language mode](https://github.com/evidencebp/commit-classification/blob/master/security_model.py) f8aaa7f 

Fix was identified using the [corrective language mode](https://github.com/evidencebp/commit-classification/blob/master/corrective_model.py)  b472b87 

# Reverted Security Commits
We [extracted](https://github.com/evidencebp/sweets/blob/main/security/code/commits_reverted_due_to_security.sql) 2,726 commits reverted due to security from 22,820 repositories.
The repositories are from the BigQuery GitHub schema with 50+ commits during 2020.Redundant and non software repositories were filtered out as described in [The Corrective Commit Probability](https://arxiv.org/pdf/2007.10912.pdf).

The data is at [commits_reverted_due_to_security.csv](https://github.com/evidencebp/sweets/blob/main/security/data/commits_reverted_due_to_security.csv)

Revert was identified using the [the GitHub default revet message](https://github.com/evidencebp/general/blob/master/queries/reverted_commits.sql) 6583f7b 

Security was identified using the [security language mode](https://github.com/evidencebp/commit-classification/blob/master/security_model.py) f8aaa7f 


# External code

See here the [linguistic commit classification](https://github.com/evidencebp/commit-classification)

See here the [analysis utilities](https://github.com/evidencebp/analysis_utils) 

See here the [general database construction](https://github.com/evidencebp/general) 

Research used the model of commit d15d54e

Repositories will keep advancing.
