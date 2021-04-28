We classify text for regular related  code modifications.


Instructions


  1. A commit that adds, modifies or removes a regular expression is considered to be related.
  1. A tangles commit, modifying a regular expression and doing other work, is considered related.
  1. Commit that was generated using a regular expression but not modifying a regular expression is not considered related.
  An example to such a case is renaming functions by some pattern.
  1. A perfective commit, a commit documenting a regular expression in the code, is consider related.
