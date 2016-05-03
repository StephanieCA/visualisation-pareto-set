#------- INSTALL PACKAGES ----------
#to install required packages: install.packages("fpc") install.packages("lattice")


#------- 1. LOAD AND PROCESS RESULTS --------
#load and assign optimisation and simulation results files (change filename and specify number of rows skipped if needed (skip = x))
opdata <- read.csv("Data/opdata.csv", header = TRUE)

#load packages
library("fpc")
library("lattice")

#------- 2. CLUSTER RESULTS BASED ON OBJECTIVE FUNCTIONS -----------
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

#--------- 3. CLUSTER RESULTS BASED ON DECISION VARIABLES ----------
#cluster results (change columns of variables to cluster, set range of possible k cluster values)
#see fpc.pdf for pamk details
dvclustpar <- pamk(opdata[1:16],krange=10:20)

#output cluster info to text file
sink("Data/pareto clustering results dvs.txt")
print(dvclustpar)
sink()

#output cluster membership numbers and cluster medoids to objects and text files for use in other graphs
dvclusternos <- data.frame(dvclustpar$pamobject$clustering)
write.csv(dvclusternos, "Data/dvclusternos.csv")
dvmedoids <- data.frame(dvclustpar$pamobject$id.med, dvclustpar$pamobject$medoids)
colnames(dvmedoids) <- c("Option", "NPI2 Threshold", "NPI2 Flow Threshold", "NPI Threshold", "NPI Flow Threshold", 
"Brisbane to Nth Pine Threshold", "Brisbane to Nth Pine Flow Threshold", "Maroochy to Baroon Threshold", "Ewen Maddock to Baroon Threshold",
"EPI Threshold", "EPI Flow Threshold", "SPI Threshold", "SPI Flow Threshold", "PRW Threshold", "Desalination 1/3 Production.Threshold",
"Desalination 2/3 Production Threshold", "Desalination Full Production Threshold")
write.csv(dvmedoids, "Data/dvmedoids.csv")

#--------- 4. CLUSTER RESULTS BASED ON OBJECTIVES AND DECISION VARIABLES ----------
# normalise objective functions to put them on the same scale as decision variables. Value of 1 is ideal point, 0 is nonideal
#min and max reversed for minstor as we are trying to maximise minimum system storage
normalspill <- (opdata[17]-max(opdata[17]))/(min(opdata[17])-max(opdata[17]))
normalminstor <- (opdata[18]-min(opdata[18]))/(max(opdata[18])-min(opdata[18]))
normalcost <- (opdata[19]-max(opdata[19]))/(min(opdata[19])-max(opdata[19]))

alldf <- data.frame(opdata[1:16], normalspill, normalminstor, normalcost)

#cluster results (change columns of variables to cluster, set range of possible k cluster values)
#see fpc.pdf for pamk details
allclustpar <- pamk(alldf,krange=10:20)

#output cluster info to text file
sink("Data/pareto clustering results all.txt")
print(allclustpar)
sink()

#output cluster membership numbers and cluster medoids to objects and text files for use in other graphs
allclusternos <- data.frame(allclustpar$pamobject$clustering)
write.csv(allclusternos, "Data/allclusternos.csv")
allmedoids <- data.frame(allclustpar$pamobject$id.med, allclustpar$pamobject$medoids)
colnames(allmedoids) <- c("Option", "NPI2 Threshold", "NPI2 Flow Threshold", "NPI Threshold", "NPI Flow Threshold", 
                         "Brisbane to Nth Pine Threshold", "Brisbane to Nth Pine Flow Threshold", "Maroochy to Baroon Threshold", "Ewen Maddock to Baroon Threshold",
                         "EPI Threshold", "EPI Flow Threshold", "SPI Threshold", "SPI Flow Threshold", "PRW Threshold", "Desalination 1/3 Production.Threshold",
                         "Desalination 2/3 Production Threshold", "Desalination Full Production Threshold", 
                         "Total Spill Volume (GL)", "Minimum System Storage (GL)", "Total Cost ($ million)")
write.csv(allmedoids, "Data/allmedoids.csv")