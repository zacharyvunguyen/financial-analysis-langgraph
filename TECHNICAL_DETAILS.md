# Technical Architecture: Financial Performance Reporting Agent

This document provides a technical overview of the Financial Performance Reporting Agent, explaining its architecture, workflow, and implementation details.

## Architecture Overview

The application implements a stateful, multi-agent system using Google Vertex AI and LangGraph. The system is structured as a directed acyclic graph (DAG) where specialized agents perform discrete tasks in the financial analysis workflow.

## LangGraph Implementation

[LangGraph](https://github.com/langchain-ai/langgraph) provides the orchestration framework, allowing for:

1. **State Management**: Persistent state throughout the workflow
2. **Directed Execution Flow**: Defined processing paths between agents
3. **Conditional Branching**: Dynamic workflow based on analysis state
4. **Checkpointing**: Resilience through state preservation
5. **Streaming Updates**: Real-time visibility into processing stages

### State Management

```python
class AgentState(TypedDict):
    """State maintained throughout the workflow."""
    task: str                 # Analysis task description
    competitors: List[str]    # Competitor companies
    csv_file: str             # Raw CSV data
    financial_data: str       # Processed financial information
    analysis: str             # Financial analysis results
    competitor_data: str      # Gathered competitor information
    comparison: str           # Comparative analysis
    feedback: str             # Quality improvement feedback
    report: str               # Final comprehensive report
    content: List[str]        # Additional context
    revision_number: int      # Current iteration count
    max_revisions: int        # Maximum allowed iterations
```

### Graph Structure

```python
def build_graph():
    """Build the directed workflow graph."""
    builder = StateGraph(AgentState)
    
    # Define nodes (agents)
    builder.add_node("gather_financials", gather_financials_node)
    builder.add_node("analyze_data", analyze_data_node)
    builder.add_node("research_competitors", research_competitors_node)
    builder.add_node("compare_performance", compare_performance_node)
    builder.add_node("collect_feedback", collect_feedback_node)
    builder.add_node("research_critique", research_critique_node)
    builder.add_node("write_report", write_report_node)
    
    # Set workflow entry point
    builder.set_entry_point("gather_financials")
    
    # Define standard edges
    builder.add_edge("gather_financials", "analyze_data")
    builder.add_edge("analyze_data", "research_competitors")
    builder.add_edge("research_competitors", "compare_performance")
    builder.add_edge("research_critique", "compare_performance")
    builder.add_edge("collect_feedback", "research_critique")
    
    # Define conditional edges for feedback loop
    builder.add_conditional_edges(
        "compare_performance",
        should_continue,
        {END: "write_report", "collect_feedback": "collect_feedback"},
    )
    
    # Configure checkpointing for resilience
    return builder.compile(checkpointer=MemorySaver())
```

## Agent Implementations

### 1. Financial Data Collection (`gather_financials_node`)

Processes raw CSV financial data and extracts structured information.

**Key Operations**:
- Parse uploaded CSV with Pandas
- Generate preliminary financial overview
- Format data for subsequent analysis

### 2. Financial Analysis (`analyze_data_node`)

Performs in-depth analysis of company financial data.

**Key Operations**:
- Evaluate key performance indicators
- Identify trends and growth patterns
- Calculate financial ratios and metrics
- Highlight strengths and weaknesses

### 3. Competitor Research (`research_competitors_node`)

Gathers information about competitor companies.

**Key Operations**:
- Generate relevant search queries for each competitor
- Execute web searches via Tavily API
- Process and structure search results
- Implement fallback mechanisms for failed searches

### 4. Performance Comparison (`compare_performance_node`)

Compares company performance against competitors.

**Key Operations**:
- Synthesize company analysis with competitor research
- Identify competitive advantages/disadvantages
- Evaluate relative market position
- Generate comparative performance metrics

### 5. Feedback Collection (`collect_feedback_node`)

Reviews the comparison report and provides critical feedback.

**Key Operations**:
- Evaluate report quality and completeness
- Identify information gaps
- Suggest additional analyses
- Act as quality control mechanism

### 6. Critique Research (`research_critique_node`)

Gathers additional information based on feedback.

**Key Operations**:
- Generate search queries from critique points
- Retrieve supplementary information
- Enhance report with targeted research
- Provide evidence for findings

### 7. Report Generation (`write_report_node`)

Creates the final comprehensive report.

**Key Operations**:
- Synthesize all previous analyses
- Structure information logically
- Include key insights and recommendations
- Format for readability and professionalism

## Feedback Loop Implementation

The application implements an iterative refinement process:

```python
def should_continue(state):
    """Determine whether to continue refinement or generate final report."""
    if state["revision_number"] > state["max_revisions"]:
        return END
    return "collect_feedback"
```

This creates a self-improving system:
1. Performance Comparison agent creates report
2. Feedback Collection agent reviews and critiques
3. Critique Research agent gathers additional information
4. Performance Comparison agent updates report
5. Cycle repeats until reaching revision threshold

## Technology Integration

### Google Vertex AI Integration

```python
model = ChatVertexAI(
    model_name=config["model_name"],
    project=config["project_id"],
    location=config["region"],
    credentials=credentials,
    temperature=config["temperature"],
    max_output_tokens=config["max_output_tokens"],
    streaming=True
)
```

### Web Search Integration (Tavily)

```python
def safe_tavily_search(tavily_client, query, max_results=2):
    """Execute search with error handling and retries."""
    attempt = 1
    max_attempts = 3
    
    while attempt <= max_attempts:
        try:
            print(f"Attempting Tavily search for: '{query}' (attempt {attempt}/{max_attempts})")
            search_result = tavily_client.search(
                query=query,
                search_depth="advanced",
                max_results=max_results
            )
            return search_result
        except Exception as e:
            if attempt == max_attempts:
                print(f"Failed to complete search after {max_attempts} attempts: {str(e)}")
                return {"error": str(e)}
            attempt += 1
            time.sleep(2)  # Brief delay before retry
```

## Error Handling & Resilience

The system implements multiple fallback mechanisms:

1. **Structured Output Parsing**:
   ```python
   def safe_structured_output(model, output_class, messages):
       """Get structured output from LLM with fallbacks."""
       try:
           result = model.with_structured_output(output_class).invoke(messages)
           if result is None:
               regular_response = model.invoke(messages)
               return output_class.from_response(regular_response.content)
           return result
       except Exception:
           # Use fallback mechanisms
   ```

2. **API Error Management**:
   - Retries for transient failures
   - Default values when services are unavailable
   - Graceful degradation for missing components

3. **Session State Preservation**:
   - Streamlit session state manages UI consistency
   - Checkpointing preserves progress on failures
   - Resumption capabilities after interruptions

## Streamlit Interface

The UI implementation uses Streamlit's component-based approach:
- Form-based data collection
- Tab-based results presentation
- Progress indicators for workflow stages
- Dynamic content updates during processing
- Interactive download capabilities

## Performance Considerations

- **State Size Management**: Careful tracking of state object growth
- **Asynchronous Processing**: Where applicable for improved responsiveness
- **Memory Management**: Proper handling of large data structures
- **Timeout Handling**: Graceful recovery from long-running operations

## Development and Extension

The modular design allows for:
- Easy addition of new analysis capabilities
- Replacement of individual components
- Extension to additional data sources
- Integration with other financial systems

For implementation details, refer to the source code in `app.py`. 