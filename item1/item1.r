install.packages("petrinetR")
install.packages("readtext")
library(petrinetR)
library(readtext)

# PATIENT NETWORK

# This program allows: 
# 1) MAX: 10 patients in place wait.
# 2) Only one patient being treated at a time.
# 3) The process will run until there is no patient left in the waiting room.

# PLEASE CHANGE THE PATH TO THE APPROPRIATE DATA DIRECTORY!
setwd("D:/Tu's Files/Documents/bach khoa/211/Mathematical Modeling/homework/as/code_R/item1")
DATA_DIR <- getwd() 

init_marking <- readLines(paste(DATA_DIR, "/initmarking_1.txt", sep = ""))

token_w <- as.numeric(init_marking[1])
token_i <- as.numeric(init_marking[2])
token_d <- as.numeric(init_marking[3])

if (token_w > 10 || token_i > 1 || token_w < 0 || token_i < 0 || token_d < 0){
  print("HALTED: Invalid input!")
  # halt
  quit(save = "ask")
}

wait <- "wait"
inside <- "inside"
done <- "done"
start <- "start"
change <- "change"
P <- c(wait, inside, done)
T <- c(start, change)
F_in <- c(wait, start, inside, change)
F_out <- c(start, inside, change, done)
F <- data.frame(from = F_in, to = F_out)
M0 <- c()
N_pa <- create_PN(P,T,F,M0)

cat("STARTING PROCESS... HOLD ON A SEC!\n")
Sys.sleep(3)

cat("INITIAL MARKING: ", paste0(token_w,".wait ", token_i,".inside ", token_d,".done\n"))
Sys.sleep(3)

cat("THE TREATMENT NOW BEGINS...\n")
Sys.sleep(3)

while (token_w > 0 || token_i > 0)
{
  if (token_i > 0 && token_d > 0){
    M0 <- c(wait, inside, done)
  }
  else if (token_i > 0){
    M0 <- c(wait, inside)
  }
  else if (token_d > 0){
    M0 <- c(wait, done)
  }
  else{
    M0 <- c(wait)
  }
  N_pa[["marking"]] <- M0
  if (token_w > 0 && token_i == 0){
    print(execute(N_pa, start))
    token_w <- token_w - 1
    token_i <- token_i + 1
  }
  else if (token_i == 1){
    print(execute(N_pa, change))
    token_d <- token_d + 1
    token_i <- token_i - 1
  }
  print(render_PN(N_pa))
  Sys.sleep(2)
  
  cat("==========================")
  cat(paste0(token_w,".wait ", token_i,".inside ", token_d,".done"))
  cat("==========================\n")
  Sys.sleep(3)
}

M0 <- c(done)
N_pa[["marking"]] <- M0
print(render_PN(N_pa))
Sys.sleep(1)

cat("FINAL MARKING: ", paste0(token_w,".wait ", token_i,".inside ", token_d,".done\n"))
cat("DONE!! ALL PATIENTS HAVE BEEN TREATED SUCCESSFULLY!")