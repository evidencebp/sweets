This sweet contains security related commits.
# Security Fixes
We [extracted](https://github.com/evidencebp/sweets/blob/main/security/code/security_fixes.sql) 261,495 security fixes from 22,820 repositories.
The repositories are from the BigQuery GitHub schema with 50+ commits during 2020.
Redundant and non software repositories were filtered out as described in [The Corrective Commit Probability](https://arxiv.org/pdf/2007.10912.pdf).

The data is at [security_fixes.csv.zip](https://github.com/evidencebp/sweets/blob/main/security/data/security_fixes.csv.zip)

Security was identified using the [security language mode](https://github.com/evidencebp/commit-classification/blob/master/security_model.py) f8aaa7f 

Fix was identified using the [corrective language mode](https://github.com/evidencebp/commit-classification/blob/master/corrective_model.py)  b472b87 

There is another data set of 13K [sql injection commits](https://github.com/evidencebp/sweets/blob/main/security/data/sql_injection_commits.csv).

# Reverted Security Commits
We [extracted](https://github.com/evidencebp/sweets/blob/main/security/code/commits_reverted_due_to_security.sql) 2,726 commits reverted due to security from 22,820 repositories.
The repositories are from the BigQuery GitHub schema with 50+ commits during 2020.Redundant and non software repositories were filtered out as described in [The Corrective Commit Probability](https://arxiv.org/pdf/2007.10912.pdf).

The data is at [commits_reverted_due_to_security.csv](https://github.com/evidencebp/sweets/blob/main/security/data/commits_reverted_due_to_security.csv)

Revert was identified using the [the GitHub default revet message](https://github.com/evidencebp/general/blob/master/queries/reverted_commits.sql) 6583f7b 

Security was identified using the [security language mode](https://github.com/evidencebp/commit-classification/blob/master/security_model.py) f8aaa7f 

# Citing

This reposotory contain database construction on the BigQuery GitHub scehmea.
It was constructed as part of

# The Corrective Commit Probability Code Quality Metric
Supplementary Materials of the ["The Corrective Commit Probability Code Quality Metric"](https://arxiv.org/abs/2007.10912) paper by Idan Amit and [Dror G. Feitelson](https://www.cs.huji.ac.il/~feit/).

Please cite as
``` 
@misc{amit2020corrective,
    title={The Corrective Commit Probability Code Quality Metric},
    author={Idan Amit and Dror G. Feitelson},
    year={2020},
    eprint={2007.10912},
    archivePrefix={arXiv},
    primaryClass={cs.SE}
}
```

It was later extended as part of

# Follow Your Nose - Which Code Smells are Worth Chasing?
Supplementary Materials of the ["Follow Your Nose -- Which Code Smells are Worth Chasing?"](https://arxiv.org/pdf/2103.01861.pdf) paper by Idan Amit, Nili Ben Ezra, and [Dror G. Feitelson](https://www.cs.huji.ac.il/~feit/).

Please cite as
``` 
@misc{amit2021follow,
      title={Follow Your Nose -- Which Code Smells are Worth Chasing?}, 
      author={Idan Amit and Nili Ben Ezra and Dror G. Feitelson},
      year={2021},
      eprint={2103.01861},
      archivePrefix={arXiv},
      primaryClass={cs.SE}
}
```


# External code

See here the [linguistic commit classification](https://github.com/evidencebp/commit-classification)

See here the [analysis utilities](https://github.com/evidencebp/analysis_utils) 

See here the [general database construction](https://github.com/evidencebp/general) 

Research used the model of commit d15d54e

Repositories will keep advancing.
