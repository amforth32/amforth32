# Amforth32 Docs

This repository contains the [documentation](https://amforth32.github.io/amforth32/) for [amforth32](https://github.com/amforth32/amforth32).

# Deployment

The site is deployed automatically when a new commit is created on the main branch.

This is done by the deploy [action](https://github.com/amforth32/amforth32.docs/actions/workflows/deploy.yaml), which copies the contents of the repository to `gh-pages` branch in the amforth32 repository.

This triggers standard GH pages build and deploy [action](https://github.com/amforth32/amforth32/actions/workflows/pages/pages-build-deployment) in the amforth32 repository which runs the contents through the static site generator (Jekyll) and deploys the result to the site.

In order for this repository to be able to push content to the amforth32 repository, the action needs to use an [access token](https://github.com/organizations/amforth32/settings/personal-access-tokens/1312377) with content write permissions to the amforth32 repository. This token is stored in local secret named [GH_PAGES_PUSH_TOKEN](https://github.com/amforth32/amforth32.docs/settings/secrets/actions). To replace the token:
1. create a new org token with content-write permission to the amforth32 repository
2. copy the resulting token into the GH_PAGES_PUSH_TOKEN secret
3. revoke/delete the old token

# References

* GitHub Pages [documentation](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
* Jekyll [documentation](https://jekyllrb.com/)
* [Just-The-Docs](https://github.com/just-the-docs/just-the-docs) theme [documentation](https://just-the-docs.com/)