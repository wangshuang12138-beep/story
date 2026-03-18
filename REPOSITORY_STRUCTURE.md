# REPOSITORY_STRUCTURE.md - 仓库结构规范

## ⚠️ 重要：目录结构必须严格遵守

本文件定义所有仓库的目录结构和文件位置规范，防止再次出错。

---

## 仓库根目录定义

| 仓库 | 本地路径 | GitHub 仓库 |
|------|----------|-------------|
| story | `/root/.openclaw/workspace/` | wangshuang12138-beep/story |
| music-daily | `/root/.openclaw/workspace/music-daily/` | wangshuang12138-beep/music-daily |
| xca-blog | `/root/.openclaw/workspace/xca-blog/` | wangshuang12138-beep/xca-blog |
| habit-tracker | `/root/.openclaw/workspace/habit-tracker/` | wangshuang12138-beep/habit-tracker |
| assets | `/root/.openclaw/workspace/assets/` | wangshuang12138-beep/assets |

**关键规则**: story 仓库的根目录是 workspace 本身，不是 story/ 子目录。

---

## story 仓库 - 文件结构

```
/root/.openclaw/workspace/          ← 这是 story 仓库的根
├── story.md                        ← 故事正文（核心文件）
├── chapters.json                   ← 章节索引
├── README.md                       ← 项目介绍
├── STORY_STATUS.md                 ← 状态追踪
├── STORY_BIBLE.md                  ← 人物设定
├── GUIDE.md                        ← 写作指南
├── REPOSITORIES.md                 ← 仓库边界说明
├── REPOSITORY_STRUCTURE.md         ← 本文件（结构规范）
└── scripts/                        ← 验证脚本
    ├── validate-all.sh
    ├── validate-story-continuity.sh
    └── validate-daily-music.sh
```

### ❌ 禁止的操作

| 禁止事项 | 原因 |
|----------|------|
| 在 story/ 子目录中编辑文件 | 该目录被 .gitignore 排除，无法提交 |
| 添加其他仓库为 submodule | 会导致仓库结构混乱，无法打开 |
| 混淆 workspace 和 story/ 子目录 | 会导致文件提交到错误位置 |

---

## music-daily 仓库 - 文件结构

```
/root/.openclaw/workspace/music-daily/     ← 这是 music-daily 仓库的根
├── index.html                              ← 主页面
├── app.js                                  ← 交互逻辑
├── data.json                               ← 音乐数据
├── README.md                               ← 项目说明
└── .github/workflows/deploy.yml            ← 自动部署配置
```

---

## 编辑操作规范

### 编辑 story.md

```bash
# ✅ 正确：直接在 workspace 根目录编辑
edit /root/.openclaw/workspace/story.md

# ❌ 错误：在 story/ 子目录编辑（被 gitignore 排除）
edit /root/.openclaw/workspace/story/story.md
```

### 提交更改

```bash
# ✅ 正确：在 workspace 根目录提交
cd /root/.openclaw/workspace
git add story.md chapters.json README.md
git commit -m "Day N: xxx"
git push origin main

# ❌ 错误：在 story/ 子目录提交（该目录不是 git 仓库）
cd /root/.openclaw/workspace/story
git add story.md  # 这会失败或添加到错误的仓库
```

---

## 每日发布检查清单

发布 Day N 时必须更新以下文件：

### story 仓库
- [ ] `story.md` - 添加新章节（在 workspace 根目录）
- [ ] `chapters.json` - 添加索引
- [ ] `README.md` - 同步章节列表
- [ ] `STORY_STATUS.md` - 更新状态（如果有）

### music-daily 仓库
- [ ] `data.json` - 添加音乐数据

### 验证步骤
```bash
cd /root/.openclaw/workspace
# 1. 确认在正确的仓库
pwd  # 应该输出 /root/.openclaw/workspace

# 2. 检查文件状态
git status

# 3. 确认 story.md 在待提交列表中
git diff --stat story.md

# 4. 提交并推送
git add story.md chapters.json README.md
git commit -m "Day N: xxx"
git push origin main
```

---

## 常见问题排查

### Q: 为什么我编辑了 story.md 但 git status 看不到？
A: 你可能编辑了 `story/story.md` 而不是根目录的 `story.md`。检查路径：
```bash
ls -la /root/.openclaw/workspace/story.md      # 正确的文件
ls -la /root/.openclaw/workspace/story/story.md # 错误的文件（被 gitignore）
```

### Q: assets-fix 和 assets-temp 是什么？
A: 它们是误添加的 git submodule，会导致仓库结构混乱。**禁止添加任何 submodule**。

### Q: 如何确认我在正确的目录？
A: 运行 `git remote -v`，应该显示 story 仓库的 URL。
```bash
cd /root/.openclaw/workspace
git remote -v
# 应该输出：
# origin  https://github.com/wangshuang12138-beep/story.git (fetch)
# origin  https://github.com/wangshuang12138-beep/story.git (push)
```

---

## 规则总结

1. **story 仓库根目录 = workspace 根目录**
2. **永远不要编辑 story/ 子目录中的文件**
3. **永远不要添加 submodule**
4. **提交前检查 git status，确保文件在待提交列表中**
5. **推送后检查 GitHub，确认文件已更新**

---

*最后更新: 2026-03-18*
