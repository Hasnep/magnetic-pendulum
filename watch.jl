#!/usr/bin/env -S julia --project=.

import BuildJuliaBlogpost

BuildJuliaBlogpost.watch(run_pandoc = true, create_tarball = false)
