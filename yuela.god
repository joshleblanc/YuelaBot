God.watch do |w|
    w.name = "yuela"
    w.start = "bundle exec ruby /home/cereal/yuelabot/main.rb"
    w.log = "/home/cereal/yuelabot/yuela.log"
    w.dir = "/home/cereal/yuelabot"
    w.keepalive
end