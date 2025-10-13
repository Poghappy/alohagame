#!/usr/bin/env node

/**
 * Logo 更换脚本
 * 安全地更换 logo 文件，避免水合错误
 */

const fs = require('fs');
const path = require('path');

// 配置
const config = {
  // 当前 logo 文件
  currentLogos: {
    dark: '/alohagamebot_transparent_logo_white.svg',
    light: '/alohagamebot_transparent_logo_dark.svg'
  },
  // 新 logo 文件（需要替换）
  newLogos: {
    dark: '/new-logo-white.svg',
    light: '/new-logo-dark.svg'
  },
  // 需要更新的文件
  filesToUpdate: [
    'src/components/layout/HeaderSSR.tsx',
    'src/components/layout/Logo.tsx'
  ]
};

function backupFiles() {
  console.log('📦 创建备份文件...');
  
  config.filesToUpdate.forEach(file => {
    const filePath = path.join(__dirname, '..', file);
    const backupPath = `${filePath}.backup.${Date.now()}`;
    
    if (fs.existsSync(filePath)) {
      fs.copyFileSync(filePath, backupPath);
      console.log(`✅ 已备份: ${file} -> ${path.basename(backupPath)}`);
    }
  });
}

function updateLogoFiles() {
  console.log('🔄 更新 logo 文件路径...');
  
  config.filesToUpdate.forEach(file => {
    const filePath = path.join(__dirname, '..', file);
    
    if (fs.existsSync(filePath)) {
      let content = fs.readFileSync(filePath, 'utf8');
      
      // 替换 logo 路径
      content = content.replace(
        config.currentLogos.dark,
        config.newLogos.dark
      );
      content = content.replace(
        config.currentLogos.light,
        config.newLogos.light
      );
      
      fs.writeFileSync(filePath, content);
      console.log(`✅ 已更新: ${file}`);
    }
  });
}

function validateChanges() {
  console.log('🔍 验证更改...');
  
  let hasErrors = false;
  
  config.filesToUpdate.forEach(file => {
    const filePath = path.join(__dirname, '..', file);
    
    if (fs.existsSync(filePath)) {
      const content = fs.readFileSync(filePath, 'utf8');
      
      // 检查是否还有旧的 logo 路径
      if (content.includes(config.currentLogos.dark) || 
          content.includes(config.currentLogos.light)) {
        console.log(`❌ ${file} 中仍有旧的 logo 路径`);
        hasErrors = true;
      }
      
      // 检查是否有 suppressHydrationWarning
      if (content.includes('suppressHydrationWarning')) {
        console.log(`✅ ${file} 包含水合错误防护`);
      }
      
      // 检查是否有条件渲染
      if (content.includes('mounted') && content.includes('useState')) {
        console.log(`✅ ${file} 使用条件渲染`);
      }
    }
  });
  
  if (hasErrors) {
    console.log('❌ 验证失败，请检查文件内容');
    process.exit(1);
  }
  
  console.log('✅ 所有验证通过');
}

function showNextSteps() {
  console.log('\n🎯 下一步操作:');
  console.log('1. 将新的 logo 文件放到 public 目录');
  console.log('2. 运行 npm run dev 测试');
  console.log('3. 检查浏览器控制台是否有水合错误');
  console.log('4. 测试深色和浅色主题');
  console.log('5. 如有问题，使用备份文件回滚');
  
  console.log('\n📋 测试清单:');
  console.log('- [ ] 深色主题 logo 显示正确');
  console.log('- [ ] 浅色主题 logo 显示正确');
  console.log('- [ ] 主题切换时 logo 更新');
  console.log('- [ ] 无水合错误');
  console.log('- [ ] 页面加载正常');
}

// 主函数
function main() {
  console.log('🎨 Logo 更换脚本启动...\n');
  
  try {
    backupFiles();
    updateLogoFiles();
    validateChanges();
    showNextSteps();
    
    console.log('\n✅ Logo 更换完成！');
  } catch (error) {
    console.error('❌ 错误:', error.message);
    process.exit(1);
  }
}

// 运行脚本
if (require.main === module) {
  main();
}

module.exports = { config, backupFiles, updateLogoFiles, validateChanges };