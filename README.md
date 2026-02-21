# PosturePrompt 🛡️

**An open-source, AI-powered Zero Trust assessment engine for Microsoft 365 tenants.**

PosturePrompt allows security administrators to map, query, and simulate their Microsoft Entra ID and Intune security posture using natural language. Built on the Microsoft Graph API, it translates complex Zero Trust configurations into actionable, human-readable insights.

## 🚀 Features
* **Natural Language Queries:** Ask questions like, *"Show me all guest users accessing financial SharePoint sites from unmanaged devices."*
* **Zero Trust Mapping:** Automatically maps relationships between identities, groups, conditional access policies, and device compliance.
* **Bring Your Own Key (BYOK):** Your tenant data never leaves your environment. PosturePrompt connects locally to your Microsoft Graph via a least-privilege App Registration and uses your own LLM API keys (Azure OpenAI or local via Ollama).
* **Agentic Remediation (Coming Soon):** Automatically generate the exact JSON payloads required to fix failing Zero Trust configurations.

## 🏗️ Architecture
PosturePrompt operates on a lightweight, privacy-first architecture:
1. **Ingestor:** Pulls raw configuration data from Entra ID / Intune via Graph API.
2. **Local Graph Store:** Stores relationships in memory (no external databases required).
3. **AI Orchestrator:** Uses Semantic Kernel/LangChain to translate chat prompts into database queries and synthesize risks.

## 🛠️ Getting Started
*(Deployment instructions via Docker Compose and App Registration setup script coming soon).*

## 🤝 Contributing
We welcome contributions from the Microsoft security community! Whether it is adding new KQL queries, refining the LLM prompts, or expanding Graph API coverage, please check out our `CONTRIBUTING.md` (coming soon).

## 📄 License
This project is licensed under the MIT License - see the `LICENSE` file for details.
