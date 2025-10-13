import type { NextConfig } from "next";
import dotenv from "dotenv";

dotenv.config();

const nextConfig: NextConfig = {
  transpilePackages: ["@bytebot/shared"],
  experimental: {
    turbo: {
      // 启用Turbopack以提升开发性能
      rules: {
        // 可以在这里添加自定义规则
      },
    },
  },
};

export default nextConfig;
