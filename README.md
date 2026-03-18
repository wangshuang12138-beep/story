# xca's 音乐故事日记

一个人的日常，一首歌的时间。

📖 **在线阅读**: https://wangshuang12138-beep.github.io/music-daily/

---

## 项目简介

这是一个以日期为维度的连载音乐故事站。每天一个故事片段，每天一首推荐歌曲。

故事围绕一个裸辞程序员的生活展开，音乐则与当天情绪相呼应。

---

## 当前连载状态

<!-- 以下内容会自动从 STORY_STATUS.md 同步，不要手动修改 -->

| 天数 | 日期 | 标题 | 状态 |
|------|------|------|------|
| Day 1 | 2026-03-16 | 起点 | ✅ 已发布 |
| Day 2 | 2026-03-17 | 没有闹钟的早晨 | ✅ 已发布 |
| Day 3 | 2026-03-18 | 菜市场经济学 | ✅ 已发布 |

**最新**: Day 3 - 菜市场经济学 (2026-03-18)

---

## 快速开始

### 写作新章节

```bash
# 1. 查看当前状态
cat STORY_STATUS.md

# 2. 查看人物设定
cat STORY_BIBLE.md

# 3. 查看写作指南
cat GUIDE.md

# 4. 运行验证脚本
./scripts/validate-all.sh
```

---

## 文档导航

| 文档 | 用途 | 更新频率 |
|------|------|----------|
| [STORY_STATUS.md](./STORY_STATUS.md) | 章节列表、当前状态、时间线 | 每次发布 |
| [STORY_BIBLE.md](./STORY_BIBLE.md) | 人物设定、固定属性 | 极少 |
| [GUIDE.md](./GUIDE.md) | 写作流程、规则、检查清单 | 极少 |
| [REPOSITORIES.md](./REPOSITORIES.md) | 仓库边界说明 | 极少 |

---

## 项目结构

```
story/
├── story.md              # 故事正文（你编辑的文件）
├── chapters.json         # 章节索引
├── STORY_STATUS.md       # 状态追踪（经常更新）
├── STORY_BIBLE.md        # 人物设定
├── GUIDE.md              # 写作指南
├── REPOSITORIES.md       # 仓库说明
└── scripts/              # 验证脚本
    ├── validate-all.sh
    ├── validate-story-continuity.sh
    └── validate-daily-music.sh
```

---

## 关键数字

- **Day 1 日期**: 2026-03-16
- **Day 1 辞职天数**: 37天
- **公式**: Day N 辞职天数 = 37 + (N-1)
- **存款**: 20万（固定）
- **居住地**: 深圳白石洲（固定）

---

## 关联项目

- [music-daily](https://github.com/wangshuang12138-beep/music-daily) - 前端展示
- [xca-blog](https://github.com/wangshuang12138-beep/xca-blog) - 博客介绍

---

*最后更新: 2026-03-17*
