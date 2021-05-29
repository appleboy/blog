---
title: '[FreeBSD] 取得 FreeBSD CVSUP 的更新狀態'
author: appleboy
type: post
date: 2009-08-31T06:30:01+00:00
url: /2009/08/freebsd-取得-freebsd-cvsup-的更新狀態/
views:
  - 6881
bot_views:
  - 653
dsq_thread_id:
  - 247270249
categories:
  - FreeBSD
  - Perl
  - php
tags:
  - FreeBSD
  - Perl
  - php

---
[<img src="https://i1.wp.com/farm3.static.flickr.com/2548/3873839724_f8dbe78179.jpg?resize=500%2C306&#038;ssl=1" title="FreeBSD CVS Site_1251699923593 (by appleboy46)" alt="FreeBSD CVS Site_1251699923593 (by appleboy46)" data-recalc-dims="1" />][1] 在 Sayya Joehorn 個人版看到有人實做出偵測台灣 CVSUP Server 更新狀態，以及更新的時間，也有程式碼的釋出，參考這篇：[Script: 取得 FreeBSD CVSUP 的更新狀態][2]，這篇寫的蠻清楚的，只需要 perl 跟 php 就可以完成，不過在使用過程有些事項必須要注意，在 FreeBSD 6.2 R 之後，已經內建了 [csup][3] 指令來更新 ports 或者是核心，所以要在另外安裝上 [cvsup][4] ports 套件，在 Perl 方面，也先裝 [net/p5-Net-Rendezvous][5] 才可以正確使用。 

<pre class="brush: bash; title: ; notranslate" title=""># 安裝必備軟體
cd /usr/ports/net/p5-Net-Rendezvous/ && make install clean
cd /usr/ports/net/cvsup-without-gui && make install clean</pre>

<!--more--> Perl 程式碼我有改過一些，不然沒辦法抓到正確資訊： 

<pre class="brush: perl; title: ; notranslate" title="">#!/usr/bin/perl
 
# Check the update status for CVSUP servers
# Copyright (C) 2007 - Shen Cheng-Da (cdsheen AT gmail.com)
# modified by appleboy (appleboy.tw AT gmail.com) 2009.08.31
 
use POSIX qw(strftime);
use Net::DNS;
use Time::HiRes qw( gettimeofday tv_interval );
 
@servers = qw( www.cn.ee.ccu.edu.tw cvsup.tw.freebsd.org cvsup1.tw.freebsd.org cvsup2.tw.freebsd.org 
                cvsup3.tw.freebsd.org cvsup4.tw.freebsd.org cvsup5.tw.freebsd.org 
                cvsup6.tw.freebsd.org cvsup7.tw.freebsd.org cvsup8.tw.freebsd.org 
                cvsup9.tw.freebsd.org cvsup10.tw.freebsd.org cvsup11.tw.freebsd.org 
                cvsup12.tw.freebsd.org cvsup13.tw.freebsd.org cvsup14.tw.freebsd.org );
 
$dir    = '/home/cvsup-monitor';
 
$cvsup  = '/usr/local/bin/cvsup';
$base   = $dir . '/base';
$log    = $dir . '/check.log';
 
chdir( $dir ) || die "ERROR: Can not change to directory [$dir]\n";
 
mkdir( $base, 0755 ) unless -d $base;
 
@files_src = qw( CVSROOT-src/commitlogs/CVSROOT CVSROOT-src/commitlogs/bin
                CVSROOT-src/commitlogs/etc CVSROOT-src/commitlogs/contrib
                CVSROOT-src/commitlogs/gnu CVSROOT-src/commitlogs/games
                CVSROOT-src/commitlogs/include CVSROOT-src/commitlogs/lib
                CVSROOT-src/commitlogs/release CVSROOT-src/commitlogs/sys
                CVSROOT-src/commitlogs/sbin CVSROOT-src/commitlogs/share
                CVSROOT-src/commitlogs/tools CVSROOT-src/commitlogs/user
                CVSROOT-src/commitlogs/usrbin CVSROOT-src/commitlogs/usrsbin );
 
@files_ports = qw( CVSROOT-ports/commitlogs/CVSROOT
                   CVSROOT-ports/commitlogs/ports);
 
$includes = '';
foreach $f ( @files_src ) {
        $includes .= " -i $f";
}
foreach $f ( @files_ports ) {
        $includes .= " -i $f";
}
 
open( LOG, ">$log");
 
my $resolver = Net::DNS::Resolver->new;
 
$resolver->usevc(1);
$resolver->udp_timeout(5);
$resolver->tcp_timeout(5);
$resolver->retrans(3);
$resolver->retry(2);
$resolver->persistent_tcp(1);
 
