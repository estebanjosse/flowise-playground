# Sample Flows

This document describes example workflows you can build with FlowiseAI using this Docker environment.

## Overview

FlowiseAI supports various types of LLM workflows. Below are common patterns and examples to help you get started.

---

## 1. Simple Chatbot

A basic conversational chatbot using an LLM.

### Components Needed:
- **ChatOpenAI** (or any chat model)
- **Buffer Memory** (optional, for conversation history)

### Setup Steps:
1. Add a **ChatOpenAI** node
2. Configure your API key in the node settings
3. Optionally add **Buffer Memory** for conversation context
4. Save and test with the Chat button

### Use Case:
- Customer support automation
- General Q&A assistant
- Interactive help systems

---

## 2. Document Q&A (RAG)

Answer questions based on your own documents using Retrieval-Augmented Generation.

### Components Needed:
- **Document Loaders** (PDF, Text, Web, etc.)
- **Text Splitter** (Recursive Character Text Splitter)
- **Embeddings** (OpenAI Embeddings or alternatives)
- **Vector Store** (Qdrant, Pinecone, etc.)
- **Retrieval QA Chain**

### Setup Steps:
1. Start the environment with Qdrant:
   ```bash
   docker compose --profile qdrant up -d
   ```

2. Create a new flow with these nodes:
   - **PDF Loader** → **Recursive Character Text Splitter**
   - **OpenAI Embeddings** + **Qdrant** vector store
   - **Retrieval QA Chain** connected to the vector store and a chat model

3. Configure Qdrant connection:
   - **Host:** `qdrant`
   - **Port:** `6333`
   - **Collection Name:** `my-documents`

4. Upload your documents and test

### Use Case:
- Knowledge base search
- Documentation assistant
- Legal document analysis
- Research paper Q&A

---

## 3. Conversational Agent

An AI agent that can use tools to accomplish tasks.

### Components Needed:
- **Chat Model** (OpenAI, Anthropic, etc.)
- **Agent** (OpenAI Functions Agent or ReAct Agent)
- **Tools** (Calculator, Web Search, Custom API, etc.)
- **Memory** (for conversation history)

### Setup Steps:
1. Add a **Conversational Agent** node
2. Connect a **Chat Model** (e.g., ChatOpenAI with GPT-4)
3. Add tools:
   - **Calculator** for math operations
   - **SerpAPI** for web search
   - **Custom Tool** for your own APIs
4. Add **Buffer Memory** for context
5. Save and test

### Use Case:
- Task automation
- Research assistant
- Multi-step problem solving

---

## 4. API Integration Flow

Build flows that can be called programmatically from your applications.

### Components Needed:
- Any Flowise flow (Chatbot, RAG, Agent, etc.)

### Setup Steps:
1. Create and save any flow
2. Click the **"API"** button in the flow editor
3. Copy the endpoint URL
4. Make API calls from your application:

```python
import requests

url = "http://localhost:3000/api/v1/prediction/{your-flow-id}"
payload = {"question": "What is the capital of France?"}
headers = {"Content-Type": "application/json"}

response = requests.post(url, json=payload, headers=headers)
print(response.json())
```

### Use Case:
- Backend integration
- Mobile apps
- Automated workflows
- Chatbots on websites

---

## 5. Multi-Model Comparison

Compare responses from different LLM providers.

### Components Needed:
- Multiple **Chat Models** (OpenAI, Anthropic, etc.)
- **Custom Logic** or parallel chains

### Setup Steps:
1. Create separate flows for each model
2. Use the API to call each flow
3. Compare responses programmatically

### Use Case:
- Model evaluation
- A/B testing
- Quality assurance

---

## Building Your Own Flows

### Best Practices:

1. **Start Simple**: Begin with basic flows and add complexity gradually
2. **Test Frequently**: Use the Chat button to test after each change
3. **Use Memory Wisely**: Only add memory when conversation context is needed
4. **Secure Your Keys**: Use the Credentials feature for API keys
5. **Export Regularly**: Backup your flows by exporting them as JSON

### Tips for RAG Workflows:

- **Chunk Size**: Start with 1000 characters, adjust based on your content
- **Overlap**: Use 200-character overlap to maintain context between chunks
- **Embeddings**: Match embedding dimensions with your vector store settings
- **Retrieval Count**: Start with 4 documents, adjust based on response quality

### Tips for Agents:

- **Tool Descriptions**: Write clear, specific descriptions for custom tools
- **Model Selection**: GPT-4 performs better for complex reasoning
- **Error Handling**: Test edge cases and unusual inputs

---

## Importing Sample Flows

If sample flow JSON files are provided in the `flows/` directory:

1. Open Flowise UI
2. Click **"Add New"**
3. Click the **"Settings"** icon
4. Select **"Load Chatflow"**
5. Upload the JSON file

---

## Community Resources

- [Flowise Documentation](https://docs.flowiseai.com/)
- [Flowise GitHub](https://github.com/FlowiseAI/Flowise)
- [LangChain Documentation](https://js.langchain.com/)
- [Qdrant Documentation](https://qdrant.tech/documentation/)
