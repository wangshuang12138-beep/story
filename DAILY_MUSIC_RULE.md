# 每日音乐推荐保障机制

**项目核心原则**: 每一天都必须有一首音乐推荐，这是不可妥协的项目初衷。

---

## 一、数据结构规则

### 1. 强制字段检查

每个音乐条目必须包含以下字段：

```json
{
  "day": 1,                          // 必填: 天数序号
  "date": "2026-03-16",              // 必填: 日期 (YYYY-MM-DD)
  "song": {
    "title": "歌曲名",                // 必填: 歌曲名称
    "artist": "艺术家",               // 必填: 艺术家
    "quote": "金句歌词"               // 必填: 代表性歌词
  },
  "audioUrl": "音频链接"              // 必填: 音频文件URL
}
```

### 2. 日期连续性检查

- **不允许跳过天数**: Day 1, Day 2, Day 3... 必须连续
- **不允许重复天数**: 每个 day 值只能出现一次
- **日期格式统一**: 必须是 YYYY-MM-DD 格式

---

## 二、发布检查清单（强制执行）

### 新增 Day N 时必须完成的检查：

- [ ] **1. 故事内容**
  - [ ] story.md 添加 Day N 故事
  - [ ] chapters.json 添加 Day N 索引
  - [ ] chapters.json 中 status 设置为 "published"

- [ ] **2. 音乐数据（核心！不可跳过）**
  - [ ] data.json 添加 Day N 音乐数据
  - [ ] 确认 title 字段不为空
  - [ ] 确认 artist 字段不为空
  - [ ] 确认 quote 字段不为空
  - [ ] 确认 audioUrl 字段不为空

- [ ] **3. 关联性检查**
  - [ ] story 的 day 与 music-daily 的 day 一致
  - [ ] story 的 date 与 music-daily 的 date 一致

- [ ] **4. 推送验证**
  - [ ] story 仓库已 push
  - [ ] music-daily 仓库已 push
  - [ ] 线上数据已更新（验证 URLs）

---

## 三、自动化验证脚本

创建文件: `scripts/validate-daily-music.sh`

```bash
#!/bin/bash
# 每日音乐推荐验证脚本
# 确保每一天都有对应的音乐数据

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 检查每日音乐推荐完整性..."

# 检查 music-daily/data.json
cd /root/.openclaw/workspace/music-daily

# 验证 JSON 格式
if ! jq empty data.json 2>/dev/null; then
    echo -e "${RED}❌ data.json JSON 格式错误${NC}"
    exit 1
fi

# 获取天数列表
DAYS=$(jq '.days | length' data.json)
echo "📊 共有 $DAYS 天的音乐数据"

# 检查每一天的必填字段
ERRORS=0
for i in $(seq 0 $(($DAYS - 1))); do
    DAY_NUM=$(jq -r ".days[$i].day" data.json)
    TITLE=$(jq -r ".days[$i].song.title" data.json)
    ARTIST=$(jq -r ".days[$i].song.artist" data.json)
    QUOTE=$(jq -r ".days[$i].song.quote" data.json)
    AUDIO_URL=$(jq -r ".days[$i].audioUrl" data.json)
    
    if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
        echo -e "${RED}❌ Day $DAY_NUM: 缺少 song.title${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    if [ -z "$ARTIST" ] || [ "$ARTIST" = "null" ]; then
        echo -e "${RED}❌ Day $DAY_NUM: 缺少 song.artist${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    if [ -z "$QUOTE" ] || [ "$QUOTE" = "null" ]; then
        echo -e "${RED}❌ Day $DAY_NUM: 缺少 song.quote${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    if [ -z "$AUDIO_URL" ] || [ "$AUDIO_URL" = "null" ]; then
        echo -e "${RED}❌ Day $DAY_NUM: 缺少 audioUrl${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ 所有音乐数据完整！${NC}"
    exit 0
else
    echo -e "${RED}🚫 发现 $ERRORS 个错误，请修复后再推送${NC}"
    exit 1
fi
```

---

## 四、联动规则更新

### 修改 REPOSITORY_LINKAGE.md 中的规则

**Rule 1: Story → Music-Daily 联动** 更新为：

```
触发条件: story 仓库新增或更新章节

联动动作（强制执行）:
1. 更新 story 仓库
   - 修改 story.md 添加/更新章节内容
   - 修改 chapters.json 更新章节标题和状态

2. 同步更新 music-daily 仓库（⚠️ 不可跳过！）
   - 在 data.json 中添加对应日期的音乐数据
   - 确保 day 和 date 字段与 chapters.json 一致
   - 确保 song.title, song.artist, song.quote, audioUrl 都不为空

3. 运行验证脚本
   - ./scripts/validate-daily-music.sh
   - 检查通过后才能推送

检查点:
- [ ] chapters.json 中的新章节 status 为 "published"
- [ ] data.json 中对应 day 的音乐数据已添加
- [ ] data.json 中所有必填字段都不为空
- [ ] 两个仓库的 day 和 date 字段一致
- [ ] 验证脚本通过
```

---

## 五、防止遗忘的机制

### 1. 物理提醒
在 workspace 根目录创建 `DAILY_MUSIC_RULE.md`，内容：
```
⚠️ 每日更新时必须包含音乐推荐！
⚠️ 不可妥协！这是项目的核心原则！

更新步骤：
1. 写故事 → story/story.md
2. 更新索引 → story/chapters.json
3. **选音乐** → music-daily/data.json （别忘了！）
4. 推送两个仓库
```

### 2. 检查脚本集成到 pre-push
修改 `scripts/pre-push-check.sh`，添加：
```bash
# 检查 music-daily 数据完整性
if [ -f "../music-daily/data.json" ]; then
    ./scripts/validate-daily-music.sh || exit 1
fi
```

### 3. 双重确认机制
每次发布时，必须回答：
- "今天的故事对应的音乐是什么？"
- "data.json 更新了吗？"

---

## 六、当前状态修复

### 问题: Day 2 音乐在 GitHub Pages 未显示
**原因**: GitHub Pages CDN 缓存
**解决**: 
1. 等待 5-10 分钟自动刷新
2. 或访问带缓存清除参数的 URL:
   `https://wangshuang12138-beep.github.io/music-daily/?nocache=1`

### 验证命令:
```bash
# 验证远程数据
curl -s https://raw.githubusercontent.com/wangshuang12138-beep/music-daily/gh-pages/data.json | jq '.days | length'

# 应该返回 2（表示有2天的数据）
```

---

## 七、文档索引

| 文档 | 路径 | 用途 |
|------|------|------|
| 音乐保障机制 | `DAILY_MUSIC_RULE.md` | 核心原则提醒 |
| 联动规则 | `REPOSITORY_LINKAGE.md` | 仓库联动流程 |
| 验证脚本 | `scripts/validate-daily-music.sh` | 自动化检查 |
| 发布清单 | 本文件 "发布检查清单" 章节 | 人工核对 |
