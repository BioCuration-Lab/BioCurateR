# BioCurateR

Welcome to the BioCuration Lab and the BioCurateR project. We're excited to collaborate with you!

This project is in active development. Our goal is to build reproducible, transparent, and well-documented workflows for handling biodiversity data that may be compiled into an R package. Every contribution—code, documentation, ideas, questions—helps us get there.

----

## Key Features (*in development*)

* Tools for evaluating observation quality and trustworthiness
* Documentation of curation criteria and data‑handling decisions
* Example workflows for downstream biodiversity analyses

----

## Project Structure

```
BioCurateR/
  ├── concept-demos/   # various workflow proof-of-concepts
  ├── data/            # processed, safe-to-share data
  ├── data-raw/        # .git-ignored
  ├── R/               # R functions
  ├── README.md
  └── .gitignore
```

----

## Contributing

We welcome contributions from collaborators of all experience levels.
Please read (CONTRIBUTING.md)[CONTRIBUTING.md] before getting started. It includes:

* how to clone the repo
* how to create a branch
* how to commit and push changes
* how to open a pull request
* coding style guidelines
* data‑handling rules
* how to ask questions

If you’re new to GitHub, don’t worry—our workflow is designed to be beginner‑friendly.

----

## Data Handling
* Do not commit raw data
* Processed, safe‑to‑share data may be stored in data/ or in the proper concept-demo
* All data transformations should be documented clearly.

If you’re unsure whether something is safe to commit, open an issue and ask.

----

## Documentation
All project documentation lives in:
• the Wiki (concepts, criteria, decisions, onboarding)
• the README (project overview)
• function documentation via roxygen2
• pipeline documentation in the concept-demos/ folder

More documentation will be added as the project grows.

----

## Contact / Questions

If you have questions, ideas, or suggestions:

* open an Issue
* comment on the Project board
* contribute to the Wiki
* or reach out directly
