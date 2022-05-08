install.packages("petrinetR")
install.packages("readtext")
library(petrinetR)
library(readtext)

# SPECIALIST NETWORK

# This program allows: 
# 1) MAX: 1 specialist on duty.
# 2) Only one patient being treated at a time.
# 3) The number of firing times will define the final display.

# PLEASE CHANGE THE PATH TO THE APPROPRIATE DATA DIRECTORY!
setwd("D:/Tu's Files/Documents/bach khoa/211/Mathematical Modeling/homework/as/code_R/item2/")
DATA_DIR <- getwd() 

init_marking <- readLines(paste(DATA_DIR, "/initmarking_2.txt", sep = ""))
firing_times <- readLines(paste(DATA_DIR, "/firingtimes_2.txt", sep = ""))

token_f <- as.numeric(init_marking[1])
token_b <- as.numeric(init_marking[2])
token_d <- as.numeric(init_marking[3])
firing_max <- as.numeric(firing_times)

if (token_f > 1 || token_b > 1 || token_d > 1 || 
    token_f < 0 || token_b < 0 || token_d < 0 || 
    token_f == 1 && token_b == 1 && token_d == 1 || 
    token_f == 1 && token_b == 1 && token_d == 0 || 
    token_f == 1 && token_b == 0 && token_d == 1 || 
    token_f == 0 && token_b == 1 && token_d == 1){
  print("HALTED: Invalid input!")
  # halt
  quit(save = "ask")
}

free <- "free"
busy <- "busy"
docu <- "docu"
start <- "start"
change <- "change"
end <- "end"
P <- c(free, busy, docu)
T <- c(start, change, end)
F_in <- c(free, start, busy, change, docu, end)
F_out <- c(start, busy, change, docu, end, free)
F <- data.frame(from = F_in, to = F_out)
M0 <- c()
N_s <- create_PN(P,T,F,M0)

cat("STARTING PROCESS... HOLD ON A SEC!\n")
Sys.sleep(3)

cat("INITIAL MARKING: ", paste0(token_f,".free ", token_b,".busy ", token_d,".docu\n"))
Sys.sleep(3)

cat("THE SPECIALIST IS WORKING HIS SHIFT...\n")
Sys.sleep(3)

firing_temp <- firing_max
while (firing_temp > 0){
  if (token_f == 1) {
    M0 <- c(free)
    N_s[["marking"]] <- M0
    print(execute(N_s, start))
    token_f <- token_f - 1
    token_b <- token_b + 1
    print(render_PN(N_s))
    Sys.sleep(2)
    
    cat("==========================")
    cat(paste0(token_f,".free ", token_b,".busy ", token_d,".docu"))
    cat("==========================\n")
    Sys.sleep(3)
  }
  else if (token_b == 1){
    M0 <- c(busy)
    N_s[["marking"]] <- M0
    print(execute(N_s, change))
    token_b <- token_b - 1
    token_d <- token_d + 1
    print(render_PN(N_s))
    Sys.sleep(2)
    
    cat("==========================")
    cat(paste0(token_f,".free ", token_b,".busy ", token_d,".docu"))
    cat("==========================\n")
    Sys.sleep(3)
  }
  else if (token_d == 1){
    M0 <- c(docu)
    N_s[["marking"]] <- M0
    print(execute(N_s, end))
    token_d <- token_d - 1
    token_f <- token_f + 1
    print(render_PN(N_s))
    Sys.sleep(2)
    
    cat("==========================")
    cat(paste0(token_f,".free ", token_b,".busy ", token_d,".docu"))
    cat("==========================\n")
    Sys.sleep(3)
  }
  firing_temp <- firing_temp - 1
}

if (token_f == 1) {
  M0 <- c(free)
  N_s[["marking"]] <- M0
  print(render_PN(N_s))
  cat("DONE!! THE SPECIALIST IS NOW FREE!\n")
} else if (token_b == 1) {
  M0 <- c(busy)
  N_s[["marking"]] <- M0
  print(render_PN(N_s))
  cat("DONE!! THE SPECIALIST IS NOW BUSY!\n")
} else if (token_d == 1){
  M0 <- c(docu)
  N_s[["marking"]] <- M0
  print(render_PN(N_s))
  cat("DONE!! THE SPECIALIST IS NOW DOCUMENTING!\n")
}
Sys.sleep(1)
cat("FINAL MARKING: ", paste0(token_f,".free ", token_b,".busy ", token_d,".docu\n"))