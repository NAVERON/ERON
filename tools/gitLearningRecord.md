# git 学习笔记

#### 基本的命令

- 初始化仓库 git init
- 如果已经在github上有了仓库，或者直接clone，或者初始化后，先pull请求合并，然后push同步到远程仓库

#### 写作过程中的过程

1. 首先更改某一个文件的内容
2. `git status`可以表明当前仓库的状态：被修改了什么，哪些没有提交
  需要提交时，首先需要**add**命令：
3. `git add <filename>`或者`git add .`提交所有文件
  一次可以提交多个文件，以空格分开
4. 最后是提交到仓库中，使用`git commit -m "comment..."`命令
  如果需要提交到远程仓库，使用`git push`命令

_需要比较文件修改了什么内容，使用`git diff <filename>`命令_

#### 版本回退问题

HEAD指向当前版本
`git log`查看提交记录，`git reflog`查看命令历史，以便于确定回到哪个版本
理解**暂缓区**的概念

#### 分支学习

查看分支：`git branch`
创建分支：`git branch <name>`
切换分支：`git checkout <name>`
切换+创建：`git checkout -b <name>`
合并某分支到当前分支：`git merge <name>`
删除分支：`git branch -d <name>`






