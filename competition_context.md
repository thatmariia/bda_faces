# Competition Context: Facial Emotion Recognition (Kaggle, CK+ 48)

This file describes the competition, the data, the rules, and the grading rubrics for each submission round. Treat everything here as binding unless the user explicitly says otherwise.

---

## 1. Task

Build an algorithm that recognizes the emotion in photographs of facial expressions. Each photo shows one of four emotions:

| Label (exact string) | Emotion |
|---|---|
| `anger` | Anger |
| `disgust` | Disgust |
| `happy` | Happiness |
| `sad` | Sadness |

### Human benchmark
UvA students (mostly Psychology, n = 20) reached **74.4% accuracy** (updated October 2022). Rows are human responses, columns are ground-truth CK+ labels:

|  | anger | disgust | happy | sadness |
|---|---|---|---|---|
| **Anger** | 23 | 9 | 1 | 0 |
| **Disgust** | 6 | 35 | 4 | 2 |
| **Happy** | 4 | 3 | 66 | 0 |
| **Sad** | 9 | 7 | 1 | 10 |

Observations worth using: humans recognize *happy* almost perfectly, confuse *anger* and *disgust* with each other, and are worst at *sad* (often called anger or disgust). Expect a model to struggle in similar places.

### Evaluation metric
Accuracy:
```r
mean(Predicted == Observed)
```

---

## 2. Data

### Origin
- Derived from the **CK+ (Extended Cohn-Kanade) database** (Lucey et al., 2010), an expansion of the original Cohn-Kanade database released to promote research on automatic detection of facial expressions. It is one of the most widely used test-beds for algorithm development and evaluation.
- This version is **CK+ 48 cropped**: photos are cropped to fit the face snugly.
- **For this competition, randomly rotated and/or shifted versions were created and added to the database.** (See modelling implications below.)
- Images are **stills from video sequences**.
- **101 different participants**, aged 18–50, 69% female, 81% Euro-American, 13% Afro-American, 6% other groups.
- Participants performed a series of 23 facial displays, including combinations of **Action Units** that correspond to anger, disgust, happy and sadness.
- **Action Units (AUs)**: facial muscle movements that can be turned on or off (more or less) independently. Specific on/off configurations correspond to specific emotions. This framework was used to collect the pictures and to validate the labels; emotion researchers validated labels by visual inspection of the AUs.
- Images are **grayscale PNG** files.
- Photos were randomly split into a training and a test set.

### Files
- `train/` — training pictures in sub-folders; **sub-folder names are the labels**.
- `test/` — test pictures without labels.
- `sampleSubmission.csv` — sample submission in the correct format.

### Data fields
- `file` — filename of the test picture (character)
- `category` — predicted label (character)

### Modelling implications of the data (for the AI to keep in mind)
- **Rotation/shift augmentation**: pixel-by-pixel features are sensitive to position. Features that are less sensitive to small shifts/rotations (e.g., region-based summaries, histograms, PCA-based features) are worth considering and motivating.
- **Same person, many images**: filenames look like `S005_001_00000010a.png` (subject `S005`, sequence `001`, frame, and a letter suffix that appears to mark augmented variants). Augmented copies and neighbouring video frames of the same subject are near-duplicates. **Random-row cross-validation can therefore be overly optimistic** (leakage between folds). Consider grouping folds by subject or sequence and explain the choice. Verify the filename pattern in the actual data before relying on it.
- **Class balance** may be uneven (the human test sample suggests many more *happy* than *sad* images). Check class counts and look at the confusion matrix, not only accuracy.
- Action Units motivate feature choices: e.g., mouth region (happy, sad), brow region (anger, sad), nose wrinkle / upper lip (disgust).

### Reference
P. Lucey, J. F. Cohn, T. Kanade, J. Saragih, Z. Ambadar and I. Matthews (2010). *The Extended Cohn-Kanade Dataset (CK+): A complete dataset for action unit and emotion-specified expression.* IEEE CVPR Workshops, San Francisco, CA, pp. 94–101. doi: 10.1109/CVPRW.2010.5543262

---

## 3. Submission format

For every image in `test/`, predict one of `anger`, `disgust`, `happy`, `sad`.

