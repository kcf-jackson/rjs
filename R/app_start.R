#' Run an interactive app
#' @param my_html An HTML object, e.g. output from 'create_html', or a character 
#' string specifying a filepath to a HTML file.
#' @param user_function R function; the function to process the data from the web interface.
#' @param server T or F; whether to enable interaction between JS and R.
#' @param assets path of the assets. Note that it only applies when `server = F`.
#' @param host character string; Address to host the app.
#' @param port integer; Port to host the app.
#' @param browser "browser" (web) or "viewer" (R).
#' @param quiet T or F; if T, display is suppressed. This is useful when one 
#' runs `daemon_app`.
#' @export
#' @note The `assets' argument does not apply when server = T, because the server creates
#' its own temporary folder and serve the website from there. At the moment, it is unclear 
#' how to gain access to that folder, so it is recommended to use DataUCI instead to serve
#' local file for dynamic site.
start_app <- function(my_html, user_function = identity, server = F, assets, 
                      host = "localhost", port = 9454, browser = "viewer", quiet = F) {
  if (!missing(assets) && server) 
    warning("The 'assets' argument does not apply when server = T. See help for more information.")
  
  site_path <- setup_site(my_html, assets)
  serve_site(site_path, user_function, server, host, port, browser, quiet)
}


#=========================================================================
setup_site <- function(my_html, assets) {
  temp_dir <- tempdir()
  tgt_path <- file.path(temp_dir, "index.html")
  print(tgt_path)

  is_html <- class(my_html) == "shiny.tag"
  if (is_html) {
    htmltools::save_html(my_html, tgt_path, libdir = temp_dir)
    unescape_html(tgt_path)  
  } else {
    if (!file.exists(my_html)) stop("File doesn't exist:", my_html)
    file.copy(my_html, tgt_path, overwrite = T)    
  }

  copy_assets(assets, temp_dir)
  tgt_path
}


# Unescape special characters in JS files
unescape_html <- function(fpath, escape = F) {
  table0 <- list('&' = '&amp;', '<' = '&lt;', '>' = '&gt;', "'" = '&#39;', '"' = '&quot;')
  readLines(fpath) %>% 
    purrr::map_chr(~replace_by_tbl(.x, table0, escape = escape)) %>% 
    writeLines(fpath)
}
replace_by_tbl <- function(x, tbl0, escape = F) {
  .f <- function(x, y, z) {
    gsub(pattern = y, replacement = z, x = x)
  }
  param <- if_else(escape,
                   list(from = names(tbl0), to = tbl0),
                   list(from = tbl0, to = names(tbl0))
  )
  purrr::reduce2(param$from, param$to, .f, .init = x)
}


#' Copy assets to target directory
#' @description This is needed when one needs to serve local file to RStudio viewer.
#' @param path character_string; path to the source file / folder.
#' @param target_dir character_string; path to the target folder.
#' @param message T or F; if T, report success.
#' @keywords internal
copy_assets <- function(path, target_dir, message = T) {
  if (!file.exists(path) || !file.exists(target_dir))
    stop("File / folder doesn't exist.")
  
  if (file.info(path)$isdir) {
    success <- file.copy(path, target_dir, recursive = T)
  } else {
    success <- file.copy(path, target_dir)
  }
  
  if (success && message) print("Folder copied successfully")
  target_dir
}


#=========================================================================
serve_site <- function(file_path, user_function, server, 
                       host, port, browser, quiet) {
  static <- !server
  if (static) return(serve_static(file_path, quiet))
  
  my_app <- create_app(file_path, user_function, server)
  serve_dynamic(my_app, host, port, browser, quiet)
}


serve_static <- function(file_path, quiet) {
  if (!quiet) getOption("viewer")(file_path)
}


serve_dynamic <- function(my_app, host, port, browser, quiet) {
  address <- paste0("http://", host, ":", port)
  cat(sprintf("Listening on: %s\n", address))
  if (!quiet) browseURL(address, browser = getOption(browser))
  
  host <- ifelse(host == "localhost", "0.0.0.0", host)
  httpuv::runServer(host, port, my_app, 250)
}
