# 仓库边界定义

本文档明确每个代码仓库的职责范围，防止内容混杂。

## 仓库清单

### 1. story (当前仓库)
**GitHub**: `wangshuang12138-beep/story`  
**Pages**: https://wangshuang12138-beep.github.io/story/

**职责**: 连载小说《xca's 音乐故事日记》的文本内容
**包含文件**:
- `story.md` - 完整故事正文
- `chapters.json` - 章节索引（日期、标题、状态）
- `README.md` - 项目说明
- `assets/` - 故事相关静态资源

**不包含**:
- ❌ 其他项目代码（decision-dice, habit-tracker, music-daily, openclaw-daily, xca-blog）
- ❌ 个人工作区文件（memory/, AGENTS.md, SOUL.md 等）

---

### 2. music-daily
**GitHub**: `wangshuang12138-beep/music-daily`  
**Pages**: https://wangshuang12138-beep.github.io/music-daily/

**职责**: 每日音乐推荐网站（前端展示）
**包含文件**:
- `index.html` - 主页面
- `app.js` - 交互逻辑
- `data.json` - 音乐数据（歌曲、艺术家、金句）
- `styles/` - CSS 样式

**数据来源**:
- 从 story 仓库加载故事内容（`https://wangshuang12138-beep.github.io/story/story.md`）
- 本地 data.json 存储音乐信息

---

### 3. xca-blog
**GitHub**: `wangshuang12138-beep/xca-blog`

**职责**: 个人博客（VitePress）
**包含文件**:
- VitePress 配置和文档
- 博客文章

---

### 4. habit-tracker
**GitHub**: `wangshuang12138-beep/habit-tracker`

**职责**: 习惯追踪工具

---

### 5. decision-dice
**GitHub**: `wangshuang12138-beep/decision-dice`

**职责**: 决策骰子工具

---

### 6. openclaw-daily
**GitHub**: `wangshuang12138-beep/openclaw-daily`

**职责**: OpenClaw 每日任务/工作流

---

## 工作区目录结构

```
/root/.openclaw/workspace/    # 本地工作区（非仓库）
├── story/                    # story 仓库根
│   ├── story.md
│   ├── chapters.json
│   ├── assets/
│   └── ...
├── music-daily/              # music-daily 仓库（独立）
├── xca-blog/                 # xca-blog 仓库（独立）
├── habit-tracker/            # habit-tracker 仓库（独立）
├── decision-dice/            # decision-dice 仓库（独立）
├── openclaw-daily/           # openclaw-daily 仓库（独立）
└── memory/                   # 本地记忆文件（不提交）
```

## 重要规则

1. **每个仓库只包含自己的内容**，不混入其他仓库文件
2. **workspace 是本地目录**，不是仓库根
3. **story 仓库的根就是 workspace**，因此需要 .gitignore 排除其他项目目录
4. **跨仓库引用**通过 GitHub Pages URL 进行，不复制文件

## 推送前检查清单

见 `scripts/pre-push-check.sh`
