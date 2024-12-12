setwd(getwd())
par(mfrow=c(1,1))

################################## Packages #####################################
library(dplyr)       # For select(), filter(), arrange()
library(olsrr)
library(RColorBrewer) # For color palettes in barplots
library(psych)
library(devtools)
library(ggplot2)
library(reshape2)
library(GGally)
library(Amelia)      # For handling missing values
library(data.table)  # For data manipulation
library(tidyr)
library(plyr)
library(FactoMineR)  # For PCA functions
library(factoextra)  # For PCA visualization
library(cluster)     # For silhouette
library(fpc)         # For cluster statistics
library(NbClust)
library(stats)
library(corrplot)    # For correlation matrix visualization
library(mvtnorm)
library(scales)
library(memisc)
library(gridExtra)

###############################################################################
########################## Data Import and Preparation ########################
###############################################################################
# 1) Data import and initial preparation
readLines("EauxFM.txt",n=20)
tabEaux <- read.table('EauxFM.txt', header=TRUE, sep="\t", dec=".")
tabEaux[duplicated(tabEaux$Nom),] # Extract duplicates
Tab <- tabEaux[-33,] # Remove the 33rd row
row.names(Tab) <- Tab$Nom # Set row names to water names

# 2) Check data import and identify missing values
print(Tab)
head(Tab, n=10)
str(Tab)
dim(Tab)     # Dimensions
names(Tab)   # Variables

# 3) Data Cleaning
################### Missing values
sum(is.na(Tab)) # Total number of missing values
sort(sapply(Tab, function(x) sum(is.na(x)))) # Missing values by column
apply(Tab, MARGIN=1, function(x) sum(is.na(x))) # Missing values by row

# Locate missing values
which(is.na(Tab), arr.ind=TRUE)

# We remove individuals with missing values
# As NO3 and PH have the most missing values but all variables are relevant,
# we choose to remove any individual with at least one missing value.

indligneNA <- which(is.na(Tab), arr.ind=TRUE)[,1]
table(indligneNA)
# 33 rows contain NA values

TabsansNa <- Tab[-indligneNA,] # Remove those 33 rows
str(TabsansNa)

# Verification
missmap(TabsansNa, main = "NA")
str(TabsansNa)
names(TabsansNa)

# Summary of the cleaned dataset
summary(TabsansNa)

# Summary of numerical variables grouped by a categorical variable (example: Pays)
summary2 <- ddply(TabsansNa, .(Pays), numcolwise(median))
summary2
summary3 <- ddply(TabsansNa, .(Nature), numcolwise(median))
summary3

###############################################################################
################### 4) Univariate and Bivariate Data Description ##############
###############################################################################

###################### Distribution of Waters #################################
# Distribution by nature
table1 = with(TabsansNa, table(Nature))
addmargins(table1)
with(TabsansNa, paste(round(100*prop.table(table(Nature)),2), "%", sep=""))

freq1 = table(TabsansNa$Nature)
pourcentage1 = prop.table(freq1)
pourcentage1 = round(100*pourcentage1,2)
graph1 = barplot(pourcentage1, col=brewer.pal(3,"Set3"), ylim=c(0,100),
                 names.arg = c("Sparkling","Still"),
                 main="Distribution by Water Nature",
                 xlab="Water Nature",
                 ylab="Percentage")
text(graph1, pourcentage1+2, label=paste(pourcentage1,"%",sep=""))

# Distribution by country
table2 = with(TabsansNa, table(Pays))
addmargins(table2)
with(TabsansNa, paste(round(100*prop.table(table(Pays)),2), "%", sep=""))

freq2 = table(TabsansNa$Pays)
pourcentage2 = prop.table(freq2)
pourcentage2 = round(100*pourcentage2,2)
graph2 = barplot(pourcentage2, col=brewer.pal(3,"Set3"), ylim=c(0,100),
                 names.arg = c("France","Morocco"),
                 main="Distribution by Country",
                 xlab="Country",
                 ylab="Percentage")
