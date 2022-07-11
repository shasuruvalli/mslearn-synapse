---
lab:
    title: 'Use Azure Machine Learning with Azure Synapse Analytics'
    module: 'Predictive Analytics with Microsoft Purview'
---

# Use Azure Machine Learning with Azure Synapse Analytics

Azure Machine Learning is a cloud-based platform for creating, deploying, and operating machine learning solutions. When combined with Azure Synapse Analytics, you can ingest and prepare data for machine learning model training, and then use Azure Machine learning to train and deploy a model. You can then use the model to support predictive analytics in Azure Synapse Analytics.

This lab will take approximately **40** minutes to complete.

## Before you start

You'll need an [Azure subscription](https://azure.microsoft.com/free) in which you have administrative-level access.

## Provision Azure resources

In this exercise, you'll integrate an Azure Machine Learning workspace and an Azure Synapse Analytics workspace. You'll start by using a script to provision these resources in your Azure subscription.

1. Sign into the [Azure portal](https://portal.azure.com) at `https://portal.azure.com`.
2. Use the **[\>_]** button to the right of the search bar at the top of the page to create a new Cloud Shell in the Azure portal, selecting a ***PowerShell*** environment and creating storage if prompted. The cloud shell provides a command line interface in a pane at the bottom of the Azure portal, as shown here:

    ![Azure portal with a cloud shell pane](./images/cloud-shell.png)

    > **Note**: If you have previously created a cloud shell that uses a *Bash* environment, use the the drop-down menu at the top left of the cloud shell pane to change it to ***PowerShell***.

3. Note that you can resize the cloud shell by dragging the separator bar at the top of the pane, or by using the **&#8212;**, **&#9723;**, and **X** icons at the top right of the pane to minimize, maximize, and close the pane. For more information about using the Azure Cloud Shell, see the [Azure Cloud Shell documentation](https://docs.microsoft.com/azure/cloud-shell/overview).

4. In the PowerShell pane, enter the following commands to clone this repo:

    ```
    rm -r dp-000 -f
    git clone https://github.com/MicrosoftLearning/mslearn-synapse dp-000
    ```

5. After the repo has been cloned, enter the following commands to change to the folder for this lab and run the **setup.ps1** script it contains:

    ```
    cd dp-000/Allfiles/Labs/11
    ./setup.ps1
    ```

6. If prompted, choose which subscription you want to use (this will only happen if you have access to multiple Azure subscriptions).
7. When prompted, enter a suitable password for your Azure SQL Database.

    > **Note**: Be sure to remember this password!

8. Wait for the script to complete - this typically takes around 15 minutes, but in some cases may take longer. While you are waiting, review the [Machine Learning capabilities in Azure Synapse Analytics](https://docs.microsoft.com/azure/synapse-analytics/machine-learning/what-is-machine-learning) article in the Azure Synapse Analytics documentation.

9. When the script has finished, in the Azure portal, view the **dp000-*xxxxxxx*** resource group that it created. This should include the following resources:
    - **aml*xxxxxxx*** - An Azure Machine Learning workspace.
    - **aml*xxxxxxx*insights*nnn*...** - An Application Insights instance.
    - **aml*xxxxxxx*keyvault*nnn*...** - A Key vault.
    - **aml*xxxxxxx*storage*nnn*...** - A storage account for Azure Machine Learning.
    - **datalake*xxxxxxx*** - A storage account for the data lake used in Azure Synapse Analytics
    - **synapse*xxxxxxx*** - An Azure Synapse Analytics workspace.


> **Tip**: If, after running the setup script you decide not to complete the lab, be sure to delete the **dp000-*xxxxxxx*** resource group that was created in your Azure subscription to avoid unnecessary Azure costs.

## Explore data for model training

Before training a model, a data scientists generally explores the data with which the model will be trained, and prepares it by removing errors and outliers, identifying predictive features, and potentially using *feature engineering* techniques to augment the data with new derived values that will result in a more predictive model. In this example, we'll explore some existing data that relates to a bike rental scheme for which we'll later train a model to predict the expected number of rentals for a given day.

1. In the **dp000-*xxxxxxx*** resource group, select the **synapse*xxxxxxx*** Synapse workspace.
2. In the **Overview** page for your Synapse workspace, in the **Open Synapse Studio** card, select **Open** to open Synapse Studio in a new browser tab; signing in if prompted.
3. On the left side of Synapse Studio, use the **&rsaquo;&rsaquo;** icon to expand the menu - this reveals the different pages within Synapse Studio that you'll use to manage resources and perform data analytics tasks.
4. On the **Data** page, view the **Linked** tab. Then expand **Azure Data Lake Storage Gen2** and your **synapse*xxxxxxx* (Primary - datalake*xxxxxxx*)** data lake storage account, and select its **files** container.
5. In the **files** tab, open the **data** folder. Then select the **bike-rentals.csv** file it contains and in the **New notebook** menu, select **Load to DataFrame**. This creates a new **Notebook 1** tab for a notebook in which a single cell contains the following code:

    ```python
    %%pyspark
    df = spark.read.load('abfss://files@datalakexxxxxxx.dfs.core.windows.net/data/bike-rentals.csv', format='csv'
    ## If header exists uncomment line below
    ##, header=True
    )
    display(df.limit(10))
    ```

6. Modify the code as follows to uncomment the `, header=True` line:

    ```python
    %%pyspark
    df = spark.read.load('abfss://files@datalakexxxxxxx.dfs.core.windows.net/data/bike-rentals.csv', format='csv'
    ## If header exists uncomment line below
    , header=True
    )
    display(df.limit(10))
    ```