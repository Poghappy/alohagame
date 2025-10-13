#!/bin/bash
# Cursor Agent 环境变量设置脚本

echo "🚀 设置Cursor Agent环境变量..."

# 检查是否存在.env文件
if [ ! -f ".env" ]; then
    echo "📝 创建.env文件..."
    cp .cursor/env.example .env
    echo "✅ .env文件已创建，请编辑并填入您的API密钥"
    echo "📋 需要配置的API密钥："
    echo "   - OPENAI_API_KEY (必需)"
    echo "   - ANTHROPIC_API_KEY (必需)"
    echo "   - GEMINI_API_KEY (必需)"
    echo "   - PERPLEXITY_API_KEY (必需)"
    echo "   - GITHUB_TOKEN (可选)"
    echo "   - LINEAR_API_KEY (可选)"
    echo ""
    echo "🔧 编辑.env文件："
    echo "   nano .env"
    echo "   或"
    echo "   code .env"
    exit 1
fi

# 加载环境变量
echo "📥 加载环境变量..."
source .env

# 验证必需的API密钥
echo "🔍 验证API密钥..."

missing_keys=()

if [ -z "$OPENAI_API_KEY" ] || [ "$OPENAI_API_KEY" = "your_openai_api_key_here" ]; then
    missing_keys+=("OPENAI_API_KEY")
fi

if [ -z "$ANTHROPIC_API_KEY" ] || [ "$ANTHROPIC_API_KEY" = "your_anthropic_api_key_here" ]; then
    missing_keys+=("ANTHROPIC_API_KEY")
fi

if [ -z "$GEMINI_API_KEY" ] || [ "$GEMINI_API_KEY" = "your_gemini_api_key_here" ]; then
    missing_keys+=("GEMINI_API_KEY")
fi

if [ -z "$PERPLEXITY_API_KEY" ] || [ "$PERPLEXITY_API_KEY" = "your_perplexity_api_key_here" ]; then
    missing_keys+=("PERPLEXITY_API_KEY")
fi

if [ ${#missing_keys[@]} -gt 0 ]; then
    echo "❌ 缺少必需的API密钥："
    for key in "${missing_keys[@]}"; do
        echo "   - $key"
    done
    echo ""
    echo "🔧 请编辑.env文件并填入正确的API密钥："
    echo "   nano .env"
    exit 1
fi

echo "✅ 所有必需的API密钥已配置"

# 验证可选API密钥
echo "🔍 检查可选API密钥..."
optional_keys=("GITHUB_TOKEN" "LINEAR_API_KEY" "BROWSERBASE_API_KEY")
for key in "${optional_keys[@]}"; do
    if [ -n "${!key}" ] && [ "${!key}" != "your_${key,,}_here" ]; then
        echo "✅ $key 已配置"
    else
        echo "⚠️  $key 未配置（可选）"
    fi
done

echo ""
echo "🎉 环境变量配置完成！"
echo "📋 配置摘要："
echo "   - OpenAI: ✅"
echo "   - Anthropic: ✅"
echo "   - Gemini: ✅"
echo "   - Perplexity: ✅"
echo "   - GitHub: $([ -n "$GITHUB_TOKEN" ] && echo "✅" || echo "⚠️ 可选")"
echo "   - Linear: $([ -n "$LINEAR_API_KEY" ] && echo "✅" || echo "⚠️ 可选")"
echo ""
echo "🚀 现在可以使用Cursor Agent的AI团队协作功能了！"
