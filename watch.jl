#!/usr/bin/env -S julia --project=.

import BuildJuliaBlogpost

BuildJuliaBlogpost.watch(standalone_html = true, create_tarball = false)
