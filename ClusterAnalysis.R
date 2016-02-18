#------- INSTALL PACKAGES ----------
#to install required packages: install.packages("fpc") install.packages("lattice")


#------- 1. LOAD AND PROCESS RESULTS --------
#load and assign optimisation and simulation results files (change filename and specify number of rows skipped if needed (skip = x))
opdata <- read.csv("Data/opdata.csv", header = TRUE)


#------- 2. CLUSTER RESULTS -----------
#load packages
library("fpc")
library("lattice")

#cluster results (change columns of variables to cluster, set range of possible k cluster values)
#see fpc.pdf for pamk details
clustpar <- pamk(opdata[17:19],krange=10:20)

#output cluster info to text file
sink("Data/pareto clustering results.txt")
print(clustpar)
sink()

#output cluster membership numbers and cluster medoids to objects and text files for use in other graphs
clusternos <- data.frame(clustpar$pamobject$clustering)
write.csv(clusternos, "Data/clusternos.csv")
medoids <- data.frame(clustpar$pamobject$id.med, clustpar$pamobject$medoids)
colnames(medoids) <- c("Option", "Total Spill Volume (GL)", "Minimum System Storage (GL)", "Total Cost ($ million)")
write.csv(medoids, "Data/medoids.csv")