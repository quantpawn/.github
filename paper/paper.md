---
title: "QuantPawn: A Self-Iteration Trading System"
subtitle: "Even starting with the equivalent of an 8-year-old's intelligence, given sufficient compute resources for iteration, generative AI can eventually beat the best human traders."
author:
    - "@codingtmd"
date: "March 9, 2026"
abstract: |
    In the past, quantitative trading heavily relied on experts or statistical mathematicians to analyze the market, discover trading strategies, and apply them for profit. An effective strategy could take years from discovery to practical deployment. And every iteration is heavily depending in smart individual and the understading of the market.

    We believe that the advancement of AI, especially the new generation of intelligence represented by Generative AI, fundamentally changes this structure. The inherent reasoning capabilities empower AI with the potential for self-reflection and self-iteration. This article is to present a ai-native structure of quant tradiing system, which is simple, self-iterationable, and with good-enough extension for future AI direction.
keywords:
    - AI
    - Crypto
    - Quantitative Trading
    - Multi-Agent Systems

---


## 1. Introduction

Modern quantitative trading firms have developed highly structured research pipelines for discovering predictive signals in financial markets. Institutions such as Two Sigma, Citadel, and DE Shaw operate large-scale infrastructures often referred to as alpha factories, where trading signals (alphas) are systematically generated, evaluated, and deployed through a standardized research workflow.

In a typical alpha factory, large volumes of market and alternative data are first collected and processed through data engineering pipelines. Researchers then construct candidate factors—statistical or domain-specific transformations of raw data—which are evaluated using predictive metrics such as information coefficients and return stratification. Promising factors are combined using statistical or machine learning models, including tree-based methods such as XGBoost and LightGBM, or even advanced algroithms like Neural network, Transformer, etc. Candidate strategies are further validated through backtesting frameworks that simulate realistic trading conditions, after which signals are aggregated through portfolio optimization and executed in live markets. Rather than relying on a single strong model, these systems typically combine large numbers of weak but statistically significant signals to produce stable returns.


```graph
                ┌───────────────────┐
                │   Data Sources    │
                │───────────────────│
                │ Market Data       │
                │ Orderbook         │
                │ On-chain Data     │
                │ Alternative Data  │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │   Data Pipeline   │
                │───────────────────│
                │ Clean             │
                │ Normalize         │
                │ Align             │
                │ Feature Store     │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │   Factor Engine   │
                │───────────────────│
                │ Technical Factors │
                │ Microstructure    │
                │ Statistical       │
                │ Alt-data Factors  │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │  Alpha Research   │
                │───────────────────│
                │ IC Test           │
                │ Feature Selection │
                │ Signal Modeling   │
                │ Ensemble Models   │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │   Backtesting     │
                │───────────────────│
                │ Transaction Cost  │
                │ Slippage Model    │
                │ Walk-forward      │
                │ Stress Test       │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │ Portfolio Engine  │
                │───────────────────│
                │ Position Sizing   │
                │ Risk Model        │
                │ Portfolio Opt     │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │ Execution Engine  │
                │───────────────────│
                │ Smart Order       │
                │ TWAP/VWAP         │
                │ Liquidity Model   │
                └─────────┬─────────┘
                          │
                          ▼
                ┌───────────────────┐
                │ Monitoring System │
                │───────────────────│
                │ PnL Attribution   │
                │ Risk Monitoring   │
                │ Model Drift       │
                └───────────────────┘
```

Despite its systematic structure, the alpha discovery process remains largely human-driven. Researchers must manually design candidate factors, select modeling approaches, interpret backtest results, and iteratively refine strategies. As the potential search space of data sources, feature transformations, and model architectures grows exponentially, human-driven exploration becomes increasingly inefficient. This limitation constrains both the scale and speed of signal discovery. Researchers can explore only a small fraction of the possible hypothesis space, and each research cycle—from factor construction to backtesting—may require substantial manual experimentation. In addition, human-driven workflows are susceptible to cognitive biases and methodological inertia, which may limit the diversity of explored strategies. As markets evolve and existing signals decay, the need for continuous strategy discovery further amplifies the burden on research teams.

We propose an AI-native autonomous alpha factory that reconstructs the traditional quantitative research pipeline as a network of interacting AI agents. Rather than treating tools as external components for human researchers, each research module is implemented as an agent-native service with its own skills, reasoning logic, and MCP-exposed interfaces. In this architecture, agents for data processing, feature construction, model training, factor evaluation, and backtesting collaborate through structured inter-agent calls.

