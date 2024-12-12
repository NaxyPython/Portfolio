# Data Analysis and Clustering of Bottled Water Composition

## Overview
This repository contains an analysis of the physicochemical composition of bottled water using Principal Component Analysis (PCA) and k-means clustering. The goal is to identify patterns and classify waters from different brands and countries into meaningful groups based on their mineral content.

## Objectives
- Explore relationships between the physicochemical compounds of bottled water.
- Perform dimensionality reduction using PCA to summarize and visualize data.
- Apply k-means clustering to classify waters into distinct groups based on their characteristics.

## Data Description
The dataset `EauxFM.txt` includes information on 95 bottled water samples, each described by 12 variables:

| Variable     | Type       | Description                                |
|--------------|------------|--------------------------------------------|
| Nature       | Categorical| "plat" (still) or "gaz" (sparkling)        |
| Ca           | Numeric    | Calcium (mg/L)                            |
| Mg           | Numeric    | Magnesium (mg/L)                          |
| Na           | Numeric    | Sodium (mg/L)                             |
| K            | Numeric    | Potassium (mg/L)                          |
| Cl           | Numeric    | Chlorides (mg/L)                          |
| NO3          | Numeric    | Nitrates (mg/L)                           |
| SO4          | Numeric    | Sulfates (mg/L)                           |
| HCO3         | Numeric    | Bicarbonates (mg/L)                       |
| PH           | Numeric    | pH level                                  |
| Pays         | Categorical| Country of origin ("France" or "Maroc")   |

### Data Preprocessing
1. **Duplicates and Missing Values:**
   - Duplicates were removed.
   - Observations with missing values (NA) were excluded, resulting in a dataset with 61 samples.
2. **Standardization:**
   - Variables were standardized (mean = 0, SD = 1) to ensure comparability.

## Methodology
### Principal Component Analysis (PCA)
PCA was performed to reduce the dimensionality of the data and summarize key information. The first three principal components explained 82.5% of the total variance:

- **CP1 (46.04%)**: Differentiates waters based on high sodium, potassium, and bicarbonates.
- **CP2 (23.40%)**: Highlights waters rich in calcium and sulfates.
- **CP3 (13.06%)**: Distinguishes waters based on nitrate content.

### k-Means Clustering
Unsupervised clustering was applied to classify waters into three groups:
- **Cluster 1:** High mineralization with rich calcium, magnesium, and sulfates.
- **Cluster 2:** High mineralization with abundant sodium, potassium, and bicarbonates.
- **Cluster 3:** Low mineralization, slightly basic, but poor quality due to high nitrates.

The optimal number of clusters was determined using the elbow method, silhouette scores, and the Dunn index.

## Visualizations
- **Correlation Matrix:** Displays strong correlations among variables like sodium and bicarbonates (r = 0.91).
- **Biplots:** Visual representation of PCA components and variable loadings.
- **Cluster Plots:** Visualization of k-means clusters in the reduced PCA space.

## Key Findings
- **French waters** are generally higher in calcium and sulfates compared to Moroccan waters, which are richer in sodium and chlorides.
- Sparkling waters are typically of better quality than still waters.
- Moroccan waters show lower overall quality, possibly due to less stringent regulations.

## Usage
To run the analysis:
1. Load the `EauxFM.txt` dataset.
2. Execute the R script `analysis_script.R` to:
   - Perform data preprocessing.
   - Apply PCA.
   - Conduct clustering analysis.
3. View the results through generated plots and summaries.

## Requirements
- R version 4.0 or higher
- R libraries: `dplyr`, `ggplot2`, `FactoMineR`, `factoextra`, `NbClust`, `cluster`, `reshape2`, `corrplot`

## Conclusion
This analysis demonstrates the effectiveness of PCA and clustering techniques in deriving meaningful insights from multivariate data. The methodology can be extended to similar studies involving the classification of products or environmental data.

## Contact
For any questions or collaboration, feel free to contact me via my [Malt profile](https://malt.fr/profile).