text(graph2, pourcentage2+2, label=paste(pourcentage2,"%",sep=""))

# Distribution by Nature and Country
table3 = with(TabsansNa, table(Nature,Pays))
addmargins(table3)

freq3 = table(TabsansNa$Nature,TabsansNa$Pays)
pourcentage3 = prop.table(freq3)
pourcentage3 = round(100*pourcentage3,2)
graph3 = barplot(pourcentage3, col=brewer.pal(3,"Set3"), ylim=c(0,100),
                 names.arg = c("France","Morocco"),
                 main="Distribution by Nature and Country",
                 xlab="Country",
                 ylab="Percentage")
legend("topright", c("Sparkling","Still"), fill = brewer.pal(3,"Set3"), 
       bty = "n", pt.cex = 1, cex = 0.8, horiz = TRUE)

###################### Distribution of Physico-Chemical Composition ###########
# Histograms for each numeric variable
hist(TabsansNa$NO3, prob=TRUE, col="lightblue",
     main="Distribution of Nitrate Concentration",
     xlab="Nitrate Concentration")
lines(density(TabsansNa$NO3, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$PH, prob=TRUE, col="lightblue",
     main="Distribution of pH",
     xlab="pH")
lines(density(TabsansNa$PH, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$Ca, prob=TRUE, col="lightblue",
     main="Distribution of Calcium Concentration",
     xlab="Calcium Concentration")
lines(density(TabsansNa$Ca, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$Mg, prob=TRUE, col="lightblue",
     main="Distribution of Magnesium Concentration",
     xlab="Magnesium Concentration")
lines(density(TabsansNa$Mg, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$Na, prob=TRUE, col="lightblue",
     main="Distribution of Sodium Concentration",
     xlab="Sodium Concentration")
lines(density(TabsansNa$Na, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$HCO3, prob=TRUE, col="lightblue",
     main="Distribution of Bicarbonate Concentration",
     xlab="Bicarbonate Concentration")
lines(density(TabsansNa$HCO3, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$K, prob=TRUE, col="lightblue",
     main="Distribution of Potassium Concentration",
     xlab="Potassium Concentration")
lines(density(TabsansNa$K, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$Cl, prob=TRUE, col="lightblue",
     main="Distribution of Chloride Concentration",
     xlab="Chloride Concentration")
lines(density(TabsansNa$Cl, na.rm=TRUE), lwd=2, col="red")

hist(TabsansNa$SO4, prob=TRUE, col="lightblue",
     main="Distribution of Sulfate Concentration",
     xlab="Sulfate Concentration")
lines(density(TabsansNa$SO4, na.rm=TRUE), lwd=2, col="red")

################### Boxplots #################
# Physico-chemical composition distribution by Nature

# Boxplot Ca vs Nature
mediane1 <- aggregate(Ca ~  Nature, TabsansNa, median)
plot1 <- ggplot(TabsansNa, aes(x=Nature,y=Ca,fill=Nature))+
  geom_boxplot(outlier.colour="blue", outlier.shape=16,outlier.size=2)+
  stat_summary(fun="mean", geom="point",colour="red",size=2,shape=15)+
  scale_x_discrete(labels = c("Sparkling","Still"))+
  labs(title="Distribution of Calcium by Water Nature", x="Nature", y="Ca")+
  scale_fill_brewer(palette="Dark2")+
  theme(legend.position="none")+
  geom_text(data = mediane1, aes(label = Ca, y = Ca + 0.08))
print(plot1)

# Identification of outliers (example shown for Ca)
out_gaz <- TabsansNa %>% filter(Nature=="gaz")
out_plat <- TabsansNa %>% filter(Nature=="plat")

OutCa_gaz <- boxplot.stats(out_gaz$Ca)$out
OutCa_gaz
outlier_indice_gazCa <- which(out_gaz$Ca %in% c(OutCa_gaz))
outlier_nom_gazCa <- out_gaz[outlier_indice_gazCa,1]
outlier_nom_gazCa

OutCa_plat <- boxplot.stats(out_plat$Ca)$out
OutCa_plat
outlier_indice_platCa <- which(out_plat$Ca %in% c(OutCa_plat))
outlier_nom_platCa <- out_plat[outlier_indice_platCa,1]
outlier_nom_platCa

# (The same boxplot analysis and outlier detection steps are repeated for Mg, Na, K, Cl, NO3, SO4, HCO3, and PH.)

# General boxplot of physico-chemical composition
boxplot(TabsansNa[,3:11], main="Physico-Chemical Composition",
        xlab="", ylab="", col="purple", border="black")

###############################################################################

# 4) Selection of study data and supplementary data

###############################################################################

# Correlation matrix
tabsansNa.corr = cor(TabsansNa[,3:11])
tabsansNa.corr
corrplot(tabsansNa.corr, type = "upper", method = "number", tl.cex = 0.9)
det(tabsansNa.corr)

# Example correlation check between HCO3 and Na
ggplot(aes(x = HCO3, y = Na), data = TabsansNa)+
  geom_point(alpha = 1)+
  scale_x_continuous()

cor(x = TabsansNa$Na, y = TabsansNa$HCO3)

# Scatterplot matrix
pairs(TabsansNa[,3:11], gap=0, cex.labels=0.8)
ggpairs(TabsansNa[,3:11])

# Supplementary individuals (Morocco)
IndSup = (TabsansNa$Pays == "Maroc")
Tabsup <- TabsansNa[IndSup,]
rownames(Tabsup) = Tabsup$Nom
tabsup <- Tabsup[,3:11]

###############################################################################
######################### Exploratory Multivariate Analysis (PCA) #############
###############################################################################

Tab1 <- TabsansNa
tab1 <- TabsansNa[,3:11]        # Quantitative data
tab2 <- Tab1[Tab1$Pays!="Maroc",][,3:11] # Active individuals (non-Moroccan)
IndSup <- (TabsansNa$Pays == "Maroc")
Tabsup <- TabsansNa[IndSup,]     
tabsup <- Tabsup[,3:11]

# Centering and Normalization
tab2.C <- apply(tab2, MARGIN=2, scale, center=TRUE, scale=FALSE)*sqrt(54/55)
tab2.CR <- scale(tab2, center=TRUE, scale=TRUE)*sqrt(54/55)

# Covariance matrix V and correlation matrix R
V <- 54/55*cov(tab2)
R <- cor(tab2)

#################### PCA on Covariance Matrix (Non-normalized) #################
va_pV <- eigen(V)
VaP_V <- va_pV$values
VecP_V <- va_pV$vectors

# Screeplot
va_pV$P_inertie = VaP_V/sum(VaP_V)
barplot(va_pV$P_inertie,col = blues9,ylab="% inertia",main="Scree Plot (Variance Matrix)")

PC_V <- as.matrix(tab2.C) %*% VecP_V

#################### PCA on Correlation Matrix (Normalized) ####################
va_pR <- eigen(R)
ValP_R <- va_pR$values
VecP_R <- va_pR$vectors

P_inertie = ValP_R/sum(ValP_R)
barplot(P_inertie, names=paste0("CP", 1:length(P_inertie)), col=blues9,
        ylab="% inertia", main="Scree Plot (Correlation Matrix)")

PC_R <- as.matrix(tab2.CR) %*% VecP_R
colnames(PC_R) = paste0("CP",1:ncol(tab2.CR))

# Plot of CP1 and CP2
plot(PC_R[,1], PC_R[,2], xlim=c(-4,4), ylim=c(-3,3), asp=1, xlab="CP1", ylab="CP2")
abline(h=0,v=0,lty=2)

# Circle of correlations
Matcoord = matrix(0,9,9)
for (i in 1:9) {
  Matcoord[,i] = sqrt(ValP_R[i])*VecP_R[,i]
}
Matcoord2 = round(Matcoord[,1:9],2)

plot(Matcoord2[,1:2],type="n",xlab=paste("CP1 (",round(P_inertie[1]*100,2),"%)"),
     ylab=paste("CP2 (",round(P_inertie[2]*100,2),"%)"))
arrows(0,0,Matcoord2[,1],Matcoord2[,2],length=0.1)
title("Correlation Circle")
abline(h=0,v=0,lty=3)
text(Matcoord2[,1:2], colnames(tab2.CR), cex=0.7)

# Adding supplementary individuals
par(new=TRUE)
plot(tabsup[,1],tabsup[,2],pch=8,cex=1,col=c(1:100),xlab="CP1",ylab="CP2")
text(tabsup[,1],tabsup[,2],rownames(tabsup),cex=0.5)

############################ Individuals and Variables #########################
# Contributions and quality of representation are computed similarly.

######################### PCA using prcomp (Normalized) ########################
pc1.CR <- prcomp(tab2, scale=T, tol=0)
fviz_eig(pc1.CR)

# Adding supplementary individuals
Ind_A <- fviz_pca_ind(pc1.CR, repel=TRUE)
fviz_add(Ind_A, tabsup, color="blue")

# Variables plot
fviz_pca_var(pc1.CR, col.var="contrib",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel=TRUE)

######################### PCA using PCA function (FactoMineR) ##################
pc2.CR <- PCA(tab1, ncp=ncol(tab1), ind.sup=IndSup, scale.unit=T, graph=T)
pc2.C <- PCA(tab1, ncp=ncol(tab1), ind.sup=IndSup, scale.unit=F, graph=T)

fviz_eig(pc2.CR, addlabels = TRUE, ylim = c(0, 50))

# Variables
plot.PCA(pc2.CR, choix="var")
fviz_pca_var(pc2.CR, col.var="cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"), repel=TRUE)

# Individuals (active in black, supplementary in blue)
fviz_pca_ind(pc2.CR, axes=c(1,2), labelsize=3, col.ind.sup="blue", repel=TRUE)

############################ Cluster Analysis ##################################
set.seed(123)
# Optimal number of clusters
fviz_nbclust(tab2.CR, kmeans, method="wss") + geom_vline(xintercept=4, linetype=2)
fviz_nbclust(tab2.CR, kmeans, method="silhouette")
fviz_nbclust(tab2.CR, kmeans, nstart=25, method="gap_stat", nboot=50)
nb <- NbClust(tab2.CR, distance="euclidean", min.nc=2, max.nc=10, method="kmeans")
fviz_nbclust(nb)

# According to these methods, we choose 3 clusters
MatDissim <- daisy(tab2.CR)
km.res3 <- kmeans(tab2.CR,3, iter.max=25,nstart=25,algorithm="Lloyd")
silou2 <- silhouette(km.res3$cluster, daisy(tab2.CR))
fviz_silhouette(silou2, label=FALSE, print.summary=FALSE)
table(km.res3$cluster)

fviz_cluster(km.res3, data=tab2.CR,
             palette=c("#2E9FDF","#00AFBB","#E7B800","#FC4E07","#E7B800"),
             ellipse.type="euclid", star.plot=TRUE, repel=TRUE, ggtheme=theme_minimal())

# Check distribution by Nature
table(km.res3$cluster, Tab1[Tab1$Pays!="Maroc",]$Nature)

# Extract clusters
Kclasse1 <- subset(tab2, km.res3$cluster=="1")
Kclasse2 <- subset(tab2, km.res3$cluster=="2")
Kclasse3 <- subset(tab2, km.res3$cluster=="3")

tab2 %>%
  mutate(Cluster = km.res3$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")

summarise_all(Tabsup[,3:11],"mean")
row.names(Tabsup)

