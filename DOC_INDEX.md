# 文档索引

**music-daily 项目完整文档体系**

---

## 核心原则文档

| 文档 | 路径 | 一句话说明 |
|------|------|-----------|
| **音乐保障** | `DAILY_MUSIC_RULE.md` | 每天必须有音乐，不可妥协 |
| **连续性保障** | `STORY_CONTINUITY.md` | 时间线、日期、状态一致性 |
| **人物圣经** | `STORY_BIBLE.md` | 主角设定，防止吃书 |

---

## 操作指南

| 文档 | 路径 | 使用场景 |
|------|------|----------|
| **每日写作流程** | `WRITING_WORKFLOW.md` | 每天写新故事时按此执行 |
| **仓库联动规则** | `REPOSITORY_LINKAGE.md` | 了解仓库间的依赖关系 |
| **仓库边界** | `REPOSITORIES.md` | 了解各仓库的职责范围 |

---

## 自动化脚本

| 脚本 | 路径 | 用途 | 使用时机 |
|------|------|------|----------|
| **音乐验证** | `scripts/validate-daily-music.sh` | 检查每天都有音乐 | 写作后 |
| **连续性验证** | `scripts/validate-story-continuity.sh` | 检查时间线连续 | 写作后 |
| **推送检查** | `.git/hooks/pre-push` | 阻止越界推送 | 自动执行 |

---

## 快速开始

### 如果你是第一次写故事

1. **阅读核心原则**（必看）
   ```bash
   cat DAILY_MUSIC_RULE.md
   cat STORY_BIBLE.md
   cat STORY_CONTINUITY.md
   ```

2. **按流程执行**
   ```bash
   cat WRITING_WORKFLOW.md
   ```

### 如果你已经熟悉流程

```bash
# 1. 查看上一天结尾
tail -100 story.md

# 2. 写作（故事 + 章节索引 + 音乐）
# ...

# 3. 运行验证
./scripts/validate-story-continuity.sh
./scripts/validate-daily-music.sh

# 4. 推送
# ...
```

---

## 关键数字速查

| 项目 | 数值 | 计算方式 |
|------|------|----------|
| Day 1 日期 | 2026-03-16 | 基准 |
| Day 1 辞职天数 | 37天 | 基准 |
| Day N 辞职天数 | 37 + (N-1) | 公式 |
| 存款 | 20万 | 固定 |
| 居住地 | 白石洲 | 固定 |

---

## 禁止事项速查

- ❌ 跳过音乐
- ❌ 日期不连续
- ❌ 辞职天数算错
- ❌ 突然找到工作
- ❌ 突然搬家
- ❌ 情绪突变
- ❌ 引入新人物

---

## 故障排查

| 问题 | 查看文档 |
|------|----------|
| 忘记写音乐 | DAILY_MUSIC_RULE.md |
| 日期对不上 | STORY_CONTINUITY.md |
| 设定矛盾 | STORY_BIBLE.md |
| 不知道怎么写 | WRITING_WORKFLOW.md |
| 推送失败 | REPOSITORIES.md |

---

**最后更新**: 2026-03-17
