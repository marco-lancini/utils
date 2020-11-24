# Homepage
https://github.com/pypa/pipenv

# Usage

## Initialize
```
$ export PIPENV_VENV_IN_PROJECT=true
$ pipenv --python /usr/bin/python3 install --skip-lock
$ pipenv shell
```
* To initialize a Python 3 virtual environment: `$ pipenv --three`
* To initialize a Python 2 virtual environment: `$ pipenv --two`

## Locate
```
# Locate the project
$ pipenv --where
     /Users/user/code/test

# Locate the virtualenv
$ pipenv --venv
     /Users/user/.local/share/virtualenvs/test-Skyy4vre

# Locate the Python interpreter:
$ pipenv --py
    /Users/user/.local/share/virtualenvs/test-Skyy4vre/bin/python
```

## Other commands
```
$ pipenv install flask==0.12.1

$ pipenv graph
```
