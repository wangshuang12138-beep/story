#!/bin/bash
# 综合验证脚本
# 检查故事连续性、音乐完整性、文档同步状态

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0

echo "=========================================="
echo "🔍 运行综合验证检查"
echo "=========================================="
echo ""

# 检查 jq 是否安装
if ! command -v jq > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  需要安装 jq 来运行检查${NC}"
    echo "   Ubuntu/Debian: apt-get install jq"
    exit 1
fi

cd /root/.openclaw/workspace

# ============================================
# 1. 检查 story.md 和 chapters.json 一致性
# ============================================
echo -e "${BLUE}📖 检查故事文件一致性...${NC}"

# 获取 chapters.json 中的天数
CHAPTER_COUNT=$(jq '.chapters | length' chapters.json)
echo "   chapters.json 记录: $CHAPTER_COUNT 天"

# 统计 story.md 中的 Day 数量
STORY_COUNT=$(grep -c "^## Day [0-9]" story.md || echo "0")
echo "   story.md 记录: $STORY_COUNT 天"

if [ "$CHAPTER_COUNT" != "$STORY_COUNT" ]; then
    echo -e "${RED}❌ 不一致: chapters.json 和 story.md 天数不匹配${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ 天数一致${NC}"
fi

# 检查每一天的日期连续性
echo ""
echo -e "${BLUE}📅 检查日期连续性...${NC}"
for i in $(seq 1 $(($CHAPTER_COUNT - 1))); do
    PREV_DATE=$(jq -r ".chapters[$((i-1))].date" chapters.json)
    CURR_DATE=$(jq -r ".chapters[$i].date" chapters.json)
    CURR_DAY=$(jq -r ".chapters[$i].day" chapters.json)
    
    # 检查日期连续
    EXPECTED_DATE=$(date -d "$PREV_DATE + 1 day" +%Y-%m-%d 2>/dev/null || date -v+1d -j -f "%Y-%m-%d" "$PREV_DATE" "+%Y-%m-%d" 2>/dev/null || echo "ERROR")
    
    if [ "$CURR_DATE" != "$EXPECTED_DATE" ] && [ "$EXPECTED_DATE" != "ERROR" ]; then
        echo -e "${RED}❌ Day $CURR_DAY: 日期不连续 ($PREV_DATE -> $CURR_DATE)${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ 日期连续${NC}"
fi

# ============================================
# 2. 检查音乐数据完整性
# ============================================
echo ""
echo -e "${BLUE}🎵 检查音乐数据完整性...${NC}"

cd /root/.openclaw/workspace/music-daily

if [ ! -f "data.json" ]; then
    echo -e "${RED}❌ music-daily/data.json 不存在${NC}"
    ERRORS=$((ERRORS + 1))
else
    MUSIC_COUNT=$(jq '.days | length' data.json)
    echo "   music-daily: $MUSIC_COUNT 天"
    
    if [ "$MUSIC_COUNT" != "$CHAPTER_COUNT" ]; then
        echo -e "${RED}❌ 不一致: story 有 $CHAPTER_COUNT 天，music 有 $MUSIC_COUNT 天${NC}"
        ERRORS=$((ERRORS + 1))
    else
        echo -e "${GREEN}✅ 天数匹配${NC}"
    fi
    
    # 检查每一天的音乐字段
    for i in $(seq 0 $(($MUSIC_COUNT - 1))); do
        DAY_NUM=$(jq -r ".days[$i].day" data.json)
        TITLE=$(jq -r ".days[$i].song.title" data.json)
        
        if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
            echo -e "${RED}❌ Day $DAY_NUM: 缺少歌曲标题${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    done
fi

cd /root/.openclaw/workspace

# ============================================
# 3. 检查文档同步
# ============================================
echo ""
echo -e "${BLUE}📄 检查文档同步状态...${NC}"

# 检查 README.md 是否包含最新章节
LATEST_DAY=$(jq -r '.chapters[-1].day' chapters.json)
LATEST_DATE=$(jq -r '.chapters[-1].date' chapters.json)
LATEST_TITLE=$(jq -r '.chapters[-1].title' chapters.json)

if ! grep -q "Day $LATEST_DAY" README.md; then
    echo -e "${RED}❌ README.md 未更新 Day $LATEST_DAY${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}✅ README.md 已更新${NC}"
fi

if [ -f "STORY_STATUS.md" ]; then
    if ! grep -q "Day $LATEST_DAY" STORY_STATUS.md; then
        echo -e "${RED}❌ STORY_STATUS.md 未更新 Day $LATEST_DAY${NC}"
        ERRORS=$((ERRORS + 1))
    else
        echo -e "${GREEN}✅ STORY_STATUS.md 已更新${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  STORY_STATUS.md 不存在${NC}"
fi

# ============================================
# 4. 检查关键数字
# ============================================
echo ""
echo -e "${BLUE}🔢 检查关键数字...${NC}"

# 检查辞职天数
echo "   Day $LATEST_DAY 应该是辞职第 $((37 + LATEST_DAY - 1)) 天"

# ============================================
# 总结
# ============================================
echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ 所有检查通过！可以推送。${NC}"
    echo ""
    echo "最新章节: Day $LATEST_DAY - $LATEST_TITLE ($LATEST_DATE)"
    exit 0
else
    echo -e "${RED}🚫 发现 $ERRORS 个问题，请修复后再推送${NC}"
    echo ""
    echo "💡 常见问题:"
    echo "   1. README.md 和 STORY_STATUS.md 是否更新了章节列表？"
    echo "   2. music-daily/data.json 是否添加了音乐？"
    echo "   3. chapters.json 的 status 是否为 published？"
    exit 1
fi
