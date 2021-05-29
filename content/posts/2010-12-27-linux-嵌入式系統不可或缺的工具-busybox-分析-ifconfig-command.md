---
title: '[Linux] 嵌入式系統不可或缺的工具 – busybox 分析 ifconfig command'
author: appleboy
type: post
date: 2010-12-26T16:08:07+00:00
url: /2010/12/linux-嵌入式系統不可或缺的工具-busybox-分析-ifconfig-command/
views:
  - 1859
bot_views:
  - 242
dsq_thread_id:
  - 246868405
categories:
  - C/C++
  - Embedded System
  - Linux
tags:
  - Busybox
  - Embedded System
  - Linux

---
<img src="https://i1.wp.com/www.busybox.net/images/busybox1.png?w=840" alt="Busybox" data-recalc-dims="1" /> 

玩過嵌入式系統的使用者，一定都會知道 [Busybox][1]，它提供一些小型 Linux command，方便在 console 端使用，以及一些 C 語言或者是 shell script 裡面，大家都知道 ifconfig 這指令，為了從 Kernel 2.6.15 轉換到 2.6.34.7 版本，原本的 Busybox 版本只有 1.0.1，現在已經到 1.18.1，轉換過程改了 Kernel [netfilter][2] 部份，以及 user space 部份 [iptables extension][3]。ifconfig 是 Busybox 其中一個指令用來查看目前有多少網路介面(network interface)，來看看他是如何得到這些 interface 資訊，包含介面名稱、type、IP Adress、IP network mask、HW address 等....。

要讀取 interface 相關資訊可以透過兩種方式，一種是讀取 (IPv6 是 /proc/net/if\_inet6)，另一種透過 Socket 連接SOCK\_DGRAM，最後用 iotcl 方式讀取 interface 相關資料，busybox 會先偵測檔案 /proc/net/dev 是否存在，如果 Kernel 有支援，就會讀取此檔案，如果不存在，則利用 socket 讀取資料。

if\_readlist\_proc 函式裡面:

```c
fh = fopen_or_warn(_PATH_PROCNET_DEV, "r");
if (!fh) {
    return if_readconf();
}
```

看一下 /proc/net/dev 內容

```bash
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    lo:     104       1    0    0    0     0          0         0      104       1    0    0    0     0       0          0
  eth0:21798505   51360    0    0    0     0          0         0  7693686   46844    0    0    0     0       0          0
```

<!--more-->

首先濾掉前兩行不需要的資料，在利用 get_name 函式抓取 lo 跟 eth0 interface

```c
fgets(buf, sizeof buf, fh); /* eat line */
fgets(buf, sizeof buf, fh);

procnetdev_vsn = procnetdev_version(buf);

err = 0;
while (fgets(buf, sizeof buf, fh)) {
    char *s, name[128];
    s = get_name(name, buf);
    ife = add_interface(name);
    get_dev_fields(s, ife, procnetdev_vsn);
    ife->statistics_valid = 1;
    if (target && !strcmp(target, name))
        break;
}
```

get_name 直接濾掉每行冒號 : 後面的資料，並且將其加入 interface structure 雙向 link list

```c
static char *get_name(char *name, char *p)
{
    /* Extract <name> from nul-terminated p where p matches
     * <name>: after leading whitespace.
     * If match is not made, set name empty and return unchanged p
     */
    char *nameend;
    char *namestart = skip_whitespace(p);

    nameend = namestart;
    while (*nameend && *nameend != ':' && !isspace(*nameend))
        nameend++;
    if (*nameend == ':') {
        if ((nameend - namestart) < IFNAMSIZ) {
            memcpy(name, namestart, nameend - namestart);
            name[nameend - namestart] = '\0';
            p = nameend;
        } else {
            /* Interface name too large */
            name[0] = '\0';
        }
    } else {
        /* trailing ':' not found - return empty */
        name[0] = '\0';
    }
    return p + 1;
}
```

add_interface 將 network interface 加入 link list

```c
static struct interface *add_interface(char *name)
{
    struct interface *ife, **nextp, *new;

    for (ife = int_last; ife; ife = ife->prev) {
        int n = /*n*/strcmp(ife->name, name);

        if (n == 0)
            return ife;
        if (n < 0)
            break;
    }

    new = xzalloc(sizeof(*new));
    strncpy_IFNAMSIZ(new->name, name);
    nextp = ife ? &ife->next : &int_list;
    new->prev = ife;
    new->next = *nextp;
    if (new->next)
        new->next->prev = new;
    else
        int_last = new;
    *nextp = new;
    return new;
}
```

最後將 /proc/net/dev 剩餘資訊利用 get\_dev\_fields 讀取 sscanf

