#!/usr/bin/env bash
# CronHub 部署脚本 —— 执行 Git 提交与变更
# 用法: bash deploy.sh "提交信息"

set -e

COMMIT_MSG="${1:-更新每日变更摘要 $(date +%Y%m%d)}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "================================"
echo "📦 CronHub 部署脚本"
echo "📅 提交时间: $(date)"
echo "📝 提交信息: $COMMIT_MSG"
echo "================================"

cd "$REPO_DIR"

echo ""
echo "🔍 检查 Git 状态..."
git status --short || true

echo ""
echo "➕ 添加变更到暂存区..."
git add -A

echo ""
echo "💾 执行 Git 提交..."
if git diff --cached --quiet; then
    echo "⚠️  无需要提交的变更"
else
    git commit -m "$COMMIT_MSG"
    echo "✅ 已提交到本地仓库"
fi

# 可选：推送到远程仓库（如果有配置 origin）
if git remote get-url origin >/dev/null 2>&1; then
    echo ""
    echo "🚀 推送至远程仓库 origin..."
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || echo "⚠️  无法推送（可能无网络或分支不存在）"
else
    echo ""
    echo "ℹ️  未配置远程仓库 origin，跳过推送"
fi

echo ""
echo "================================"
echo "🎉 部署流程结束"
echo "================================"
