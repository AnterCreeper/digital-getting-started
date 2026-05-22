# AGENTS.md - Digital Circuit Getting Started

本文件是本项目的**唯一操作入口规范**。下次接手时请先读它，再动文件。

## 1. 项目目标

- 维护一套本科生数字电路课程仓库
- 每讲必须同时交付：PPT（Beamer）+ 讲义（article）
- 最终产出可部署静态站点（GitHub Pages）

## 2. 非协商约束（必须遵守）

1. 不要手改 `pdf/` 与 `site/` 下的生成产物内容  
这些目录只允许通过命令生成覆盖。

2. 不要破坏章节化结构  
讲次必须放在：`chapters/<chapter-slug>/<lecture-slug>/`

3. 每讲必须有 `metadata.json`  
`scripts/check_style.sh` 会检查，不满足视为不合格。

4. 风格统一优先  
不要在单讲里私自改主题、字体体系、全局色板；统一改在 `styles/`。

5. 每次改动后必须验证  
至少执行：
- `make check-style`
- `make all`
- `make site`

## 3. 接手第一分钟流程

在仓库根目录执行：

```bash
pwd
find chapters -mindepth 2 -maxdepth 2 -type d | sort
make check-style
```

如果 `check-style` 失败，先修结构问题再做内容编辑。

## 4. 常见任务标准流程

### A. 新增一讲

```bash
./scripts/new_lecture.sh ch03-digital-fundamentals l02-fsm-basic
```

然后填写：
- `slides.tex`
- `handout.tex`
- `metadata.json`
- `figures/` 内图

最后执行：

```bash
make check-style
make all
make site
```

### B. 仅修改某一讲内容

1. 只改对应讲次目录文件  
2. 不改其他讲目录命名  
3. 执行 `make all && make site`

### C. 修改全局样式

只改：
- `styles/beamer-style.tex`
- `styles/handout-style.tex`

然后抽样检查至少 1 讲 PDF 与站点渲染。

## 5. 产物说明

- `pdf/`：讲次级 PDF 汇总（用于下载分发）
- `site/`：静态站点可部署目录
- `site/assets/lectures/*`：每讲 slides/handout/source zip

## 6. Definition of Done（完成定义）

一次改动仅在以下条件全满足时算完成：

1. `make check-style` 通过
2. `make all` 通过
3. `make site` 通过
4. 相关 `pdf/` 输出存在
5. `site/index.html` 可本地打开并看到新增/更新讲次

## 7. 相关文档导航

- `README.md`：总览
- `STYLE_GUIDE.md`：格式规范
- `docs/OPS_RUNBOOK.md`：详细操作手册
- `docs/STATIC_SITE_DEPLOY.md`：部署流程
- `docs/IMPLEMENTATION_REPORT.md`：改造说明
