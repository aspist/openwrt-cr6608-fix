# OpenWrt CR6608 云编译（含 MT7530 ARL 修复）

为小米 CR6608 路由器编译自定义 OpenWrt 固件，修复 MT7530 交换芯片端口间转发失败的问题。

## 修复内容

这个固件包含一个内核补丁，修复了 MT7530 DSA 驱动的三个问题：

1. **添加 `port_fast_age` 回调** — DSA 框架在端口离开 bridge 时可以刷新 ARL 表
2. **修复 AGE_CNT 老化 bug** — `mt7530_set_ageing_time()` 从 `tmp_age_count=1` 开始搜索，防止条目永不过期
3. **设置 `ageing_time_min/max`** — 让 DSA 核心验证老化时间范围

## 使用方法

### 1. 创建 GitHub 仓库

把本目录所有文件上传到一个新的 GitHub 仓库（公开仓库，GitHub Actions 免费额度足够）。

### 2. 触发编译

- 进入仓库的 **Actions** 页面
- 选择 **"Build OpenWrt for CR6608"** 工作流
- 点击 **"Run workflow"**

### 3. 下载固件

编译大约需要 2-3 小时。完成后：
- 在 Actions 运行页面底部 **Artifacts** 区域下载固件
- 文件名类似 `openwrt-cr6608-mt7530-fix.zip`

### 4. 刷入固件

解压后，使用 `sysupgrade` 镜像：
```
sysupgrade.bin
```

通过 LuCI 界面（系统 → 备份/刷机）或命令行刷入。

## 文件说明

| 文件 | 作用 |
|------|------|
| `.github/workflows/build.yml` | GitHub Actions 编译工作流 |
| `patches/999-mt7530-arl-fix.patch` | MT7530 ARL/ATU 修复补丁 |
| `diy.sh` | 应用补丁的脚本 |

## 验证修复

刷入后，验证端口间转发：
- 设备重启后，从其他端口 ping 该设备应该能通
- 不再需要交换网线插头来恢复连接

如果仍然有问题，可以临时使用 ARL flush：
```bash
mdio mt7530* phy 0x1f raw 0x1f 0x0002
mdio mt7530* phy 0x1f raw 8 0x0009/0xffff
```
