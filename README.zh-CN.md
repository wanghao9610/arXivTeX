# arXiv TeX Template

[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf&logoColor=white)](https://www.overleaf.com/docs?snip_uri=https%3A%2F%2Fgithub.com%2Fwanghao9610%2FarXivTeX%2Farchive%2Frefs%2Fheads%2Foverleaf.zip)

**Language:** [English](README.md) | 简体中文

一个简洁的 arXiv 风格 LaTeX 论文模板。项目采用模块化组织方式:
`main/main.tex` 是入口文件,而各个章节、图片、表格、算法、附录内容以及参考文献数据
都分别存放在 `main/` 下各自的文件中。

<a id="contents"></a>

## 目录

- [主要特性](#features)
- [环境要求](#requirements)
- [项目结构](#project-organization)
- [论文样式](#paper-styles)
- [可选主题](#selectable-themes)
- [快速开始](#quick-start)
- [arXiv 预印本](#arxiv-pre-print)
- [会议/期刊模板](#venue-template)
- [类文件 API](#class-api)
- [最小示例](#minimal-example)
- [添加内容](#adding-content)
- [许可证](#license)

<a id="features"></a>

## 主要特性

- **基于 Article 类**:支持单栏与双栏排版。
- **标题面板**:标题、作者、单位、摘要、关键词,以及代码/项目/数据集链接
  集中展示在同一区块中。
- **可选主题**:提供绿色、蓝色、黑色三种配色方案。
- **论文常用宏**:`\parahead`、`\headbf`、`\tablestyle`、`\cmark`、
  `\xmark`、紧凑型表格列类型、`cleveref` 以及 `natbib`。
- **无外部字体依赖**:仅使用标准 TeX Live 字体,保证 GitHub 与 arXiv
  提交的可移植性。
- **一键转换**:使用 `make-arxiv` 技能生成 [arXiv 预印本](#arxiv-pre-print);
  使用 `convert-template` 技能转换为 [会议/期刊模板](#venue-template)。

<a id="requirements"></a>

## 环境要求

- 一套 TeX Live 发行版(建议 2022 及以上版本),并确保 `latexmk` 在
  `PATH` 中。该类文件加载了 `fontawesome5`、`nicematrix`、`siunitx`、
  `tcolorbox` 等常用宏包,因此建议安装完整版(`scheme-full`)以避免
  缺少宏包的报错。
- `make arxiv` 需要 `latexpand` 和 `perl`(大多数 TeX Live 安装都自带)。
- 参考文献由 `latexmk` 使用 `unsrtnat` 样式从 `main/main.bib` 自动编译
  生成,无需单独配置 BibTeX。

<a id="project-organization"></a>

## 项目结构

该目录结构参照了大型论文仓库的组织方式,同时保持了作为起始模板应有的精简:

```text
.
+-- main/                 # 本地构建所用的论文源码树
|   +-- main.tex          # 入口文件:元信息、全局宏、引入顺序
|   +-- main.cls          # 可复用的 arXiv 风格类文件
|   +-- main.bib          # BibTeX 条目
|   +-- appx.tex          # 可选的附录入口
|   +-- secs/             # 正文章节片段
|   |   +-- 00_abstract.tex
|   |   +-- 01_introduction.tex
|   |   +-- 02_related.tex
|   |   +-- 03_method.tex
|   |   +-- 04_experiments.tex
|   |   +-- 09_conclusion.tex
|   |   +-- 10_results.tex
|   |   +-- 11_reproducibility.tex
|   |   +-- 12_impact.tex
|   +-- figs/             # 图片环境包装文件
|   |   +-- 00_teaser.tex
|   |   +-- 10_figure.tex
|   |   +-- srcs/         # 原始 PDF/PNG/JPG 素材
|   +-- tabs/             # 表格环境包装文件
|   |   +-- 00_example.tex
|   |   +-- 10_extra.tex
|   +-- algs/             # 算法环境包装文件
|       +-- 00_example.tex
|       +-- 10_procedure.tex
+-- arXiv/                # 生成的扁平化投稿包
+-- submit/               # 生成的会议/期刊投稿副本
+-- templates/            # 解压后的会议/期刊模板文件
+-- .temp/                # 生成的构建产物
+-- .vscode/settings.json # 可选的 LaTeX Workshop 设置
+-- Makefile              # 构建命令
```

以下约定用于保持项目结构在论文不断增长时依然清晰一致。

### 文件命名

`main/secs/`、`main/figs/`、`main/tabs/`、`main/algs/`(以及
`main/figs/srcs/` 下的原始素材)中的所有模块化文件,都在描述性名称前使用
两位数字前缀:

| 位数 | 含义 |
| --- | --- |
| 第一位(`0`、`1`、……) | 论文部分:`0` = 正文,`1` = 附录 |
| 第二位(`0`、`1`、……) | 在该部分内的顺序 |

示例:

| 目录 | 正文 | 附录 |
| --- | --- | --- |
| `main/secs/` | `00_abstract.tex`、`01_introduction.tex` | `10_results.tex` |
| `main/figs/` | `00_teaser.tex`、`01_framework.tex` | `10_figure.tex` |
| `main/figs/srcs/` | `00_teaser.pdf`、`01_framework.pdf` | `10_figure.pdf` |
| `main/tabs/` | `00_main_results.tex` | `10_extra.tex` |
| `main/algs/` | `00_training.tex` | `10_pseudocode.tex` |

保持包装文件与素材文件的基础名称一致(例如,`main/figs/00_teaser.tex`
指向 `main/figs/srcs/00_teaser.pdf`)。

### 目录布局

- 将章节片段放在 `main/secs/` 中,并从 `main/main.tex` 引入。
- 将图片环境放在 `main/figs/` 中,原始素材放在 `main/figs/srcs/` 中。
- 将较长的表格代码放在 `main/tabs/` 中,并使用 `\input{tabs/...}` 引入。
- 将算法环境放在 `main/algs/` 中。
- 将项目专属的宏保留在 `main/main.tex` 中;将可复用的排版逻辑保留在
  `main/main.cls` 中。

### 目录说明

- `main/secs/`:存放章节片段,并从 `main/main.tex` 中使用
  `\input{secs/...}` 引入。例如 `00_abstract.tex`、
  `01_introduction.tex` 和 `10_results.tex`。
- `main/figs/`:存放可复用的 `\begin{figure}...\end{figure}` 代码块,
  并从章节文件中使用 `\input{figs/...}` 引入。例如 `00_teaser.tex`、
  `01_framework.tex` 和 `10_figure.tex`。
- `main/figs/srcs/`:存放原始图片文件,如 PDF、PNG 或 JPG 素材。在图片
  包装文件中通过 `figs/srcs/00_teaser.pdf` 之类的路径引用,建议与对应
  包装文件使用相同的基础名称。
- `main/tabs/`:存放可复用的 `\begin{table}...\end{table}` 代码块,并从
  章节文件中使用 `\input{tabs/...}` 引入。例如 `00_main_results.tex` 和
  `10_extra_results.tex`。
- `main/algs/`:存放可复用的 `\begin{algorithm}...\end{algorithm}` 代码
  块,并从章节文件中使用 `\input{algs/...}` 引入。例如
  `00_training.tex` 和 `10_pseudocode.tex`。

`main/secs/`、`main/figs/`、`main/figs/srcs/`、`main/tabs/` 和
`main/algs/` 都遵循相同的两位数字前缀方案。

<a id="paper-styles"></a>

## 论文样式

通过 `\paperstyle{...}` 选择标题面板样式,并结合 `\papercolor{...}`
选择配色。下面展示示例论文首页在当前所有样式与配色组合下的效果。

| 样式 | `green` | `blue` | `black` |
| --- | --- | --- | --- |
| `fancy` | ![fancy green](docs/imgs/fancy-green.png) | ![fancy blue](docs/imgs/fancy-blue.png) | ![fancy black](docs/imgs/fancy-black.png) |
| `simple` | ![simple green](docs/imgs/simple-green.png) | ![simple blue](docs/imgs/simple-blue.png) | ![simple black](docs/imgs/simple-black.png) |

<a id="selectable-themes"></a>

## 可选主题

通过 `\paperstyle{...}` 设置为 `fancy` 或 `simple`, 通过
`\papercolor{...}` 设置为 `green`、`blue` 或 `black`。旧的
`\papertheme{...}` 仍作为 `\papercolor{...}` 的别名保留。

<a id="quick-start"></a>

## 快速开始

编译示例论文:

```bash
make
```

默认构建目标会将生成的文件写入 `.temp/`,包括 `.temp/main.pdf`。可通过
覆盖 `MAIN_DIR`、`MAIN` 或 `OUT_DIR` 来指定不同的源码目录、入口文件或
输出目录,例如 `OUT_DIR=build make`。

也可以直接运行 LaTeX:

```bash
cd main && latexmk -pdf -outdir=../.temp main.tex
```

生成扁平化的 arXiv 投稿包:

```bash
make arxiv
```

该命令会将扁平化后的入口文件直接写入 `arXiv/main.tex`。

<a id="arxiv-pre-print"></a>

## arXiv 预印本

编辑完成后运行 `make arxiv`,即可生成扁平化、可直接投稿的论文副本。
`make-arxiv` 技能(同时为 Claude Code、Codex、Cursor 及其他智能体提供,
分别位于 `.claude/skills/make-arxiv/`、`.codex/skills/make-arxiv/`、
`.cursor/skills/make-arxiv/` 和 `.agents/skills/make-arxiv/`)对该流程做了
自动化封装,包含前置条件检查以及独立编译验证:

1. 按常规方式编辑 `main/` 下的论文,然后让你的智能体打包论文,例如:
   > 将这篇论文打包为 arXiv 投稿。

   或者

   > 运行 make arxiv 并确认输出能够编译通过。
2. 智能体会确认 `latexpand` 和 `perl` 已在 `PATH` 中,运行
   `make arxiv`,并核对生成的 `arXiv/MANIFEST.txt` 与实际输出是否一致。
3. 接着它会在 `arXiv/` 目录内(而非 `main/`)独立编译 `arXiv/main.tex`,
   确认扁平化后的副本不依赖 `arXiv/` 之外的任何文件,然后反馈结果——
   通过、失败(附带错误信息),或者在当前环境没有 TeX 工具链时提示
   "未验证"。
4. 根据反馈修复 `main/` 下的问题——切勿直接修改 `arXiv/`,因为它每次都
   会被完全重新生成——然后让智能体重新运行。
5. 提交 `arXiv/` 的全部内容;入口文件为 `arXiv/main.tex`。

你也可以不借助智能体,自己直接运行 `make arxiv`:

- 该命令会在 `main/` 中执行 `latexpand main.tex > ../arXiv/main.tex`,
  然后将本地类文件、参考文献和图片素材一并填充到 `arXiv/` 中。投稿时
  提交 `arXiv/` 的全部内容——入口文件为 `arXiv/main.tex`。
- 它会复制 `main/*.cls`、`main/*.sty`、`main/*.bst`、`main/*.bib`、
  `main/*.bbx` 和 `main/*.cbx` 文件,将 `main/figs/srcs/` 中的源码树
  素材复制到 `arXiv/srcs/` 并相应地重写扁平化后 `arXiv/main.tex` 中的
  路径;当存在 `main/srcs/` 时也会一并复制,以支持更扁平的源码树结构。

需要注意以下几点:

- 将项目专属的宏保留在 `main/main.tex` 中,而不是 `main/main.cls` 中。
- 优先使用 PDF、PNG 或 JPG 格式的图片,避免使用绝对路径。
- 不要提交 `.temp/`、编辑器设置、SyncTeX 文件、日志或本地预览 PDF。
- 如果 arXiv 报告缺少某个宏包,请在投稿前将该功能从类文件移到论文源码
  中,或直接移除该功能。

进阶用法——覆盖入口文件或输出目录:

```bash
MAIN=submission.tex ARXIV_DIR=arXiv-submission make arxiv
```

<a id="venue-template"></a>

## 会议/期刊模板

`convert-template` 技能(同时为 Claude Code 和 Codex 提供,分别位于
`.claude/skills/convert-template/` 和 `.codex/skills/convert-template/`)
可以将本论文转换为官方提供的会议/期刊 LaTeX 模板的投稿副本——例如
CVPR、ICCV 或 NeurIPS。

1. 获取目标会议的官方作者工具包(包含其 `.cls`/`.sty`/`.bst` 文件及
   示例 `.tex` 文件的压缩包),并准备好本地文件。该技能本身不会获取或
   猜测会议模板——始终需要你提供官方压缩包。
2. 让你的智能体(在 Claude Code 或 Codex 中)转换论文,提供压缩包路径
   以及所需的模式,例如:
   > 将本论文转换为 `~/Downloads/cvpr2025.zip` 中的 CVPR 模板,
   > 使用匿名评审模式。

   或者

   > 现在为同一个 CVPR 模板生成正式发表(camera-ready)版本。
3. 智能体会将工具包解压到 `templates/<venue>/`,然后在
   `submit/<venue>/` 下生成一份独立、可编译的副本——其中包含一个
   `compat.sty` 兼容层,使本模板的辅助命令(`\parahead`、`\figref`、
   `\tablestyle`、紧凑型列类型等)在会议自身的类文件下继续可用,并生成
   一个使用会议原生标题/作者宏、内容来自本论文元信息的新 `main.tex`。
4. 盲审草稿选择 `anonymous`(匿名)模式(作者姓名、单位以及
   代码/项目/数据集链接会被隐去);最终投稿选择 `camera-ready`
   (正式发表)模式,包含完整的作者元信息。

整个过程中 `main/` 和 `main/main.bib` 都不会被修改,其复制进来的官方
会议文件同样不会被修改。`templates/` 和 `submit/` 已加入 `.gitignore`,
因为会议工具包通常受版权保护,且 `submit/<venue>/` 每次都会从 `main/`
完全重新生成——在 `main/` 下修改论文后,重新运行该技能即可刷新投稿副本。

<a id="class-api"></a>

## 类文件 API

在 `\begin{document}` 之前使用以下命令:

| 命令 | 作用 |
| --- | --- |
| `\paperstyle{fancy}` | 选择标题样式。可选值:`fancy`、`simple`。 |
| `\papercolor{green}` | 选择颜色。可选值:`green`、`blue`、`black`。 |
| `\papertheme{green}` | 旧接口, 等价于 `\papercolor{green}`。 |
| `\title{...}` | 标题面板中显示的论文标题。 |
| `\author[1,2]{Name}` | 添加作者,可选带单位编号标记。 |
| `\affiliation[1]{Institution}` | 添加所属单位。 |
| `\contribution[\dagger]{Text}` | 添加贡献说明或共同贡献说明。 |
| `\abstract{...}` | 在标题面板中添加摘要。 |
| `\keywords{...}` | 在摘要下方添加关键词。 |
| `\code{URL}` | 添加代码链接。 |
| `\project{URL}` | 添加项目主页链接。 |
| `\dataset{URL}` | 添加数据集链接。 |
| `\demo{URL}` | 添加演示链接。 |
| `\correspondence{...}` | 添加联系方式。 |
| `\metadata[Label:]{Value}` | 添加自定义元信息行。 |

在正文中使用以下命令:

| 命令 | 作用 |
| --- | --- |
| `\parahead{Title}` | 行内主题色无衬线加粗段首标题,后接一个句号和空格。 |
| `\headbf{Text}` | 主题色无衬线加粗文本,不自动添加标点或间距。 |
| `\figref{fig:label}` | 图片引用,格式为 `Figure 1`。 |
| `\tabref{tab:label}` | 表格引用,格式为 `Table 1`。 |
| `\algref{alg:label}` | 算法引用,格式为 `Algorithm 1`。 |
| `\eqnref{eq:label}` | 公式引用,格式为 `Equation (1)`。 |
| `\tablestyle{4pt}{1.1}` | 设置表格列间距与行距。 |
| `\cmark`、`\xmark` | 用于对比表格的对勾与叉号符号。 |
| `x`、`y`、`z`、`P`、`Y` 列类型 | 紧凑型表格列辅助类型。 |

<a id="minimal-example"></a>

## 最小示例

```tex
\documentclass[twocolumn]{main}

\papertheme{green}

\title{Your Paper Title}
\author[1]{First Author}
\author[1,2]{Second Author}
\affiliation[1]{Example University}
\affiliation[2]{Example Research Lab}

\abstract{Write a concise summary of the paper.}
\keywords{keyword one, keyword two}
\date{\today}
\code{https://github.com/your-name/your-project}
\project{https://your-name.github.io/your-project}
\correspondence{\email{name@example.com}}

\input{secs/00_abstract.tex}

\begin{document}
\maketitle

\section{Introduction}
Your paper starts here.
\input{figs/00_teaser.tex}

\bibliographystyle{unsrtnat}
\bibliography{main}
\end{document}
```

<a id="adding-content"></a>

## 添加内容

添加新章节:

```tex
% main/main.tex
\input{secs/04_more_experiments.tex}
```

添加新图片:

```tex
% main/figs/01_framework.tex
\begin{figure}[t]
  \centering
  \includegraphics[width=\linewidth]{figs/srcs/01_framework.pdf}
  \caption{Overview of the proposed framework.}
  \label{fig:framework}
\end{figure}
```

添加新表格:

```tex
% main/tabs/01_main_results.tex
\begin{table}[t]
  \tablestyle{4pt}{1.1}
  \caption{Main results.}
  \label{tab:main_results}
  \begin{tabular}{lcc}
    \toprule
    Method & Score & Speed \\
    \midrule
    Baseline & 82.1 & 1.0x \\
    Ours & 85.4 & 1.1x \\
    \bottomrule
  \end{tabular}
\end{table}
```

示例论文通过 `main/main.tex` 末尾附近的这一行引入附录:

```tex
\input{appx.tex}
```

附录入口文件是 `main/appx.tex`。它先开始附录,然后引入附录专属的模块:

```tex
\clearpage
\beginappendix

\input{secs/10_results.tex}
\input{secs/11_reproducibility.tex}
\input{secs/12_impact.tex}
```

`main/secs/12_impact.tex` 是一个起始的"广泛影响与算力资源"章节——部分
会议(例如 NeurIPS)要求报告社会影响和产出结果所用的硬件预算。如果目标
会议不要求该内容,删除对应的 `\input` 行即可。

附录专属的图片、表格和算法应使用相同的前缀区间:

- `main/figs/10_figure.tex`
- `main/tabs/10_extra.tex`
- `main/algs/10_procedure.tex`

若仅撰写正文而不需要附录,可注释掉这一行;若希望示例 PDF 包含附录页面,
则保持启用状态。

<a id="license"></a>

## 许可证

本模板基于 MIT 许可证发布。