A feedback-driven critic loop continuously analyzes intermediate results and guides subsequent reasoning, enabling the system to iteratively refine hypotheses and trading strategies. By preserving the functional structure of existing alpha factories while replacing human coordination with AI-native orchestration, the framework removes human researchers as the primary bottleneck in large-scale alpha discovery.


```graph
                     ┌─────────────────────────────────┐
                     │           Data Sources           │
                     │─────────────────────────────────│
                     │ Market Data                     │
                     │ On-chain Data                   │
                     │ Alternative Data                │
                     └───────────────┬─────────────────┘
                                     │
                                     ▼

        ┌──────────────────────────────────────────────────────────┐
        │               Functional Research Agents                  │
        │            (each agent exposed as MCP service)           │
        │                                                          │
        │  ┌──────────────┐   ┌──────────────┐   ┌──────────────┐  │
        │  │ Data Agent   │◄─►│ Feature Agent│◄─►│ Model Agent  │  │
        │  │              │   │              │   │              │  │
        │  │ Data prep    │   │ Factor gen   │   │ Model train  │  │
        │  │ Dataset build│   │ Feature eng  │   │ Hyper search │  │
        │  └───────┬──────┘   └───────┬──────┘   └───────┬──────┘  │
        │          │                  │                  │         │
        │          ▼                  ▼                  ▼         │
        │     ┌───────────────────────────────────────────────┐   │
        │     │           Evaluation / Backtesting Agent      │   │
        │     │───────────────────────────────────────────────│   │
        │     │ Factor diagnostics (IC, RankIC)               │   │
        │     │ Strategy simulation                           │   │
        │     │ Portfolio & risk evaluation                   │   │
        │     │ Performance metrics                           │   │
        │     └───────────────────────┬───────────────────────┘   │
        │                             │                           │
        └─────────────────────────────┼───────────────────────────┘
                                      │
                                      ▼

         ┌────────────────────────────────────────────────────┐
         │                 Control Agents                     │
         │                                                    │
         │  ┌────────────────────┐    ┌────────────────────┐ │
         │  │ Planner Agent      │    │ Critic Agent       │ │
         │  │                    │    │                    │ │
         │  │ Task orchestration │    │ Result analysis    │ │
         │  │ Agent coordination │    │ Failure diagnosis  │ │
         │  │ Exploration policy │    │ Feedback signals   │ │
         │  └─────────┬──────────┘    └─────────┬──────────┘ │
         │            │                         │            │
         └────────────┼─────────────────────────┼────────────┘
                      │                         │
                      ▼                         ▼

           ┌───────────────────────────────────────────────┐
           │          Continuous Research Loop             │
           │                                               │
           │   Hypothesis Generation → Strategy Testing   │
           │          → Feedback → Reasoning Update       │
           │                → Next Iteration              │
           └───────────────────────────────────────────────┘
```



## 2. Search Space

We formulate the whole automation system as a search problem over a large combinational strategy space. A trading signal can be represented as

$$
\alpha = f(D, F, M, S, E)
$$

where:

- **D**: data sources (market data, on-chain signals, alternative datasets)  
- **F**: feature or factor transformations derived from raw data  
- **M**: predictive models that map features to expected returns  
- **S**: strategy construction rules such as signal aggregation and position sizing  
- **E**: execution assumptions including transaction costs, slippage, and market impact  

Under this formulation, the strategy search space can be defined as

$$
\mathcal{A} = \{ f(D, F, M, S, E) \}
$$

The objective of alpha discovery is to find the optimal strategy

$$
\alpha^* = \arg\max_{\alpha \in \mathcal{A}} \; \text{Performance}(\alpha)
$$

where $\text{Performance}(\alpha)$ represents a performance metric such as Sharpe ratio, risk-adjusted return, or cumulative profit.


Traditional quantitative research explores this space through human-driven experimentation. Rather than treating quantitative modeling as a fixed pipeline, we frame alpha discovery as a large-scale search problem over strategy space, where generative AI agents iteratively explore and refine candidate trading systems.

## 3. Factor Discovery

