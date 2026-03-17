#!/bin/bash
# 每日音乐推荐验证脚本
# 确保每一天都有对应的音乐数据

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🔍 检查每日音乐推荐完整性..."

# 进入 music-daily 目录
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
    
    echo -n "  Day $DAY_NUM: "
    
    if [ -z "$TITLE" ] || [ "$TITLE" = "null" ]; then
        echo -e "${RED}❌ 缺少 song.title${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi
    
    if [ -z "$ARTIST" ] || [ "$ARTIST" = "null" ]; then
        echo -e "${RED}❌ 缺少 song.artist${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi
    
    if [ -z "$QUOTE" ] || [ "$QUOTE" = "null" ]; then
        echo -e "${RED}❌ 缺少 song.quote${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi
    
    if [ -z "$AUDIO_URL" ] || [ "$AUDIO_URL" = "null" ]; then
        echo -e "${RED}❌ 缺少 audioUrl${NC}"
        ERRORS=$((ERRORS + 1))
        continue
    fi
    
    echo -e "${GREEN}✅ $TITLE - $ARTIST${NC}"
done

if [ $ERRORS -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ 所有音乐数据完整！${NC}"
    exit 0
else
    echo ""
    echo -e "${RED}🚫 发现 $ERRORS 个错误，请修复后再推送${NC}"
    echo "💡 提示: 每一天都必须有完整的音乐数据（title, artist, quote, audioUrl）"
    exit 1
fi
