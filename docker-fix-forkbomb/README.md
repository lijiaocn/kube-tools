---
layout: default
title: README
author: lijiaocn
createdate: 2017/07/27 17:06:48
changedate: 2017/07/31 14:34:50

---

* auto-gen TOC:
{:toc}

## 说明

设置每个容器的pids上限，防止forkbomb。

通过设置每个容器的cgroup实现，docker的cgroup driver不同，容器的cgroup目录位置可能不同。

[Add pids-limit support in docker update][1]给docker增加了--pids-limit参数，但是还没有被merge。2017-07-27 17:18:36

代码合入以后，可以通过`--pids-limit`参数限制。

## 参考

1. [Add pids-limit support in docker update][1]

[1]:  https://github.com/moby/moby/pull/32519   "Add pids-limit support in docker update" 