In quantitative finance, AI has already been widely applied to factor discovery. Techniques such as genetic programming, symbolic regression, and deep learning models have been used to automatically generate large numbers of candidate factors. These methods significantly expand the search space of potential signals and allow researchers to explore complex nonlinear relationships in financial data. However, a key limitation of traditional approaches is that **the search process lacks directional guidance**. While AI can generate a vast number of candidate factors, it typically lacks the contextual understanding of the market environment and data characteristics required to steer the search toward promising regions. As a result, the discovery process often relies on human researchers to continuously adjust the search direction, refine evaluation metrics, and interpret intermediate results.

Our approach focuses on replacing this **human guidance layer**. Instead of relying on researchers to steer the factor search process, AI agents analyze the data, propose directions for factor exploration, and design evaluation criteria. Through iterative feedback and reasoning, the system continuously adjusts its search strategy and corrects its exploration trajectory.

The system evaluates candidate factors in two stages. In the first stage, the factor discovery agent performs **lightweight screening** based on internally defined evaluation metrics. These metrics may include predictive correlation, statistical stability, and redundancy with existing factors. The purpose of this stage is to rapidly filter out weak or redundant signals while allowing promising candidates to proceed to deeper evaluation.

In the second stage, the surviving factors are passed to the **modeling module** for full integration testing. Here, the factors are evaluated within the context of the predictive model and the trading strategy. This stage measures the factor's **marginal contribution** to overall strategy performance under the Sharpe-oriented evaluation framework described earlier.



## 4. Modeling

A key design principle of our system is to fix a stable, controllable, and reproducible modeling backbone while delegating experimental exploration to AI agents. Instead of allowing unrestricted model invention, the modeling layer is grounded in a quantile regression framework implemented with XGBoost. Key modeling operations—including hyperparameter search, factor subset selection, and feature fusion experiments—are exposed through MCP-compatible interfaces. These interfaces allow AI agents to programmatically invoke modeling capabilities and design experiments through structured reasoning and natural-language-driven instructions. 

In our work, AI does not replace the modeling foundation itself, but instead autonomously explores the experimental space built on top of it. When a new factor is introduced, the system does not evaluate it in isolation. Instead, the factor is tested in combination with the existing factor set, measuring its marginal contribution under the current modeling framework. The modeling agent launches a series of experiments involving different hyperparameter settings and factor subsets, and evaluates the resulting strategies through backtesting metrics.

Based on the experimental results, the system adaptively refines model configurations and determines whether the new factor improves the overall strategy. The module then produces structured feedback indicating whether the factor should be accepted, rejected, or further refined. 

The major objective of the modeling module is to maximize **risk-adjusted trading performance**:

