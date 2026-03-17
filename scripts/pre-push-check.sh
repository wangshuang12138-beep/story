#!/bin/bash
# 推送前检查脚本
# 确保不会将其他仓库的内容推送到当前仓库

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 执行推送前检查..."

# 获取当前仓库名
REPO_NAME=$(basename $(git remote get-url origin 2>/dev/null) .git 2>/dev/null || echo "unknown")
echo "📦 当前仓库: $REPO_NAME"

# 定义每个仓库的允许文件模式
case "$REPO_NAME" in
    "story")
        ALLOWED_PATTERNS=(
            "^story/"
            "^assets/"
            "^README\.md$"
            "^story\.md$"
            "^chapters\.json$"
            "^REPOSITORIES\.md$"
            "^\.gitignore$"
        )
        FORBIDDEN_PATTERNS=(
            "^decision-dice/"
            "^habit-tracker/"
            "^music-daily/"
            "^openclaw-daily/"
            "^xca-blog/"
            "^memory/"
            "^AGENTS\.md$"
            "^SOUL\.md$"
            "^IDENTITY\.md$"
            "^USER\.md$"
            "^MEMORY\.md$"
            "^TOOLS\.md$"
            "^BOOTSTRAP\.md$"
        )
        ;;
    "music-daily")
        ALLOWED_PATTERNS=(
            "^index\.html$"
            "^app\.js$"
            "^data\.json$"
            "^styles/"
            "^assets/"
            "^README\.md$"
            "^\.gitignore$"
        )
        FORBIDDEN_PATTERNS=(
            "story\.md$"
            "chapters\.json$"
        )
        ;;
    *)
        echo -e "${YELLOW}⚠️  未定义仓库规则: $REPO_NAME，跳过详细检查${NC}"
        exit 0
        ;;
esac

# 检查暂存区文件
echo ""
echo "📋 检查暂存区文件..."

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM 2>/dev/null || true)

if [ -z "$STAGED_FILES" ]; then
    echo -e "${YELLOW}⚠️  暂存区为空${NC}"
    exit 0
fi

ERRORS=0

while IFS= read -r file; do
    [ -z "$file" ] && continue
    
    # 检查禁止的文件
    for pattern in "${FORBIDDEN_PATTERNS[@]}"; do
        if echo "$file" | grep -qE "$pattern"; then
            echo -e "${RED}❌ 禁止的文件: $file (匹配规则: $pattern)${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    done
done <<< "$STAGED_FILES"

if [ $ERRORS -gt 0 ]; then
    echo ""
    echo -e "${RED}🚫 检查失败: 发现 $ERRORS 个不合规文件${NC}"
    echo ""
    echo "💡 解决方法:"
    echo "   1. 从暂存区移除这些文件: git reset HEAD <file>"
    echo "   2. 如果文件属于其他仓库，到对应目录下提交"
    echo "   3. 如果是本地文件，添加到 .gitignore"
    echo ""
    exit 1
fi

echo -e "${GREEN}✅ 检查通过！暂存区文件符合仓库边界定义${NC}"
exit 0
