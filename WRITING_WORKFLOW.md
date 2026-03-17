# 每日写作工作流

**本文档**: 每日更新故事的标准操作流程（SOP）

---

## 写作前准备

### 1. 查看连续性文档
```bash
# 必读的三个文档
cat /root/.openclaw/workspace/STORY_BIBLE.md        # 人物设定
cat /root/.openclaw/workspace/STORY_CONTINUITY.md   # 时间线规则
cat /root/.openclaw/workspace/DAILY_MUSIC_RULE.md   # 音乐保障
```

### 2. 查看上一天内容
```bash
# 确认上一天的结尾情绪和关键信息
tail -100 /root/.openclaw/workspace/story.md
```

### 3. 计算今天信息
```
Day N = 昨天 Day + 1
日期 = 昨天日期 + 1天
星期 = 昨天星期 + 1（循环）
辞职天数 = 37 + (N - 1)
```

---

## 标准写作流程

### Step 1: 规划今天内容

**必答问题**（在脑海中回答）：
1. 今天的辞职天数是多少？`37 + (N - 1)`
2. 今天星期几？承接上一天
3. 今天的情绪基调？（参考状态弧光表）
4. 今天的音乐是什么？（必须与情绪匹配）
5. 是否违反任何禁止事项？

### Step 2: 写作故事

```bash
cd /root/.openclaw/workspace
vim story.md
```

**写作模板**：
```markdown
---

## Day N

[星期X]，[日期]，[天气温度]。

我算了一下，这是裸辞的第[37+N-1]天。

[承接上一天的情绪/事件]

[今天发生的故事]

[结尾的情绪，为明天铺垫]
```

**写作检查点**：
- [ ] 日期格式：三月十八日
- [ ] 辞职天数正确
- [ ] 情绪渐变（不突变）
- [ ] 没有出现新的重大设定

### Step 3: 更新章节索引

```bash
vim chapters.json
```

添加新条目：
```json
{
  "day": N,
  "date": "2026-03-XX",
  "title": "章节标题",
  "status": "published"
}
```

### Step 4: 选择今日音乐

```bash
cd /root/.openclaw/workspace/music-daily
vim data.json
```

添加新条目：
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

**音乐选择原则**：
- 与今天的故事情绪匹配
- 有代表性的歌词引用
- 风格多样化（不重复）

### Step 5: 运行验证脚本

```bash
# 在 workspace 目录
cd /root/.openclaw/workspace

# 检查故事连续性
./scripts/validate-story-continuity.sh

# 检查音乐完整性
./scripts/validate-daily-music.sh
```

**必须通过所有检查才能推送！**

### Step 6: 提交并推送

```bash
# story 仓库
cd /root/.openclaw/workspace
git add story.md chapters.json
git commit -m "Day N: 添加故事内容"
git push

# music-daily 仓库
cd /root/.openclaw/workspace/music-daily
git add data.json
git commit -m "Day N: 添加音乐数据"
git push
```

### Step 7: 线上验证

```bash
# 验证 story 仓库
curl https://raw.githubusercontent.com/wangshuang12138-beep/story/main/chapters.json

# 验证 music-daily 仓库
curl https://raw.githubusercontent.com/wangshuang12138-beep/music-daily/gh-pages/data.json

# 访问页面查看
# https://wangshuang12138-beep.github.io/music-daily/
```

---

## 快速检查清单

### 发布前必须检查

**故事方面**：
- [ ] 日期连续（昨天+1）
- [ ] 辞职天数 = 37 + (Day - 1)
- [ ] 星期正确
- [ ] 情绪渐变（不突变）
- [ ] 没有新人物/搬家/找工作

**音乐方面**：
- [ ] data.json 添加了今天
- [ ] title, artist, quote, audioUrl 都不为空
- [ ] 音乐情绪与故事匹配

**技术方面**：
- [ ] chapters.json 添加了今天
- [ ] status = "published"
- [ ] 两个仓库都已 push
- [ ] 验证脚本通过

---

## 常见错误及避免

### 错误1: 忘记写音乐
**避免**: 音乐是必选项，不是可选项。写作前先选好音乐。

### 错误2: 日期跳错
**避免**: 使用连续性验证脚本，会自动检查日期连续性。

### 错误3: 辞职天数算错
**避免**: 公式 `37 + (Day - 1)`，Day 1=37, Day 2=38, Day 3=39...

### 错误4: 情绪突变
**避免**: 查看 STORY_BIBLE.md 中的「状态弧光表」，保持渐进变化。

### 错误5: 引入新设定
**避免**: 新增物品/地点记录在 STORY_BIBLE.md 中，新增人物需谨慎。

---

## 文档索引

| 阶段 | 文档 | 用途 |
|------|------|------|
| 写作前 | STORY_BIBLE.md | 查看人物设定 |
| 写作前 | STORY_CONTINUITY.md | 查看时间线规则 |
| 写作前 | DAILY_MUSIC_RULE.md | 确认音乐必写 |
| 写作中 | 本文件 (WRITING_WORKFLOW.md) | 按流程执行 |
| 写作后 | scripts/validate-*.sh | 自动化检查 |

---

## 紧急联系

如果发现连续性错误：
1. 停止写作
2. 查看 STORY_CONTINUITY.md 的「紧急修复流程」
3. 评估影响范围
4. 修复后重新运行验证脚本
