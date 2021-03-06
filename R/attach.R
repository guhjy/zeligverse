
#' @source tidyverse
#' @keywords internal

## Add zeligverse modules here and in the DESCRIPTION Imports ##
core <- c('Zelig', 'ZeligChoice', 'ZeligEI', 'Amelia', 'MatchIt', 'WhatIf')

zeligverse_attach <- function() {
    versions <- vapply(core, function(x) as.character(utils::packageVersion(x)),
                       character(1))
    packages <- paste0("+ ", format(core), " ", format(versions))

    if (length(packages) < 6) {
        packages <- c(packages, rep('                         ',
                                    6 - length(packages)))
    }

    info <- platform_info()
    info <- paste0(format(paste0(names(info)), justify = "right"), ": ", info)

    n <- max(length(packages), length(info))
    info <- c(info, rep("", n - length(info)))

    info <- paste0(packages, "      ", info, collapse = "\n")

    startup_message(info)
    suppressPackageStartupMessages(
        lapply(core, library, character.only = TRUE, warn.conflicts = FALSE)
    )

    invisible()
}

#' @importFrom rstudioapi getVersion isAvailable
#' @source tidyverse
#' @keywords internal

platform_info <- function() {
    if (rstudioapi::isAvailable()) {
        ver <- rstudioapi::getVersion()
        ui <- paste0("RStudio ", ver, "")
    } else {
        ui <- .Platform$GUI
    }

    ver <- R.version

    c(
        Date = format(Sys.Date()),
        R = paste0(ver$major, ".", ver$minor),
        OS = os(),
        GUI = ui,
        Locale = Sys.getlocale("LC_COLLATE"),
        TZ = Sys.timezone()
    )
}

#' @source tidyverse
#' @keywords internal

os <- function() {
    x <- utils::sessionInfo()$running

    # Regexps to clean up long windows strings generated at
    # https://github.com/wch/r-source/blob/af7f52f70101960861e5d995d3a4bec010bc89e6/src/library/utils/src/windows/util.c

    x <- gsub("Service Pack", "SP", x)
    x <- gsub(" [(]build \\d+[)]", "", x)

    x
}
