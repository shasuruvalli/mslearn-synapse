---
lab:
    title: 'Use Microsoft Purview with Azure Synapse Analytics'
    module: 'Data Governance with Microsoft Purview'
---

# Use Microsoft Purview with Azure Synapse Analytics

Microsoft Purview enables you to catalog data assets across your data estate and track the *lineage* of data as it is moved from one data source to another. Close integration with Azure Synapse Analytics enables you to use Microsoft Purview to track the data assets in your analytical environment - a key element of a comprehensive data governance solution.

This lab will take approximately **35** minutes to complete.

## Before you start

You'll need an [Azure subscription](https://azure.microsoft.com/free) in which you have administrative-level access.

## Provision Azure resources

In this exercise, you'll use Microsoft Purview to track assets and data lineage in an Azure Synapse Analytics workspace. You'll start by using a script to provision these resources in your Azure subscription.

1. Sign into the [Azure portal](https://portal.azure.com).
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
    cd dp-000/Allfiles/Labs/10
    ./setup.ps1
    ```

6. If prompted, choose which subscription you want to use (this will only happen if you have access to multiple Azure subscriptions).
7. When prompted, enter a suitable password for your Azure SQL Database.

    > **Note**: Be sure to remember this password!

8. Wait for the script to complete - this typically takes around 15 minutes, but in some cases may take longer. While you are waiting, review the [What's available in the Microsoft Purview governance portal?](https://docs.microsoft.com/azure/purview/overview) article in the Microsoft Purview documentation.

## Catalog Azure Synapse Analytics data assets

With Microsoft Purview, you can catalog data assets across your data estate - including data sources in an Azure Synapse Workspace. The workspace you deployed using a script includes a data lake (in an Azure Data Lake Storage Gen2 account), a serverless database, and a data warehouse in a dedicated SQL pool.

### Configure access permissions for Microsoft Purview

Microsoft Purview is configured to use a managed identity. In order to catalog data assets, this managed identity account must have access to the Azure Synapse Analytics workspace and any SQL databases it contains.

1. In the [Azure portal](https://portal.azure.com), browse to the **dp000-*xxxxxxx*** resource group that was created by the setup script and view the resources that it created. These include:
    - A storage account with a name similar to **datalake*xxxxxxx***.
    - A Microsoft Purview account with a name similar to **purview*xxxxxxx***.
    - A dedicated SQL pool with a name similar to **sql*xxxxxxx***.
    - A Synapse workspace with a name similar to **synapse*xxxxxxx***.