$$
(\theta^*, F^*) =
\arg\max_{\theta,\, F' \subseteq \mathcal{F}}
\text{Sharpe}(\text{Model}(F'; \theta))
$$

where

- $\theta$ denotes model hyperparameters  
- $F'$ represents a subset of candidate factors  
- $\mathcal{F}$ is the current factor pool  
- $\text{Sharpe}(\cdot)$ measures risk-adjusted strategy performance.


When a new candidate factor $f_{\text{new}}$ is proposed, its usefulness is determined by evaluating its marginal improvement to the current factor set:

$$
\Delta_{\text{new}} =
\text{Sharpe}(F_{\text{base}} \cup \{f_{\text{new}}\}; \theta^*)
-
\text{Sharpe}(F_{\text{base}}; \theta_0)
$$

where $F_{\text{base}}$ denotes the existing factor set and $\theta_0$ represents the baseline model configuration. A factor is considered beneficial if it produces a positive and stable improvement in Sharpe ratio under the current modeling framework. 

Real-world trading strategies must balance multiple considerations, including profitability, drawdown stability, turnover, and robustness across market regimes. Traditional modeling pipelines typically address this challenge through manually designed multi-objective optimization schemes or rigid scoring functions. However, these approaches often struggle to capture the nuanced trade-offs required for long-term strategy evolution.

In contrast, our system treats Sharpe ratio as the **primary anchor metric**, while allowing AI agents to reason over a broader set of diagnostic signals produced during modeling and backtesting. These signals include metrics such as cumulative return, drawdown characteristics, turnover, prediction stability, and factor redundancy. Rather than optimizing a fixed scalar objective, the AI agent performs **reasoning-driven evaluation**, synthesizing these metrics to produce a holistic assessment of candidate strategies. This allows the system to recommend modeling adjustments and factor selections that better align with the long-term evolutionary direction of the strategy quanlity, rather than optimizing a single short-term performance indicator.

```graph
                         Strategy Quality
                               ▲
                               │
                               │
                Stability ◄────┼─────► Return
                               │
                               │
                Factor         ●         Drawdown
               Diversity     Sharpe
                               │
                               │
                        Turnover Cost


                   AI Reasoning-Based Evaluation

```




## 5. MCP Interface Example

Let's use a simple example to explain how MCP interfaces work here with agent. Here we use pseudocode to demo the idea. To enable AI agents to autonomously conduct modeling experiments, the capabilities of the modeling module are exposed through MCP-compatible interfaces. Each interface represents a callable research skill that can be invoked programmatically by AI agents during the research process.

The following example illustrates a simplified MCP interface for training the quantile model.

```json
{
  "tool": "train_quantile_model",
  "description": "Train XGBoost quantile regression model for factor evaluation",
  "parameters": {
    "factors": {
      "type": "array",
      "description": "List of factors used as model features"
    },
    "hyperparameters": {
      "type": "object",
      "description": "XGBoost model hyperparameters"
    },
    "train_range": {
      "type": "string",
      "description": "Training time range"
    }
  }
}
```

Using this interface, an AI agent can launch modeling experiments through structured tool invocation. 
```
AI Reasoning
      │
      ▼
  MCP Calls
      │
      ▼
Research Skills
(train / backtest / evaluate)
```

For example, the agent may decide to test the factor in combination with existing signals.
```
train_quantile_model(
  factors = ["momentum_5d", "funding_rate", "new_factor"],
  hyperparameters = {
    "max_depth": 6,
    "eta": 0.05,
    "subsample": 0.8
  },
  train_range = "2022-01-01 to 2023-12-31"
)
```

The modeling system then trains the model and evaluates the resulting trading strategy through backtesting. The result is returned to the AI agent as a structured response containing key evaluation metrics.

```
{
  "sharpe": 1.42,
  "return": 0.23,
  "max_drawdown": 0.11,
  "turnover": 0.34
}
```
These metrics are subsequently analyzed by the AI agent within the Sharpe-anchored multi-metric evaluation framework, allowing the agent to reason about the usefulness of the factor and propose further experiments.


## 6. Feedback-Driven Loop

A key feature of our system is the **bidirectional feedback loop** between factor discovery and modeling. While the factor discovery module proposes new candidate factors and performs preliminary screening, the modeling module provides deeper evaluation results based on full model training and backtesting. The feedback produced by the modeling stage—including improvements or degradations in Sharpe ratio and other metrics—is fed back into the factor discovery agent.

This feedback allows the system to iteratively refine its search strategy. Factors that consistently improve model performance guide the generation of new related candidates, while unsuccessful directions are gradually abandoned. Through repeated cycles of proposal, evaluation, and feedback, the system progressively evolves the factor space toward more robust signals.

In this architecture, factor discovery is no longer a static search process but becomes a self-correcting exploration system, where AI agents continuously adapt their search direction based on observed strategy outcomes. This is why we say, given enough computing power, even each step is minor, it will eventually beats the best trader. 




## 6. Human Participation

While AI systems are capable of large-scale search and experimentation, human intuition and domain knowledge can still help accelerate convergence toward promising research directions and avoid unproductive regions of the search space.

Our system shifts the role of humans from primary decision-makers to cognitive advisors. To enable lightweight human participation, we integrate a communication way based on OpenClaw and Discord. Inside the Discord channels, developers and researchers can discuss observations, propose ideas, or analyze experimental outcomes. The OpenClaw bot monitors these discussions, summarizes key insights, and converts them into structured feedback that can be consumed by the AI system.


Importantly, the system does not depend on human input to function. However, when available, human cognition and imagination can help guide exploration and accelerate the discovery process. Over time, as AI agents become increasingly capable of interpreting data and generating hypotheses independently, the role of human participation may gradually diminish.



## 8. Conclusion

A central idea of our approach is to transform the factor discovery and modeling process into a self-iterative AI system. 

By redesigning the research pipeline as an AI-native system capable of autonomous iteration, the problem becomes computationally scalable. Under this formulation, quant trading is no longer constrained by human research capacity. Instead, it becomes a compute-driven optimization problem, where improved solutions can be obtained by increasing computational resources and expanding the search process. In this paradigm, computational scalability replaces human effort as the primary limiting factor.

Evolution is nature’s greatest art. In the age of AI, the role of us shifts from designing strategies to building systems that create them.