```c
static void get_dev_fields(char *bp, struct interface *ife, int procnetdev_vsn)
{
    memset(&ife->stats, 0, sizeof(struct user_net_device_stats));

    sscanf(bp, ss_fmt[procnetdev_vsn],
           &ife->stats.rx_bytes, /* missing for 0 */
           &ife->stats.rx_packets,
           &ife->stats.rx_errors,
           &ife->stats.rx_dropped,
           &ife->stats.rx_fifo_errors,
           &ife->stats.rx_frame_errors,
           &ife->stats.rx_compressed, /* missing for <= 1 */
           &ife->stats.rx_multicast, /* missing for <= 1 */
           &ife->stats.tx_bytes, /* missing for 0 */
           &ife->stats.tx_packets,
           &ife->stats.tx_errors,
           &ife->stats.tx_dropped,
           &ife->stats.tx_fifo_errors,
           &ife->stats.collisions,
           &ife->stats.tx_carrier_errors,
           &ife->stats.tx_compressed /* missing for <= 1 */
           );

    if (procnetdev_vsn <= 1) {
        if (procnetdev_vsn == 0) {
            ife->stats.rx_bytes = 0;
            ife->stats.tx_bytes = 0;
        }
        ife->stats.rx_multicast = 0;
        ife->stats.rx_compressed = 0;
        ife->stats.tx_compressed = 0;
    }
}
```

另外要得到 IP Address 資訊，就必須用 if_fetch 函式，透過 ioctl 進行讀取

```c
/* Fetch the interface configuration from the kernel. */
static int if_fetch(struct interface *ife)
{
    struct ifreq ifr;
    char *ifname = ife->name;
    int skfd;

    skfd = xsocket(AF_INET, SOCK_DGRAM, 0);

    strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
    if (ioctl(skfd, SIOCGIFFLAGS, &ifr) < 0) {
        close(skfd);
        return -1;
    }
    ife->flags = ifr.ifr_flags;

    strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
    memset(ife->hwaddr, 0, 32);
    if (ioctl(skfd, SIOCGIFHWADDR, &ifr) >= 0)
        memcpy(ife->hwaddr, ifr.ifr_hwaddr.sa_data, 8);

    ife->type = ifr.ifr_hwaddr.sa_family;

    strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
    ife->metric = 0;
    if (ioctl(skfd, SIOCGIFMETRIC, &ifr) >= 0)
        ife->metric = ifr.ifr_metric;

    strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
    ife->mtu = 0;
    if (ioctl(skfd, SIOCGIFMTU, &ifr) >= 0)
        ife->mtu = ifr.ifr_mtu;

    memset(&ife->map, 0, sizeof(struct ifmap));
#ifdef SIOCGIFMAP
    strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
    if (ioctl(skfd, SIOCGIFMAP, &ifr) == 0)
        ife->map = ifr.ifr_map;
#endif

#ifdef HAVE_TXQUEUELEN
    strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
    ife->tx_queue_len = -1;  /* unknown value */
    if (ioctl(skfd, SIOCGIFTXQLEN, &ifr) >= 0)
        ife->tx_queue_len = ifr.ifr_qlen;
#else
    ife->tx_queue_len = -1;  /* unknown value */
#endif

    strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
    ifr.ifr_addr.sa_family = AF_INET;
    memset(&ife->addr, 0, sizeof(struct sockaddr));
    if (ioctl(skfd, SIOCGIFADDR, &ifr) == 0) {
        ife->has_ip = 1;
        ife->addr = ifr.ifr_addr;
        strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
        memset(&ife->dstaddr, 0, sizeof(struct sockaddr));
        if (ioctl(skfd, SIOCGIFDSTADDR, &ifr) >= 0)
            ife->dstaddr = ifr.ifr_dstaddr;

        strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
        memset(&ife->broadaddr, 0, sizeof(struct sockaddr));
        if (ioctl(skfd, SIOCGIFBRDADDR, &ifr) >= 0)
            ife->broadaddr = ifr.ifr_broadaddr;

        strncpy_IFNAMSIZ(ifr.ifr_name, ifname);
        memset(&ife->netmask, 0, sizeof(struct sockaddr));
        if (ioctl(skfd, SIOCGIFNETMASK, &ifr) >= 0)
            ife->netmask = ifr.ifr_netmask;
    }

    close(skfd);
    return 0;
}
```

以上就是執行 ifconfig command 的流程，如果有任何問題可以直接留言 ^^

 [1]: http://zh.wikipedia.org/zh-tw/BusyBox
 [2]: http://www.netfilter.org/
 [3]: http://netfilter.org/documentation/HOWTO/netfilter-extensions-HOWTO.html