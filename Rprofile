
#options(prompt="\U211D > ")


.First <- function(){
    # options(repos=structure(c(CRAN="https://ftp.osuosl.org/pub/cran/")))
    library(colorout)
    library(lintr)
    # library(setwidth)
    # library(KernSmooth)
    # library(slackr)
    # slackrSetup()


    setOutputColors(normal = 39, number = 217, negnum = 82, date = 111, stderror = 226, string = 75, const = 75, verbose = FALSE)
    # Use the text based web browser w3m to navigate through R docs
    # in Linux Console after help.start():
    if(Sys.getenv("TMUX") != "" && Sys.getenv("DISPLAY") == "")
        options(browser = function(u) system(paste0("tmux new-window 'w3m ", u, "'")))

    cat("\nWelcome at", date(), "\n")

}

.Last <- function(){
     cat("\nGoodbye at ", date(), "\n")
}
