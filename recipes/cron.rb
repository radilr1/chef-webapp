app.crontab.each do |c|
  cron "#{app.name}-#{c.name}" do
    user app.user.name

    if c[:action] && c[:action].to_sym == :delete
      action :delete
    else
      command "bash -c 'source #{app.user.home}/.rvm/scripts/rvm; cd #{app.current_path}; bundle exec #{c.command} >> #{app.log_path}/cron.log 2>&1'"

      environment app.env_vars

      for k, v in c
        next if [:command, :name].include?(k.to_sym)
        send(k.to_sym, v)
      end
    end
  end
end
