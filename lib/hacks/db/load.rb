HackTree.define do
  group :db do
    desc <<-EOT
      Load database snapshot (MySQL InnoDB only)

      Examples:

        >> c.db.load

        >> c.db.load :foo

        >> c.db.load :undo
    EOT

    hack :load do |mnemo = :current|
      raise ArgumentError, "Symbol expected, #{mnemo.class.name} given" unless mnemo.kind_of? Symbol
      
      # TODO: configuration conventions needed!
      konfig = {
        :db_save_undo_snapshot => true,
        :db_snapshot_folder => File.join(Rails.root, "tmp"),
      }

      config  = ActiveRecord::Base.configurations[Rails.env]
      unless config["adapter"] == "mysql2"
        puts "Error: this hack is for MySQL-driven Rails applications only. " +
        "Your DB adapter is `%s`" % config['adapter']
        next # TODO: should be return, ask Hly
      end

      mnemo    = mnemo.to_s
      version  = ActiveRecord::Migrator.current_version
      basename = [Rails.env, version, mnemo].join('.').concat(".sql")
      dumpfile = File.join(konfig[:db_snapshot_folder], basename)

      unless File.exists? dumpfile
        puts "Error: file `%s` doesn't exist!" % dumpfile
        next # TODO: should be return, ask Hly
      end

      # Take database snapshot for 'undo', if needed
      c.db.dump :undo if konfig[:db_save_undo_snapshot] && mnemo != "undo"

      mysql_args = [
        "--user=%s" % config['username'],
        "--database=%s" % config['database'],
      ]
      mysql_args << "--password=%s" % config["password"] unless config["password"].blank?      

      # Execute shell command
      command = ["mysql", mysql_args, "<", dumpfile.shellescape] * " "
      pid, stdin, stdout, stderr = Open4::popen4(command)

      stdout, stderr = stdout.lines.to_a.join.strip, stderr.lines.to_a.join.strip
      exitstatus     = Process::waitpid2(pid)[1].exitstatus

      unless exitstatus == 0
        puts "Error: MySQL exit status is %s. Here are details:" % exitstatus
        puts command, stdout, stderr
      else
        puts "Snapshot `%s` load successful" % basename
      end

      nil
    end
  end
end
