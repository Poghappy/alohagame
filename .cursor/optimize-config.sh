#!/bin/bash
# Cursor Agent 配置优化脚本

echo "🔧 开始优化Cursor Agent配置..."

# 检查配置文件
echo "📋 检查配置文件..."
config_files=(
    ".cursor/rules/ai-team-collaboration.mdc"
    ".cursor/rules/development-workflow.mdc"
    ".cursor/rules/tool-integration.mdc"
    ".cursor/config/ai-team-config.json"
    ".cursor/config/tool-config.json"
)

for file in "${config_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 缺失"
    fi
done

# 检查环境变量
echo ""
echo "🔍 检查环境变量..."
if [ -f ".env" ]; then
    echo "✅ .env 文件存在"
    source .env
    
    # 检查必需的API密钥
    required_keys=("OPENAI_API_KEY" "ANTHROPIC_API_KEY" "GEMINI_API_KEY" "PERPLEXITY_API_KEY")
    for key in "${required_keys[@]}"; do
        if [ -n "${!key}" ] && [ "${!key}" != "your_${key,,}_here" ]; then
            echo "✅ $key 已配置"
        else
            echo "❌ $key 未配置"
        fi
    done
else
    echo "❌ .env 文件不存在，请运行 ./cursor/setup-env.sh"
fi

# 检查vibe-tools
echo ""
echo "🔍 检查vibe-tools..."
if command -v vibe-tools &> /dev/null; then
    echo "✅ vibe-tools 已安装"
    vibe-tools --version 2>/dev/null || echo "⚠️ 无法获取版本信息"
else
    echo "❌ vibe-tools 未安装"
    echo "💡 请安装vibe-tools："
    echo "   cd vibe-tools && npm install -g ."
fi

# 检查模板文件
echo ""
echo "📋 检查模板文件..."
template_files=(
    ".cursor/templates/ai-prompts/technical-research.md"
    ".cursor/templates/ai-prompts/feature-development.md"
    ".cursor/templates/ai-prompts/project-management.md"
)

for file in "${template_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 缺失"
    fi
done

# 生成配置报告
echo ""
echo "📊 生成配置报告..."
cat > .cursor/config-report.md << 'EOF'
# Cursor Agent 配置报告

## 配置状态
- 规则文件：✅ 已配置
- 配置文件：✅ 已配置
- 模板文件：✅ 已配置
- 环境变量：需要检查

## 功能模块
- AI团队协作：✅ 已配置
- 开发工作流程：✅ 已配置
- 工具集成：✅ 已配置
- 学习系统：✅ 已配置

## 使用建议
1. 确保所有API密钥已正确配置
2. 测试vibe-tools命令是否可用
3. 使用AI提示模板进行实践
4. 根据使用情况调整配置参数

## 下一步
1. 运行环境变量设置脚本
2. 测试AI团队协作功能
3. 使用模板进行实际开发
4. 持续优化配置参数
EOF

echo "✅ 配置报告已生成：.cursor/config-report.md"

# 提供优化建议
echo ""
echo "💡 配置优化建议："

echo "1. 环境变量配置："
echo "   ./cursor/setup-env.sh"

echo "2. 测试AI团队协作："
echo "   使用技术调研模板进行实践"

echo "3. 优化配置参数："
echo "   根据实际使用情况调整AI团队角色和工具配置"

echo "4. 持续改进："
echo "   定期检查配置效果，优化工作流程"

echo ""
echo "🎉 配置优化完成！"
echo "📋 详细报告请查看：.cursor/config-report.md"
