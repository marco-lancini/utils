# Github Changelog Generator

Docker image for [github-changelog-generator](https://github.com/github-changelog-generator/github-changelog-generator), which automatically generates change log from your tags, issues, labels and pull requests on GitHub.


## Usage
```bash
$ docker run --rm -it -v $(pwd):/src                                 \
             ghcr.io/marco-lancini/github-changelog-generator:latest \
             --user <user> --project <project>                       \
             -t $CHANGELOG_GITHUB_TOKEN                              \
```
