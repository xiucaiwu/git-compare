#!/bin/bash
#############################################################################################################
# Author:	william
# email: 	xiuwu_just@163.com
# GitHub: 	https://github.com/xiucaiwu/git-compare
# Gitee: 	https://gitee.com/bullet/git-compare
# Date: 	2018-07-21
# Short-Description: 对比git两次提交,找出变动文件.
# Description: 本工具用于对比两次git提交找出有变动的文件,请在仓库所在的目录下执行
# 使用方法:./git-compare.sh 新的commit 旧的commit
# 默认记录删除的文件在/tmp/项目/分支/del  文件下 
# 默认记录修改和添加的文件在/tmp/项目/分支/update  文件下
#############################################################################################################
#项目路径
project_path=`git rev-parse --show-toplevel`
#仓库名称
repo_name=`basename $project_path`
#仓库的分支
branch=`git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3`
#记录删除的文件
delFile=/tmp/$repo_name/$branch/del
#记录更新的文件
updateFile=/tmp/$repo_name/$branch/update

#检查目录是否存在
if [ ! -d `dirname $delFile` ]; then
 mkdir -p `dirname $delFile`
fi
if [ ! -d `dirname $updateFile` ]; then
 mkdir -p `dirname $updateFile`
fi
#检查文件是否存在
if [ ! -f "$delFile" ]; then
 touch $delFile
fi
if [ ! -f "$updateFile" ]; then
 touch $updateFile
fi
# 文件清空
echo '' > $delFile $updateFile

# 两次提交比对
if [ $# -eq 0 ]
then git diff --name-status HEAD |
	while read status file; do
	case $status in
		D)   echo -e "\033[31;1m${file}\033[0m was deleted" ; echo "$file" >> "$delFile";; # deploy (or ignore) file deletion here
		A|M) echo "$file was added or modified" ;echo "$file" >> "$updateFile";; # deploy file modification here
	esac
	done
elif [ $# -eq 1 ]
	then git diff --name-status HEAD $1 |
	while read status file; do
	case $status in
		D)   echo -e "\033[31;1m${file}\033[0m was deleted" ; echo "$file" >> "$delFile";; # deploy (or ignore) file deletion here
		A|M) echo "$file was added or modified" ;echo "$file" >> "$updateFile";; # deploy file modification here
	esac
	done
elif [ $# -eq 2 ]
	then git diff --name-status $1 $2 |
	while read status file; do
	case $status in
		D)   echo -e "\033[31;1m${file}\033[0m was deleted" ; echo "$file" >> "$delFile";; # deploy (or ignore) file deletion here
		A|M) echo "$file was added or modified" ;echo "$file" >> "$updateFile";; # deploy file modification here
	esac
	done
elif [ $# -gt 2 ]
	then echo "Usage: $0 new_commit_SHA old_commit_SHA"
	exit 1
fi
