#!/usr/bin/perl
use File::Basename;
use FindBin '$Bin';
use strict;
use warnings;
use Term::ANSIColor;
use URI::Escape;
use HTML::Entities;
use HTTP::Request::Common;
use Digest::MD5;
use MIME::Base64;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
######################################################################################################################################################################################################
## LICENSE   #########################################################################################################################################################################################
#   This software is Copyright (c) 2015 Alisam Technology
#   Tool coded by Ali Mehdioui founder of Alisam Technology.
#
#   This is free software, licensed under:
#   The Artistic License 2.0
#   The Artistic License
#   Copyright (c) 2000-2006, The Perl Foundation.
######################################################################################################################################################################################################
## INTRODUCTION #######################################################################################################################################################################################
#   This script is Copyright (c) 2015 Alisam Technology
#   Tool coded by Ali Mehdioui.
#   Script name: Atscan Scanner.
#   Codename: Anon4t.
#   Works in linux platforms. Best Run on Ubuntu 14.04, Kali Linux 2.0, Arch Linux, Fedora Linux, Centos..
#   Windows with perl required!
######################################################################################################################################################################################################
## DESCRIPTION #######################################################################################################################################################################################
#   ATSCAN Scanner
#   Tool to scan engines, dorks and sites for commune errors and vulnerabilities.
#   Search engine 
#   XSS scanner. 
#   LFI / ADF scanner.
#   Filter wordpress and Joomla sites in the server. 
#   Find Admin page.
#   Decode / Encode MD5 + Base64.
#   Ports scan. 
#   Scan E-mails in sites. 
#   Use proxy. 
#   Random user agent. 
#   Random proxy. 
#   Scan errors. 
#   Detect Cms.
#   Multiple instant scan. 
#   Extern commands execution.
#   Disponible on BlackArch Linux Platform.
#
#   [::] AUTOR:        Alisam Technology - MEZGUIDA DEVELOPERS --
#   [::] FB:           https://facebook.com/Forces.des.tempetes.marocaines
#   [::] Twitter:      https://twitter.com/AlisamTechno
#   [::] Pastebin      http://http://pastebin.com/u/Alisam_Technology
#   [::] GIT:          https://github.com/AlisamTechnology
#   [::] YOUTUBE:      http://youtube.com/c/AlisamTechnology
#
######################################################################################################################################################################################################
## REQUIREMENT  ######################################################################################################################################################################################
# Requiered libreries
# apt-get install libxml-simple-perl
######################################################################################################################################################################################################
######################################################################################################################################################################################################
#### CHECK INC DIR ###################################################################################################################################################################################
## CHECK INC DIR
if (!-d $Bin."/inc") {
  print "[!] Downoloading components Please wait..\n";
  system("git clone https://github.com/AlisamTechnology/ATSCAN.git $Bin/atscan_update");
  ###if (-e "$Bin/atscan.pl") {
   # system("chmod +x $Bin/atscan.pl");
   # unlink "$Bin/atscan.pl";
 # }
  dircopy("$Bin/atscan_update", $Bin);
  system "rm -rf $Bin/atscan_update"; 
  if (!-d "$Bin/inc") { print "\n[!] Cannot connect to the server!\n"; exit(); }
  system("chmod +x $Bin/atscan.pl | perl $Bin/atscan.pl --update || atscan --update");
  exit();
}
######################################################################################################################################################################################################
## ALL ARRAYS ########################################################################################################################################################################################
our (@c, @XSS, @LFI, @RFI, @ADFWP, @ADMIN, @SUBDOMAIN, @UPLOAD, @ZIP, @TT, @OTHERS, @AUTH, @ErrT, @DT, @DS, @cms, @SCAN_TITLE, @E_MICROSOFT, @E_ORACLE, @E_DB2, @E_ODBC, @E_POSTGRESQL, @E_SYBASE,
     @E_JBOSSWEB, @E_JDBC, @E_JAVA, @E_PHP, @E_ASP, @E_LUA, @E_UNDEFINED, @E_MARIADB, @E_SHELL, @strings, @browserlangs, @googleDomains, @Ids, @MsIds, @sys, @vary, @buildArrays, @dorks, @z, 
     @userArraysList, @exploits, @data, @proxies, @aTsearch, @aTscans, @aTtargets, @aTcopy, @ports, @motor, @motors, @systems, , @mrands, @allMotors, @V_WP, @V_JOOM, @V_TP, @V_SMF, @V_VB, @V_MyBB,
     @V_CF, @V_DRP, @V_PN, @V_AT, @V_PHPN, @V_MD, @V_ACM, @V_SS, @V_MX, @V_XO, @V_OSC, @V_PSH, @V_BB2, @V_MG, @V_ZC, @V_CC5, @V_OCR, @V_XSS, @V_LFI,@V_TODO, @V_AFD, @TODO, @V_VALID, @ERR, @CMS)=();
