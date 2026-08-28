
# Computer Science

This is a repo for all teachers working on the course to collaborate.

Given that many people might push code to the repo, it is important to keep things organized and clean.

Before trying to modify anything, please read this document.


## Project structure

The project is structured as follows:

* `slides/`: contains the slides for the course.
    * `style.scss`: contains the default style for the slides.
    * `images/`: contains the images used in the slides.
    * `_metadata.yml`: contains the default metadata for the slides.
    * `1-components/`, `2-binary/`, ...: contains the slides for the respective sessions.
* `exercices/`, `projects/`, `exams/`: contain the exercises, projects, and exams for the course with subdirectories for each session.
* `scripts/`: contain miscellenaous scripts.


## Initialization

This project was setup using the following commands (to simply install, go to next section):

```
uv init edu
cd edu
uv venv
quarto create project
```

Note: default values left for quarto.


## Setup

To start woking on the project, please first ensure that you have `git`, `uv` and `quarto` installed.

Pull project from github:

```
git clone https://github.com/julribon/edu.git
cd edu
```

Activate the virtual environement:

```
source .venv/bin/activate
```


