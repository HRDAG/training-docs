# Glossary

In training, troubleshooting, or general, we will use words that may be unfamiliar.
In an effort to get us on the same page, here's what we mean.

- **algorithm:** In very simple terms, an algorithm is a routine. Some algorithms are so common we know them by name, each one is unique and comes with pros, cons, and best use cases. If you've ever tried to search or sort data, an algorithm was deployed to perform that work for you.
- **bayesian:**
- **bias:** There are several specific types of bias that we consider and test for in our data, but at the core these refer to some factor having an effect on data or results. We might have an algorithm or model that introduces bias we have to account for, we might observe bias introduced by human data collection.
- **build:** We want our work to be reproducible and _rebuildable_. We use Makefiles to setup rules for how to rebuild a particular output by synthesizing source code with input(s).
- **classify / classifier:**
- **clean:** Data cleaning refers the process of reading in data and applying some methods to get it into better shape for downstream analysis. This might including removing extra whitespace, converting numeric data to the appropriate datatype (ie. integer, float, datetime, timedelta), splitting fields that contain multiple types of info, etc. Although some methods are more common than others, your cleaning routine is unique to your data.
- **compiler:** There are functional distinctions between a compiler and an interpreter, but the important thing to know is which one the language(s) you're writing in use. Java and C use a compiler and require you to have a deeper understanding of how the computer receives instructions. There are referred to as _lower level_ languages because they are closer to the ground or machine level and there is no interpreter to meet you halfway. These tend to be quicker to compile and there are even some parts of interpretted language code that compiles to C.
- **complexity:**
- **conditional probability:**
- **confidence interval:**
- **control vocabulary:** If I ask you to read a narrative and tell me whether a home invasion is mentioned, how can you be sure we are on the same page about what qualifies as a home invasion? We use control vocabulary to create a common language for tasks where we might accidentally operate on different interpretations of the same prompt.
- **convenience sample:** A convenience sample is a sample taken conveniently. If I walk around my campus or office and ask anyone who walks by me a particular question, I took a convenience sample. If you respond to a survey on a website you were already on, you were part of a convenience sample.
- **correlation:** Two things are correlated if they share some (potentially unknown) attribute and this common link affects both things. The classic statistics example is shark attacks and ice cream sales increasing at the same time. If you saw it as a headline, you might mistakenly assume _causation_ is being suggested, but if you think about it, these events more likely share a common feature: summertime, so it's more likely there is a correlation between shark attacks and ice cream sales.
- **credible interval:**
- **debug:**
- **deduplication:**
- **depdendency:**
- **deterministic:**
- **disjoint:**
- **distribution:**
- **frequentist:**
- **hashid:**
- **heuristic:**
- **imputation:**
- **independent / dependent:**
- **inference:**
- **interpreter:** There are functional distinctions between a compiler and an interpreter, but the important thing to know is which one the language(s) you're writing in use. Python and R both use an interpreter, and this enables the programmer to mind fewer syntax rules and be less in touch with how the computer understands the work being done. These can be slower programs to run for exactly that reason, but that doesn't mean they aren't remarkably useful tools than can run effectively. Know that the extra work the interpreter is doing does not solve all the problems that can arise, and in no way should you slack on writing good code!
- **interrater reliability:**
- **language:** You write code in a programming language. There are many languages you could choose from, each has pros and cons and ideal use cases.
- **margin of error:** A margin of error is a window above and below an estimate that puts parameters on under- and over-counting that might've occurred and what the true number would be in that case. 
- **marginal probability:**
- **mean/median/mode/stddev:**
- **model / selection / evaluation / parameter:**
- **multiple systems estimation (capture-recapture):**
- **ocr:**
- **pair programming:** Sometimes we end up doing this in code review, but in general it refers to a practice of sitting side-by-side and writing code together, usually for the same project.
- **posterior:**
- **prior:**
- **probabilistic:**
- **push:** When we talk about pushing code, we're talking about sending your code and/or changes to the remote place where the project lives. If your project is tracked by git (via GitHub, in our case), then you'll push to GitHub. If your project is tracked by snap, then you'll push to snap.
- **refactor:**
- **repo:** We use GitHub, so our projects live in GitHub repos. These are basically fancy directories or folders that give us useful functionality like version control 
- **sample:**
- **set / set theory:**
- **sparse / sparsity:**
- **task:**
- **transitive closure:** Suppose we have 3 sets, A, B, and C. I run a clustering algorithm to help me identify if these all refer to the same underlying set. The results suggest that A is the same as B, and B is the same as C, but _not_ that A and C are the same. What do I do? That's the problem of transitive closure.
- **uncertainty:**
- **variance:**
- **version control:** What happens if we remove some code we thought we didn't need, only to discover we did need it? This is why we use a version control system (namely, git). If we've set this up, we can roll back to any previous version (or directly view the code we're missing on GitHub from the commit history) and restore our work. 

<---- done ---->
