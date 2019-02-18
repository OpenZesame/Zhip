# How to respond to Issues and PRs

## How we treat each other  

When replying to issues and PRs, make sure you always follow our [Code of Conduct](CODE_OF_CONDUCT.md). Make sure to read these thoroughly and understand them before you interact with any other users! In general, be nice to each other, and treat **everyone** with the same respect and dignity.

Also, whenever you submit a comment, don’t ask users for their personal information or account credentials.

## How we use GitHub Labels

Issues and PRs may get marked with labels to help the Zhip team communicate with each other and with the community as a whole. Usually most issues and PRs will get a label that represents some general information about the state or nature of the issue/PR.

If you identify an issue that seems interesting but not time-critical, and is simple for new contributors to dive into, we recommend adding the “you can do this” label. PRs labeled “you can do this” should have very clear descriptions of the problem and solution. Remember that someone who is new to Zhip will need some coaching to be successful!

### Workflow Labels

| Label | Meaning|
| ----- | ------ |
| awaiting-reply | The Zhip team is engaged in discussion, but is currently waiting for a response from the community |
| blocked | We don't currently have a way forward, though we'd like to continue if possible |
| bug | We've acknowledged the issue as a defect |
| duplicate | Another issue/PR already exists that we think captures the problem/request |
| feature | The issue represents a request for an enhancement or new feature |
| you can do this | We're not actively looking at solving this issue, but community help would be appreciated |
| question | Someone is looking for help, but isn't describing a problem with the software |

## How to review Pull Requests

### Recommended setup for testing the code

- Clone the _zhip_ repository by running  `git clone git@github.com:openzesame/Zhip.git` in your terminal
- For each PR you want to review, make sure to add the user’s fork as a remote
  - `git remote add <GITHUB_USERNAME> git@github.com:<GITHUB_USERNAME>/Zhip.git`
- Then, check out the branch for the user’s PR
  - Fetch all their branches `git fetch <GITHUB_USERNAME>`
  - Checkout the branch for the PR `git checkout <THEIR_PR_BRANCH>`
  - Sometimes, changes have to be split over multiple PRs - one for each tool. In that case, it is often easier to test all the changes together. To do that, create a new branch that merges all their changes:
    - Create a new branch to merge the others into `git checkout -b my_new_branch`
    - Merge the branch from one PR `git pull --rebase <GITHUB_USERNAME> <THEIR_PR_BRANCH>`
    - Repeat the last step for each of the related PRs that the user submitted.
- After checking out a user’s code, you should always make sure that the tests are still working.
  - Run `bundle install` to make sure all dependencies are installed
  - Use `bundle exec fastlane test` from the root directory to run tests

If you have commit access, instead of adding each person's fork as a remote, you can also quickly test a single PR with the following commands:

```
git fetch origin pull/1234/head:pr-1234
git checkout pr-1234
```

### Reviewing the Code

Before diving into the source code changes of a pull request, step back and think if this change is a good change for _Zhip_. If you are not 100% certain that a pull request adds good value to _Zhip_, ask the author to clarify on why this should be included in the main code base. 

To review the code, start a new review on GitHub by going to the “Files changed” tab on the PR page. You can then add comments by tapping on the plus that appears when your mouse hovers over a line. Instead of submitting multiple comments one after another, use the `Start Review` button, so that participants don’t get flooded with multiple notifications.

When adding comments to a review, make sure they are
- *Polite*: Ask the author nicely to make the changes. We want to create an environment where our contributors like working with us and come back to submit more PRs
- *Constructive*: Don’t just say ‘This is bad’ or ‘I don’t like this’. Point the author in the right direction for changes they need to make to improve the code
- *Necessary*: It is often too easy to ask for changes on perfectly fine code because of personal opinions. If the change follows our vision, adheres to our style guides and is simple to understand, don’t ask the author to change it! You can always make follow-up on a merged PR with improvements of your own.
