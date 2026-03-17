# 仓库联动规则

本文档定义各仓库之间的依赖关系和数据流转规则，确保跨仓库更新时保持一致性。

## 一、仓库架构图

```
┌─────────────────────────────────────────────────────────────┐
│                      数据来源层                              │
├─────────────────────────────────────────────────────────────┤
│  story 仓库 (内容源)                                         │
│  ├── story.md        - 故事正文                             │
│  └── chapters.json   - 章节索引                             │
└──────────────────┬──────────────────────────────────────────┘
                   │ 读取
                   ▼
┌─────────────────────────────────────────────────────────────┐
│                      展示层                                  │
├─────────────────────────────────────────────────────────────┤
│  music-daily 仓库                                            │
│  ├── index.html      - 页面框架                             │
│  ├── app.js          - 交互逻辑                             │
│  └── data.json       - 音乐数据 (独立维护)                   │
│                                                                │
│  数据来源:                                                    │
│  - 故事内容: https://wangshuang12138-beep.github.io/story/   │
│  - 音乐数据: 本地 data.json                                  │
└─────────────────────────────────────────────────────────────┘
```

## 二、联动关系表

| 仓库 | 角色 | 依赖上游 | 被下游依赖 | 触发联动条件 |
|------|------|----------|------------|--------------|
| **story** | 内容源 | 无 | music-daily | 章节发布/更新 |
| **music-daily** | 展示层 | story | 无 | story 章节发布时需要同步更新 data.json |

## 三、联动规则详情

### Rule 1: Story → Music-Daily 联动

**触发条件**: story 仓库新增或更新章节

**联动动作**:
1. 更新 story 仓库
   - 修改 story.md 添加/更新章节内容
   - 修改 chapters.json 更新章节标题和状态

2. 同步更新 music-daily 仓库
   - 在 data.json 中添加对应日期的音乐数据
   - 确保 day 和 date 字段与 chapters.json 一致

**检查点**:
- [ ] chapters.json 中的新章节 status 为 "published"
- [ ] data.json 中对应 day 的音乐数据已添加
- [ ] 两个仓库的 day 和 date 字段一致

**验证 URL**:
- Story: https://wangshuang12138-beep.github.io/story/chapters.json
- Music Daily: https://wangshuang12138-beep.github.io/music-daily/data.json

---

## 四、日常操作流程

### 场景：发布 Day N 内容

#### Step 1: 更新 Story 仓库
```bash
cd /root/.openclaw/workspace

# 1. 更新故事内容
vim story.md  # 添加 Day N 内容

# 2. 更新章节索引
vim chapters.json  # 添加 Day N 条目，设置 status: published

# 3. 提交并推送
git add story.md chapters.json
git commit -m "Day N: 添加故事内容"
git push
```

#### Step 2: 更新 Music-Daily 仓库
```bash
cd /root/.openclaw/workspace/music-daily

# 1. 更新音乐数据
vim data.json  # 添加 Day N 的音乐数据

# 2. 提交并推送
git add data.json
git commit -m "Day N: 添加音乐数据"
git push
```

#### Step 3: 验证联动
```bash
# 检查 story 仓库
curl https://wangshuang12138-beep.github.io/story/chapters.json

# 检查 music-daily 仓库
curl https://wangshuang12138-beep.github.io/music-daily/data.json

# 检查最终页面
curl https://wangshuang12138-beep.github.io/music-daily/
```

---

## 五、一致性检查清单

### 每日发布检查表

- [ ] **Story 仓库**
  - [ ] story.md 包含最新 Day N 内容
  - [ ] chapters.json 包含 Day N 条目
  - [ ] chapters.json 中 Day N status 为 "published"
  - [ ] 已推送到 GitHub

- [ ] **Music-Daily 仓库**
  - [ ] data.json 包含 Day N 音乐数据
  - [ ] data.json 中 day 字段与 chapters.json 一致
  - [ ] data.json 中 date 字段与 chapters.json 一致
  - [ ] 已推送到 GitHub

- [ ] **线上验证**
  - [ ] https://wangshuang12138-beep.github.io/story/story.md 显示最新内容
  - [ ] https://wangshuang12138-beep.github.io/music-daily/ 正常加载
  - [ ] 页面可以切换到 Day N

---

## 六、故障排查

### 问题1: music-daily 页面显示 "正在加载今日故事..."
**原因**: story.md 或 chapters.json 未正确更新
**解决**: 
1. 检查 story 仓库是否推送
2. 检查 chapters.json 中对应章节 status 是否为 published
3. 等待 GitHub Pages 刷新（约5-10分钟）

### 问题2: music-daily 页面没有显示音乐
**原因**: data.json 未包含对应日期的音乐数据
**解决**:
1. 检查 music-daily/data.json 是否包含对应 day
2. 检查 audioUrl 是否有效

### 问题3: 日期不匹配
**原因**: story 和 music-daily 的 date 字段不一致
**解决**: 统一两个仓库的 date 格式（YYYY-MM-DD）

---

## 七、文档位置

**本规则文档位置**:
- 本地: `/root/.openclaw/workspace/REPOSITORY_LINKAGE.md`
- 远程: https://github.com/wangshuang12138-beep/story/blob/main/REPOSITORY_LINKAGE.md

**相关文档**:
- 仓库边界: `/root/.openclaw/workspace/REPOSITORIES.md`
- 推送检查: `/root/.openclaw/workspace/scripts/pre-push-check.sh`

---

## 八、当前状态检查

**最后更新**: 2026-03-17

### Story 仓库状态
- 最新章节: Day 2
- 故事内容: ✅ 已发布
- 章节索引: ✅ 已更新
- 远程同步: ✅ 已推送

### Music-Daily 仓库状态
- 最新音乐: Day 2 (旅行的意义)
- 数据文件: ✅ 已更新
- 远程同步: ✅ 已推送

### 联动状态
- Day 1: ✅ 故事 + 音乐 均已发布
- Day 2: ✅ 故事 + 音乐 均已发布
