---
title: Messages
layout: examples
---

The i18n application demonstrates the various [internationalization](/manual/i18n-messages.html) features of Revel:

* Retrieving the current locale from a controller and template.
* Resolving messages using the current locale from a controller and template.
* Message file features such as referencing and message arguments.

<a class="btn btn-success btn-sm" href="https://github.com/revel/examples/tree/master/i18n" role="button"><span class="glyphicon glyphicon-floppy-disk" aria-hidden="true"></span> Browse Source</a>


<div class="alert alert-info"><strong>Note:</strong> at the time of writing this sample application only demonstrates the <em>messages</em> feature.</div>

### Contents

	i18n/
		app/		# Controllers & views
		conf/		# Configuration file(s)
		messages/
			sample.en 	# English language sample messages
			sample2.en 	# English language sample messages #2
		public/
		tests/