- File type: `.csv` with a header and exactly two columns: `file`, `category`.
- `category` must contain **only those exact labels**.
- `file` must be **identical to the test image's filename** (case sensitive), **without the path**: everything up to and including the last `/` or `\` must be removed.

```
file,category
S005_001_00000010a.png,anger
S005_001_00000010b.png,happy
S005_001_00000010c.png,anger
⋮
```

### Integrity rule
Because the test set is "easy" to label by hand, the submitted notebook must:
- run without problems ("Run all", no errors),
- **fit and tune the model only on the training set**,
- produce exactly the predictions file that was submitted,
- make it clear how the final model was chosen and tuned using only the training set,
- set a **fixed seed** at the start of the notebook for reproducibility.

---

## 4. Competition rules

### 4.1 Allowed methods ("leveling the playing field")
- **Only methods from ISLR (An Introduction to Statistical Learning, with Applications in R) Chapters 1–9 and Chapter 12**, plus techniques introduced in class. **Any other method automatically disqualifies the submission.**
- Use the **example code from class and/or the ISLR book**.
- **Googling "how-to's" is prohibited.** All needed information is in the book, reading materials and examples.
- **Packages**: only those discussed in the relevant ISLR chapters or in the official course materials. No other libraries.
- **caret warning**: caret gives access to many advanced methods; only those discussed in the allowed chapters and in class may be used.
- **Visualization**: extra visualization packages (e.g., `corrplot`) are **not allowed**. **ggplot2 (tidyverse) is allowed and encouraged.**

Allowed chapter content (for quick reference; the textbook in this project is the authority):

| Ch. | Topic | Typical methods |
|---|---|---|
| 1 | Introduction | — |
| 2 | Statistical learning | bias–variance trade-off, training vs test error, KNN idea |
| 3 | Linear regression | linear models, interactions, non-linear transformations |
| 4 | Classification | logistic & multinomial logistic regression, LDA, QDA, naive Bayes, KNN |
| 5 | Resampling | validation set, LOOCV, k-fold CV, bootstrap |
| 6 | Model selection & regularization | subset/stepwise selection, ridge, lasso, PCR, PLS |
| 7 | Moving beyond linearity | polynomials, step functions, splines, local regression, GAMs |
| 8 | Tree-based methods | classification trees, bagging, random forests, boosting, BART |
| 9 | Support vector machines | maximal margin, support vector classifier, SVM (kernels), multi-class SVM |
| 12 | Unsupervised learning | PCA, k-means, hierarchical clustering, matrix completion |

**Not allowed** (examples): Chapter 10 deep learning (neural networks, **CNNs**, Keras/torch), Chapter 11 survival analysis, Chapter 13 multiple testing, and any outside methods (e.g., XGBoost package, pretrained face/landmark detectors, OpenCV-style feature descriptors not covered in class).

### 4.2 Feature extraction
- All available data may be used.
- The rules text says: "Your team must at least consider a full document-term matrix. This approach can only be abandoned if performance results clearly demonstrate that an alternative is superior." **This wording comes from a text-based competition; for this image competition, the likely equivalent is the full set of raw pixel values as features.** Confirm with the course staff; until then, include a raw-pixel baseline and only drop it if results clearly show an alternative is better.

### 4.3 Teams
- Teams of 2 or at most 3 members; joint submission for rounds 2 and 3.
- Each team may enter 2 submissions (and indicate which two count).
- Three deadlines: round 1 (individual), rounds 2 and 3 (team). **All submissions are graded.**
- After round 2, learn from other teams' public notebooks and adopt good ideas, **with proper credit**.

### 4.4 How to submit
1. Work in (or copy into) a **Kaggle Notebook**. Alternatively upload an **RMarkdown** file (it must also compile without errors; test with a one-block file first, then add blocks incrementally).
2. Click **Save Version**; Kaggle runs the notebook, which must finish without errors and write the predictions file to the output folder. Select that file to submit.
3. Set the kernel to **Public** (Share → Public), copy the **Public URL**, click Save.
4. Submit the Public URL in the matching **Canvas** assignment. Round 1: your own notebook. Rounds 2–3: the shared team notebook (any member can submit).

---

## 5. AI usage rules (competition rules, binding)

