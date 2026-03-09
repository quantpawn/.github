# QuantPawn - A self-iteration trading system
> Even starting with the equivalent of an 8-year-old's intelligence, given sufficient compute resources for iteration, generative AI can eventually beat the best human traders.

@codingtmd

## Abstract

In the past, quantitative trading heavily relied on experts or statistical mathematicians to analyze the market, discover trading strategies, and apply them for profit. An effective strategy could take years from discovery to practical deployment. And every iteration is heavily depending in smart individual and the understading of the market.

We believe that the advancement of AI, especially the new generation of intelligence represented by Generative AI, fundamentally changes this structure. The inherent reasoning capabilities empower AI with the potential for self-reflection and self-iteration. This article is to present a ai-native structure of quant tradiing system, which is simple, self-iterationable, and with good-enough extension for future AI direction.



## Introduction

Modern quantitative trading firms have developed highly structured research pipelines for discovering predictive signals in financial markets. Institutions such as Two Sigma, Citadel, and DE Shaw operate large-scale infrastructures often referred to as alpha factories, where trading signals (alphas) are systematically generated, evaluated, and deployed through a standardized research workflow.

In a typical alpha factory, large volumes of market and alternative data are first collected and processed through data engineering pipelines. Researchers then construct candidate factors—statistical or domain-specific transformations of raw data—which are evaluated using predictive metrics such as information coefficients and return stratification. Promising factors are combined using statistical or machine learning models, including tree-based methods such as XGBoost and LightGBM, or even advanced algroithms like Neural network, Transformer, etc. Candidate strategies are further validated through backtesting frameworks that simulate realistic trading conditions, after which signals are aggregated through portfolio optimization and executed in live markets. Rather than relying on a single strong model, these systems typically combine large numbers of weak but statistically significant signals to produce stable returns.


```
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


```
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


We train an XGBoost model.

$$
y = f(x)
$$

