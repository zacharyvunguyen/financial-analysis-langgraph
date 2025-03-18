# Financial Performance Reporting Agent

An intelligent AI workflow system powered by Large Language Models that transforms financial data into comprehensive analysis reports with minimal human intervention.

## Project Overview

This project demonstrates how modern AI technologies can automate complex business workflows. By combining Large Language Models (LLMs) with agent orchestration frameworks, the system creates a self-improving analysis pipeline that gets smarter with each iteration.

## Key Technologies

- **LangGraph**: A Python framework for building stateful, multi-step AI agent workflows using directed graphs
- **Google Vertex AI**: Cloud-based AI platform providing access to state-of-the-art foundation models
- **Gemini & Claude Models**: Powerful LLMs that power the natural language understanding and generation
- **Retrieval-Augmented Generation (RAG)**: Combines real-time web data with LLM reasoning to enhance outputs
- **Streamlit**: Python framework for rapidly building interactive web applications
- **Terraform**: Infrastructure as Code (IaC) tool for automated cloud resource provisioning
- **Python Pandas**: Data manipulation library for financial data processing

## Technical Architecture

### Agent Framework
The system is built on LangGraph's agent orchestration capabilities, creating a directed acyclic graph (DAG) of specialized nodes that handle different aspects of the analysis pipeline:

```
Financial Data Input → Analysis → Competitor Research → Performance Comparison → 
Feedback Loop → Additional Research → Report Generation
```

### AI Integration
- **Vertex AI Integration**: Uses Google Cloud's AI platform to access advanced LLMs
- **Context-Aware Processing**: Maintains state between nodes for coherent multi-step reasoning
- **Web-Based Research**: Utilizes Tavily API for real-time information retrieval

### DevOps & Infrastructure
- **Automated Infrastructure**: Terraform scripts provision all required Google Cloud resources
- **Service Account Management**: Automated creation of least-privilege service accounts
- **Environment Configuration**: Dotenv-based configuration for easy deployment

## How It Works

1. **Data Ingestion & Parsing**: Processes structured financial data from CSV files
2. **LLM-Powered Analysis**: AI models examine financial metrics and identify key insights
3. **Dynamic Web Research**: The agent autonomously researches competitors and market conditions
4. **Comparative Analysis**: Generates data-driven comparisons against industry competitors
5. **Self-Improvement Loop**: An automated critique and refinement cycle improves output quality
6. **Report Synthesis**: Consolidates all findings into a cohesive, well-structured report

## Detailed Workflow & Technology Stack

The application follows a sophisticated workflow where each step is powered by specific technologies:

### 1. Financial Data Processing
- **Pandas (Python)**: Parses CSV financial data into structured dataframes
- **StringIO**: Handles in-memory file operations for uploaded data
- **Streamlit Widgets**: Provides the file upload interface and data visualization

### 2. Financial Analysis Node
- **Vertex AI Gemini Model**: Performs the initial financial data analysis
- **LangChain Prompting**: Uses specialized system prompts to guide the AI analysis
- **Pydantic Models**: Validates and structures the analysis output

### 3. Competitor Research Node
- **LangGraph State Management**: Tracks the research context and progress
- **Tavily API**: Performs targeted web searches for competitor information
- **Structured Output Parsing**: Extracts specific search queries from model outputs
- **Error Handling Layer**: Ensures resilience if searches or API calls fail

### 4. Performance Comparison Node
- **LangGraph Checkpointer**: Saves the state between processing steps
- **Vertex AI Context Window**: Processes large volumes of research data
- **In-Memory Data Storage**: Manages competitor information and analysis results

### 5. Feedback Loop Mechanism 
- **Multi-step LLM Reasoning**: The system critiques its own work using dedicated nodes
- **LangGraph Conditional Edges**: Dynamically decides whether to continue refinement
- **Iteration Counter**: Tracks and limits revision cycles to prevent infinite loops

### 6. Report Generation & Presentation
- **Streamlit Interface**: Presents the final report with interactive elements
- **Markdown Rendering**: Formats the report for easy reading and navigation
- **State Management**: Preserves analysis across Streamlit sessions

### Integration & Orchestration
- **LangGraph Directed Graph**: Orchestrates the entire workflow with specialized nodes
- **Python Environment Management**: Conda environment with specific dependencies
- **Google Cloud Authentication**: Service account-based access to Vertex AI
- **Terraform Automation**: Creates all necessary cloud resources and permissions

## Project Structure

```
.
├── app.py                           # Main application code with LangGraph workflow
├── financials.csv                   # Sample financial data for testing
├── QUICKSTART.md                    # Setup and usage guide
├── .env.example                     # Template for environment variables
├── terraform/                       # Infrastructure as Code
│   ├── main.tf                      # Terraform configuration for GCP resources
│   └── service-account-key.json     # Created during setup
└── LangGraph_311_requirements.txt   # Python dependencies
```

## Advanced Features

- **Stateful Agent Memory**: The system maintains context between processing steps
- **Error-Resilient Processing**: Robust error handling for API and model failures
- **Structured Output Parsing**: Converts unstructured LLM outputs into structured data
- **Custom Prompting Techniques**: Specialized prompting for different analysis stages
- **Multi-Step Reasoning**: Complex problem-solving through sequential thinking steps

## Getting Started

See the [QUICKSTART.md](./QUICKSTART.md) guide for detailed setup and usage instructions.

## Use Cases

- **Financial Reporting Automation**: Generate quarterly/annual financial analyses
- **Investment Research**: Perform due diligence on potential investments
- **Competitive Intelligence**: Monitor and analyze competitor performance
- **Market Entry Analysis**: Evaluate new market opportunities
- **Strategic Planning**: Generate data-driven insights for executive decision-making

## Prerequisites

- Google Cloud Platform account with billing enabled
- Tavily API key for web search capabilities
- Python 3.11+ with Anaconda/Miniconda (recommended)
- Basic familiarity with command line interfaces

## License

MIT License

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or create an Issue. 