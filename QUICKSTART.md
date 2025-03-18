# Financial Performance Reporting Agent - Quick Start Guide

This guide will help you set up and run the Financial Performance Reporting Agent, an AI-powered tool that analyzes financial data, researches competitors, and generates comprehensive reports.

## Prerequisites

- Google Cloud Platform account with billing enabled
- Tavily API key (for web search capabilities)
- Anaconda/Miniconda installed on your system
- Basic familiarity with command line

## 1. Environment Setup

### Create a Python Environment

```bash
# Create a new conda environment with Python 3.11
conda create -n langgraph python=3.11
conda activate langgraph

# Install all required dependencies
pip install -r LangGraph_311_requirements.txt
```

### Set Up Google Cloud Infrastructure

```bash
# Navigate to the terraform directory
cd terraform

# Initialize Terraform
terraform init

# Deploy the infrastructure (you'll be prompted to confirm)
terraform apply

# Verify that the service account key was created
ls service-account-key.json
```

### Configure Environment Variables

```bash
# Copy the example .env file
cp .env.example .env

# Edit the .env file with your credentials
# Required variables:
# - GOOGLE_CLOUD_PROJECT_ID=your-gcp-project-id
# - GOOGLE_CLOUD_REGION=your-preferred-region (e.g., us-east5)
# - GOOGLE_APPLICATION_CREDENTIALS=./terraform/service-account-key.json
# - TAVILY_API_KEY=your-tavily-api-key
```

## 2. Running the Application

```bash
# Make sure you're in the project root directory
# Activate your environment if not already active
conda activate langgraph

# Start the Streamlit application
streamlit run app.py
```

The application will open in your default web browser at http://localhost:8501.

## 3. Using the Application

1. **Input Information**
   - Enter your task description (e.g., analyze company financials)
   - Add competitor names (one per line)
   - Set the maximum number of revision cycles
   - Upload your financial data CSV file (use the provided sample as a template)
   - Click "Start Analysis"

2. **View Results**
   - Navigate through the tabs to see different aspects of the analysis
   - The application works through several steps automatically:
     - Analyzing financial data
     - Researching competitors
     - Comparing performance
     - Generating a final report

3. **Download Report**
   - Once analysis is complete, use the "Download Report" button to save your report

## 4. Troubleshooting

### Common Issues

1. **Authentication Problems**
   ```bash
   # Verify your GCP authentication
   gcloud auth application-default login
   
   # Check your service account key path in .env file
   # Should be: GOOGLE_APPLICATION_CREDENTIALS=./terraform/service-account-key.json
   ```

2. **Missing Dependencies**
   ```bash
   # Reinstall all dependencies
   pip install -r LangGraph_311_requirements.txt
   
   # Install specific missing packages if needed
   pip install langchain-community langchain-google-vertexai langgraph streamlit
   ```

3. **Model Availability**
   - If you encounter model errors, check if the model is available in your GCP region
   - You might need to update the MODEL_NAME variable to use a model available in your project

## Sample Data

The application includes a sample `financials.csv` file you can use for testing.

## Need Help?

If you encounter issues not covered here, please refer to the documentation or create an issue with specific error details. 