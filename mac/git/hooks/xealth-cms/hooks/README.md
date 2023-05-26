You can copy these to your .git/hooks directory. Make sure they are executable. (You can manually run to test.)

If you clone a repo you need to remember to re-add these. (Also see pre-commit project online. May be useful. It is like brew for git hooks.)

* commit-msg

Looks for missing jira ticket number (e.g. "MAIN-123") and complains if missing.
If your branch name starts with a ticket number it will automatically add it to the message.


* pre-commit

Looks for accidental inclusion of "it.only" or "describe.only" and complains if found in your .git index prior to commit.
