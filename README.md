# Emotional human faces

Work in small R Markdown sections, keep reusable code in R files, and assemble
one report or standalone notebook.

## Layout

```text
analysis/          numbered Rmd sections, executed in filename order
R/                 reusable functions by purpose:
                   data, features, models, evaluation, visualization, submission
scripts/           setup, section execution, formatting, and notebook export
notebook.Rmd       complete report
renv.lock          shared package versions
data/              local inputs; see data/README.md
output/            generated files
```

## Setup

Use the R version recorded in `renv.lock`. In RStudio, open the `.Rproj` file.
In VS Code, open the repository folder, install the recommended
[R extension](https://github.com/REditorSupport/vscode-R), and start
**R: Create R terminal**. Then restore packages in the R console/terminal:

```r
install.packages("renv") # only if needed
renv::restore()
```

On Windows, restore with `renv::restore(exclude = "doMC")`.
Rendering also requires Pandoc; RStudio bundles it. Outside RStudio, check
`rmarkdown::pandoc_available()` and [install Pandoc](https://pandoc.org/installing.html)
if needed. Follow `data/README.md` for input placement. Data and outputs are ignored by Git.

## Run and edit

Run these from the repository root:

```sh
Rscript scripts/run.R            # all sections
Rscript scripts/run.R 02_pixels  # stop after this section
Rscript -e 'rmarkdown::render("notebook.Rmd", output_dir = "output")'
Rscript scripts/build_notebook.R # output/notebook.ipynb (suitable for kaggle)
```

To work interactively in either editor, prepare earlier sections in your R session:

```r
source("scripts/setup.R")
source("scripts/report.R")
run_sections(read_sections()[1:2])
```

Continue running chunks in subsequent Rmd files using the same session; variables
remain available until R restarts. `source("scripts/run.R")` runs all sections in
that session. Shell commands using `Rscript` start separate processes.
Render `notebook.Rmd` for the complete report; individual sections depend on earlier ones.

Add sections as `NN_name.Rmd`; unnumbered drafts are excluded. Keep short calls
and explanations in Rmd files, and functions with roxygen comments in focused
`R/` files.
After editing a function file, source it again in your session.
Use `code=readLines("R/path.R")` on a chunk containing its `source()` call to embed
the implementation in exports. Add `fold="Label"` to make the code collapsible.

For feature work, start with `R/features/features.R` and explain your method
in `analysis/03_features.Rmd`. The function currently returns the original
pixels. Its outputs, `features_train` and `features_test`, feed the tree and
prediction sections. After editing section 03, rerun the model and submission
sections.

Each model gets a function in `R/models/` and its own Rmd, like
`analysis/05_tree.Rmd`. Use the tree function and Rmd as templates. Reuse the settings in `04_models.Rmd`, set a fixed seed,
and give each fitted model a distinct name. Insert new model sections before
model selection, renumbering later sections. Compare cross-validation results
and choose `final_model` in `06_model_selection.Rmd`; submission uses that choice.

## Team workflow

Start focused branches from the latest `main`. Give independent methods separate files.
Review changes through pull requests; coordinate conflicts with the affected author.

```sh
Rscript scripts/check_style.R --fix # format and lint
Rscript scripts/check_style.R       # check without editing
```

Before pushing a commit, run affected sections and rebuild the notebook. Keep data and
outputs out of commits. When changing dependencies, update and commit `renv.lock`
with `renv::snapshot()`. Use only methods and packages allowed for your project.
