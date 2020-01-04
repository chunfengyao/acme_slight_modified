# acme_tiny_modified

acme_tiny.py
EN:add --save-to options, and better for bash script (add error code to notice bash script).
ZH:添加了 --save-to 选项来指定生成的公钥的保存位置。添加了错误码的返回，可以便于bash脚本的调用（可以获取错误码，得知哪里出问题了，并进行相应的处理。）


example-update-scripts.sh
EN:one demo ,you can add it to your crontab ,you'd better use another scripts to wrapper it, especially you no need nginx start background.
ZH:一个例子，可以添加到自己的定时脚本里面（最好是再嵌套一个脚本，用来关闭nginx，因为脚本设置了一旦有任何一条命令执行失败，直接结束整个脚本。所以，可能会导致开启nginx后未运行到关闭nginx的命令。）
