sdroot(M::Monitor) = get!(M.extras, "_SD_ROOT", pwd())
sdroot!(M::Monitor, dir::String) = setindex!(M.extras, dir, "_SD_ROOT")

