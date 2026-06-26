# Emacs major mode for Slipshow

An emacs major mode for [slipshow](https://slipshow.org).

> [!WARNING]
> This is an early work. Requires an unreleased version of slipshow for all
> features to work.

## Features

This provides a major emacs mode for editing and previewing slipshow source
file. It is automatically activated on `.slp` files, but you can activate it on
`.md` files as well with `M-x slipshow-mode`.

The major mode provides:

- Syntax highlighting, and all editing facilities for Markdown files as it is
  based on [`markdown-mode`](https://jblevins.org/projects/markdown-mode/).
- Preview for the opened files. Once activated, it starts a preview server at
  `https://localhost:8080` (or a bigger port if this one is not available).
- A setting to decide to refresh the preview on save, or on every key-stroke,
  available through the `customize` interface.
- Two commands, `slipshow-preview-go-next` and `slipshow-preview-go-previous` to
  control the preview state from the editor.

## Multi-directory setup

If your project includes source files in multiple directories, `slipshow-mode`
currently requires them to be in the same "project". Emacs detects projects
mainly by looking for a `.git` folder, so you are good to go if your folder is
managed by git. You can also extend this mechanism by adding eg `.slipshow` to
the "Project VC Extra Root Markers" variable, and putting an empty `.slipshow`
file at the root of your project.

## Install

You need the last release of [slipshow](https://slipshow.org) to be installed,
as well as a recent emacs (at least `29.1`).

Slipshow is not (yet) on melpa. In the meantime, just append the following line
to your `.emacs` file:

```elisp
(use-package slipshow-mode
  :vc (:url "https://github.com/panglesd/slipshow-emacs-mode" :rev :newest))
```
