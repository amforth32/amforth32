# Amforth32 Docs

This repository contains the [documentation](https://amforth32.github.io/amforth32/) for [amforth32](https://github.com/amforth32/amforth32).


# Deployment

The site is deployed automatically when a new commit is created on the main branch.

This is done by the deploy [action](https://github.com/amforth32/amforth32.docs/actions/workflows/deploy.yaml), which copies the contents of the repository to `gh-pages` branch in the amforth32 repository.

This triggers standard GH pages build and deploy [action](https://github.com/amforth32/amforth32/actions/workflows/pages/pages-build-deployment) in the amforth32 repository which runs the contents through the static site generator (Jekyll) and deploys the result to the site.


# References

* GitHub Pages [documentation](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll/about-github-pages-and-jekyll)
* Jekyll [documentation](https://jekyllrb.com/)
* [Just-The-Docs](https://github.com/just-the-docs/just-the-docs) theme [documentation](https://just-the-docs.com/)