install.packages("petrinetR")
install.packages("readtext")
library(petrinetR)
library(readtext)

# SUPERIMPOSED NETWORK

# This program allows: 
# 1) MAX: 10 patients in place wait & 1 specialist on duty.
# 2) Only one patient being treated at a time.
# 3) The process will run until there is no patient left in the waiting room.

# PLEASE CHANGE THE PATH TO THE APPROPRIATE DATA DIRECTORY!
setwd("D:/Tu's Files/Documents/bach khoa/211/Mathematical Modeling/homework/as/code_R/item3/")
DATA_DIR <- getwd() 

init_marking <- readLines(paste(DATA_DIR, "/initmarking_3.txt", sep = ""))

token_w <- as.numeric(init_marking[1])
token_f <- as.numeric(init_marking[2])
token_ib <- as.numeric(init_marking[3])
token_dc <- as.numeric(init_marking[4])
token_dn <- as.numeric(init_marking[5])

if (token_w > 10 || token_ib > 1 || token_w < 0 || token_ib < 0 || token_dn < 0 || 
    token_f > 1 || token_dc > 1 || token_f < 0 || token_dc < 0 || 
    token_f == 1 && token_ib == 1 && token_dc == 1 || 
    token_f == 1 && token_ib == 1 && token_dc == 0 || 
    token_f == 1 && token_ib == 0 && token_dc == 1 || 
    token_f == 0 && token_ib == 1 && token_dc == 1){
  print("HALTED: Invalid input!")
  # halt
  quit(save = "ask")
}

wait <- "wait"
free <- "free"
inbu <- "inside|busy"
docu <- "docu"
done <- "done"
start <- "start"
change <- "change"
end <- "end"
P <- c(wait, free, inbu, docu, done)
T <- c(start, change, end)
F_in <- c(wait, free, start, inbu, change, change, docu, end)
F_out <- c(start, start, inbu, change, docu, done, end, free)
F <- data.frame(from = F_in, to = F_out)
M0 <- c()
PN <- create_PN(P,T,F,M0)

cat("STARTING PROCESS... HOLD ON A SEC!\n")
Sys.sleep(3)

cat("INITIAL MARKING: ", paste0(token_w,".wait ", token_f,".free ",
          token_ib,".inside|busy ", token_dc,".docu ", token_dn,".done\n"))
Sys.sleep(3)

cat("THE TREATMENT NOW BEGINS...\n")
Sys.sleep(3)

while (token_w > 0 || token_ib > 0 || token_dc > 0){
  if (token_f == 1){
    if (token_dn > 0)
      M0 <- c(wait, free, done)
    else
      M0 <- c(wait, free)
  }
  else if (token_ib == 1){
    if (token_dn > 0)
      M0 <- c(wait, inbu, done)
    else
      M0 <- c(wait, inbu)
  }
  else if (token_dc == 1){
    if(token_dn > 0)
      M0 <- c(wait, docu, done)
    else
      M0 <- c(wait, docu)
  }
  PN[["marking"]] <- M0
  
  if (token_f == 1){
    print(execute(PN, start))
    token_ib <- token_ib + 1
    token_w <- token_w - 1
    token_f <- token_f - 1
  }
  else if (token_ib == 1){
    print(execute(PN, change))
    token_dc <- token_dc + 1
    token_dn <- token_dn + 1
    token_ib <- token_ib - 1
  }
  else if (token_dc == 1){
    print(execute(PN, end))
    token_dc <- token_dc - 1
    token_f <- token_f + 1
  }
  print(render_PN(PN))
  Sys.sleep(2)
  
  cat("==============")
  cat(paste0(token_w,".wait ", token_f,".free ",
             token_ib,".inside|busy ", token_dc,".docu ", token_dn,".done"))
  cat("==============\n")
  Sys.sleep(3)
}

M0 <- c(done, free)
PN[["marking"]] <- M0
print(render_PN(PN))
Sys.sleep(1)

cat("FINAL MARKING: ", paste0(token_w,".wait ", token_f,".free ",
          token_ib,".inside|busy ", token_dc,".docu ", token_dn,".done\n"))
cat("DONE!! ALL PATIENTS HAVE BEEN TREATED SUCCESSFULLY!")