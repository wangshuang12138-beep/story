#!/bin/bash
# 故事连续性验证脚本
# 检查时间线、日期、状态的连续性

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🔍 检查故事连续性..."
echo ""

cd /root/.openclaw/workspace

# 检查 jq 是否安装
if ! command -v jq > /dev/null 2>&1; then
    echo -e "${YELLOW}⚠️  需要安装 jq 来运行检查${NC}"
    echo "   Ubuntu/Debian: apt-get install jq"
    exit 1
fi

# 验证 chapters.json 格式
if ! jq empty chapters.json 2>/dev/null; then
    echo -e "${RED}❌ chapters.json JSON 格式错误${NC}"
    exit 1
fi

# 获取天数
TOTAL_DAYS=$(jq '.chapters | length' chapters.json)
echo -e "${BLUE}📊 共有 $TOTAL_DAYS 天的故事${NC}"
echo ""

ERRORS=0

# 检查每一天的连续性
echo "📅 检查日期连续性..."
for i in $(seq 1 $(($TOTAL_DAYS - 1))); do
    PREV_DAY=$(jq -r ".chapters[$((i-1))].day" chapters.json)
    CURR_DAY=$(jq -r ".chapters[$i].day" chapters.json)
    PREV_DATE=$(jq -r ".chapters[$((i-1))].date" chapters.json)
    CURR_DATE=$(jq -r ".chapters[$i].date" chapters.json)
    
    # 检查 day 连续性
    EXPECTED_DAY=$((PREV_DAY + 1))
    if [ "$CURR_DAY" != "$EXPECTED_DAY" ]; then
        echo -e "${RED}❌ Day 序号不连续: Day $PREV_DAY 后是 Day $CURR_DAY (应为 $EXPECTED_DAY)${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    # 检查 date 连续性
    EXPECTED_DATE=$(date -d "$PREV_DATE + 1 day" +%Y-%m-%d 2>/dev/null || date -v+1d -j -f "%Y-%m-%d" "$PREV_DATE" "+%Y-%m-%d" 2>/dev/null || echo "ERROR")
    
    if [ "$CURR_DATE" != "$EXPECTED_DATE" ] && [ "$EXPECTED_DATE" != "ERROR" ]; then
        echo -e "${RED}❌ Day $CURR_DAY: 日期不连续${NC}"
        echo "   预期: $EXPECTED_DATE"
        echo "   实际: $CURR_DATE"
        ERRORS=$((ERRORS + 1))
    else
        echo -e "✅ Day $CURR_DAY: $CURR_DATE"
    fi
done

echo ""

# 检查辞职天数（Day 1 应该是37天）
echo "💼 检查辞职天数设定..."
DAY1_RESIGN=$(grep -oP "裸辞的第\K\d+" story.md | head -1)
if [ -n "$DAY1_RESIGN" ]; then
    echo "   Day 1 辞职天数: $DAY1_RESIGN 天"
    if [ "$DAY1_RESIGN" != "37" ]; then
        echo -e "${YELLOW}⚠️  注意: Day 1 辞职天数是 $DAY1_RESIGN，不是37${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  未在 story.md 中找到辞职天数${NC}"
fi

echo ""

# 检查 story.md 中的日期与 chapters.json 一致性
echo "📖 检查 story.md 与 chapters.json 一致性..."
for i in $(seq 0 $(($TOTAL_DAYS - 1))); do
    DAY_NUM=$(jq -r ".chapters[$i].day" chapters.json)
    CHAPTER_DATE=$(jq -r ".chapters[$i].date" chapters.json)
    
    # 从 story.md 提取日期（简化检查，只检查月份日期格式）
    STORY_DATE=$(grep -A2 "## Day $DAY_NUM$" story.md 2>/dev/null | grep -oP "\d{1,2}月\d{1,2}日" | head -1)
    
    if [ -n "$STORY_DATE" ]; then
        # 转换为 YYYY-MM-DD 格式比较
        STORY_MONTH=$(echo "$STORY_DATE" | grep -oP "\d+(?=月)")
        STORY_DAY=$(echo "$STORY_DATE" | grep -oP "\d+(?=日)")
        FORMATTED_STORY_DATE="2026-$(printf "%02d" $STORY_MONTH)-$(printf "%02d" $STORY_DAY)"
        
        if [ "$FORMATTED_STORY_DATE" != "$CHAPTER_DATE" ]; then
            echo -e "${RED}❌ Day $DAY_NUM: story.md 日期($STORY_DATE)与 chapters.json($CHAPTER_DATE)不一致${NC}"
            ERRORS=$((ERRORS + 1))
        else
            echo -e "✅ Day $DAY_NUM: 日期一致 ($CHAPTER_DATE)"
        fi
    else
        echo -e "${YELLOW}⚠️  Day $DAY_NUM: 未在 story.md 中找到日期${NC}"
    fi
done

echo ""

# 总结
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ 故事连续性检查通过！${NC}"
    echo ""
    echo "💡 写作前请检查:"
    echo "   1. STORY_BIBLE.md - 人物设定"
    echo "   2. STORY_CONTINUITY.md - 时间线"
    echo "   3. 上一天的情绪结尾"
    exit 0
else
    echo -e "${RED}🚫 发现 $ERRORS 个连续性问题，请修复后再推送${NC}"
    exit 1
fi
