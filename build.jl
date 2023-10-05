#!/usr/bin/env -S julia --project=.

import BuildJuliaBlogpost

BuildJuliaBlogpost.build(standalone_html = true, create_tarball = false)
