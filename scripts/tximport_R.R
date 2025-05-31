#!/usr/bin/Rscript

##### <1.import 3 libraries> #####
library(tximport)
library(readr)
library(stringr)

sessionInfo()

##### <2.get 3 arguments([1]=TX2GENEID, [2]=$CSV_FILE, [3]=$OUTPUT_FILE)> #####
args1 <- commandArgs(trailingOnly=TRUE)[1] #nolint
args2 <- commandArgs(trailingOnly=TRUE)[2] #nolint
args3 <- commandArgs(trailingOnly=TRUE)[3] #nolint

##### <3.Storage TX2GENEID as data.frame> #####
tx2knownGene <- read_delim(args1, '\t', col_names = c('TXNAME', 'GENEID')) #nolint

##### <4.Read CSV_FILE into a data frame> #####
exp.table <- read.csv(args2, row.names=NULL) #nolint

##### <5.Remove specific extensions from the file names in the second column> ##### nolint
files.raw <- exp.table[,2] #nolint
files.raw <- gsub(".gz$", "", files.raw) #nolint
files.raw <- gsub(".fastq$", "", files.raw) #nolint
files.raw <- gsub(".fq$", "", files.raw) #nolint

##### <6.Extract only the file names from the paths> #####
split.vec <- sapply(files.raw, basename)

##### <7.Strage file vector as list> #####
files <- paste(c("salmon_output_") , split.vec, c("/quant.sf"), sep='')
names(files) <- exp.table[,1]

##### <8.Print file path vector> #####
print(files)

##### <9.tximport process> #####
txi.salmon <- tximport(files, type = "salmon", tx2gene = tx2knownGene, countsFromAbundance="scaledTPM") # nolint

##### <10.Write txi.salmon$counts> #####
write.table(txi.salmon$counts, file=args3, sep="\t",col.names=NA,row.names=T,quote=F,append=F)
write.table(exp.table[-c(2,3)], file="designtable.csv",row.names=F,quote=F,append=F)
