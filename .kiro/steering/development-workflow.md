---
inclusion: always
---

# 开发工作流程规则

## 标准开发流程

### 1. 需求分析阶段
- **项目总监** 使用 `vibe-tools web` 进行市场调研和技术趋势分析
- **技术架构师** 使用 `vibe-tools repo` 分析现有技术栈和架构
- **全栈开发** 使用 `vibe-tools plan` 制定技术实现方案
- **测试工程师** 使用 `vibe-tools browser` 设计测试方案
- **DevOps工程师** 使用 `vibe-tools github` 配置项目环境

### 2. 设计阶段
- **技术架构师** 使用 `vibe-tools repo` 设计系统架构
- **全栈开发** 使用 `vibe-tools plan` 制定实现计划
- **测试工程师** 使用 `vibe-tools browser` 设计测试方案
- **项目总监** 使用 `vibe-tools doc` 生成设计文档

### 3. 开发阶段
- **全栈开发** 使用 `vibe-tools repo` 进行代码开发
- **测试工程师** 使用 `vibe-tools browser` 进行自动化测试
- **技术架构师** 使用 `vibe-tools repo` 进行代码审查
- **DevOps工程师** 使用 `vibe-tools github` 管理代码仓库

### 4. 测试阶段
- **测试工程师** 使用 `vibe-tools browser` 进行端到端测试
- **全栈开发** 使用 `vibe-tools repo` 修复Bug和优化代码
- **技术架构师** 使用 `vibe-tools repo` 进行性能优化
- **项目总监** 使用 `vibe-tools doc` 生成测试报告

### 5. 部署阶段
- **DevOps工程师** 使用 `vibe-tools github` 管理部署流程
- **测试工程师** 使用 `vibe-tools browser` 进行生产环境测试
- **项目总监** 使用 `vibe-tools linear` 跟踪项目进度
- **技术架构师** 使用 `vibe-tools doc` 生成部署文档

## 质量保证流程

### 代码质量
- 使用 `vibe-tools repo` 进行代码分析和审查
- 使用 `vibe-tools plan` 制定代码规范和质量标准
- 使用 `vibe-tools doc` 生成代码文档和注释

### 测试质量
- 使用 `vibe-tools browser` 进行自动化测试
- 使用 `vibe-tools test` 进行单元测试和集成测试
- 使用 `vibe-tools repo` 进行代码覆盖率分析

### 文档质量
- 使用 `vibe-tools doc` 生成技术文档
- 使用 `vibe-tools web` 研究最佳实践
- 使用 `vibe-tools repo` 分析文档结构

## 最佳实践

### 技术调研
- 始终使用 `vibe-tools web` 进行技术调研
- 使用 `vibe-tools repo` 分析现有代码库
- 使用 `vibe-tools plan` 制定技术方案

### 代码开发
- 使用 `vibe-tools repo` 分析代码结构
- 使用 `vibe-tools plan` 制定实现计划
- 使用 `vibe-tools browser` 进行功能测试

### 项目管理
- 使用 `vibe-tools github` 管理代码仓库
- 使用 `vibe-tools linear` 管理任务和项目
- 使用 `vibe-tools doc` 生成项目文档

## 工作流程示例

### 新功能开发
```bash
# 1. 需求分析
vibe-tools web "用户认证功能的最佳实践和安全性要求"

# 2. 架构设计
vibe-tools repo "分析现有项目的认证架构，设计新的认证方案"

# 3. 实现规划
vibe-tools plan "实现用户认证功能，包括登录、注册、密码重置"

# 4. 代码开发
vibe-tools repo "分析认证功能的代码实现"

# 5. 功能测试
vibe-tools browser "测试用户认证功能，包括正常登录和异常情况"

# 6. 代码管理
vibe-tools github "创建认证功能的Pull Request"

# 7. 文档生成
vibe-tools doc "生成用户认证功能的API文档"
```

### Bug修复流程
```bash
# 1. 问题发现
vibe-tools browser "复现用户报告的登录问题"

# 2. 问题分析
vibe-tools repo "分析登录功能的代码，找出问题根源"

# 3. 修复方案
vibe-tools plan "制定Bug修复方案，包括代码修改和测试验证"

# 4. 修复实现
vibe-tools repo "修复登录Bug，优化代码实现"

# 5. 验证修复
vibe-tools browser "验证Bug修复效果，确保功能正常"

# 6. 代码提交
vibe-tools github "提交Bug修复的代码变更"

# 7. 文档更新
vibe-tools doc "更新相关文档，记录Bug修复过程"
```

### 性能优化流程
```bash
# 1. 性能分析
vibe-tools repo "分析应用性能瓶颈，识别优化点"

# 2. 优化研究
vibe-tools web "研究应用性能优化的最佳实践"

# 3. 优化方案
vibe-tools plan "制定性能优化方案，包括代码优化和架构调整"

# 4. 优化实现
vibe-tools repo "实现性能优化，包括代码重构和缓存优化"

# 5. 性能测试
vibe-tools browser "测试优化后的性能表现"

# 6. 监控部署
vibe-tools github "部署性能优化版本，配置监控"

# 7. 效果评估
vibe-tools doc "生成性能优化报告，记录优化效果"
```

## 工具使用原则

### 网络研究
- 使用 `vibe-tools web` 进行技术调研和竞品分析
- 适用于：技术选型、最新趋势研究、解决方案搜索

### 代码分析
- 使用 `vibe-tools repo` 进行代码库分析和理解
- 适用于：架构分析、代码审查、技术债务评估

### 实现规划
- 使用 `vibe-tools plan` 制定实现方案和开发计划
- 适用于：功能规划、技术方案设计、开发计划

### 自动化测试
- 使用 `vibe-tools browser` 进行自动化测试和操作
- 适用于：端到端测试、用户界面测试、功能验证

### 文档生成
- 使用 `vibe-tools doc` 生成技术文档和API文档
- 适用于：API文档、技术文档、项目文档

### 项目管理
- 使用 `vibe-tools github` 管理代码仓库和部署
- 使用 `vibe-tools linear` 管理任务和项目进度
- 适用于：代码管理、任务跟踪、团队协作