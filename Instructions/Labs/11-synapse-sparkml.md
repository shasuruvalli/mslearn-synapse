---
lab:
    title: 'Use Spark MLlib with Azure Synapse Analytics'
    module: 'Predictive Analytics with Azure Synapse Analytics'
---

# Use Spark MLlib with Azure Synapse Analytics

Spark MLlib is a library for Spark that enables you to train and use machine learning models for predictive analytics.

This lab will take approximately **30** minutes to complete.

## Before you start

You'll need an [Azure subscription](https://azure.microsoft.com/free) in which you have administrative-level access.

## Provision Azure resources

In this exercise, you'll use a Spark pool in an Azure Synapse Analytics workspace. You'll start by using a script to provision these resources in your Azure subscription.

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
    - **datalake*xxxxxxx*** - A storage account for the data lake used in Azure Synapse Analytics
    - **spark*xxxxxxx* (synapse*xxxxxxx*/spark*xxxxxxx*)** - An Apache Spark pool.
    - **synapse*xxxxxxx*** - An Azure Synapse Analytics workspace.

> **Tip**: If, after running the setup script you decide not to complete the lab, be sure to delete the **dp000-*xxxxxxx*** resource group that was created in your Azure subscription to avoid unnecessary Azure costs.

## Explore data for model training

Before training a model, a data scientists generally explores the data with which the model will be trained, and prepares it by removing errors and outliers, identifying predictive features, and potentially using *feature engineering* techniques to augment the data with new derived values that will result in a more predictive model. In this example, we'll explore some existing data that relates to a bike rental scheme for which we'll later train a model to predict the expected number of rentals for a given day.

1. In the **dp000-*xxxxxxx*** resource group, select the **synapse*xxxxxxx*** Synapse workspace.
2. In the **Overview** page for your Synapse workspace, in the **Open Synapse Studio** card, select **Open** to open Synapse Studio in a new browser tab; signing in if prompted.
3. On the left side of Synapse Studio, use the **&rsaquo;&rsaquo;** icon to expand the menu - this reveals the different pages within Synapse Studio that you'll use to manage resources and perform data analytics tasks.
4. On the **Data** page, view the **Linked** tab. Then expand **Azure Data Lake Storage Gen2** and your **synapse*xxxxxxx* (Primary - datalake*xxxxxxx*)** data lake storage account, and select its **files** container.
5. In the **files** tab, open the **data** folder. Then select the **bike-rentals-training.csv** file it contains and in the **New notebook** menu, select **Load to DataFrame**. This creates a new **Notebook 1** tab for a notebook in which a single cell contains code similar to the following example:

    ```python
    %%pyspark
    df = spark.read.load('abfss://files@datalakexxxxxxx.dfs.core.windows.net/data/bike-rentals-training.csv', format='csv'
    ## If header exists uncomment line below
    ##, header=True
    )
    display(df.limit(10))
    ```

6. Modify the code as follows to uncomment the `, header=True` line and add a `, inferSchema=True` line:

    ```python
    %%pyspark
    df = spark.read.load('abfss://files@datalakexxxxxxx.dfs.core.windows.net/data/bike-rentals-training.csv', format='csv'
    ## If header exists uncomment line below
    , header=True
    , inferSchema=True
    )
    display(df.limit(10))
    ```

7. In the **Attach to** list, select your **spark*xxxxxxx*** Spark pool. Then use the **&#9655; Run all** button to run all of the cells in the notebook (there's currently only one!).

    Since this is the first time you've run any Spark code in this session, the Spark pool must be started. This means that the first run in the session can take a few minutes. Subsequent runs will be quicker.

8. When the code has finished running, view the output; which shows daily data for bike rentals. The data includes details for each day; including temporal, seasonal, and meteorological data) as well as the number of bikes rented.

    > ***Citation**: This data is derived from [Capital Bikeshare](https://ride.capitalbikeshare.com/system-data) and is used in accordance with the [published data license agreement](https://ride.capitalbikeshare.com/data-license-agreement).*

9. Use the **+ Code** button to add a new code cell to the notebook, and then enter the following code:

    ```python
    bike_df = df.select("season", 
                        "mnth", 
                        "holiday", 
                        "weekday", 
                        "workingday", 
                        "weathersit", 
                        "temp", 
                        "atemp", 
                        "hum", 
                        "windspeed", 
                        "rentals")
    bike_df.write.saveAsTable("bike_data")
    ```

10. Use the **&#9655;** button to the left of the code cell to run it. The code selects a subset of columns from the original dataset, and saves them as a table named **bike_data** in the default Spark database.

11. Use the **Publish all** button to publish the **Notebook 1** notebook - you will return to it later.

12. In the **Data** pane, view the **Workspace** tab. If no databases are listed, you may need to use the **&#8635;** button at the top right of Synapse Studio to refresh the page. Then expand **Lake database**, the **default** database, and its **Tables** folder to see the **bike_data** table you just created.

13. In the **Notebook 1** notebook, add another new code cell and use it to run the following code to query the **bike_data** table:

    ```sql
    %%sql

    SELECT * FROM bike_data
    ```

14. Publish the changes to the notebook. Then close the **Notebook 1** tab, and stop the Spark session.
