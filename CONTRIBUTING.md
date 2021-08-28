# Contribution Guide

+Below you will find the information needed to contribute to this project.

Note that by contributing to this collection, you agree with the code of conduct you can find [here.](https://github.com/maxhoesel/ansible-collection-pterodactyl/blob/main/CODE_OF_CONDUCT.md)

## Requirements

To begin development on this collection, you need to have the following dependencies installed:

- Docker, accessible by your local user account
- Python 3.6 or higher. CI tets run specifically against 3.6, but to make things easier we just use whatever version is available locally
- [Tox](https://tox.readthedocs.io/en/latest/)

## Quick Start

1. Fork the repository and clone it to your local machine
2. Run `./scripts/setup.sh` to configure a local dev environment (virtualenv) with a commit hook
3. Make your changes and commit them to a new branch
4. Run the tests locally with `./scripts/test.sh`. This will run the full test suite that also runs in the CI
5. Once you're done, push your changes and open a PR

## About commit messages and structure

- All commits **must** follow the [conventional-commits standard](https://www.conventionalcommits.org/en/v1.0.0/):
  `<type>(optional scope): <description>`
  - Valid scopes are all components of this collection, such as modules or roles
- Structure your changes so that they are separated into logical and independent commits whenever possible.
- The commit message should clearly state **what** your change does. The "why" and "how" belong into the commit body.

Some good examples:
- `fix(pterodactyl_panel): don't install unneeded packages`
- `feat(pterodactyl_wings): add support for new feature`

Don't be afraid to rename/amend/rewrite your branch history to achieve these goals!
Take a look at the `git rebase -i` and `git commit --amend` commands if you are not sure how to do so.
As long as your make these changes on your feature branch, there is no harm in doing so.#### Hints for role development


## Testing Framework

We use `molecule` to test all roles and the `ansible-test` suite to test modules.
Calls to these are handled by `tox` and the [`tox-ansible` extension]( https://github.com/ansible-community/tox-ansible).
You can run all the required tests for this project with `./scripts/test.sh`.
You can also open that file to view the individual test stages.

Note that you **can't** just run `tox`, as the `sanity` and `integration` environments need extra parameters passed to
`ansible-test`. Without these, they will fail. In addition, the `tox-ansible` plugin (which automatically generate scenario envs)
also adds a few unneeded environments to the list, such as `env`.

## Release Workflow

This project uses sematic versioning. Name versions accordingly.

For now, releases are simply tags on the main branch, with no separate release branch currently in use.

To create a release, simply run the "Create Release" GitHub Action with the desired version number (e.g. "0.3.0").
This action will:

1. Bump the version number in `galaxy.yml`
2. Update the changelog
3. Commit the changes in a "Release" commit and push it
4. Create a GitHub release (which will also create a tag at that commit)
5. Build the collection and publish the new release on galaxy
