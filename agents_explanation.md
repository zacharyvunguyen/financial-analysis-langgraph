# Financial Performance Analysis Agents

This document describes the various agents (nodes) used in the Financial Performance Reporting application and their specific roles in the analysis workflow.

## Agent Architecture Overview

The application uses a directed graph workflow powered by LangGraph, where each node represents a specialized agent responsible for a specific task in the financial analysis pipeline. These agents work together to create a comprehensive financial analysis report by passing state between each processing step.

## Core Agents

### 1. Financial Data Collection Agent (`gather_financials_node`)

**Purpose**: Processes raw CSV financial data and extracts structured information.

**Key Capabilities**:
- Parses uploaded CSV data using Pandas
- Generates a preliminary overview of financial metrics
- Formats the financial data for further analysis
- Operates using Vertex AI's Gemini model with financial analysis prompt

**Technical Implementation**:
```python
def gather_financials_node(state: AgentState):
    """Process financial data from CSV and generate initial analysis."""
    csv_file = state["csv_file"]
    df = pd.read_csv(StringIO(csv_file))
    financial_data_str = df.to_string(index=False)
    # Process with LLM to generate structured output
```

### 2. Financial Analysis Agent (`analyze_data_node`)

**Purpose**: Performs in-depth analysis of company financial data to extract insights.

**Key Capabilities**:
- Evaluates financial performance indicators
- Identifies trends, strengths, and weaknesses
- Calculates key financial ratios and metrics
- Provides contextual understanding of the financial data

**Technical Implementation**:
```python
def analyze_data_node(state: AgentState):
    """Analyze financial data to extract insights."""
    messages = [
        SystemMessage(content=PROMPTS["analyze_data"]),
        HumanMessage(content=state["financial_data"]),
    ]
    # LLM generates detailed analysis
```

### 3. Competitor Research Agent (`research_competitors_node`)

**Purpose**: Gathers information about competitor companies for comparison.

**Key Capabilities**:
- Generates relevant search queries based on competitor names
- Uses Tavily Search API to retrieve real-time market information
- Handles errors gracefully with fallback mechanisms
- Structures information for comparative analysis

**Technical Implementation**:
```python
def research_competitors_node(state: AgentState):
    """Research competitors using web search."""
    # For each competitor:
    # 1. Generate search queries using structured output
    # 2. Execute Tavily searches
    # 3. Collect and structure results
```

### 4. Performance Comparison Agent (`compare_performance_node`)

**Purpose**: Compares the target company's performance against competitors.

**Key Capabilities**:
- Synthesizes company analysis with competitor research
- Identifies competitive advantages and disadvantages
- Evaluates relative market position
- Provides cross-company performance metrics

**Technical Implementation**:
```python
def compare_performance_node(state: AgentState):
    """Compare company performance against competitors."""
    content = "\n\n".join(state["content"] or [])
    # Create message combining analysis and competitor data
    # LLM generates comparative analysis
```

### 5. Feedback Collection Agent (`collect_feedback_node`)

**Purpose**: Reviews the comparison report and provides critical feedback.

**Key Capabilities**:
- Evaluates the quality and completeness of the comparison report
- Identifies areas for improvement
- Suggests additional metrics or analyses
- Acts as an internal quality control mechanism

**Technical Implementation**:
```python
def collect_feedback_node(state: AgentState):
    """Collect feedback on the comparison report."""
    messages = [
        SystemMessage(content=PROMPTS["feedback"]),
        HumanMessage(content=state["comparison"]),
    ]
    # LLM generates feedback
```

### 6. Critique Research Agent (`research_critique_node`)

**Purpose**: Gathers additional information to address feedback on the analysis.

**Key Capabilities**:
- Generates search queries based on critique points
- Retrieves supplementary information to fill gaps
- Enhances the report with targeted additional research
- Provides evidence to support or refute initial findings

**Technical Implementation**:
```python
def research_critique_node(state: AgentState):
    """Research additional information based on critique."""
    # Generate queries from feedback
    # Perform Tavily searches
    # Collect additional research data
```

### 7. Report Generation Agent (`write_report_node`)

**Purpose**: Creates the final comprehensive financial report.

**Key Capabilities**:
- Synthesizes all previous steps into a cohesive document
- Structures information in a logical, readable format
- Includes key insights, comparisons, and recommendations
- Produces a polished, professional report

**Technical Implementation**:
```python
def write_report_node(state: AgentState):
    """Generate the final comprehensive report."""
    messages = [
        SystemMessage(content=PROMPTS["write_report"]),
        HumanMessage(content=f"Analysis: {state['analysis']}\n\nComparison: {state['comparison']}\n\nFeedback: {state.get('feedback', '')}"),
    ]
    # LLM generates complete report
```

## Workflow Orchestration

The agents work together in a directed graph with conditional transitions:

1. **Linear Path**: 
   - Financial Data Collection → Analysis → Competitor Research → Performance Comparison

2. **Feedback Loop**:
   - Performance Comparison → Feedback Collection → Critique Research → Performance Comparison (repeated until revision threshold)

3. **Final Stage**:
   - Performance Comparison → Report Generation

The workflow is managed by the `should_continue` function, which determines whether to continue the refinement loop or generate the final report:

```python
def should_continue(state):
    """Determine whether to continue the refinement loop or generate the final report."""
    if state["revision_number"] > state["max_revisions"]:
        return END
    return "collect_feedback"
```

## Technology Stack

These agents are powered by:

- **LLM**: Google Vertex AI (Gemini-1.0-Pro) for text generation and analysis
- **Web Search**: Tavily API for retrieving up-to-date competitor information
- **Orchestration**: LangGraph for managing the multi-step workflow
- **Checkpointing**: Memory-based state persistence for resilience
- **Data Processing**: Pandas for CSV parsing and data manipulation
- **UI**: Streamlit for interactive visualization and user interface

## Error Handling and Resilience

Each agent incorporates robust error handling to ensure the workflow continues even if individual components fail. Fallback mechanisms include:

- Default queries for search failures
- Parsing strategies for structured output failures
- Graceful degradation for API errors
- Session state management for UI consistency 