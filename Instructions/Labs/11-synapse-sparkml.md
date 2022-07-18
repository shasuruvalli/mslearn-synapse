---
lab:
    title: 'Use Spark MLlib with Azure Synapse Analytics'
    module: 'Predictive Analytics with Azure Synapse Analytics'
---

# Use Spark MLlib with Azure Synapse Analytics

Spark MLlib is a library for Spark that enables you to train and use machine learning models for predictive analytics.

This lab will take approximately **40** minutes to complete.

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

## Explore data and train a machine learning model

*Spark MLlib* is a library for training and using machine learning models on Apache Spark. It's similar to the commonly used *Skikit-Learn* library used in Python environments; but optimized for distributed processing on a Spark cluster.

In this lab, you'll use a Spark notebook to explore data, and then use Spark MLlib to train and validate a machine learning model from that data.

1. In the **dp000-*xxxxxxx*** resource group, select the **synapse*xxxxxxx*** Synapse workspace.
2. In the **Overview** page for your Synapse workspace, in the **Open Synapse Studio** card, select **Open** to open Synapse Studio in a new browser tab; signing in if prompted.
3. On the left side of Synapse Studio, use the **&rsaquo;&rsaquo;** icon to expand the menu - this reveals the different pages within Synapse Studio that you'll use to manage resources and perform data analytics tasks.
4. On the **Develop** page, expand **Notebooks** and then open the **Spark MLlib** notebook.
5. Follow the instructions in the notebook to explore a machine learning scenario.

## Delete Azure resources

When you've finished exploring machine learning with Spark MLlib in Azure Synapse Analytics, you should delete the resources you've created to avoid unnecessary Azure costs.

1. Close the Synapse Studio browser tab and return to the Azure portal.
2. On the Azure portal, on the **Home** page, select **Resource groups**.
3. Select the **dp000-*xxxxxxx*** resource group.
4. At the top of the **Overview** page for your resource group, select **Delete resource group**.
5. Enter the **dp000-*xxxxxxx*** resource group name to confirm you want to delete it, and select **Delete**.

    After a few minutes, your Azure Synapse workspace resource group and the managed workspace resource group associated with it will be deleted.
