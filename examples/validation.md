---
title: Validation
layout: examples
godoc: 
    - Validation
    - Validator
---

The validation app demonstrates every way that the [Validation](../manual/validation.html) system may be used
to good effect.

<a class="btn btn-success btn-sm" href="https://github.com/revel/samples/tree/master/validation" role="button"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Browse Source</a>

Here are the contents of the app:

	validation/app/
		models
			user.go     # User struct and validation routine.
		controllers
			app.go      # Introduction
			sample1.go  # Validating simple fields with error messages shown at top of page.
			sample2.go  # Validating simple fields with error messages shown inline.
			sample3.go  # Validating a struct with error messages shown inline.

