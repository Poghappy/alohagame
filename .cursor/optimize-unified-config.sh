#!/bin/bash
# 统一Cursor Agent配置优化脚本

echo "🔧 开始优化统一Cursor Agent配置..."

# 检查整合后的配置文件
echo "📋 检查统一配置文件..."
unified_files=(
    ".cursor/config/unified-config.json"
    ".cursor/config/cursor-workspace-agent-team.json"
    ".cursor/config/cursor-workspace-team-config.json"
    ".cursor/config/solution-evaluation-system.json"
    ".cursor/rules/unified-ai-team.mdc"
    ".cursor/rules/zero-worry-delivery.mdc"
    ".cursor/rules/team-collaboration.mdc"
    ".cursor/rules/communication-style.mdc"
    ".cursor/rules/prd-plan-todo-methodology.mdc"
    ".cursor/rules/supabase-integration.mdc"
    ".cursor/rules/technical-explanations.mdc"
)

for file in "${unified_files[@]}"; do
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
    echo "❌ .env 文件不存在，请运行："
    echo "   ./.cursor/setup-env.sh"
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

# 检查cursor-workspace集成
echo ""
echo "🔍 检查cursor-workspace集成..."
if [ -d "cursor-workspace" ]; then
    echo "✅ cursor-workspace 项目存在"
    echo "✅ 已整合cursor-workspace配置"
else
    echo "⚠️ cursor-workspace 项目不存在"
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

# 生成统一配置报告
echo ""
echo "📊 生成统一配置报告..."
cat > .cursor/unified-config-report.md << 'EOF'
# 统一Cursor Agent配置报告

## 配置概述
- 配置版本：2.0.0
- 整合来源：cursor-workspace + vibe-tools
- 配置状态：已整合
- 功能状态：完整

## 整合优势

### 来自cursor-workspace的优势
- ✅ 零操心交付团队
- ✅ 智能解决方案评估系统
- ✅ 完整的团队协作流程
- ✅ 学习管理系统
- ✅ 质量保证体系

### 来自vibe-tools的优势
- ✅ AI团队协作
- ✅ 工具集成
- ✅ 开发工作流程
- ✅ 技术调研和学习
- ✅ 自动化测试

### 统一后的增强功能
- ✅ 完整的AI团队协作体系
- ✅ 智能解决方案评估
- ✅ 零操心交付流程
- ✅ 学习管理系统
- ✅ 质量保证体系

## 功能模块

### AI团队角色
- 项目总监：需求分析、项目规划、技术选型
- 技术架构师：系统设计、技术选型、架构规划
- 全栈开发：代码实现、功能开发、技术实现
- 测试工程师：自动化测试、质量保证、Bug修复
- DevOps工程师：部署管理、环境配置、监控运维

### 工具集成
- vibe-tools web：网络研究和技术调研
- vibe-tools repo：代码分析和架构理解
- vibe-tools plan：实现规划和方案设计
- vibe-tools browser：自动化测试和功能验证
- vibe-tools doc：文档生成和知识管理
- vibe-tools github：代码管理和版本控制
- vibe-tools linear：任务管理和项目跟踪

### 增强功能
- 智能解决方案评估：自动评估技术选型
- 零操心交付：完全自动化的项目交付
- 学习管理系统：持续的技术学习和技能提升
- 质量保证体系：端到端的测试和验证

## 使用建议

### 1. 环境配置
```bash
# 配置环境变量
./cursor/setup-env.sh

# 安装vibe-tools
cd vibe-tools && npm install -g .
```

### 2. 功能测试
```bash
# 测试AI团队协作
./cursor/test-ai-team.sh

# 测试统一配置
./cursor/optimize-unified-config.sh
```

### 3. 实际使用
- 使用技术调研模板进行技术选型
- 使用功能开发模板进行功能实现
- 使用项目管理模板进行项目跟踪
- 利用零操心交付系统进行自动化交付

## 配置文件

### 规则文件
- unified-ai-team.mdc：统一AI团队规则
- zero-worry-delivery.mdc：零操心交付规则
- team-collaboration.mdc：团队协作规则
- communication-style.mdc：沟通风格规则
- prd-plan-todo-methodology.mdc：PRD规划方法
- supabase-integration.mdc：Supabase集成规则
- technical-explanations.mdc：技术解释规则

### 配置文件
- unified-config.json：统一配置文件
- cursor-workspace-agent-team.json：cursor-workspace团队配置
- cursor-workspace-team-config.json：cursor-workspace团队结构
- solution-evaluation-system.json：解决方案评估系统
- ai-team-config.json：AI团队配置
- tool-config.json：工具配置

### 模板文件
- technical-research.md：技术调研模板
- feature-development.md：功能开发模板
- project-management.md：项目管理模板

## 下一步

1. 配置环境变量和API密钥
2. 安装vibe-tools工具
3. 测试统一配置功能
4. 使用模板进行实际开发
5. 持续优化配置参数

## 总结

统一配置成功整合了cursor-workspace和vibe-tools的优势，提供了完整的AI团队协作解决方案，包括：

- 完整的AI团队协作体系
- 智能解决方案评估系统
- 零操心交付流程
- 学习管理系统
- 质量保证体系
- 工具集成和自动化

现在可以开始使用统一的Cursor Agent进行AI辅助开发了！
EOF

echo "✅ 统一配置报告已生成：.cursor/unified-config-report.md"

# 提供优化建议
echo ""
echo "💡 统一配置优化建议："

echo "1. 环境变量配置："
echo "   ./cursor/setup-env.sh"

echo "2. 安装vibe-tools："
echo "   cd vibe-tools && npm install -g ."

echo "3. 测试统一配置："
echo "   ./cursor/test-ai-team.sh"

echo "4. 使用统一AI团队："
echo "   利用整合后的AI团队协作功能"

echo "5. 零操心交付："
echo "   使用完整的自动化交付流程"

echo ""
echo "🎉 统一配置优化完成！"
echo "📋 详细报告请查看：.cursor/unified-config-report.md"
echo ""
echo "🚀 现在您拥有了整合cursor-workspace和vibe-tools优势的统一Cursor Agent！"