######################################################################################################################################################################################################
## TOP CONFIG ########################################################################################################################################################################################
require "$Bin/inc/top.pl";
######################################################################################################################################################################################################
## TOOL SETTINGS #####################################################################################################################################################################################
our ($Version, $logoVersion, $scriptUrl, $logUrl, $ipUrl, $conectUrl, $script, $script_bac, $scriptbash, $scriptPass, $paylNote, $psx, $updtd, $V_EMAIL, $V_IP, $V_RANG, $V_SEARCH, $V_REGEX,
     $S_REGEX, $motor1, $motor2, $motor3, $motor4, $motor5, $motorparam, $mrand, $pat2, $nolisting, $Hstatus, $validText, $WpSites, $JoomSites, $xss, $lfi, $JoomRfi, $WpAfd, $adminPage, $subdomain,
     $mupload, $mzip, $eMails, $command, $mmd5, $mencode64, $mdecode64, $port, $msites, $mdom, $Target, $exploit, $p, $tcp, $udp, $full, $proxy, $prandom, $help, $output, $replace, $with, $dork,
     $mlevel, $unique, $shell, $nobanner, $beep, $ifinurl, $noinfo, $motor, $timeout, $limit, $checkVersion, $searchIps, $regex, $searchRegex, $noQuery, $ifend, $uninstall, $post, $get, $brandom,
     $data, $payloads, $mrandom, $content, $pass, $scriptComplInstall, $scriptCompletion, $scriptInstall);
######################################################################################################################################################################################################
## ARGUMENTS #########################################################################################################################################################################################
######################################################################################################################################################################################################
use Getopt::Long qw(GetOptions);
our %OPT;
######################################################################################################################################################################################################
## ARGUMENTS #########################################################################################################################################################################################
Getopt::Long::GetOptions(\%OPT, 'status=s'=>\$Hstatus, 'valid|v=s'=>\$validText, 'wp'=>\$WpSites, 'joom'=>\$JoomSites, 'xss'=>\$xss, 'lfi'=>\$lfi, 'joomrfi'=>\$JoomRfi, 'wpafd'=>\$WpAfd,
                         'admin'=>\$adminPage, 'shost'=>\$subdomain, 'upload'=>\$mupload, 'zip'=>\$mzip, 'email'=>\$eMails, 'command|c=s'=>\$command, 'md5=s'=>\$mmd5, 'encode64=s'=>\$mencode64,
                         'decode64=s'=>\$mdecode64, 'port=s'=>\$port, 'sites'=>\$msites, 'host'=>\$mdom, 't=s'=>\$Target, 'exp|e=s'=>\$exploit, 'p=s'=>\$p, 'tcp'=>\$tcp, 'udp'=>\$udp,
                         'full'=> \$full, 'proxy=s'=>\$proxy, 'proxy-random=s'=>\$prandom, 'help|h|?'=>\$help, 'save|s=s'=>\$output, 'replace=s'=>\$replace, 'with=s'=>\$with, 'dork|d=s'=>\$dork,
                         'level|l=s'=>\$mlevel, 'unique'=>\$unique, 'shell=s'=>\$shell, 'nobanner'=>\$nobanner, 'beep'=>\$beep, 'ifinurl=s'=>\$ifinurl, 'noinfo'=>\$noinfo, 'm=s'=>\$motor,
                         'time=s'=>\$timeout, 'limit=s'=>\$limit, 'update'=>\$checkVersion, 'ip'=>\$searchIps, 'regex=s'=>\$regex, 'sregex=s'=> \$searchRegex, 'noquery'=> \$noQuery,
                         'ifend'=>\$ifend, 'uninstall'=> \$uninstall, 'post'=>\$post, 'get'=>\$get, 'b-random'=>\$brandom, 'data=s'=>\$data, 'payload=s'=>\$payloads,
                         'm-random'=>\$mrandom, 'content'=>\$content, 'pass'=>\$pass, 'updtd'=>\$updtd) or badArgs();
######################################################################################################################################################################################################
## INCLUDES ##########################################################################################################################################################################################
require "$Bin/inc/includes.pl";
######################################################################################################################################################################################################
## SET USER PASS #####################################################################################################################################################################################
sub pass { password(); }
######################################################################################################################################################################################################
## NO ARGUMENTS ######################################################################################################################################################################################
our @NoArg=($dork, $help, $Target, $mmd5, $mencode64, $checkVersion, $data, $uninstall, $pass, $updtd);
my $NoArg=0;
for (@NoArg) { $NoArg++ if defined $_; }
advise() if $NoArg<1;
######################################################################################################################################################################################################
## CHECK VERSION #####################################################################################################################################################################################
sub checkVersion { ckvrsn(); }
######################################################################################################################################################################################################
## INDEX #############################################################################################################################################################################################
require "$Bin/inc/index.pl";
######################################################################################################################################################################################################
## HELP MENU #########################################################################################################################################################################################
sub help { require "$Bin/inc/help.pl"; }
######################################################################################################################################################################################################
## EXIT ##############################################################################################################################################################################################
if (!defined $checkVersion && !defined $help && !defined $updtd && !defined $uninstall) { subfin(); logoff(); }
######################################################################################################################################################################################################
## FIN ###############################################################################################################################################################################################
######################################################################################################################################################################################################
## Copy@right Alisam Technology Team
## 2015  
