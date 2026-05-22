# Digital Circuit Getting Started

本科生数字电路教学仓库（章节化、模板化、可发布静态站）。

## 快速接手（必看）

1. 先读 [AGENTS.md](/root/digital-getting-started/AGENTS.md)
2. 再跑：

```bash
make check-style
make all
make site
```

3. 本地预览静态站：

```bash
cd site
python -m http.server 8000
```

## 项目目标

- 统一 PPT 与讲义格式（避免风格漂移）
- 按章节/讲次组织教学内容（便于扩展）
- 自动生成 PDF 与静态网页（便于发布）

## 目录说明

- `AGENTS.md`：项目级操作入口规范（下次直接照做）
- `OUTLINE.md`：课程大纲
- `STYLE_GUIDE.md`：PPT 与讲义格式规范
- `chapters/`：课程正文（唯一主要编辑区）
- `styles/`：全局样式文件（beamer + handout）
- `templates/`：新讲次模板
- `scripts/`：脚手架、检查与站点生成脚本
- `pdf/`：汇总 PDF 产物（生成）
- `site/`：静态站产物（生成）
- `docs/`：运行手册、部署文档、改造报告

## 标准工作流

### 新增讲次

```bash
./scripts/new_lecture.sh ch03-digital-fundamentals l02-fsm-basic
```

补齐该讲的：
- `slides.tex`
- `handout.tex`
- `metadata.json`
- `figures/*`

然后执行：

```bash
make check-style
make all
make site
```

### 修改既有讲次

只改对应讲目录，再执行：

```bash
make all
make site
```

## 文档导航

- [AGENTS.md](/root/digital-getting-started/AGENTS.md)：接手入口与硬约束
- [STYLE_GUIDE.md](/root/digital-getting-started/STYLE_GUIDE.md)：格式与质量规范
- [OPS_RUNBOOK.md](/root/digital-getting-started/docs/OPS_RUNBOOK.md)：详细操作手册
- [STATIC_SITE_DEPLOY.md](/root/digital-getting-started/docs/STATIC_SITE_DEPLOY.md)：静态站部署
- [IMPLEMENTATION_REPORT.md](/root/digital-getting-started/docs/IMPLEMENTATION_REPORT.md)：改造说明
