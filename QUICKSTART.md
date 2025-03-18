# Financial Performance Reporting Agent - Quick Start Guide

This guide helps you set up and run the Financial Performance Reporting Agent on your system.

## Prerequisites

- Google Cloud Platform account with billing enabled
- Tavily API key (for web search capabilities)
- Anaconda/Miniconda
- Git

## Setup

### 1. Clone & Configure Environment

```bash
# Clone repository
git clone [repository-url]
cd financial-analysis-langgraph

# Create and activate conda environment
conda create -n langgraph python=3.11
conda activate langgraph

# Install dependencies
pip install -r requirements.txt

# Configure environment variables
cp .env.example .env
# Edit .env with your credentials
```

Required variables in `.env`:
- `GOOGLE_CLOUD_PROJECT_ID`: Your GCP project ID
- `GOOGLE_CLOUD_REGION`: Preferred region (e.g., us-east5)
- `GOOGLE_APPLICATION_CREDENTIALS`: Path to service account key
- `TAVILY_API_KEY`: Your Tavily API key

### 2. Set Up GCP Resources

```bash
# Initialize Terraform
cd terraform
terraform init

# Deploy infrastructure
terraform apply

# Return to project root
cd ..
```

## Running the Application

```bash
# Ensure you're in the project root with environment activated
conda activate langgraph

# Launch application
streamlit run app.py
```

The application opens in your browser at http://localhost:8501

## Using the Application

1. **Enter Analysis Parameters**:
   - Task description (already populated with default)
   - Competitor names (defaults provided)
   - Maximum revision cycles
   - Upload financial data in CSV format (a sample financials.csv file is provided in the repository)

2. **Start Analysis**:
   - Click "Start Analysis"
   - Watch progress across multiple processing stages

3. **Review Results**:
   - Navigate the tabs to view different stages of analysis
   - Download the final report when complete

## Troubleshooting

- **Authentication Error**: Verify your GCP credentials and `GOOGLE_APPLICATION_CREDENTIALS` path
- **Missing Dependencies**: Run `pip install -r requirements.txt`
- **Model Unavailable**: Ensure the model is available in your GCP region

For detailed technical information, see [TECHNICAL_DETAILS.md](./TECHNICAL_DETAILS.md). 