Purpose: you do the thinking; AI usage must be verifiable and reviewable. You steer the AI and rein it in when it produces overly verbose code or unnecessarily defensive coding for an interactive modelling script.

1. **No AI for markdown cells.** All markdown/explanatory text is written by the student.
2. **Top-level code** (not inside a function definition):
   - A code cell containing AI-assisted code starts on **line 1** with `# LLM src=https://...` (a **shareable** URL to the chat that generated it), even if modified afterwards.
   - **No functions are defined** in such a cell.
   - **Each top-level chunk is generated in a separate chat/session**, so each has its own URL.
3. **Function definitions**:
   - Each AI-generated function is generated in its **own separate chat**.
   - The URL goes as the **first comment after the function definition start**:
     ```r
     myfunc = function(x, ...) {
                  # URL=https://chatgpt.com/share/6accc115-d1fc-83eb-b282-5a836d922292
                  ...
     }
     ```
   - URLs must be shareable.
4. **CLI agents** (Claude Code, Codex, Copilot, …):
   - Same rules: one session per top-level chunk or function (use `/clear` before starting the next one).
   - Export each session to `.md` (`/export` in Claude Code/Codex, `/share` in Copilot, or equivalent); letting the agent pick the filename is easiest.
   - Reference as `SRC=file://filename.md`.
   - Upload all exported files to the notebook (edit notebook → File → Upload input → Upload dataset).
5. **Local models**: best used through Claude Code or Codex pointed at the local LLM (Codex with `--sso` is probably easiest).
6. **Inline code completion** (e.g., VS Code autocomplete): **ask the instructor first.**

---

## 6. Grading rubrics per round

### Round 1 — Individual notebook

**Code requirements**
- Neat formatting and a consistent layout and style (Tidyverse Style Guide or Google R Style Guide); pay attention to syntax.
- Code broken into sections reflecting conceptual steps, marked with clear internal structure comments.
- **Explain feature extraction**:
  - *What*: which features?
  - *Why*: motivation (reasoning, literature/theory, or both).
  - *How*: how they are computed in R.
- Show **creativity, originality and effort**.
- Use **dplyr with pipes (`|>`)** whenever possible (generalizes to large databases/SQL). **dplyr use is graded.**
- Mark key pipeline steps with **inline comments**.
- **Define functions** where appropriate: if multiple lines are repeated more than twice, make a function.

**Presentation**
- Less critical in round 1, but must be clear for teammates. They must easily find:
  - feature extraction markdown and code cells,
  - model training markdown and code cells,
  - model evaluation code cells.
- Must run with **"Run all"** without errors and output a ready-to-submit predictions file.

### Rounds 2 and 3 — Team notebook

**Code requirements**
- Everything from round 1 on style, sections, dplyr with `|>`, inline comments, and the repetition rule for functions.
- Functions must additionally:
  - **accept arguments and return a value** (number, vector, list, …);
  - **avoid side effects**: no modifying variables outside their scope, no generating files or plots, unless that is the function's main purpose (e.g., a plotting or file-saving function);
  - start with a **1–2 line comment on purpose**, followed by comments on **expected inputs and output**. Keep it concise.

**Presentation**
- A **well-structured, neatly formatted report**; a notebook with only code blocks is insufficient.
- Use Markdown/RMarkdown for logical sections with introductory, explanatory and connective text.
- **Remove all irrelevant cells from the Quickstart notebook**; keep only what is needed for execution.
- Explanations succinct: just enough for an outsider to follow the workflow and reasoning.
- **Feature extraction**: What / Why / How (as in round 1), with creativity, originality and effort.
- **Model fitting, selection and performance**:
  - Try **multiple models, from inflexible to more flexible**.
  - **Present all models tested**, including performance outputs.
  - **Explain how performance was measured.**
  - **Describe how flexibility was varied and optimized** (feature selection, interactions, non-linear transformations, tuning parameters).
  - **Visualize performance differences** within and across algorithms (chart or table, whichever compares most clearly).
- **Division of labor**:
  - At the end of the notebook, clearly list how work was divided.
  - **Every member must have contributed code** for (a) feature extraction, (b) model fitting, and (c) model evaluation.
- Must run with **"Run all"** without errors and output a ready-to-submit predictions file.
