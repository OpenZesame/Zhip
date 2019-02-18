# Your first PR

## Prerequisites

Before you start working on _Zhip_, make sure you had a look at [CONTRIBUTING.md](CONTRIBUTING.md).

For working on _Zhip_ you should have [Bundler][bundler] installed. Bundler is a ruby project that allows you to specify all ruby dependencies in a file called the `Gemfile`. If you want to learn more about how Bundler works, check out [their website][bundler help].
    
## Checking out the _Zhip_ repo

- Click the “Fork” button in the upper right corner of the [main _Zhip_ repo][zhip repo]
- Clone your fork:
  - `git clone git@github.com:<YOUR_GITHUB_USER>/Zhip.git`
  - Learn more about how to manage your fork: https://help.github.com/articles/working-with-forks/
- Install dependencies:
  - Run `bundle install` in the project root
  - If there are dependency errors, you might also need to run `bundle update`
- Create a new branch to work on:
  - `git checkout -b <YOUR_BRANCH_NAME>`
  - A good name for a branch describes the thing you’ll be working on, e.g. `bugfix/crash_when_deleting_wallet`, `tweak/gui_height_button`, `tweak/localizable_strings_settings`, `feature/contact_list`, etc.
- That’s it! Now you’re ready to work on _Zhip_

## Testing your changes

Write unit tests for logic, take a look at existing unit tests.

## Submitting the PR

When the coding is done and you’re finished testing your changes, you are ready to submit the PR to the [_Zhip_ main repo][zhip repo]. Everything you need to know about submitting the PR itself is inside our [Pull Request Template][pr template]. Some best practices are:

- Use a descriptive title
- Link the issues that are related to your PR in the body

## After the review

Once a core member has reviewed your PR, you might need to make changes before it gets merged. To make it easier on us, please make sure to avoid using `git commit --amend` or force pushes to make corrections. By avoiding rewriting the commit history, you will allow each round of edits to become its own visible commit. This helps the people who need to review your code easily understand exactly what has changed since the last time they looked. Feel free to use whatever commit messages you like, as we will squash them anyway. When you are done addressing your review, also add a small comment like “Feedback addressed @<your_reviewer>”.

It might take a couple of days until a core membber will have had time to merge your PR. And then it might take an additional week or so until a new release to App Store.

<!-- Links -->
[zhip repo]: https://github.com/OpenZesame/Zhip
[pr template]: .github/PULL_REQUEST_TEMPLATE.md
[bundler]: https://bundler.io
[bundler help]: https://bundler.io/v1.12/#getting-started
