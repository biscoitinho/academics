Let's start with the problems these tools want to solve:

My system package manager don't have the Python versions I wanted or I want to install multiple Python versions side by side, Python 3.9.0 and Python 3.9.1, Python 3.5.3, etc

Then use pyenv.

```
pip install virtualenv
python -m venv venv
source myvenv/bin/activate
deactivate
```

I want to install and run multiple applications with different, conflicting dependencies.

Then use virtualenv or venv. These are almost completely interchangeable, the difference being that virtualenv supports older python versions and has a few more minor unique features, while venv is in the standard library.

I'm developing an /application/ and need to manage my dependencies, and manage the dependency resolution of the dependencies of my project.

Then use pipenv or poetry.

I'm developing a /library/ or a /package/ and want to specify the dependencies that my library users need to install

Then use setuptools.

I used virtualenv, but I don't like virtualenv folders being scattered around various project folders. I want a centralised management of the environments and some simple project management

Then use virtualenvwrapper. Variant: pyenv-virtualenvwrapper if you also use pyenv.

Not recommended

pyvenv. This is deprecated, use venv or virtualenv instead. Not to be confused with pipenv or pyenv.