foreach $server ( @servers ) {
        my $query = $resolver->query($server, 'A');
        @ipaddr = @cname = ();
        if( $query ) {
                foreach $rr ($query->answer) {
                        if( $rr->type eq 'A' ) {
                                print LOG "$server => [A] ".$rr->address."\n";
                                push( @ipaddr, $rr->address );
                        }
                        elsif( $rr->type eq 'CNAME' ) {
                                print LOG "$server => [CNAME] ".$rr->cname."\n";
                                push( @cname, $rr->cname );
                        }
                }
        }
        $ip = $ipaddr[0];
        $ipaddr = join( '|', @ipaddr );
        $cname  = join( '|', @cname  );
 
        $ibase   = "$base/$server";
        mkdir( $ibase, 0755 ) unless -d $ibase;
        mkdir( "$ibase/SRC", 0755 ) unless -d "$ibase/SRC";
 
        $cmd = "$cvsup -b $ibase -h $ip -L 0 -r 0 $includes $dir/cvs-supfile";

        $time_start = [gettimeofday];
        system($cmd);
        $elapsed = tv_interval( $time_start );
        printf LOG ("$server => cvsup on $ip elapsed %.2fs\n", $elapsed);
 
        unless( $? ) {
                $mt_src = $mt_ports = 0;
                foreach $f ( @files_src ) {
                        $t = (stat( "$f" ))[9];
                        $mt_src = $t if $t > $mt_src;
                }
                foreach $f ( @files_ports ) {
                        $t = (stat( "$f" ))[9];
                        $mt_ports = $t if $t > $mt_ports;
                }
                open( REC, ">$ibase/last-commit.txt" );
                printf REC ("$mt_src,$mt_ports,%.2f,$ipaddr,$cname",$elapsed);
                close(REC);
 
                printf LOG ("$server => SRC: %s\n",
                        strftime("%Y/%m/%d %H:%M:%S", localtime($mt_src)) );
                printf LOG ("$server => PORTS: %s\n",
                        strftime("%Y/%m/%d %H:%M:%S", localtime($mt_ports)) );
        }
}
 
close(LOG);</pre> PHP 顯示部份，這邊就沒有動到，直接 copy 就可以 

<pre class="brush: php; title: ; notranslate" title="">




&lt;table border=1 cellspacing=0 cellpadding=2>


<tr>
  &lt;td class=head>Server Name&lt;/td>&lt;td class=head>IP&lt;/td>
  &lt;td class=head>CNAME&lt;/td>&lt;td class=head>latest commit of src&lt;/td>
  &lt;td class=head>latest commit of ports&lt;/td>
  
</tr>


<?
        $dir = '/usr/home/cvsup-monitor';
        $servers = array(
              'www.cn.ee.ccu.edu.tw', 'cvsup.tw.freebsd.org',  'cvsup1.tw.freebsd.org',  'cvsup2.tw.freebsd.org',
              'cvsup3.tw.freebsd.org', 'cvsup4.tw.freebsd.org', 'cvsup5.tw.freebsd.org',
              'cvsup6.tw.freebsd.org', 'cvsup7.tw.freebsd.org', 'cvsup8.tw.freebsd.org',
              'cvsup9.tw.freebsd.org', 'cvsup10.tw.freebsd.org', 'cvsup11.tw.freebsd.org',
              'cvsup12.tw.freebsd.org', 'cvsup13.tw.freebsd.org', 'cvsup14.tw.freebsd.org' );
        $check = time() - 86400;
        $time_format = '%Y/%m/%d %H:%M:%S';
        $latest_src = $latest_ports = 0;
        foreach( $servers as $server ) {
                $data = @file_get_contents("$dir/base/$server/last-commit.txt");
                $data = trim($data);
                if( $data != '' ) {
                        $SERVER[$server] = explode(',', $data);
                        if( $SERVER[$server][0] > $latest_src )
                                $latest_src = $SERVER[$server][0];
                        if( $SERVER[$server][1] > $latest_ports )
                                $latest_ports = $SERVER[$server][1];
                }
        }
        foreach( $servers as $server ) {
                if( is_array($SERVER[$server]) ) {
                        list( $src, $ports, $elapsed, $ipaddr, $aliases ) = $SERVER[$server];
                        $ipaddr = str_replace( '|', '

<br />', $ipaddr );
                        $aliases = str_replace( '|', '<br />', $aliases );
                        if( $aliases == '' )
                                $aliases = '&nbsp;';
                        print "

<tr>
  \n";
                          print "  &lt;td class=c>$server&lt;/td>\n";
                          print "  &lt;td class=c>$ipaddr&lt;/td>\n";
                          print "  &lt;td class=c>$aliases&lt;/td>\n";
                          if( $src == $latest_src )
                                  print "  &lt;td class=green>";
                          elseif( $src &lt; $check )
                                  print "  &lt;td class=red>";
                          else
                                  print "  &lt;td class=c>";
                          print strftime( $time_format, $src ) . "&lt;/td>\n";
                          if( $ports == $latest_ports )
                                  print "  &lt;td class=green>";
                          elseif( $ports &lt; $check )
                                  print "  &lt;td class=red>";
                          else
                                  print "  &lt;td class=c>";
                          print strftime( $time_format, $ports ) . "&lt;/td>\n";
  #                       print "  &lt;td align=right>$elapsed s&lt;/td>\n";
                          print "
</tr>\n";
                }
        }
?>
&lt;/table>

</pre>

 [1]: https://www.flickr.com/photos/appleboy/3873839724/ "FreeBSD CVS Site_1251699923593 (by appleboy46)"
 [2]: http://blog.urdada.net/2007/12/24/69/
 [3]: http://www.freshports.org/net/csup/
 [4]: http://www.freshports.org/net/cvsup/
 [5]: http://www.freshports.org/net/p5-Net-Rendezvous/