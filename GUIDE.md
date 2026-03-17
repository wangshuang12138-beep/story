# 写作指南

**本文档**: 合并所有写作相关的规则、流程和检查清单。

---

## 一、核心原则

### 1. 每日音乐原则
⚠️ **每一天都必须有一首音乐推荐，不可妥协。**

### 2. 连续性原则
- 日期必须连续
- 辞职天数按公式计算: `37 + (Day - 1)`
- 人物设定保持一致（参考 STORY_BIBLE.md）

### 3. 渐进变化原则
- 情绪变化要渐变，不能突变
- 生活状态短期内保持无业
- 不引入新的重大设定

---

## 二、写作流程

### 发布 Day N 的标准流程

**Step 1: 准备**
```bash
# 查看当前状态
cat STORY_STATUS.md

# 查看人物设定
cat STORY_BIBLE.md

# 查看上一天结尾
tail -100 story.md
```

**Step 2: 计算今天信息**
```
Day N = 昨天 Day + 1
日期 = 昨天日期 + 1天
星期 = 昨天星期 + 1（循环）
辞职天数 = 37 + (N - 1)
```

**Step 3: 写作故事**
```bash
vim story.md
```

格式:
```markdown
## Day N

[星期X]，[日期]，[天气温度]。

我算了一下，这是裸辞的第[37+N-1]天。

[承接上一天的情绪/事件]

[当天发生的故事]

[结尾的情绪，为明天铺垫]
```

**Step 4: 更新章节索引**
```bash
vim chapters.json
```

添加:
```json
{
  "day": N,
  "date": "2026-03-XX",
  "title": "章节标题",
  "status": "published"
}
```

**Step 5: 更新状态文档**
```bash
vim STORY_STATUS.md  # 更新章节列表
vim README.md        # 更新章节列表
```

**Step 6: 选择今日音乐**
```bash
cd /root/.openclaw/workspace/music-daily
vim data.json
```

添加:
```json
{
  "day": N,
  "date": "2026-03-XX",
  "song": {
    "title": "歌曲名",
    "artist": "艺术家",
    "quote": "歌词金句"
  },
  "audioUrl": "https://wangshuang12138-beep.github.io/assets/music/2026-03-XX.mp3"
}
```

**Step 7: 运行验证**
```bash
./scripts/validate-all.sh
```

**Step 8: 提交推送**
```bash
# Story 仓库
cd /root/.openclaw/workspace
git add story.md chapters.json STORY_STATUS.md README.md
git commit -m "Day N: 添加故事内容"
git push

# Music-Daily 仓库
cd /root/.openclaw/workspace/music-daily
git add data.json
git commit -m "Day N: 添加音乐数据"
git push
```

---

## 三、检查清单

### 发布前必须检查

**故事方面**:
- [ ] 日期连续（昨天+1）
- [ ] 辞职天数 = 37 + (Day - 1)
- [ ] 星期正确
- [ ] 情绪渐变（不突变）
- [ ] 没有新人物/搬家/找工作

**数据方面**:
- [ ] chapters.json 添加了今天
- [ ] chapters.json status = "published"
- [ ] STORY_STATUS.md 更新了章节列表
- [ ] README.md 更新了章节列表

**音乐方面**:
- [ ] data.json 添加了今天
- [ ] title, artist, quote, audioUrl 都不为空
- [ ] 音乐情绪与故事匹配

**联动方面**:
- [ ] day 和 date 在两个仓库一致
- [ ] 验证脚本通过
- [ ] 两个仓库都已 push

---

## 四、禁止事项

❌ **高危禁止**:
- 跳过音乐
- 日期不连续
- 辞职天数算错
- 突然找到工作
- 突然搬家
- 情绪突变

❌ **中危禁止**:
- 引入新重要人物
- 存款突然变化
- 物品设定矛盾

---

## 五、仓库联动规则

### 架构图

```
story 仓库 (内容源)
├── story.md         → music-daily 读取
├── chapters.json    → music-daily 读取
└── STORY_STATUS.md  → 手动同步到 README.md

music-daily 仓库 (展示层)
├── 读取 story 的故事
└── data.json (音乐数据)
```

### 联动规则

| 触发条件 | 联动动作 |
|----------|----------|
| story 发布新章节 | 1. 更新 story.md, chapters.json<br>2. 更新 STORY_STATUS.md<br>3. 更新 README.md<br>4. 更新 music-daily/data.json<br>5. 推送两个仓库 |

---

## 六、常见错误

### 错误1: 忘记更新状态文档
**解决**: 每次发布后必须更新 STORY_STATUS.md 和 README.md

### 错误2: 忘记写音乐
**解决**: 音乐是必选项，验证脚本会检查

### 错误3: 日期跳错
**解决**: 使用连续性验证脚本

### 错误4: 文档不同步
**解决**: 使用 validate-all.sh 检查

---

## 七、文档联动更新规则

**发布 Day N 时必须更新的文件**:

1. **story.md** - 添加新章节（必须）
2. **chapters.json** - 添加索引（必须）
3. **STORY_STATUS.md** - 更新章节列表（必须）
4. **README.md** - 同步章节列表（必须）
5. **music-daily/data.json** - 添加音乐（必须）
6. **xca-blog** - 写博客（可选）

**检查命令**:
```bash
./scripts/validate-all.sh
```

---

## 八、故障排查

| 问题 | 原因 | 解决 |
|------|------|------|
| 网站不显示新章节 | chapters.json status 不为 published | 检查 status 字段 |
| 音乐不显示 | data.json 未更新 | 检查 data.json |
| 日期错误 | 计算错误 | 使用公式 37+(N-1) |
| 设定矛盾 | 未查 STORY_BIBLE | 核对人物设定 |

---

**相关文档**:
- [STORY_STATUS.md](./STORY_STATUS.md) - 当前连载状态
- [STORY_BIBLE.md](./STORY_BIBLE.md) - 人物设定
- [REPOSITORIES.md](./REPOSITORIES.md) - 仓库说明
