read_workspace <- function(path, object) {
  if (!file.exists(path)) stop("Missing authorized source: ", path)
  env <- new.env(parent = emptyenv())
  found <- load(path, envir = env)
  if (!object %in% found) stop("Missing source object: ", object)
  get(object, envir = env)
}

verify_sources <- function(path = "docs/sources.csv") {
  manifest <- read.csv(path, stringsAsFactors = FALSE)
  for (i in seq_len(nrow(manifest))) {
    file <- manifest$path[i]
    if (!file.exists(file)) stop("Missing authorized source: ", file, "; see data/README.md")
    if (digest::digest(file = file, algo = "sha256") != manifest$sha256[i]) {
      stop("Source checksum changed: ", file)
    }
  }
  invisible(TRUE)
}

write_result <- function(x, name, directory = "tabs") {
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  write.csv(x, file.path(directory, paste0(name, ".csv")), row.names = FALSE, na = "")
}
