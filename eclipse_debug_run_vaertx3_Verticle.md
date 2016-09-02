工程上右键菜单
=>Debug As
=>Debug Configuractions...
=>Java Application
=>右键菜单NEW添加lancher
=> Main Tab的Project选你的目标工程 ,Main class填"io.vertx.core.Starter"
=>Arguments Tab的Program arguments填"run io.vertx.blueprint.kue.queue.KueVerticle -cluster"
