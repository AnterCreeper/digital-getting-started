# Operations Runbook

本手册用于“下次直接上手”，避免重复摸索与误操作。

## 1. 日常命令

```bash
make check-style   # 结构与必要文件检查
make all           # 构建全部讲次 PDF
make site          # 生成静态网站
make clean         # 清理中间文件
```

## 2. 目录职责（不要混用）

- `chapters/`：唯一可编辑的课程正文源
- `styles/`：全局样式层
- `templates/`：新讲次模板
- `scripts/`：自动化脚本
- `pdf/`：汇总产物目录（生成）
- `site/`：站点产物目录（生成）

## 3. 新增讲次操作 SOP

1. 创建脚手架  
`./scripts/new_lecture.sh <chapter-slug> <lecture-slug>`

2. 填写内容  
- `slides.tex`
- `handout.tex`
- `metadata.json`
- `figures/*`

3. 质量门禁  
`make check-style && make all && make site`

4. 检查结果  
- `pdf/<chapter>_<lecture>_slides.pdf`
- `pdf/<chapter>_<lecture>_handout.pdf`
- 站点首页出现该讲卡片

## 3.1 内容开工前的校准步骤

在真正动 `slides.tex` / `handout.tex` 之前，先完成一次轻量校准，避免后面反复推翻：

1. 先明确这一讲的**唯一主线**
- 只允许一条主干叙事线
- 历史、案例、流程、图示都必须服务这条主线

2. 写下这一讲要交付给读者的**最小认知增量**
- 读完这一讲后，读者脑中新增的那个“判断框架”是什么？
- 例如：一个对象层次图、一组分析问题、一条流程位置感

3. 明确这一讲是**第一次引入**还是**螺旋式回访**
- 第一次引入：先立轮廓、位置感和基本直觉
- 回访加深：再补定义、边界、反例和技术细节

4. 开工前自检
- 这讲会不会写成资料汇编？
- 会不会出现两条以上并列主线？
- 是否已经想清楚“这一讲和前后章节的关系”？

## 3.2 讲义写作流程建议

建议按下面顺序推进，而不是一上来全文铺开：

1. 先写 3--6 行本章导读，交代“为什么有这一讲”
2. 再写 `Learning Objectives`，明确交付边界
3. 再确定大节骨架与顺序
4. 先写每节的段首句：本节要回答什么问题
5. 再补图、例子、类比、`tipbox` / `warnbox`
6. 最后才统一润色和压语气

这样做的好处是：

- 先把骨架立稳，再填肉
- 先控制结构风险，再处理文风细节
- 避免写了很多段落后才发现主线跑偏

## 3.3 自学教材取向的验收问题

除了编译通过，还建议用下面的问题验收正文：

1. 读者是否能看出这一讲为什么存在？
2. 读者是否知道这讲和前后章节的关系？
3. 这一讲是在“解释知识”，还是在“训练一种以后会反复使用的观察方式”？
4. 有没有让读者感到被训诫，而不是被带着往前走？
5. 有没有给出“这一遍先认识轮廓，后面会回来加深”的提示？
6. 如果删掉一半修辞，主干结构是否仍然成立？

## 4. metadata.json 约定

每讲必须包含：

```json
{
  "chapter_title": "章节名",
  "title": "讲次标题",
  "subtitle": "副标题",
  "summary": "一句话摘要",
  "keywords": ["关键词1", "关键词2"],
  "difficulty": "本科基础",
  "duration": "90 min",
  "updated": "YYYY-MM-DD"
}
```

## 5. 常见故障排查

### 5.1 `make check-style` 失败

通常是缺少以下文件之一：
- `slides.tex`
- `handout.tex`
- `metadata.json`
- `figures/`

### 5.2 `make all` 失败

优先检查：
- LaTeX 编译报错行（语法、宏包、路径）
- `\includegraphics` 路径是否在讲次目录内有效
- 图文件是否真的存在

### 5.3 `make site` 失败或站点缺内容

检查：
- `pdf/` 中是否有对应讲次 PDF
- `metadata.json` 格式是否是合法 JSON
- 讲次目录是否满足 `chapters/<chapter>/<lecture>/` 两层结构

## 6. 变更边界策略

- 内容更新：只改 `chapters/`
- 全局视觉更新：只改 `styles/`
- 流程自动化更新：只改 `scripts/`
- 部署逻辑更新：优先改 `scripts/build_site.py` 与 `docs/STATIC_SITE_DEPLOY.md`

禁止把上述改动混在一次提交中，除非是紧急修复。

## 7. 发布前最终清单

1. `make check-style` 通过
2. `make all` 通过
3. `make site` 通过
4. `site/index.html` 本地预览正常
5. 新增讲次按钮链接（Slides/Handout/Source ZIP）可点击
6. 正文通过一次“主线 / 语气 / 螺旋式节奏”自查
## 中文与图片约束

- 本仓库中文内容统一按 `xelatex` 路线处理
- 共享样式文件已经引入 `ctex + fontspec + Noto CJK`
- 若只用 `pdflatex`，中文标题与正文会出现缺字或直接报错
- `webp` 不应直接喂给 LaTeX；请先转换为 `png`
